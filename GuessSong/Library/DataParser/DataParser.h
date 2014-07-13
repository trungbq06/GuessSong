//
//  DataParser.h
//  GuessSong
//
//  Created by TrungBQ on 7/13/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

+ (NSMutableArray *) parseQuiz:(NSDictionary *)data;

@end
