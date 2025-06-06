//
//  SavedTrackDetailView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/30/25.
//

import SwiftUI
import UIKit
import PDFKit

struct SavedTrackDetailView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.backgroundColor = .white
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        guard let imageURL = URL(string: url) else { return }
        
        // Download image asynchronously
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                let page = PDFPage(image: image)
            else {
                print("Failed to load image from URL: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            DispatchQueue.main.async {
                let pdfDocument = PDFDocument()
                pdfDocument.insert(page, at: 0)
                uiView.document = pdfDocument
            }
        }.resume()
    }
}
