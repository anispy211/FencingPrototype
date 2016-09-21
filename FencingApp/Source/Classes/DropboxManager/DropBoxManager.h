//
//  DropBoxManager.h
//  FencingDBPOC
//
//  Created by CW on 6/9/16.
//  Copyright (c) 2016 Aniruddha. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

//#define kDropbox_AppKey @"j7ipxq64ep0t6fk" // Provide your key here
//#define kDropbox_AppSecret @"po8d4lrtzksfif4" // Provide your secret key here
#define kDropbox_RootFolder kDBRootDropbox //Decide level access like root or app


#define kDropbox_AppKey @"urh2qap6u6w2c68" // Provide your key here
#define kDropbox_AppSecret @"v5gksblev1zekjh" // Provide your secret key here

@protocol DropBoxDelegate;

typedef enum
{
    DropBoxTypeStatusNone = 0,
    DropBoxGetAccountInfo = 1,
    DropBoxGetFolderList = 2,
    DropBoxCreateFolder = 3,
    DropBoxUploadFile = 4
} DropBoxPostType;

@interface DropBoxManager : NSObject <DBRestClientDelegate,DBSessionDelegate,UIAlertViewDelegate>
{
  //  UIViewController<DropBoxDelegate> *apiCallDelegate;
    
    DBSession *objDBSession;
    NSString *relinkUserId;
    DBRestClient *objRestClient;
    
    DropBoxPostType currentPostType;
    
    NSString *strFileName;
    NSString *strFilePath;
    NSString *strDestDirectory;
    NSString *strFolderCreate;
    NSString *strFolderToList;
}

@property (nonatomic,retain) DBSession *objDBSession;
@property (nonatomic,retain) NSString *relinkUserId;

@property (nonatomic,weak) UIViewController<DropBoxDelegate> *apiCallDelegate;

@property (nonatomic,retain) DBRestClient *objRestClient;

@property (nonatomic,assign) DropBoxPostType currentPostType;

@property (nonatomic,retain) NSString *strFileName;
@property (nonatomic,retain) NSString *strFilePath;
@property (nonatomic,retain) NSString *strDestDirectory;

@property (nonatomic,retain) NSString *strFolderCreate;

@property (nonatomic,retain) NSString *strFolderToList;

//Singleton
+(id)dropBoxManager;


// DB is linked or not
- (BOOL)isLinkedDB;

-(void)checkForLink;

//Initialize dropbox
-(void)initDropbox;

//Authentication Verification
-(BOOL)handledURL:(NSURL*)url;
-(void)dropboxDidLogin;
-(void)dropboxDidNotLogin;

// Upload File And share
-(void)uploadFileFromSourcePathAndShare:(NSString*)pstrSourcePath;

//Upload file
-(void)uploadFile;

//Download File
-(void)downlaodFileFromSourcePath:(NSString*)pstrSourcePath destinationPath:(NSString*)toPath;

//Create Folder
-(void)createFolder;

//Get Account Information
-(void)loginToDropbox;
-(void)logoutFromDropbox;
-(BOOL)isLoggedIn;

//List Folders
-(void)listFolders;

@end

@protocol DropBoxDelegate <NSObject>

@optional


- (void)finishedGeneratingUrl:(NSString*)url;
- (void)failedGeneratingUrl:(NSString*)withMessage;


- (void)finishedLogin:(NSMutableDictionary*)userInfo;
- (void)failedToLogin:(NSString*)withMessage;

- (void)finishedCreateFolder;
- (void)failedToCreateFolder:(NSString*)withMessage;

- (void)finishedUploadFileForPath:(NSString *)path;
- (void)failedToUploadFile:(NSString*)withMessage;

- (void)finishedDownloadFile;
- (void)failedToDownloadFile:(NSString*)withMessage;

- (void)getFolderContentFinished:(DBMetadata*)metadata;
- (void)getFolderContentFailed:(NSString*)withMessage;

@end
