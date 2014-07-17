//
//  Helper.h
//  GuessSong
//
//  Created by Mr Trung on 7/11/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDCommon.h"
#import "CDModel.h"
#import "UserInfo.h"
#import "CDSingleton.h"

@interface Helper : NSObject

+ (BOOL) isNotNull:(id) object;
+ (void) updateCoins:(int) newCoins;

@end
