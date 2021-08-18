//
//  DTCamera.swift
//
//  Created by Darktt on 19/1/28.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import AVFoundation

internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusCamera: Status {
        
        let cameraStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        var status: Status = .notDetermined
        
        switch cameraStatus {
        case .authorized:
            status = .authorized
        
        case .restricted, .denied:
            status = .denied
            
        case .notDetermined:
            status = .notDetermined
            
        default:
            fatalError()
        }
        
        return status
    }
    
    // MARK: - Methods -
    
    func requestCamera(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .cameraUsageDescription
        
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARING: \(key.rawValue) not found in Info.plist.")
        }
        
        let completionHandler: (Bool) -> Void = {
            
            [unowned self] _ in
            
            let status = self.statusCamera
            
            result(status)
        }
        
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completionHandler)
    }
}
