//
//  ViewController.h
//  FencingApp
//
//  Created by Aniruddha Kadam on 28/07/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import "DropBoxManager.h"


@interface LoginViewController : UIViewController <DropBoxDelegate>
{
    DropBoxManager *objManager;

}

@end

