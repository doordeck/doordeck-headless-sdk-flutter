//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<doordeck_headless_sdk_flutter/DoordeckHeadlessSdkFlutterPlugin.h>)
#import <doordeck_headless_sdk_flutter/DoordeckHeadlessSdkFlutterPlugin.h>
#else
@import doordeck_headless_sdk_flutter;
#endif

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [DoordeckHeadlessSdkFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"DoordeckHeadlessSdkFlutterPlugin"]];
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
}

@end
