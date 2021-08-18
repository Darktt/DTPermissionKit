//
//  DTPhotos.swift
//
//  Created by Darktt on 19/1/29.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Photos

internal extension DTPermission
{
    // MARK: - Properties -
    
    @available(iOS, introduced: 8.0, deprecated: 14.0)
    var statusPhtots: Status
    {
        let statusPhtots: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        let status: Status = statusPhtots.status
        
        return status
    }
    
    // MARK: - Methods -
    
    @available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *)
    static func statusPhotos(for level: PHAccessLevel) -> Status
    {
        let statusPhtots: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: level)
        let status: Status = statusPhtots.status
        
        return status
    }
    
    func requestPhotos(for level: PhotoAccessLevel, handler: @escaping RequestHandler)
    {
        let key: DTInfoKey = .photoLibraryUsageDescription
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let completionHandler: (PHAuthorizationStatus) -> Void = {
            
            [unowned self] _ in
            
            let status: Status = self.statusPhtots
            
            handler(status)
        }
        
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *) {
            
            PHPhotoLibrary.requestAuthorization(for: level.phAccessLevel, handler: completionHandler)
        } else {
            
            PHPhotoLibrary.requestAuthorization(completionHandler)
        }
    }
}

private extension PHAuthorizationStatus
{
    var status: DTPermission.Status {
        
        let status: DTPermission.Status
        
        switch self {
        case .authorized:
            status = .authorized
            
        case .restricted, .denied:
            status = .denied
            
        case .notDetermined:
            status = .notDetermined
            
        case .limited:
            status = .limit
            
        default:
            fatalError()
        }
        
        return status
    }
}
