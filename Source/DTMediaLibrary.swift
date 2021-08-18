//
//  DTMediaLibrary.swift
//
//  Created by Darktt on 19/1/28.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import MediaPlayer

@available(iOS 9.3, *)
internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusMediaLibrary: Status {
        
        let statusMediaLibrary: MPMediaLibraryAuthorizationStatus = MPMediaLibrary.authorizationStatus()
        
        var status: Status = .notDetermined
        
        switch statusMediaLibrary {
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
    
    func requestMediaLibrary(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .mediaLibraryUsageDescription
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let completionHandler: (MPMediaLibraryAuthorizationStatus) -> Void = {
            
            [unowned self] _ in
            
            let status: Status = self.statusMediaLibrary
            
            result(status)
        }
        
        MPMediaLibrary.requestAuthorization(completionHandler)
    }
}
