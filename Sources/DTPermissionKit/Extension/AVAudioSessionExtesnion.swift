//
//  AVAudioSessionExtesnion.swift
//
//  Created by Darktt on 21/9/23.
//  Copyright © 2021年 Darktt. All rights reserved.
//

import AVFoundation

internal extension AVAudioSession
{
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func requestRecordPermission() async -> Bool
    {
        let result: Bool = await withCheckedContinuation {
            
            [unowned self] continuation in
            
            self.requestRecordPermission {
                
                continuation.resume(returning: $0)
            }
        }
        
        return result
    }
}
