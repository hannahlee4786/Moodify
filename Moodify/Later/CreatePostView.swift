////
////  CreatePostView.swift
////  Moodify
////
////  Created by Hannah Lee on 5/7/25.
////
//
//import SwiftUI
//import PhotosUI
//
//struct CreatePostView: View {
//    @ObservedObject var viewModel: UserProfileViewModel
//
//    @State private var isPhotoPickerPresented = false
//    @State private var selectedItem: PhotosPickerItem? = nil
//    @State private var selectedImage: UIImage? = nil
//    @State private var caption: String = ""
//    @State private var isUploading = false
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//        
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Create Post")
//                    .font(.largeTitle)
//                    .padding()
//                
//                VStack {
//                    if let selectedImage {
//                        Image(uiImage: selectedImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxHeight: 300)
//                            .cornerRadius(12)
//                            .padding()
//                            .shadow(radius: 3)
//                    } else {
//                        Button(action: {
//                            isPhotoPickerPresented.toggle()
//                        }) {
//                            VStack {
//                                Image(systemName: "photo.on.rectangle.angled")
//                                    .font(.system(size: 50))
//                                    .padding()
//                                
//                                Text("Tap to select an image")
//                                    .font(.headline)
//                            }
//                            .frame(maxWidth: .infinity, maxHeight: 250)
//                            .background(Color(UIColor.systemGray6))
//                            .cornerRadius(12)
//                            .padding()
//                        }
//                    }
//                }
//                
//                // Caption text field
//                TextField("Enter Mood", text: $caption)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                // Buttons row
//                HStack {
//                    // Clear button
//                    if selectedImage != nil {
//                        Button(action: {
//                            clearInputs()
//                        }) {
//                            HStack {
//                                Image(systemName: "trash")
//                                Text("Clear")
//                            }
//                            .padding()
//                            .foregroundColor(.red)
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    // Post button
//                    Button(action: {
//                        //uploadPost()
//                    }) {
//                        HStack {
//                            Image(systemName: "paperplane.fill")
//                            Text("Post")
//                        }
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                    }
//                    .disabled(selectedImage == nil || caption.isEmpty || isUploading)
//                    .opacity((selectedImage == nil || caption.isEmpty || isUploading) ? 0.5 : 1)
//                }
//                .padding()
//                
//            }
//            .navigationBarTitle("", displayMode: .inline)
//            .sheet(isPresented: $isPhotoPickerPresented) {
//                PhotosPicker(
//                    selection: $selectedItem,
//                    matching: .images,
//                    photoLibrary: .shared()) {
//                        Text("Select a photo")
//                    }
//                    .presentationDetents([.medium, .large])
//            }
//            .onChange(of: selectedItem, perform: { newItem in
//                Task {
//                    if let selectedItem,
//                       let data = try? await selectedItem.loadTransferable(type: Data.self),
//                       let uiImage = UIImage(data: data) {
//                        selectedImage = uiImage
//                    }
//                }
//            })
//            .alert(isPresented: $showingAlert) {
//                Alert(
//                    title: Text("Post Status"),
//                    message: Text(alertMessage),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//    
//    // Reset the inputs after posting
//    private func clearInputs() {
//        selectedImage = nil
//        selectedItem = nil
//        caption = ""
//    }
//}
//
