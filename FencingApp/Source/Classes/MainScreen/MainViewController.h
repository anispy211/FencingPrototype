//
//  MainViewController.h
//  FencingApp
//
//  Created by Aniruddha Kadam on 01/08/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
#import <MobileCoreServices/MobileCoreServices.h>





@interface MainViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) ICSDrawerController *drawer;

#pragma mark - PROFILE VIEW CONTROLLER MESSAGES

- (void)didReciveMessageFromProfileVC:(int)msg;

@end
