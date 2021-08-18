//
//  DTReminders.swift
//
//  Created by Darktt on 19/1/29.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import EventKit

internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusReminders: Status {
        
        let statusReminders: EKAuthorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
        
        var status: Status = .notDetermined
        
        switch statusReminders {
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
    
    func requestReminders(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .remindersUsageDescription
        
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARING: \(key.rawValue) not found in Info.plist.")
        }
        
        let completionHandler: (Bool, Error?) -> Void = {
            
            [unowned self] _, _ in
            
            let status: Status = self.statusReminders
            
            result(status)
        }
        
        let store = EKEventStore()
        store.requestAccess(to: .reminder, completion: completionHandler)
    }
}
