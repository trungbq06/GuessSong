//
//  PSAMUserDefault.m
//  PSAManager
//
//  Created by Thai Nguyen on 9/26/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "AppUserDefault.h"

@implementation AppUserDefault

#pragma mark - USER DEFAULT MANAGER

+ (void)saveData:(id)data forKey:(NSString *)key{
    NSUserDefaults *_defaultUser = [NSUserDefaults standardUserDefaults];
    [_defaultUser setObject:data forKey:key];
    [_defaultUser synchronize];
}

+ (id)dataForKey:(NSString *)key{
    NSUserDefaults *_defaultUser = [NSUserDefaults standardUserDefaults];
    return [_defaultUser objectForKey:key];
}

+ (void)removeDataForKey:(NSString *)key{
    NSUserDefaults *_defaultUser = [NSUserDefaults standardUserDefaults];
    [_defaultUser removeObjectForKey:key];
    [_defaultUser synchronize];
}

@end
