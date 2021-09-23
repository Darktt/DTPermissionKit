//
//  DTSiri.swift
//
//  Created by Darktt on 19/1/29.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Intents

@available(iOS 10.0, *)
internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusSiri: Status {
        
        let statusSiri: INSiriAuthorizationStatus = INPreferences.siriAuthorizationStatus()
        
        var status: Status = .notDetermined
        
        switch statusSiri {
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
    
    func requestSiri(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .siriUsageDescription
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let completionHandler: (INSiriAuthorizationStatus) -> Void = {
            
            [unowned self] _ in
            
            let status: Status = self.statusSiri
            
            result(status)
        }
        
        INPreferences.requestSiriAuthorization(completionHandler)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func requestSiri() async -> Status
    {
        let key: DTInfoKey = .siriUsageDescription
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let _ = await INPreferences.requestSiriAuthorization()
        let status: Status = self.statusSiri
        
        return status
    }
}
