//
//  LocationHelper.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 18/09/19.
//

import CoreLocation

internal class LocationHelper: NSObject {
    static let instance = LocationHelper()
    var onGetLocation: ((_ latitude: String, _ longitude: String)->())?
    
    private var isStartUpdated = false
    private let locationManager = CLLocationManager()
    
    func getLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.isStartUpdated = true
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                self.showDeniedDialog()
                self.isStartUpdated = false
            case .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func showDeniedDialog() {
        let alert = UIAlertController(title: "Permission Dialog", message: "Your location permission is denied, you must change it on the setting menu", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }))
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = (UIApplication.shared.windows.last?.windowLevel)! + 1
        window.rootViewController = UIViewController()
        window.tintColor = UIApplication.shared.keyWindow?.tintColor
        window.makeKeyAndVisible()

        
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            self.isStartUpdated = false
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last, isStartUpdated else { return }
        self.onGetLocation?(String(lastLocation.coordinate.latitude), String(lastLocation.coordinate.longitude))
        self.isStartUpdated = false
        manager.stopUpdatingLocation()
    }
}
