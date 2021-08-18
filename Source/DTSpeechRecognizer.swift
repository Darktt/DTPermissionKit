//
//  DTSpeechRecognizer.swift
//
//  Created by Darktt on 19/1/29.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import Speech

@available(iOS 10.0, *)
internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusSpeechRecognizer: Status {
        
        let statusSpeechRecognizer: SFSpeechRecognizerAuthorizationStatus = SFSpeechRecognizer.authorizationStatus()
        
        var status: Status = .notDetermined
        
        switch statusSpeechRecognizer {
        case .authorized:
            status = .authorized
            
        case .restricted, .denied:
            status = .denied
            
        case .notDetermined:
            status = .notDetermined
            
        default:
            fatalError()
        }
        
        return status
    }
    
    // MARK: - Methods -
    
    func requestSpeechRecognizer(with result: @escaping RequestHandler)
    {
        let keys: Set<DTInfoKey> = [.microphoneUsageDescription, .speechRecognitionUsageDescription]
        
        for key in keys {
            
            if Bundle.object(forInfoDictionaryKey: key) == nil {
                
                fatalError("WARNING: \(key.rawValue) not found in Info.plist")
            }
        }
        
        let completionHandler: (SFSpeechRecognizerAuthorizationStatus) -> Void = {
            
            [unowned self] _ in
            
            let status: Status = self.statusSpeechRecognizer
            
            OperationQueue.mainOperation {
                
                result(status)
            }
        }
        
        SFSpeechRecognizer.requestAuthorization(completionHandler)
    }
}
