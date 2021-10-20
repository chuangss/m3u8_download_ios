#import "M3u8DownloadIosPlugin.h"
#if __has_include(<m3u8_download_ios/m3u8_download_ios-Swift.h>)
#import <m3u8_download_ios/m3u8_download_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "m3u8_download_ios-Swift.h"
#endif

@implementation M3u8DownloadIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftM3u8DownloadIosPlugin registerWithRegistrar:registrar];
}
@end
