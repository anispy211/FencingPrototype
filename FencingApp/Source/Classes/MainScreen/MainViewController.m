//
//  MainViewController.m
//  FencingApp
//
//  Created by Aniruddha Kadam on 01/08/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import "MainViewController.h"
#import "DropBoxManager.h"
#import "Utilities.h"
#import "AppDelegate.h"

@interface MainViewController ()<DropBoxDelegate>
{
    DropBoxManager * objManager;
    AppDelegate * appDelegate;
}

@property(nonatomic, weak) UIButton *openDrawerButton;
@property(nonatomic, strong)IBOutlet UILabel * mainMsgLable;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

// Main Array data
@property (strong, nonatomic) NSMutableArray * mainListArray;


// ---- UICollectionView --- //
@property (strong, nonatomic) IBOutlet UICollectionView * collectionView;



- (IBAction)openDrawer:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = self.collectionView.frame.size.width;
    
    width = width - 180;
    width= width/3;
    
    [flowLayout setItemSize:CGSizeMake(width, width)];
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
   self.mainListArray = [[NSMutableArray alloc] init];
    
    [self reloadMyCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    [self loadDropboxUserCredentials];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDropboxUserCredentials];
}


- (void)reloadMyCollectionView
{
    if ([self.mainListArray count] == 0)
    {
        self.collectionView.hidden = YES;
        self.mainMsgLable.hidden = NO;
        return;
    }
    
    self.mainMsgLable.hidden = YES;
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
}


#pragma -mark Collection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.mainListArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellIdentifier = @"SMTag";
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView1 dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView1 didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView1 cellForItemAtIndexPath:indexPath];
//
//    return cell;
}





#pragma mark - PROFILE VIEW CONTROLLER MESSAGES

- (void)didReciveMessageFromProfileVC:(int)msg
{
    
}

#pragma mark - Dropbox

- (void)loadDropboxUserCredentials
{
//    [appDelegate showHUDActivityIndicator:@"Gathering Info..."];

    objManager = [DropBoxManager dropBoxManager];
    objManager.apiCallDelegate =self;
    [[objManager objRestClient] loadAccountInfo];
}

- (void)saveUserProfile:(NSMutableDictionary *)userInfo
{
    [Utilities saveValue:[userInfo valueForKey:USER_NAME] forKey:USER_NAME];
    [Utilities saveValue:[userInfo valueForKey:USER_ID] forKey:USER_ID];
    [Utilities saveValue:[userInfo valueForKey:EMAIL] forKey:EMAIL];
    [Utilities saveValue:[userInfo valueForKey:COUNTRY] forKey:COUNTRY];
    [Utilities saveValue:[userInfo valueForKey:REF_LINK] forKey:REF_LINK];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app sendMessageToProfileVC:1];
    
}

#pragma mark - DropBoxDelegate

- (void)finishedLogin:(NSMutableDictionary*)userInfo
{
    NSLog(@"finishedLogin : %@",userInfo);
    
    if (userInfo)
    {
        [appDelegate hideHUDActivityIndicator];
        [self saveUserProfile:userInfo];
    }
}

- (void)failedToLogin:(NSString*)withMessage
{
    NSLog(@"failedToLogin : %@",withMessage);
    
    [appDelegate hideHUDActivityIndicator];

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

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button

- (IBAction)openDrawer:(id)sender
{
    [self.drawer open];
}


#pragma mark - CAMERA

- (void)createDummyTag
{
    NSString * moviePath = [[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"mov"];

    NSURL *url = [Utilities dataStoragePath];
    url = [url URLByAppendingPathComponent:@"vid@@@###.mov"];
    NSError *error = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:url.path])
    {
        [[NSFileManager defaultManager] removeItemAtPath:url.path error:&error];
    }[[NSFileManager defaultManager] copyItemAtPath:moviePath toPath:url.path error:&error];
    //[self saveVideo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tagCreated"
                                                        object:self];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"tagCreated"
                                  message:@"Tag Created"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)cameraButtonClicked:(id)sender
{
    
    [self createDummyTag];
    
    return;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Sorry"
                                      message:@"Camera on device not detected"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
       
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    self.imagePickerController = [[UIImagePickerController alloc] init];

    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}

#pragma mark - CAMERA DELEGATES

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    
    //[picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"])
    {
        [self continueToSaveVideoWithInfo:info];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - SAVE VIDEO

-(void) continueToSaveVideoWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSString *moviePath = nil;
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo)
    {
        moviePath = [NSString stringWithFormat:@"%@",[[info objectForKey:UIImagePickerControllerMediaURL] path]];
        NSURL *url = [Utilities dataStoragePath];
        url = [url URLByAppendingPathComponent:@"vid@@@###.mov"];
        NSError *error = nil;
        if([[NSFileManager defaultManager] fileExistsAtPath:url.path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:url.path error:&error];
        }[[NSFileManager defaultManager] copyItemAtPath:moviePath toPath:url.path error:&error];
        //[self saveVideo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tagCreated"
                                                            object:self];
    }
}


#pragma mark - MEMORY
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
