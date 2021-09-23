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
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func requestPhotos(for level: PhotoAccessLevel) async -> Status
    {
        let key: DTInfoKey = .photoLibraryUsageDescription
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let _ = await PHPhotoLibrary.requestAuthorization(for: level.phAccessLevel)
        let status: Status = self.statusPhtots
        
        return status
    }
}

private extension PHAuthorizationStatus
{
    var status: DTPermission.Status {
        
        var status: DTPermission.Status = .notDetermined
        
        if self == .authorized {
            
            status = .authorized
        }
        
        if self == .restricted || self == .denied {
            
            status = .denied
        }
        
        if #available(iOS 14.0, *), self == .limited {
            
            status = .limit
        }
        
        return status
    }
}
