import Flutter
import UIKit
import CoreLocation

public class SwiftFlutterBackgroundLocationPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    static var locationManager: CLLocationManager?
    static var channel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterBackgroundLocationPlugin()

        SwiftFlutterBackgroundLocationPlugin.channel = FlutterMethodChannel(name: "flutter_background_location", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: SwiftFlutterBackgroundLocationPlugin.channel!)
        SwiftFlutterBackgroundLocationPlugin.channel?.setMethodCallHandler(instance.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftFlutterBackgroundLocationPlugin.locationManager = CLLocationManager()
        SwiftFlutterBackgroundLocationPlugin.locationManager?.delegate = self
        SwiftFlutterBackgroundLocationPlugin.locationManager?.requestAlwaysAuthorization()
        SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "method")

        if (call.method == "start_location_service") {
            SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "start_location_service")
            SwiftFlutterBackgroundLocationPlugin.locationManager?.startUpdatingLocation()
        } else if (call.method == "stop_location_service") {
            SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "stop_location_service")
            SwiftFlutterBackgroundLocationPlugin.locationManager?.stopUpdatingLocation()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {

        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = [
            "speed": locations.last!.speed,
            "altitude": locations.last!.altitude,
            "latitude": locations.last!.coordinate.latitude,
            "longitude": locations.last!.coordinate.longitude,
            "accuracy": locations.last!.horizontalAccuracy,
            "bearing": locations.last!.course
        ] as [String : Any]

        SwiftFlutterBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: location)
    }
}
