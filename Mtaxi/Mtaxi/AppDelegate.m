//
//  AppDelegate.m
//  BackendProject
//
//  Created by Marcos Vilela on 08/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //search for login details in the keychain and then try to sigin
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    if (currentSessionToken.username &&
        currentSessionToken.password) {
        

        NSError *error = nil;
        NSString *returnedUser;
        NSString *segueId;
        
        SignInToken *token = [[SignInToken alloc] initWithUsername:currentSessionToken.username andPassword:currentSessionToken.password andApnsToken:currentSessionToken.apnsToken];
        
        BOOL success = [UserServerController signIn:token userType:&returnedUser error: &error];
        
        if (!success) {
            segueId = @"LogInNavigationController";
            [CurrentSessionController resetCurrentSession];
        } else {
            if ([returnedUser isEqualToString:@"PASSENGER"]) {
                segueId = @"InitPassenger";
            }else{
                segueId = @"InitDriver";

            }
        }

        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:segueId];

    }
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    currentSessionToken.apnsToken = [deviceToken description] ;
    [CurrentSessionController writeCurrentSessionToken:currentSessionToken];

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
    //Generic Token
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    currentSessionToken.apnsToken = @"9a1cd758 47e20f1a 27132790 dfe1a0cb 4107f42d a1a39c01 9dd1a082 0fc5c504";
    [CurrentSessionController writeCurrentSessionToken:currentSessionToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
