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
    
    // Login function
    func startLogin(completion: @escaping (Bool) -> Void) {
        let codeChallenge = generateCodeChallenge()
        let scope = "user-read-email user-read-private playlist-read-private"

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

//            // Log the raw response body for clarity
//            if let responseText = String(data: data, encoding: .utf8) {
//                print("Raw token response:\n\(responseText)")
//            }

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
                completion(user.id, user.display_name, imageURL)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil, nil, nil)
            }
        }.resume()
    }

    
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
        return UIApplication.shared.windows.first ?? UIWindow()
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
