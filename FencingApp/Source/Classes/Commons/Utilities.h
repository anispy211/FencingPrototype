//
//  Utilities.h
//  FencingApp
//
//  Created by Aniruddha Kadam on 04/08/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject


+ (NSURL *)dataStoragePath;

#pragma mark - NSUserDefaults Methods
+ (void)saveValue:(NSString *)value forKey:(NSString *)keyString;
+ (NSString *)getValueForKey:(NSString *)keyString;
+ (void)resetDefaults;

@end
