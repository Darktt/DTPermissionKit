//
//  DTContacts.swift
//
//  Created by Darktt on 19/1/28.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Contacts

@available(iOS 9.0, *)
internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusContacts: Status {
        
        let contactsStatus: CNAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        var status: Status = .notDetermined
        
        switch contactsStatus {
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
    
    func requestContacts(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .contactUssageDescription
        
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARING: \(key.rawValue) not found in Info.plist.")
        }
        
        let completionHandler: (Bool, Error?) -> Void = {
            
            [unowned self] _, _ in
            
            let status = self.statusContacts
            result(status)
        }
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: completionHandler)
    }
}
