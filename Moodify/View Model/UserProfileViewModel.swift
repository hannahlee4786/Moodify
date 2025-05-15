//
//  UserProfileViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userService = UserService.shared
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    init(user: User? = nil,
         isLoading: Bool = false,
         errorMessage: String? = nil) {
        self.user = user
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }

    // Load user profile from Firestore
    func loadUser(with id: String, token: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        print("Loading user with ID: \(id)")

        let docRef = db.collection("users").document(id)
        docRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Failed to load user: \(error.localizedDescription)"
                    print("Error loading user: \(error.localizedDescription)")
                    return
                }

                guard let data = snapshot?.data() else {
                    self.errorMessage = "No user data found"
                    print("No user data found for ID: \(id)")
                    return
                }
                
                print("Successfully loaded user data")

                // First create the user with basic data
                var user = User(
                    id: data["id"] as? String ?? id,
                    username: data["username"] as? String ?? "Unknown",
                    bio: data["bio"] as? String ?? "",
                    aesthetic: data["aesthetic"] as? String ?? "",
                    spotifyToken: token ?? (data["spotifyToken"] as? String ?? ""),
                    profileImageURL: data["profileImageURL"] as? String,
                    likedTracks: [],
                    posts: []
                )
                
                // Now handle posts separately since they need special processing
                if let postsData = data["posts"] as? [[String: Any]] {
                    var posts: [Post] = []
                    
                    for postData in postsData {
                        if let postId = postData["id"] as? String,
                           let caption = postData["caption"] as? String,
                           let imageURL = postData["imageURL"] as? String {
                            
                            let post = Post(
                                id: UUID(uuidString: postId) ?? UUID(),
                                image: UIImage(systemName: "photo")!, // Placeholder image
                                caption: caption,
                                imageURL: imageURL
                            )
                            posts.append(post)
                        }
                    }
                    
                    user.posts = posts
                    print("Loaded \(posts.count) posts for user")
                } else {
                    print("No posts found for user")
                }

                self.user = user
            }
        }
    }

    // Save or update user profile data to Firestore
    func saveUser(username: String, bio: String, aesthetic: String, profileImageURL: String?) {
        guard let userId = user?.id else {
            errorMessage = "User ID is missing"
            return
        }
        
        guard let spotifyToken = user?.spotifyToken, !spotifyToken.isEmpty else {
            print("Spotify token is missing or empty.")
            return
        }

        isLoading = true
        errorMessage = nil

        // Save data to Firestore
        UserService.shared.createOrUpdateUser(id: userId, username: username, bio: bio, aesthetic: aesthetic, spotifyToken: spotifyToken, profileImageURL: profileImageURL) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    // Update local user data after saving to Firestore
                    self?.user?.username = username
                    self?.user?.bio = bio
                    self?.user?.aesthetic = aesthetic
                    self?.user?.profileImageURL = profileImageURL
                    print("User updated successfully in Firestore!")
                } else {
                    self?.errorMessage = "Failed to save user data"
                }
            }
        }
    }

    // Fetch user by username from Firestore
    func fetchUser(byUsername username: String, token: String? = nil, completion: @escaping (User?) -> Void) {
        isLoading = true
        errorMessage = nil

        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false

                    if let error = error {
                        self.errorMessage = "Error fetching user: \(error.localizedDescription)"
                        completion(nil)
                        return
                    }

                    guard let document = snapshot?.documents.first else {
                        self.errorMessage = "User not found"
                        completion(nil)
                        return
                    }

                    let data = document.data()
                    
                    // Create user with basic information first
                    var user = User(
                        id: data["id"] as? String ?? document.documentID,
                        username: data["username"] as? String ?? "Unknown",
                        bio: data["bio"] as? String ?? "",
                        aesthetic: data["aesthetic"] as? String ?? "",
                        spotifyToken: token ?? "",
                        profileImageURL: data["profileImageURL"] as? String,
                        likedTracks: [],
                        posts: []
                    )
                    
                    // Handle posts separately with proper conversion
                    if let postsData = data["posts"] as? [[String: Any]] {
                        var posts: [Post] = []
                        
                        for postData in postsData {
                            if let postId = postData["id"] as? String,
                               let caption = postData["caption"] as? String,
                               let imageURL = postData["imageURL"] as? String {
                                
                                let post = Post(
                                    id: UUID(uuidString: postId) ?? UUID(),
                                    image: UIImage(systemName: "photo")!, // Placeholder
                                    caption: caption,
                                    imageURL: imageURL
                                )
                                posts.append(post)
                            }
                        }
                        
                        user.posts = posts
                    }

                    completion(user)
                }
            }
    }

    // Add a post with image upload to Firebase Storage (FIXED VERSION)
    func addPost(caption: String, image: UIImage) {
        guard let userId = user?.id else {
            errorMessage = "User ID is missing"
            print("Cannot add post: User ID is missing")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Create a unique image filename using UUID
        let imageId = UUID().uuidString
        
        // First, let's create a Post object with the local image for immediate display
        let postId = UUID()
        let newPost = Post(
            id: postId,
            image: image, // Store the image in memory for immediate display
            caption: caption
            // No imageURL yet, we'll add it after upload
        )
        
        // Add to local user data so it appears immediately
        if self.user?.posts == nil {
            self.user?.posts = []
        }
        self.user?.posts.append(newPost)
        
        // Create a local copy of the post data
        let postData: [String: Any] = [
            "id": postId.uuidString,
            "caption": caption,
            "createdAt": Timestamp()
            // imageURL will be added after upload success
        ]
        
        // Convert UIImage to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            errorMessage = "Failed to process image"
            isLoading = false
            return
        }
        
        print("Starting image upload to Firebase Storage...")
        
        // Create the storage reference
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(userId)/\(imageId).jpg")
        
        // Create metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the image to Firebase Storage
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                    print("Image upload failed: \(error.localizedDescription)")
                    
                    // Remove the post from local data since upload failed
                    if let index = self.user?.posts.firstIndex(where: { $0.id == postId }) {
                        self.user?.posts.remove(at: index)
                    }
                }
                return
            }
            
            print("Image uploaded successfully, getting download URL...")
            
            // Get the download URL for the uploaded image
            imageRef.downloadURL { [weak self] url, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Failed to get image URL: \(error.localizedDescription)"
                        print("Failed to get image URL: \(error.localizedDescription)")
                        
                        // Remove the post from local data since we couldn't get the URL
                        if let index = self.user?.posts.firstIndex(where: { $0.id == postId }) {
                            self.user?.posts.remove(at: index)
                        }
                        return
                    }
                    
                    guard let downloadURL = url else {
                        self.errorMessage = "Image URL is missing"
                        print("Image URL is missing after upload")
                        
                        // Remove the post from local data
                        if let index = self.user?.posts.firstIndex(where: { $0.id == postId }) {
                            self.user?.posts.remove(at: index)
                        }
                        return
                    }
                    
                    print("Download URL obtained: \(downloadURL.absoluteString)")
                    
                    // Update the local post with the image URL
                    if let index = self.user?.posts.firstIndex(where: { $0.id == postId }) {
                        self.user?.posts[index].imageURL = downloadURL.absoluteString
                    }
                    
                    // Update post data with the image URL
                    var updatedPostData = postData
                    updatedPostData["imageURL"] = downloadURL.absoluteString
                    
                    // Save to Firestore
                    self.savePostToFirestore(userId: userId, postData: updatedPostData)
                }
            }
        }
        
        // Monitor upload progress (optional)
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount) * 100
            print("Upload is \(percentComplete)% complete")
        }
    }
    
    // Helper method to save post data to Firestore
    private func savePostToFirestore(userId: String, postData: [String: Any]) {
        // Get the current posts array from Firestore
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot, document.exists else {
                print("User document doesn't exist")
                return
            }
            
            // Start a transaction to update the posts array
            self.db.runTransaction({ (transaction, errorPointer) -> Any? in
                let userDocument: DocumentSnapshot
                
                do {
                    userDocument = try transaction.getDocument(userRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                // Get the current posts array or create a new one
                var posts = userDocument.data()?["posts"] as? [[String: Any]] ?? []
                
                // Add the new post
                posts.append(postData)
                
                // Update the document with the new posts array
                transaction.updateData(["posts": posts], forDocument: userRef)
                
                return posts
            }) { [weak self] (_, error) in
                if let error = error {
                    print("Error updating posts: \(error.localizedDescription)")
                } else {
                    print("Post successfully saved to Firestore!")
                }
            }
        }
    }
    
    // Debug function to check Firebase Storage setup
    func checkFirebaseStorage() {
        let storageRef = storage.reference()
        let testRef = storageRef.child("test.txt")
        
        let data = "Test data".data(using: .utf8)!
        
        testRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                print("Firebase Storage test upload failed: \(error.localizedDescription)")
            } else {
                print("Firebase Storage test successful!")
                
                // Clean up test file
                testRef.delete { error in
                    if let error = error {
                        print("Cleanup error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
