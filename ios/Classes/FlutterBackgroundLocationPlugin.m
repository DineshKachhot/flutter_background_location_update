#import "FlutterBackgroundLocationPlugin.h"
#import <flutter_background_location/flutter_background_location-Swift.h>

@implementation FlutterBackgroundLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBackgroundLocationPlugin registerWithRegistrar:registrar];
}
@end
