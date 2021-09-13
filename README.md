# DTPermissionKit
Check iOS permission

Usage:
```swift
// Request camera permission.
let premission = DTPermission.camera
premission.request {
    
    status in
    
    switch status {
    
    case .authorized:
        // Can access camera.
        break
    
    case .denied:
        // User denied camera access permission.
        break
    
    case .notDetermined:
        // User not determine.
        break
    
    default:
        // Other case.
        break
    }
}
```

Note:
When summit app to **Apple Store Connect**, you need add all privacy, then just write description of requested permission on you app, other description can be empty.

