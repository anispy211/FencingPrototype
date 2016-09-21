//
//  AppDelegate.m
//  FencingApp
//
//  Created by Aniruddha Kadam on 28/07/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import "AppDelegate.h"
//#import <DropboxSDK/DropboxSDK.h>
#include "DropBoxManager.h"
#import "ICSDrawerController.h"
#import "ProfileScreenViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"


@interface AppDelegate ()
{
    ProfileScreenViewController * profileVC;
    MainViewController * mainVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    DropBoxManager *objManager;
    objManager = [DropBoxManager dropBoxManager];
    [objManager initDropbox];

    if ([[DBSession sharedSession] isLinked])
    {
        [self loadMainView];
    }
    else
    {
        [self loadLoginView];
    }
  
    return YES;
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0); // no equiv. notification. return NO if the application can't open for some reason



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([[DBSession sharedSession] handleOpenURL:url])
    {
        if ([[DBSession sharedSession] isLinked])
        {
            // At this point you can start making API Calls. Login was successful
            NSLog(@"Login Successfull ");
            [self showHUDActivityIndicator:@"Siginig In.."];
            [self performSelector:@selector(loadMainView) withObject:self afterDelay:1.5];
        }
        else
        {
            // Login was canceled/failed.
            NSLog(@"AATA kay Gela Khadyat");
        }
        return YES;
    }
    
    return NO;
}




#pragma mark - LOGIN & MAINVIEW SWITCH

- (void)loadMainView
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:HOME_SCREEN_FLOW_STORYBOARD bundle:nil];
    
    if (profileVC == nil)
    {
        profileVC = [storyboard instantiateViewControllerWithIdentifier:PROFILE_VC_SID];
    }
    
    if (mainVC == nil)
    {
        mainVC = [storyboard instantiateViewControllerWithIdentifier:MAIN_VC_SID];
    }
    
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:profileVC
                                                                     centerViewController:mainVC];
    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];

    [self hideHUDActivityIndicator];

}

- (void)loadLoginView
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:MAIN_STORYBOARDS bundle:nil];
    
    LoginViewController * loginVC = [storyboard instantiateViewControllerWithIdentifier:LOGIN_VC_SID];

    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];

}

#pragma mark - MESSAGE

- (void)sendMessageToMainVC:(int)msg
{
    if (mainVC)
    {
        [mainVC didReciveMessageFromProfileVC:msg];
    }
}

- (void)sendMessageToProfileVC:(int)msg
{
    if (profileVC)
    {
        [profileVC didReciveMessageFromMainVC:msg];
    }
}

#pragma mark - Loading Indicator -- MBHUD

- (void)showHUDActivityIndicator:(NSString *)message
{
    // Start Activity Indicator
    if (self.hudActivityIndicator == nil) {
        // Set an offset to allow interaction over teh navigation bar.
        self.hudActivityIndicator = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
        [_hudActivityIndicator setLabelText:message];
    }
}


- (void)hideHUDActivityIndicator
{
    if (self.hudActivityIndicator) {
        [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];
        self.hudActivityIndicator = nil;
    }
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

//[[[DropBoxManager dropBoxManager] objRestClient] loadAccountInfo];



@end
