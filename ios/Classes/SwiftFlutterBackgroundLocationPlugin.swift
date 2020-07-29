import Flutter
import UIKit
import CoreLocation

public class SwiftFlutterBackgroundLocationPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    static var locationManager: CLLocationManager?
    static var channel: FlutterMethodChannel?
    static var timer: Timer?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterBackgroundLocationPlugin()

        SwiftFlutterBackgroundLocationPlugin.channel = FlutterMethodChannel(name: "flutter_background_location", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: SwiftFlutterBackgroundLocationPlugin.channel!)
        SwiftFlutterBackgroundLocationPlugin.channel?.setMethodCallHandler(instance.handle)
        instance.initializLocationManager();
    }
    
    private func initializLocationManager() {
        SwiftFlutterBackgroundLocationPlugin.locationManager = CLLocationManager()
        SwiftFlutterBackgroundLocationPlugin.locationManager?.delegate = self
        SwiftFlutterBackgroundLocationPlugin.locationManager?.requestWhenInUseAuthorization()
        SwiftFlutterBackgroundLocationPlugin.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        SwiftFlutterBackgroundLocationPlugin.locationManager?.pausesLocationUpdatesAutomatically = false
        if #available(iOS 11.0, *) {
            SwiftFlutterBackgroundLocationPlugin.locationManager?.showsBackgroundLocationIndicator = false
        }
        if #available(iOS 9.0, *) {
            SwiftFlutterBackgroundLocationPlugin.locationManager?.allowsBackgroundLocationUpdates = true
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if let args = call.arguments as? Dictionary<String, Any>, let distanceFilter = args["distance_filter"] as? Double {
            SwiftFlutterBackgroundLocationPlugin.locationManager?.distanceFilter = distanceFilter
        }
        
        if let args = call.arguments as? Dictionary<String, Any>, let timeInterval = args["time_interval"] as? Double {
            if #available(iOS 10.0, *) {
                SwiftFlutterBackgroundLocationPlugin.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
                    SwiftFlutterBackgroundLocationPlugin.locationManager?.requestLocation()
                }
            }
        }
        
        SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "method")

        if (call.method == "start_location_service") {
            SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "start_location_service")
            SwiftFlutterBackgroundLocationPlugin.locationManager?.startUpdatingLocation()
        } else if (call.method == "stop_location_service") {
            SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "stop_location_service")
            SwiftFlutterBackgroundLocationPlugin.locationManager?.stopUpdatingLocation()
            SwiftFlutterBackgroundLocationPlugin.timer?.invalidate()
        } else if (call.method == "one_shot_location") {
            SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "one_shot_location")
            if #available(iOS 9.0, *) {
                SwiftFlutterBackgroundLocationPlugin.locationManager?.requestLocation()
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {

        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = [
            "speed": locations.last!.speed,
            "altitude": locations.last!.altitude,
            "latitude": locations.last!.coordinate.latitude,
            "longitude": locations.last!.coordinate.longitude,
            "accuracy": locations.last!.horizontalAccuracy,
            "bearing": locations.last!.course,
        ] as [String : Any]

        SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: location)
    }
}
