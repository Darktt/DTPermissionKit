//
//  SFSpeechRecognizerExtension.swift
//  
//  Created by Darktt on 21/9/23.
//  Copyright © 2021年 Darktt. All rights reserved.
//

import Speech

internal extension SFSpeechRecognizer
{
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    static func requestAuthorization() async -> SFSpeechRecognizerAuthorizationStatus
    {
        let status: SFSpeechRecognizerAuthorizationStatus = await withCheckedContinuation {
            
            continuation in
                        
            self.requestAuthorization {
                
                continuation.resume(returning: $0)
            }
        }
        
        return status
    }
}
