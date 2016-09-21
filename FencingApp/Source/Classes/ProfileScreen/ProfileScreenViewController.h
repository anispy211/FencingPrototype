//
//  ProfileScreenViewController.h
//  FencingApp
//
//  Created by Aniruddha Kadam on 03/08/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"


@interface ProfileScreenViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

#pragma mark - MAIN VIEW CONTROLLER MESSAGES

- (void)didReciveMessageFromMainVC:(int)msg;

@end
