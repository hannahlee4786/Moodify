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
    @Published var userRequests: [SongRequest] = []
    @Published var friendsRequests: [SongRequest] = []
    
    private let db = Firestore.firestore()
    
    // Load user's past song requests
    func loadUserRequests(for userId: String) {
        self.db.collection("users")
            .document(userId)
            .collection("requests")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching requests: \(error)")
                    return
                }
                
                self.userRequests = snapshot?.documents.compactMap { document in
                    try? document.data(as: SongRequest.self)
                } ?? []
                
                print("Successfully fetched \(self.userRequests.count) requests.")
            }
    }
    
    // Makes a song request
    func makeRequest(userID: String, description: String, mood: String, user: User, completion: @escaping (Bool) -> Void) {
        guard let userId = user.id else {
            completion(false)
            return
        }
        
        let request = SongRequest(
            recommendations: [],
            userId: userID,
            userProfilePic: user.profileImageURL,
            username: user.username,
            description: description,
            mood: mood
        )
        
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
    func deleteRequest(userId: String, requestId: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
                self.userRequests.removeAll { $0.id == requestId }
        }
        
        // Update firebase
        db.collection("users")
            .document(userId)
            .collection("requests")
            .document(requestId)
            .delete { error in
                if let error = error {
                    print("Error deleting request: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Successfully deleted request from Firestore.")
                    completion(true)
                }
            }
    }
    
    // Loads friends' song requests
    func loadFriendsRequests(for userId: String) {
        db.collection("users")
            .document(userId)
            .collection("friends")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friends: \(error)")
                    return
                }
                
                // Gets all of friends' ids into an array
                let friendIds = snapshot?.documents.compactMap {
                    try? $0.data(as: Friend.self).id
                } ?? []
                
                let group = DispatchGroup()
                var allRequests: [SongRequest] = []
                
                for friendId in friendIds {
                    group.enter()
                    self.db.collection("users")
                        .document(friendId)
                        .collection("requests")
                        .order(by: "date", descending: true)
                        .limit(to: 3)
                        .getDocuments { postSnapshot, error in
                            defer {
                                group.leave()
                            }
                            
                            if let error = error {
                                print("Error fetching requests for friend, \(friendId): \(error)")
                                return
                            }
                            
                            let songRequests = postSnapshot?.documents.compactMap {
                                try? $0.data(as: SongRequest.self)
                            } ?? []
                            
                            allRequests.append(contentsOf: songRequests)
                        }
                }
                
                group.notify(queue: .main) {
                    self.friendsRequests = allRequests.sorted(by: { $0.date > $1.date })
                    print("Successfully fetched \(self.friendsRequests.count) friends' requests.")
                }
            }
    }
    
    // Adds a recommendation to a friend's request
    func addRecommendation(friendId: String, username: String, song: TrackObject, requestId: String, completion: @escaping (Bool) -> Void) {
        // Create SongRecommendation object to add to [SongRecommendation] to friend's request
        let songRecommendation = SongRecommendation(
            username: username,
            userId: friendId,
            song: song)
        
        let requestRef = db.collection("users")
            .document(friendId)
            .collection("requests")
            .document(requestId)
        
        requestRef.getDocument { document, error in
            if let document = document, document.exists {
                var recommendations = (document.data()?["recommendations"] as? [[String: Any]]) ?? []
                
                // Convert the new recommendation to a dictionary
                let encodedRecommendation: [String: Any]
                do {
                    encodedRecommendation = try Firestore.Encoder().encode(songRecommendation)
                } catch {
                    print("Encoding error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                recommendations.append(encodedRecommendation)
                
                requestRef.updateData([
                    "recommendations": recommendations
                ]) { error in
                    if let error = error {
                        print("Error updating recommendations: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Successfully added recommendation.")
                        completion(true)
                    }
                }
            } else {
                print("Request document not found.")
                completion(false)
            }
        }
    }
}
