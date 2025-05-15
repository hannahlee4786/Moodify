//
//  CreatePostView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @State private var isPhotoPickerPresented = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var caption: String = ""
    @State private var isUploading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @ObservedObject var viewModel: UserProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Create Post")
                    .font(.largeTitle)
                    .padding()
                
                VStack {
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .padding()
                            .shadow(radius: 3)
                    } else {
                        Button(action: {
                            isPhotoPickerPresented.toggle()
                        }) {
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 50))
                                    .padding()
                                
                                Text("Tap to select an image")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .padding()
                        }
                    }
                }
                
                // Caption text field
                TextField("Enter Mood 🎧💗", text: $caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Buttons row
                HStack {
                    // Clear button
                    if selectedImage != nil {
                        Button(action: {
                            clearInputs()
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear")
                            }
                            .padding()
                            .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    
                    // Post button
                    Button(action: {
                        uploadPost()
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Post")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .disabled(selectedImage == nil || caption.isEmpty || isUploading)
                    .opacity((selectedImage == nil || caption.isEmpty || isUploading) ? 0.5 : 1)
                }
                .padding()
                
                if isUploading {
                    VStack {
                        ProgressView("Uploading...")
                        Text("Please wait")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $isPhotoPickerPresented) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Select a photo")
                    }
                    .presentationDetents([.medium, .large])
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let selectedItem,
                       let data = try? await selectedItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Post Status"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Upload the post
    private func uploadPost() {
        guard let image = selectedImage else { return }
        
        // Start uploading
        isUploading = true
        
        // Add a small delay to let the UI update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Call the view model to add the post
            viewModel.addPost(caption: caption, image: image)
            
//            // Display feedback based on the result
//            if let errorMessage = viewModel.errorMessage {
//                alertMessage = "Failed to upload post: \(errorMessage)"
//                showingAlert = true
//            } else {
//                alertMessage = "Post uploaded successfully!"
//                showingAlert = true
//                clearInputs()
//            }
            
            isUploading = false
        }
    }
    
    // Reset the inputs after posting
    private func clearInputs() {
        selectedImage = nil
        selectedItem = nil
        caption = ""
    }
}

// Preview provider
struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(viewModel: UserProfileViewModel())
    }
}
