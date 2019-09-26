#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"AIzaSyB87vkTpcrMAivnEtr_OzH7fi4dy_kCdLc"];
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // cancel old notifications that were scheduled to be periodically shown upon a reinstallation of the app
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"]){
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Notification"];
    }
    // Override point for customization after application launch.
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end