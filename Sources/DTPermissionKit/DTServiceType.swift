//
//  DTServiceType.swift
//
//  Created by Darktt on 19/1/24.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import UIKit
import UserNotifications

public extension DTPermission
{
    enum ServiceType
    {
        @available(iOS 9.0, *)
        case contacts
        
        case locationAlways
        
        case locationWhenInUse
        
        @available(iOS 11.0, *)
        case locationAlwaysAndWhenInUse
        
        @available(iOS 10.0, *)
        case notifications(options: UNAuthorizationOptions, categories: Set<UNNotificationCategory>?)
        
        case microphone
        
        case camera
        
        case photos(level: PhotoAccessLevel)
        
        case reminders
        
        case events
        
        @available(iOS 10.0, *)
        case speechRecognizer
        
        @available(iOS 9.3, *)
        case mediaLibrary
        
        @available(iOS 10.0, *)
        case siri
    }
}

extension DTPermission.ServiceType: CustomStringConvertible, Equatable
{
    public var description: String {
        
        let description: String!
        
        switch self {
        case .contacts:
            description = "Contacts"
            
        case .locationAlways:
            description = "Location always usage"
            
        case .locationWhenInUse:
            description = "Location when in use"
            
        case .locationAlwaysAndWhenInUse:
            description = "Location always and when in use"
            
        case .notifications:
            description = "Notifications"
            
        case .microphone:
            description = "Microphone"
            
        case .camera:
            description = "Camera"
            
        case .photos:
            description = "Photos"
            
        case .reminders:
            description = "Reminders"
            
        case .events:
            description = "Events"
            
        case .speechRecognizer:
            description = "Speech Recognizer"
            
        case .mediaLibrary:
            description = "Media Library"
            
        case .siri:
            description = "SiriKit"
        }
        
        return description
    }
    
    public static func ==(lhs: DTPermission.ServiceType, rhs: DTPermission.ServiceType) -> Bool
    {
        return lhs.description == rhs.description
    }
}
