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
    
    func statusAndRequestNotifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>?, with result: @escaping RequestHandler)
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
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func statusAndRequestNotifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>?) async -> Status
    {
        let status: Status = await self.statusForNotifications()
        
        guard status != .notDetermined else {
            
            let status: Status = await self.requestNotifications(options: options, categories: categories)
            
            return status
        }
        
        return status
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
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func statusNotifications() async -> Status
    {
        let status: Status = await withCheckedContinuation {
            
            [unowned self] continuation in
            
            self.statusNotifications {
                
                continuation.resume(returning: $0)
            }
        }
        
        return status
    }
    
    @available(iOS 10.0, *)
    func requestNotifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>?, with result: @escaping RequestHandler)
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
        
        if let categories: Set<UNNotificationCategory> = categories {
            
            self.notificationCenter.setNotificationCategories(categories)
        }
        
        self.notificationCenter.requestAuthorization(options: options, completionHandler: completionHandler)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func requestNotifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>?) async -> Status
    {
        if let categories: Set<UNNotificationCategory> = categories {
            
            self.notificationCenter.setNotificationCategories(categories)
        }
        
        let grant: Bool = (try? await self.notificationCenter.requestAuthorization(options: options)) ?? false
        let status: Status = grant ? .authorized : .denied
        
        if grant {
            
            let application = await UIApplication.shared
            await application.registerForRemoteNotifications()
        }
        
        return status
    }
}
 
