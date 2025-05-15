//
//  PhotoPickerView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var selectedItem: PhotosPickerItem?
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem, // Binding to the selected item
                matching: .images,         // Limit picker to images
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { newItem in
                    // Handle the selected item
                    Task {
                        // Retrieve selected asset
                        if let selectedItem {
                            // Retrieve selected asset from PhotosPickerItem
                            if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                                // Here you can use the data to load the image
                                if let uiImage = UIImage(data: data) {
                                    print("Selected image: \(uiImage)")
                                }
                            }
                        }
                    }
                }
        }
        .onAppear {
            // Present the photo picker when the view appears
            isImagePickerPresented = true
        }
    }
}

//struct ContentView: View {
//    @State private var selectedItem: PhotosPickerItem? = nil
//
//    var body: some View {
//        VStack {
//            if let selectedItem, let assetData = try? await selectedItem.loadTransferable(type: Data.self), let uiImage = UIImage(data: assetData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//            } else {
//                Text("No image selected.")
//            }
//
//            PhotoPicker(selectedItem: $selectedItem)
//        }
//        .padding()
//    }
//}
//
