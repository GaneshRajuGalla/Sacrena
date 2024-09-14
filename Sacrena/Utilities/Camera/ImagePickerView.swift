//
//  ImagePickerView.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//
import Foundation
import SwiftUI
import UIKit
import MobileCoreServices

enum SourceType {
    case camera(CameraMediaType)
    case library
    case both
}

enum CameraMediaType {
    case video
    case photo
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    // MARK: - Properties
    var sourceType:SourceType = .both
    var onMediaPicked: (Result<MediaItem, Error>) -> Void
    
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - UIViewControllerRepresentable Methods
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        switch sourceType {
        case .camera(let cameraMediaType):
            picker.sourceType = UIImagePickerController.SourceType.camera
            if cameraMediaType == .photo {
                picker.mediaTypes = [kUTTypeImage as String]
            } else if cameraMediaType == .video {
                picker.videoQuality = .typeHigh
                picker.mediaTypes = [kUTTypeMovie as String]
            }
        case .library:
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        case .both:
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.videoQuality = .typeHigh
            picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        }
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onMediaPicked(.success(.image(image)))
            } else if let videoUrl = info[.mediaURL] as? URL {
                parent.onMediaPicked(.success(.video(videoUrl)))
            } else {
                parent.onMediaPicked(.failure(PickerError.mediaSelectionFailed))
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    enum MediaItem {
        case image(UIImage)
        case video(URL)
    }
    
    enum PickerError: Error {
        case mediaSelectionFailed
    }
}
