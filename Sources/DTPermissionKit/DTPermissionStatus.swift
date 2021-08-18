//
//  DTPermissionStatus.swift
//
//  Created by Darktt on 19/1/24.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Photos

public extension DTPermission
{
    enum Status: String
    {
        case authorized     = "Authorized"
        
        // For location always use.
        case authorizedAlways = "Authorized Always"
        
        // For location when in use.
        case authorizedWhenInUse = "Authorized WhenInUse"
        
        case denied         = "Denied"
        
        case disabled       = "Disabled"
        
        case notDetermined  = "Not Determined"
        
        // For photo on iOS 14.0 or later.
        case limit = "Limit"
    }
}

extension DTPermission.Status: CustomStringConvertible
{
    public var description: String {
        
        return self.rawValue
    }
}

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
