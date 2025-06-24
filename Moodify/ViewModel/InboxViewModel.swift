//
//  InboxViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 6/18/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class InboxViewModel: ObservableObject {
    @Published var userRequests: [Request] = []
    @Published var friendsRequests: [Request] = []
    
    private let db = Firestore.firestore()
    
    // Load user's past song requests
    func loadRequests(for userId: String) {
        self.db.collection("users")
            .document(userId)
            .collection("requests")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching requests: \(error)")
                    return
                }

                self.userRequests = snapshot?.documents.compactMap { document in
                    try? document.data(as: Request.self)
                } ?? []

                print("Successfully fetched \(self.userRequests.count) requests.")
            }
    }
    
    // Makes a song request
    func makeRequest(userID: String, mood: String, user: User, completion: @escaping (Bool) -> Void) {
        guard let userId = user.id else {
            completion(false)
            return
        }
        
        let request = Request(recommendations: [], mood: mood, status: true)
        
        do {
            try db.collection("users")
                .document(userId)
                .collection("requests")
                .addDocument(from: request) { error in
                    if let error = error {
                        print("Error adding request: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Successfully added request to [request].")
                        completion(true)
                    }
                }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Deletes a certain request
    func deleteRequest(userID: String, mood: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            var idx = 0
            for request in self.userRequests {
                if request.mood == mood {
                    self.userRequests.remove(at: idx)
                }
                idx += 1
            }
        }
        
        // Update firebase
        let data: [String: Any] = [
            "id": userID,
            "requests": self.userRequests
        ]
        
        db.collection("users").document(userID).setData(data, merge: true) { error in
            if let error = error {
                print("Error deleting request: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Loads friends' song requests
    func loadFriendRequests() {
        
    }
    
    // Sends recommendation to a friend's request
    func sendRecommendation() {
        
    }
}
