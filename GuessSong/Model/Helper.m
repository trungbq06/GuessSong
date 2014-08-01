//
//  Helper.m
//  GuessSong
//
//  Created by Mr Trung on 7/11/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (BOOL) isNotNull:(id) object
{
    if ([object isKindOfClass:[NSString class]]) {
        if ( object != (id) [NSNull null] && object != nil && [(NSString*)object compare:@""] != NSOrderedSame )
            return TRUE;
        else
            return FALSE;
    }
    
    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
        if ( object != (id) [NSNull null] && object != nil && [object count] > 0)
            return TRUE;
        else
            return FALSE;
    }
    
    if ( object != (id) [NSNull null] && object != nil )
        return TRUE;
    
    return FALSE;
}

+ (void) updateLevel:(int)newLevel success:(void (^)())_success
{
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        NSNumber *_newLevel = [NSNumber numberWithInt:newLevel];
        NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_newLevel, kLevel, nil];
        
        [_cdSingleton updateWithData:_cdModel newData:_uInfo success:^(CDUpdate *operation, id responseObject) {
            if (_success)
                _success();
            
            dispatch_async(dispatch_get_main_queue(),^{
            });
        } failure:^(CDUpdate *operation, NSError *error) {
            
        }];
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
}

+ (void) updateNewCoins:(int)newCoins success:(void (^)())_success
{
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        NSNumber *_newCoins = [NSNumber numberWithInt:newCoins];
        NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_newCoins, kCoins, nil];
        
        [_cdSingleton updateWithData:_cdModel newData:_uInfo success:^(CDUpdate *operation, id responseObject) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDidChangeCoins object:nil userInfo:_uInfo];
            if (_success)
                _success();
            
            dispatch_async(dispatch_get_main_queue(),^{
            });
        } failure:^(CDUpdate *operation, NSError *error) {
            
        }];
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
}

+ (void) updateCoins:(int) newCoins
{
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        DLog_Low(@"%@", responseObject);
        UserInfo *uInfo = (UserInfo*) [responseObject objectAtIndex:0];
        
        NSNumber *_newCoins = [NSNumber numberWithInt:([uInfo.coins intValue] + newCoins)];
        NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:_newCoins, kCoins, nil];
        
        [_cdSingleton updateWithData:_cdModel newData:_uInfo success:^(CDUpdate *operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDidChangeCoins object:nil userInfo:_uInfo];
            
            dispatch_async(dispatch_get_main_queue(),^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyDidChangeCoins object:nil userInfo:_uInfo];
            });
        } failure:^(CDUpdate *operation, NSError *error) {
            
        }];
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
}

+ (void) updateSound:(BOOL)newSound success:(void (^)())_success
{
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        DLog_Low(@"%@", responseObject);
        
        NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:newSound], kSound, nil];
        
        [_cdSingleton updateWithData:_cdModel newData:_uInfo success:^(CDUpdate *operation, id responseObject) {
            
        } failure:^(CDUpdate *operation, NSError *error) {
            
        }];
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
}

+ (NSString *) localizedString:(NSString *) key
{
    // langCode should be set as a global variable somewhere
    NSString *path = [[NSBundle mainBundle] pathForResource:LANG_CODE ofType:@"lproj"];
    
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:key value:@"" table:nil];
}

@end
