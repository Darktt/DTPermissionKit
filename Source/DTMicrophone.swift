//
//  DTMicrophone.swift
//
//  Created by Darktt on 19/1/29.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import AVFoundation

internal extension DTPermission
{
    // MARK: - Properties -
    
    fileprivate var audioSession: AVAudioSession {
        
        return AVAudioSession.sharedInstance()
    }
    
    var statusMicrophone: Status {
        
        let statusMicrophone: AVAudioSession.RecordPermission = self.audioSession.recordPermission
        
        var status: Status = .notDetermined
        
        switch statusMicrophone {
        case .granted:
            status = .authorized
            
        case .denied:
            status = .denied
            
        case .undetermined:
            status = .notDetermined
            
        default:
            fatalError()
        }
        
        return status
    }
    
    // MARK: - Methods -
    
    func requestMicrophone(with result: @escaping RequestHandler)
    {
        let key: DTInfoKey = .microphoneUsageDescription
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let completionHandler: (Bool) -> Void = {
            
            [unowned self] _ in
            
            let status: Status = self.statusMicrophone
            
            result(status)
        }
        
        self.audioSession.requestRecordPermission(completionHandler)
    }
}
