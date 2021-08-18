//
//  DTNotifications.swift
//
//  Created by Darktt on 19/1/29.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import UserNotifications
import UIKit.UIApplication

@available(iOS 10.0, *)
internal extension DTPermission
{
    // MARK: - Properties -
    
    fileprivate var notificationCenter: UNUserNotificationCenter {
        
        return UNUserNotificationCenter.current()
    }
    
    // MARK: - Methods -
    
    func statusAndRequestNotifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>? , with result: @escaping RequestHandler)
    {
        let statusResult: RequestHandler = {
            
            status in
            
            if status != .notDetermined {
                
                result(status)
                return
            }
            
            self.requestNotifications(options: options, categories: categories, with: result)
        }
        
        self.statusForNotifications(with: statusResult)
    }
    
    func statusNotifications(with result: @escaping RequestHandler)
    {
        let completionHandler: (UNNotificationSettings) -> Void = {
            
            setting in
            
            let statusNotification: UNAuthorizationStatus = setting.authorizationStatus
            var status: Status = .notDetermined
            
            switch statusNotification {
            case .authorized, .provisional:
                status = .authorized
            
            case .denied:
                status = .denied
                
            case .notDetermined:
                status = .notDetermined
                
            default:
                fatalError()
            }
            
            OperationQueue.mainOperation {
                
                result(status)
            }
        }
        
        self.notificationCenter.getNotificationSettings(completionHandler: completionHandler)
    }
    
    @available(iOS 10, *)
    func requestNotifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>? , with result: @escaping RequestHandler)
    {
        let completionHandler: (Bool, Error?) -> Void = {
            
            grant, _ in
            
            let status: Status = grant ? .authorized : .denied
            
            OperationQueue.mainOperation {
                
                let application = UIApplication.shared
                application.registerForRemoteNotifications()
                result(status)
            }
        }
        
        if let categories = categories {
            
            self.notificationCenter.setNotificationCategories(categories)
        }
        
        self.notificationCenter.requestAuthorization(options: options, completionHandler: completionHandler)
    }
}
