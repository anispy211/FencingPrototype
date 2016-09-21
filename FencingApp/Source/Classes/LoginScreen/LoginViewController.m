//
//  ViewController.m
//  FencingApp
//
//  Created by Aniruddha Kadam on 28/07/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic,weak) IBOutlet UIImageView * backgroundImgView;

- (IBAction)loginWithDBButtonAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViewlayout];
}

- (void)setupViewlayout
{
    objManager = [DropBoxManager dropBoxManager];
    objManager.apiCallDelegate =self;
}


#pragma mark - NOTIFICATIONS

//- (void)addObserver
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:DB_LOGIN_SUCCESS object:nil];
//}
//
//
//- (void)removeObserver
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:DB_LOGIN_SUCCESS object:nil];
//}

#pragma mark - Methods

- (void)loginSuccess
{
    
}



#pragma mark - UI INTERACTIONS

- (IBAction)loginWithDBButtonAction:(id)sender
{
    if ([objManager isLinkedDB])
    {
        [objManager logoutFromDropbox];
    }
    else
    {
        [objManager loginToDropbox];
    }
}




#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
