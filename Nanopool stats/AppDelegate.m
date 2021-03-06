//
//  AppDelegate.m
//  Nanopool stats
//
//  Created by Mihai Dragnea on 5/29/17.
//  Copyright © 2017 Dragnea Mihai. All rights reserved.
//

#import "AppDelegate.h"
#import "NanopoolController.h"
#import "AccountVC.h"
#import "DBController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)customizeAppearances {
    [[UINavigationBar appearance] setBarTintColor:[UIColor themeColorBackground]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont systemFontOfSize:22.0f]}];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"left_arrow"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"left_arrow"]];
    
    UIBarButtonItem<UIAppearance> *barButtonAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]];
    if (@available(iOS 11, *)) {
        [barButtonAppearance setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:0.1], NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
        [barButtonAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateHighlighted];
    } else {
        [barButtonAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-200.0f, 0.0f) forBarMetrics:UIBarMetricsDefault];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [DBController setupWithName:@"Database"];
    [self customizeAppearances];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[AccountVC alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //[[NanopoolController sharedInstance] updateAccounts:completionHandler];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
