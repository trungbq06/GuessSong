//
//  SQLiteSingleton.h
//  PSAInspector
//
//  Created by Thai Nguyen on 9/11/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteSingleton : NSObject

+ (SQLiteSingleton *)sharedSingleton;

- (NSMutableArray *)loadAddressData;
- (NSMutableArray *)loadThanachartData;

@end
