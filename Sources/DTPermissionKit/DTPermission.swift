//
//  DTPermission.swift
//
//  Created by Darktt on 19/1/24.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import UserNotifications

public class DTPermission
{
    // MARK: - Properties -
    
    fileprivate let type: ServiceType
    
    public static let contacts: DTPermission = DTPermission(.contacts)
    
    public static let locationAlways: DTPermission = DTPermission(.locationAlways)
    
    public static let locationWhenInUse: DTPermission = DTPermission(.locationWhenInUse)
    
    @available(iOS 11.0, *)
    public static let locationAlwaysAndWhenInUse: DTPermission = DTPermission(.locationAlwaysAndWhenInUse)
    
    @available(iOS 10.0, *)
    public static let notifications: DTPermission = DTPermission.notifications(options: [.sound, .alert, .badge])
    
    public static let camera: DTPermission = DTPermission(.camera)
    
    public static let photo: DTPermission = DTPermission(.photos(level: .default))
    
    @available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *)
    public static let photosAddOnly: DTPermission = DTPermission(.photos(level: .addOnly))
    
    @available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *)
    public static let photosReadWrite: DTPermission = DTPermission(.photos(level: .readWrite))
    
    public static let reminders: DTPermission = DTPermission(.reminders)
    
    public static let events: DTPermission = DTPermission(.events)
    
    @available(iOS 10.0, *)
    public static let speechRecognizer: DTPermission = DTPermission(.speechRecognizer)
    
    @available(iOS 9.3, *)
    public static let mediaLibrary: DTPermission = DTPermission(.mediaLibrary)
    
    @available(iOS 10.0, *)
    public static let siri: DTPermission = DTPermission(.siri)
    
    public var status: Status {
        
        var status: Status = .notDetermined
        
        switch self.type {
        
        case .contacts:
            status = self.statusContacts
            
        case .locationAlways, .locationWhenInUse, .locationAlwaysAndWhenInUse:
            status = self.statusLocation
            
        case .microphone:
            status = self.statusMicrophone
            
        case .camera:
            status = self.statusCamera
            
        case .photos:
            status = self.statusPhtots
            
        case .reminders:
            status = self.statusReminders
            
        case .events:
            status = self.statusEvents
            
        case .speechRecognizer:
            status = self.statusSpeechRecognizer
            
        case .mediaLibrary:
            status = self.statusMediaLibrary
            
        case .siri:
            status = self.statusSiri
            
        case .notifications:
            fatalError("WARNING: Not support for notification type, please use statusForNotifications(with:) to query status.")
        }
        
        return status
    }
    
    internal var locationDelegate: LocationDelegate?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    @available(iOS 10.0, *)
    public static func notifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>? = nil) -> DTPermission
    {
        let type = ServiceType.notifications(options: options, categories: categories)
        let permission = DTPermission(type)
        
        return permission
    }
    
    public init(_ type: ServiceType)
    {
        self.type = type
    }
    
    deinit
    {
        self.locationDelegate = nil
    }
    
    public func request(with result: @escaping RequestHandler)
    {
        if case let .notifications(options: options, categories: categories) = self.type {
            
            self.statusAndRequestNotifications(options: options, categories: categories, with: result)
            return
        }
        
        let status = self.status
        
        // If permission not determined, callback current status.
        if status != .notDetermined {
            
            result(status)
            return
        }
        
        let type: ServiceType = self.type
        
        switch type {
            
        case .contacts:
            self.requestContacts(with: result)
            
        case .locationAlways, .locationWhenInUse, .locationAlwaysAndWhenInUse:
            self.requestLocation(for: type, with: result)
            
        case let .notifications(options, categories):
            self.requestNotifications(options: options, categories: categories, with: result)
            
        case .microphone:
            self.requestMicrophone(with: result)
            
        case .camera:
            self.requestCamera(with: result)
            
        case let .photos(level: level):
            self.requestPhotos(for: level, handler: result)
            
        case .reminders:
            self.requestReminders(with: result)
            
        case .events:
            self.requestEvent(with: result)
            
        case .speechRecognizer:
            self.requestSpeechRecognizer(with: result)
            
        case .mediaLibrary:
            self.requestMediaLibrary(with: result)
            
        case .siri:
            self.requestSiri(with: result)
        }
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func request() async -> Status
    {
        if case let .notifications(options: options, categories: categories) = self.type {
            
            let status: Status = await self.statusAndRequestNotifications(options: options, categories: categories)
            
            return status
        }
        
        var status = self.status
        
        // If permission not determined, callback current status.
        if status != .notDetermined {
            
            return status
        }
        
        let type: ServiceType = self.type
        
        switch type {
            
        case .contacts:
            status = await self.requestContacts()
            
        case .locationAlways, .locationWhenInUse, .locationAlwaysAndWhenInUse:
            status = await self.requestLocation(for: type)
            
        case let .notifications(options, categories):
            status = await self.requestNotifications(options: options, categories: categories)
            
        case .microphone:
            status = await self.requestMicrophone()
            
        case .camera:
            status = await self.requestCamera()
            
        case let .photos(level: level):
            status = await self.requestPhotos(for: level)
            
        case .reminders:
            status = await self.requestReminders()
            
        case .events:
            status = await self.requestEvent()
            
        case .speechRecognizer:
            status = await self.requestSpeechRecognizer()
            
        case .mediaLibrary:
            status = await self.requestMediaLibaray()
            
        case .siri:
            status = await self.requestSiri()
            
        }
        
        return status
    }
    
    public func statusForNotifications(with result: @escaping RequestHandler)
    {
        guard case .notifications(_, _) = self.type else {
            
            fatalError("WARNING: Only for notification status")
        }
        
        self.statusNotifications(with: result)
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func statusForNotifications() async -> Status {
        
        guard case .notifications(_, _) = self.type else {
            
            fatalError("WARNING: Only for notification status")
        }
        
        let status: Status = await self.statusNotifications()
        
        return status
    }
}

// MARK: - Closure -

public extension DTPermission
{
    typealias RequestHandler = (Status) -> Void
}
