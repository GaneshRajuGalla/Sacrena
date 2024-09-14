//
//  PermissionsManager.swift
//  Sacrena
//
//  Created by Ganesh Raju Galla on 14/09/24.
//
import AVFoundation
import Photos
import Combine

class PermissionsManager {
    enum PermissionType {
        case camera
        case photoLibrary
    }
    
    enum PermissionStatus {
        case notDetermined, restricted, denied, authorized
    }
    
    static func requestPermission(type: PermissionType, completion: @escaping (PermissionStatus) -> Void) {
        switch type {
        case .camera:
            requestCameraPermission(completion: completion)
        case .photoLibrary:
            requestPhotoLibraryPermission(completion: completion)
        }
    }
    
    private static func requestCameraPermission(completion: @escaping (PermissionStatus) -> Void) {
        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch currentStatus {
        case .authorized:
            completion(.authorized)
        case .restricted:
            completion(.restricted)
        case .denied:
            completion(.denied)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied)
                }
            }
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    private static func requestPhotoLibraryPermission(completion: @escaping (PermissionStatus) -> Void) {
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        switch currentStatus {
        case .authorized:
            completion(.authorized)
        case .restricted:
            completion(.restricted)
        case .denied:
            completion(.denied)
        case .limited:
            completion(.authorized)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(.denied)
                }
            }
        @unknown default:
            completion(.notDetermined)
        }
    }
}
