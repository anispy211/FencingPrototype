//
//  ProfileScreenViewController.m
//  FencingApp
//
//  Created by Aniruddha Kadam on 03/08/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import "ProfileScreenViewController.h"
#import "ProfileTableViewCell.h"
#import "Utilities.h"
#import "DropBoxManager.h"
#import "AppDelegate.h"


@interface ProfileScreenViewController ()
{
    NSArray * mainArray;
    
    NSMutableDictionary * userInfo;
}

@property (nonatomic,weak) IBOutlet UILabel * nameLabel;
@property (nonatomic,weak) IBOutlet UILabel * emailLbl;

@property (nonatomic,weak) IBOutlet UITableView * myTableView;

@end

@implementation ProfileScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mainArray = [[NSArray alloc] initWithObjects:@"Home",@"Profile",@"Policies",@"Terms & Conditions",@"Settings",@"Logout", nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self loadUserInfo];
}


- (void)refreshProfilVCData
{
    NSString * name = [userInfo valueForKey:USER_NAME];
    
    if (name)
    {
        NSArray * namearray = [name componentsSeparatedByString:@" "];
        if (namearray)
        {
            [self.nameLabel setText:[NSString stringWithFormat:@"%@",namearray[0]]];
        }
    }
    
    NSString * email = [userInfo valueForKey:EMAIL];
    
    [self.emailLbl setText:[NSString stringWithFormat:@"%@",email]];
    
    [self.myTableView reloadData];
    
}


#pragma mark - MAIN VIEW CONTROLLER MESSAGES

- (void)didReciveMessageFromMainVC:(int)msg
{
    switch (msg)
    {
        case 1:
            [self loadUserInfo];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Profile INFO

- (void)loadUserInfo
{
    userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setObject:[Utilities getValueForKey:USER_NAME] forKey:USER_NAME];
    [userInfo setObject:[Utilities getValueForKey:USER_ID] forKey:USER_ID];
    [userInfo setObject:[Utilities getValueForKey:EMAIL] forKey:EMAIL];
    [userInfo setObject:[Utilities getValueForKey:COUNTRY] forKey:COUNTRY];
    [userInfo setObject:[Utilities getValueForKey:REF_LINK] forKey:REF_LINK];
    
    [self refreshProfilVCData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [mainArray count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Profile_Cell";
    
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    
    cell.nameLbl.text = [NSString stringWithFormat:@"%@",[mainArray objectAtIndex:indexPath.row]];
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 65;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.drawer close];

    if (indexPath.row == 5)
    {
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate showHUDActivityIndicator:@"Logging Out..."];
        
        [self performSelector:@selector(logout) withObject:self afterDelay:2.0];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -- LOGOUT

- (void)logout
{
    DropBoxManager * objManager = [DropBoxManager dropBoxManager];
    [objManager logoutFromDropbox];
    
    [Utilities resetDefaults];
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate hideHUDActivityIndicator];
    
    [delegate loadLoginView];


}

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark - MEMORY
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
