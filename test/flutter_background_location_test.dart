/*
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_background_location/flutter_background_location.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_background_location');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterBackgroundLocation.platformVersion, '42');
  });
}
*/
