//
//  SpotifyAuthManager.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import Foundation
import AuthenticationServices
import CryptoKit

class SpotifyAuthManager: NSObject, ASWebAuthenticationPresentationContextProviding {
    static let spotifyAuthManager = SpotifyAuthManager()
    
    private let CLIENT_ID = /* Add client id from Spotify for Developers Web API */
    private let CLIENT_SECRET = /* Add client secret from Spotify for Developers Web API */
    private let REDIRECT_URI = "moodify://callback"
    private let AUTH_URL = "https://accounts.spotify.com/authorize"
    private let TOKEN_URL = "https://accounts.spotify.com/api/token"
    private let API_BASE_URL = "https://api.spotify.com/v1/"
    
    private var codeVerifier: String = ""
    private var authSession: ASWebAuthenticationSession?

    var accessToken: String?
    var refreshToken: String?
    var expiresIn: String?      // Number of seconds accessToken lasts for (1 day)
    var playlists: [SimplifiedPlaylistObject]?
    var savedTracks: [SavedTrackObject]?
    var searchedTracks: [TrackObject]?
    
    // Resets all variables in case loggin in with a different Spotify account
    func resetSession() {
        accessToken = nil
        refreshToken = nil
        expiresIn = nil
        playlists = nil
        savedTracks = nil
        searchedTracks = nil
    }
    
    // Login function
    func startLogin(completion: @escaping (Bool) -> Void) {
        let codeChallenge = generateCodeChallenge()
        let scope = "user-read-email user-read-private playlist-read-private user-library-read"

        // Fetch necessary components from Spotify Accounts Service
        var components = URLComponents(string: AUTH_URL)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: CLIENT_ID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: REDIRECT_URI)
        ]

        // Check that authorization components exist
        guard let authUrl = components.url else {
            completion(false)
            return
        }

        // Initialize authSession with authorization components
        authSession = ASWebAuthenticationSession(
            url: authUrl,
            callbackURLScheme: "moodify",
            completionHandler: { [weak self] callbackURL, error in
                guard
                    let self = self,
                    let callbackURL = callbackURL,
                    error == nil,
                    let code = self.extractCode(from: callbackURL)
                else {
                    completion(false)
                    return
                }

                self.exchangeCodeForToken(code: code, completion: completion)
            }
        )

        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = true
        authSession?.start()
    }

    // Token Exchange after successful login
    private func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: TOKEN_URL) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Proper URL-encoded form body using URLComponents
        var components = URLComponents(string: TOKEN_URL)!
        
        components.queryItems = [
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: REDIRECT_URI),
            URLQueryItem(name: "client_id", value: CLIENT_ID),
            URLQueryItem(name: "code_verifier", value: codeVerifier)
        ]
        
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Error checking
            if let error = error {
                print("Token request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response object")
                completion(false)
                return
            }
            
            // Check status code and try parsing token
            guard httpResponse.statusCode == 200 else {
                print("Token request failed with status: \(httpResponse.statusCode)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data in response")
                completion(false)
                return
            }

            // Retrieve accessToken if no error
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    self.accessToken = json["access_token"] as? String
                    self.refreshToken = json["refresh_token"] as? String
                    self.expiresIn = json["expires_in"] as? String
                    completion(true)
                } else {
                    print("Couldn't extract token from response")
                    completion(false)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
    
    // Get user profile
    func getUserProfile(completion: @escaping (String?, String?, String?) -> Void) {
        guard let accessToken = accessToken else {
            print("Access token is missing")
            completion(nil, nil, nil)
            return
        }

        guard let url = URL(string: API_BASE_URL + "me") else {
            completion(nil, nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            // Error checking
            if let error = error {
                print("User request error: \(error.localizedDescription)")
                completion(nil, nil, nil)
                return
            }

            guard let data = data else {
                print("No data in user response")
                completion(nil, nil, nil)
                return
            }

            // Try parsing user info
            do {
                let user = try JSONDecoder().decode(SpotifyUser.self, from: data)
                let imageURL = user.images.first?.url
                completion(user.id, user.display_name ?? "Unknown", imageURL)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil, nil, nil)
            }
        }.resume()
    }

    // Get user's playlists
    func getUserPlaylists(completion: @escaping (Bool) -> Void) {
        // Check for valid accessToken for early exit
        guard let accessToken = accessToken else {
            print("Access token is missing")
            completion(false)
            return
        }

        // URL for user playlist request
        guard let url = URL(string: API_BASE_URL + "me/playlists") else {
            print("Invalid playlist URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Error checking
            if let error = error {
                print("Playlist request error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Playlist request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data in playlist response")
                completion(false)
                return
            }

            // Try parsing playlists
            do {
                let decoder = JSONDecoder()
                let playlistResponse = try decoder.decode(Playlists.self, from: data)
                self.playlists = playlistResponse.items
                print("Fetched \(playlistResponse.items.count) playlists")
                completion(true)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
    
    // Get user's saved tracks
    func getSavedTracks(completion: @escaping (Bool) -> Void) {
        // Check for valid accessToken for early exit
        guard let accessToken = accessToken else {
            print("Access token is missing")
            completion(false)
            return
        }
        
        // URL for user playlist request
        guard let url = URL(string: API_BASE_URL + "me/tracks") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var savedRequest = URLRequest(url: url)
        savedRequest.httpMethod = "GET"
        savedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: savedRequest) { data, response, error in
            // Error checking
            if let error = error {
                print("Saved tracks request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data from saved tracks endpoint")
                return
            }
            
            // Try parsing data
            do {
                let decoder = JSONDecoder()
                let savedTracksResponse = try decoder.decode(SavedTracks.self, from: data)
                self.savedTracks = savedTracksResponse.items
                print("Fetched \(savedTracksResponse.total), for saved tracks")
                completion(true)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }

    // Search tracks on Spotify search
    func searchTracks(query: String, completion: @escaping (Bool) -> Void) {
        // Check for valid accessToken for early exit
        guard let accessToken = accessToken else {
            print("Access token is missing")
            completion(false)
            return
        }

        // URL for search request
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: API_BASE_URL + "search?q=\(encodedQuery)&type=track&limit=10") else {
            print("Invalid search URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Search request failed: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received from search")
                completion(false)
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(SearchResult.self, from: data)
                self.searchedTracks = result.tracks.items
                print("Search successful: found \(result.tracks.items.count) tracks")
                completion(true)
            } catch {
                print("Failed to decode search response: \(error)")
                    completion(false)
            }
        }.resume()
    }

    // Helper functions for authorization
    private func extractCode(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "code" })?.value
    }

    private func generateCodeChallenge() -> String {
        codeVerifier = generateRandomString()
        let data = Data(codeVerifier.utf8)
        let hash = SHA256.hash(data: data)
        let base64 = Data(hash).base64URLEncodedString()
        return base64
    }

    private func generateRandomString(length: Int = 128) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }

    // To conform to ASWebAuthenticationPresentationContextProviding protocol
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

extension Data {
    func base64URLEncodedString() -> String {
        return self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
