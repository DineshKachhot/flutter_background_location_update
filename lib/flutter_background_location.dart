import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBackgroundLocation {
  static const MethodChannel _channel =
  const MethodChannel('flutter_background_location');

  static stopLocationService() {
    _channel.invokeMapMethod("stop_location_service");
  }

  static getOneShotLocation() {
    _channel.invokeListMethod('one_shot_location');
  }

  static startLocationService({double? timeInterval, double? distanceFilter}) {
    _channel.invokeMapMethod("start_location_service", <String, dynamic>{"time_interval": timeInterval, "distance_filter": distanceFilter});
  }

  Future<_Location> getCurrentLocation() async {
    Completer<_Location> completer = Completer();

    _Location? _location = _Location();
    await getLocationUpdates((location) {
      _location.latitude = location.latitude;
      _location.longitude = location.longitude;
      _location.accuracy = location.accuracy;
      _location.altitude = location.altitude;
      _location.bearing = location.bearing;
      _location.speed = location.speed;
      completer.complete(_location);
    });
    return completer.future;
  }

  static getLocationUpdates(Function(_Location) location) {
    _channel.setMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == "location") {
        Map locationData = Map.from(methodCall.arguments);
        // print(locationData["speed"]);
        location(_Location(
            latitude: locationData["latitude"],
            longitude: locationData["longitude"],
            altitude: locationData["altitude"],
            accuracy: locationData["accuracy"],
            bearing: locationData["bearing"],
            speed: locationData["speed"] * 3.6, // To convert meter/second to km/second
            ));
      }
    });
  }
}

class _Location {
  _Location(
      {this.longitude,
        this.latitude,
        this.altitude,
        this.accuracy,
        this.bearing,
        this.speed});

  double? latitude;
  double? longitude;
  double? altitude;
  double? bearing;
  double? accuracy;
  double? speed;
}
