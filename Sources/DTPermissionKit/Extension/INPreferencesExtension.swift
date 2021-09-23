//
//  INPreferencesExtension.swift
//  
//  Created by Darktt on 21/9/23.
//  Copyright © 2021年 Darktt. All rights reserved.
//

import Intents

internal extension INPreferences
{
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    static func requestSiriAuthorization() async -> INSiriAuthorizationStatus
    {
        let status: INSiriAuthorizationStatus = await withCheckedContinuation {
            
            continuation in
            
            self.requestSiriAuthorization {
                
                continuation.resume(returning: $0)
            }
        }
        
        return status
    }
}
