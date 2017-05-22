//
//  AppDelegate.m
//  Byte Me
//
//  Created by Leandro Marques on 07/04/2015.
//  Copyright (c) 2015 NetDevo Limited. All rights reserved.
//

#import "AppDelegate.h"
//#import "GAI.h"
#import "Constants.h"
#import "SettingsManager.h"
#import "Mixpanel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*
    if(trackingVerbose)
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    [[GAI sharedInstance] trackerWithTrackingId:trackingID];
     */
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Tell iOS you want your app to receive push notifications
    // This code will work in iOS 8.0 xcode 6.0 or later:
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    // Call .identify to flush the People record to Mixpanel
    [mixpanel identify:mixpanel.distinctId];
    
    
    
    
    
    
    
    
    [SettingsManager sharedSettings];
    
    
      
    
    // STYLES
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    //[[UINavigationBar appearance] setBarTintColor:globalBackgroundColor];
    //[[UINavigationBar appearance] setTranslucent:NO];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:navigationBarTintColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:@{
                              NSFontAttributeName: [UIFont fontWithName:@"Quicksand-Bold" size:17],
                              }
     forState:UIControlStateNormal];
    
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"Quicksand-Bold" size:15],
                                                                                                 }];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:@{
                              NSFontAttributeName: [UIFont fontWithName:@"Quicksand-Bold" size:17],
                              }
     forState:UIControlStateNormal];
    
    /*
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
   
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:globalBackgroundColor];
     */

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people addPushDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Show alert for push notifications recevied while the
    // app is running
    NSString *message = [[userInfo objectForKey:@"aps"]
                         objectForKey:@"alert"];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:message
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    //[alert release];
}




@end
