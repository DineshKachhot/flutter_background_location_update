#import "FlutterBackgroundLocationPlugin.h"
#import <flutter_background_location_update/flutter_background_location_update-Swift.h>

@implementation FlutterBackgroundLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBackgroundLocationPlugin registerWithRegistrar:registrar];
}
@end
