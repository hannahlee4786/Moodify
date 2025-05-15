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
    
    static let shared = SpotifyAuthManager()
    
    private let clientID = "31888163750a43988ab29c929f7a0aa1"
    private let redirectURI = "moodify://callback"
    private let tokenAPIURL = "https://accounts.spotify.com/api/token"
    
    private var codeVerifier: String = ""
    private var authSession: ASWebAuthenticationSession?

    var accessToken: String?
    var refreshToken: String?
    
    // Start Login
    func startLogin(completion: @escaping (Bool) -> Void) {
        let codeChallenge = generateCodeChallenge()
        let scope = "user-read-email user-read-private"

        var components = URLComponents(string: "https://accounts.spotify.com/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "scope", value: scope)
        ]

        guard let authURL = components.url else {
            completion(false)
            return
        }

        authSession = ASWebAuthenticationSession(
            url: authURL,
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

    // Token Exchange
    private func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: tokenAPIURL) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let params: [String: String] = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "client_id": clientID,
            "code_verifier": codeVerifier
        ]

        // Proper URL-encoded form body using URLComponents
        var components = URLComponents()
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // For debugging
        print("Requesting token with body:\n\(components.query ?? "nil")")

        URLSession.shared.dataTask(with: request) { data, response, error in
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

            guard let data = data else {
                print("No data in response")
                completion(false)
                return
            }

            // Log the raw response body for clarity
            if let responseText = String(data: data, encoding: .utf8) {
                print("Raw token response:\n\(responseText)")
            }

            // Check status code and try parsing token
            guard httpResponse.statusCode == 200 else {
                print("Token request failed with status: \(httpResponse.statusCode)")
                completion(false)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["access_token"] as? String {
                    self.accessToken = token
                    self.refreshToken = json["refresh_token"] as? String
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


    // Helpers
    private func makeURLEncodedBody(from params: [String: String]) -> Data? {
        var components = URLComponents()
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.query?.data(using: .utf8)
    }

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
