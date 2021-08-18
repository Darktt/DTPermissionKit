//
//  DTEvents.swift
//
//  Created by Darktt on 19/1/28.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import EventKit

internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusEvents: Status {
        
        let statusEvent: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .event)
        var status: Status = .notDetermined
        
        switch statusEvent {
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
    
    func requestEvent(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .eventUsageDescription
        
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARING: \(key.rawValue) not found in Info.plist.")
        }
        
        let completionHandler: (Bool, Error?) -> Void = {
            
            [unowned self] _, _ in
            
            let status: Status = self.statusEvents
            
            result(status)
        }
        
        let store = EKEventStore()
        store.requestAccess(to: .event, completion: completionHandler)
    }
}
