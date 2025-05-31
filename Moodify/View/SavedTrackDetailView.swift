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
        view.document = PDFDocument()

        var pdfImage: UIImage?

        let data = try! Data(contentsOf: URL(string: url)!)
        pdfImage = UIImage(data: data)

        if pdfImage == nil {
            return view
        }

        guard let pdfImage, let page = PDFPage(image: pdfImage) else {
            return view
        }

        view.backgroundColor = .white
        view.document?.insert(page, at: 0)
        view.autoScales = true
        return view
    }
    
    // To conform to UIViewRepresentable
    func updateUIView(_ uiView: PDFView, context: Context) {
        // empty
    }
}
