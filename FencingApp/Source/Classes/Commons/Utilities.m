//
//  Utilities.m
//  FencingApp
//
//  Created by Aniruddha Kadam on 04/08/16.
//  Copyright © 2016 Aniruddha Kadam. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities




+ (NSURL *)dataStoragePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:cachePath];
    return url;
}

#pragma mark - NSUserDefaults Methods

+ (void)saveValue:(NSString *)value forKey:(NSString *)keyString
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:keyString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getValueForKey:(NSString *)keyString
{
    NSString * value = [[NSUserDefaults standardUserDefaults] valueForKey:keyString];
    
    if (value)
    {
        return value;
    }
    
    return @"";
}

+ (void)resetDefaults
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}



@end
