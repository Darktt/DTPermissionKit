# DTPermissionKit
Check iOS permission

Usage:
```
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
