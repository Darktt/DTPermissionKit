//
//  AVCaptureDeviceExtension.swift
//  
//  Created by Darktt on 21/9/23.
//  Copyright © 2021年 Darktt. All rights reserved.
//

import AVFoundation


internal extension AVCaptureDevice
{
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    static func requestAccess(to mediaType: AVMediaType) async -> Bool
    {
        let result: Bool = await withCheckedContinuation {
            
            contnuation in
            
            self.requestAccess(for: mediaType) {
                
                contnuation.resume(returning: $0)
            }
        }
        
        return result
    }
}
