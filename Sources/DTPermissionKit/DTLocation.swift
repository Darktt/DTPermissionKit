//
//  DTLocationManager.swift
//
//  Created by Darktt on 19/1/28.
//  Copyright © 2019年 Darktt. All rights reserved.
//

import CoreLocation

internal extension DTPermission
{
    // MARK: - Properties -
    
    var statusLocation: Status {
        
        return LocationDelegate.status
    }
    
    // MARK: - Methods -
    
    func requestLocation(for type: ServiceType, with result: @escaping RequestHandler)
    {
        var key: DTInfoKey = .locationWhenInUseUsageDescription
        
        if type == .locationAlways {
            
            key = .locationAlwaysUsageDescription
        }
        
        if #available(iOS 11.0, *), type == .locationAlwaysAndWhenInUse {
            
            key = .locationAlwaysAndWhenInUseUsageDescription
        }
        
        guard let _ = Bundle.object(forInfoDictionaryKey: key) else {
            
            fatalError("WARNING: \(key.rawValue) not found in Info.plist")
        }
        
        let delegate = LocationDelegate(whth: result)
        delegate.request(for: type)
        
        self.locationDelegate = delegate
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func requestLocation(for type: ServiceType) async -> Status
    {
        let status: Status = await withCheckedContinuation {
            
            [unowned self] continuation in
            
            self.requestLocation(for: type) {
                
                continuation.resume(returning: $0)
            }
        }
        
        return status
    }
}

internal extension DTPermission
{
    class LocationDelegate: NSObject
    {
        // MARK: - Properties -
        
        fileprivate static var status: Status {
            
            var statusLocation: CLAuthorizationStatus = .notDetermined
            var fullAccuracy: Bool = true
            
            if #available(iOS 14.0, *) {
                
                let manager = CLLocationManager()
                
                statusLocation = manager.authorizationStatus
                fullAccuracy = (manager.accuracyAuthorization == .fullAccuracy)
                
            } else {
                // Fallback on earlier versions
                
                statusLocation = CLLocationManager.authorizationStatus()
            }
            
            
            var status: Status = .notDetermined
            
            switch statusLocation {
            case .authorizedAlways:
                status = .authorizedAlways(fullAccuracy: fullAccuracy)
                
            case .authorizedWhenInUse:
                status = .authorizedWhenInUse(fullAccuracy: fullAccuracy)
                
            case .restricted, .denied:
                status = .denied
                
            case .notDetermined:
                status = .notDetermined
                
            default:
                fatalError()
            }
            
            return status
        }
        
        fileprivate var status: Status {
            
            return LocationDelegate.status
        }
        
        fileprivate let result: RequestHandler
        
        fileprivate lazy var locationManager: CLLocationManager = {
            
            let manager = CLLocationManager()
            manager.delegate = self
            
            return manager
        }()
        
        // MARK: - Methods -
        
        fileprivate init(whth result: @escaping RequestHandler)
        {
            self.result = result
            
            super.init()
        }
        
        fileprivate func request(for type: ServiceType)
        {
            if type == .locationAlways {
                
                self.locationManager.requestAlwaysAuthorization()
            }
            
            if type == .locationWhenInUse {
                
                self.locationManager.requestWhenInUseAuthorization()
            }
            
            if #available(iOS 11.0, *), type == .locationAlwaysAndWhenInUse {
                
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.requestAlwaysAuthorization()
            }
        }
    }
}

extension DTPermission.LocationDelegate: CLLocationManagerDelegate
{
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        guard status != .notDetermined else {
            
            return
        }
        
        let premissionStatus: DTPermission.Status = self.status
        self.result(premissionStatus)
    }
    
    @available(iOS 14.0, *)
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        let premissionStatus: DTPermission.Status = self.status
        self.result(premissionStatus)
    }
}
