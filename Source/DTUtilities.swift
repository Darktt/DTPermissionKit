//
//  DTUtilities.swift
//
//  Created by Darktt on 19/1/28.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Foundation

internal enum DTInfoKey: String
{
    case cameraUsageDescription = "NSCameraUsageDescription"
    
    case contactUssageDescription = "NSContactsUsageDescription"
    
    case eventUsageDescription = "NSCalendarsUsageDescription"
    
    case locationAlwaysAndWhenInUseUsageDescription = "NSLocationAlwaysAndWhenInUseUsageDescription"
    
    @available(iOS, introduced: 8.0, deprecated: 13.0)
    case locationAlwaysUsageDescription = "NSLocationAlwaysUsageDescription"
    
    case locationWhenInUseUsageDescription = "NSLocationWhenInUseUsageDescription"
    
    case mediaLibraryUsageDescription = "NSAppleMusicUsageDescription"
    
    case microphoneUsageDescription = "NSMicrophoneUsageDescription"
    
    case photoLibraryAddUsageDescription = "NSPhotoLibraryAddUsageDescription"
    
    case photoLibraryUsageDescription = "NSPhotoLibraryUsageDescription"
    
    case remindersUsageDescription = "NSRemindersUsageDescription"
    
    case siriUsageDescription = "NSSiriUsageDescription"
    
    case speechRecognitionUsageDescription = "NSSpeechRecognitionUsageDescription"
}

internal extension Bundle
{
    static func object(forInfoDictionaryKey key: DTInfoKey) -> Any?
    {
        let bundle = Bundle.main
        let object: Any? = bundle.object(forInfoDictionaryKey: key.rawValue)
        
        return object
    }
}

internal extension OperationQueue
{
    static func mainOperation(with block: @escaping () -> Void)
    {
        let queue = OperationQueue.main
        queue.addOperation(block)
    }
}
