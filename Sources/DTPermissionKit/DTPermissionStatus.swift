//
//  DTPermissionStatus.swift
//
//  Created by Darktt on 19/1/24.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Photos

// MARK: - DTPermission.Status -

public extension DTPermission
{
    enum Status
    {
        case authorized
        
        // For location always use.
        case authorizedAlways(fullAccuracy: Bool)
        
        // For location when in use.
        case authorizedWhenInUse(fullAccuracy: Bool)
        
        case denied
        
        case disabled
        
        case notDetermined
        
        // For photo on iOS 14.0 or later.
        @available(iOS 14, *)
        case limit
    }
}

extension DTPermission.Status: CustomStringConvertible
{
    public var description: String {
        
        let description: String
        
        switch self {
        case .authorized:
            description = "Authorized"
            
        case let .authorizedAlways(fullAccuracy):
            description = "Authorized always, full accuracy: \(fullAccuracy)"
            
        case let .authorizedWhenInUse(fullAccuracy):
            description = "Authorized when in use, full accuracy: \(fullAccuracy)"
            
        case .denied:
            description = "Denied"
            
        case .disabled:
            description = "Disabled"
            
        case .notDetermined:
            description = "Not Determined"
            
        case .limit:
            description = "Limit"
        }
        
        return description
    }
}

extension DTPermission.Status: Equatable
{
    public static func == (lhs: DTPermission.Status, rhs: DTPermission.Status) -> Bool
    {
        return lhs.description == rhs.description
    }
}

// MARK: - DTPermission.PhotoAccessLevel -

public extension DTPermission
{
    enum PhotoAccessLevel
    {
        case `default`
        
        @available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *)
        case addOnly
        
        @available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *)
        case readWrite
    }
}

internal extension DTPermission.PhotoAccessLevel
{
    @available(iOS 14.0, tvOS 14.0, macOS 11.0, macCatalyst 14.0, *)
    var phAccessLevel: PHAccessLevel {
        
        var level: PHAccessLevel
        
        switch self {
            
            case .addOnly:
                level = .addOnly
            
            case .default, .readWrite:
                level = .readWrite
        }
        
        return level
    }
}
