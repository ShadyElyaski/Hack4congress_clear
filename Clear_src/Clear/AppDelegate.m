//
//  AppDelegate.m
//  Clear
//
//  Created by Shady A. Elyaski on 3/22/15.
//  Copyright (c) 2015 Elyaski. All rights reserved.
//

#import "AppDelegate.h"
#import <OpenSans/UIFont+OpenSans.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:64/255. green:70/255. blue:79/255. alpha:1];
    [UILabel appearance].font = [UIFont openSansFontOfSize:18];
    [UITextView appearance].font = [UIFont openSansFontOfSize:16];
    [UITextField appearance].font = [UIFont openSansFontOfSize:16];
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObjects:@[[UIFont openSansBoldFontOfSize:20], [UIColor whiteColor]] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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

@end
