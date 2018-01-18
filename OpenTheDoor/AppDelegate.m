//
//  AppDelegate.m
//  OpenTheDoor
//
//  Created by KongFanyi on 2017/2/27.
//  Copyright © 2017年 KongFanyi. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

//当前亮度
@property CGFloat currentLight;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    self.currentLight = [[UIScreen mainScreen] brightness];
    [[UIScreen mainScreen] setBrightness:0.9];
    [Bugly startWithAppId:@"31354da0d6"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[UIScreen mainScreen] setBrightness:_currentLight>0.1f?_currentLight:0.5f];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"init" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIScreen mainScreen] setBrightness:0.9];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
