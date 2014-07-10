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

@end
