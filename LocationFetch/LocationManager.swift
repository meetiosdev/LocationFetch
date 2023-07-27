import UIKit
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    static let shared = LocationFetcher()
    
    private var locationManager: CLLocationManager?
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    func fetchLocation(completion: @escaping (CLLocation?) -> Void) {
        self.locationCompletion = completion
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            showLocationDeniedAlert()
            locationCompletion?(nil)
            locationCompletion = nil
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        @unknown default:
            locationCompletion?(nil)
            locationCompletion = nil
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            showLocationDeniedAlert()
            locationCompletion = nil
        default:
            locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        let location = locations.last
        locationCompletion?(location)
        locationCompletion = nil
    }
    
    private func showLocationDeniedAlert() {
        // Show an alert to the user indicating that location access is denied
        // You can customize the alert message and actions as per your requirements
        let alertController = UIAlertController(title: "Location Access Denied",
                                                message: "Please enable location access in Settings.",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
