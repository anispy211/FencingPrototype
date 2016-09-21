//
//  AppDelegate.h
//  FencingApp
//
//  Created by Aniruddha Kadam on 28/07/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MBProgressHUD * hudActivityIndicator;



- (void)loadLoginView;

#pragma mark - MESSAGE

- (void)sendMessageToMainVC:(int)msg;
- (void)sendMessageToProfileVC:(int)msg;

#pragma mark - Loading Indicator -- MBHUD

- (void) showHUDActivityIndicator:(NSString *)message;
- (void) hideHUDActivityIndicator;

@end

