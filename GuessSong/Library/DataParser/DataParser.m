//
//  DataParser.m
//  GuessSong
//
//  Created by TrungBQ on 7/13/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "DataParser.h"
#import "QuizModel.h"

@implementation DataParser

+ (NSMutableArray *) parseQuiz:(NSDictionary *)data {
    if (data) {
        NSArray *categories = [data objectForKey:@"results"];
        
        if (![categories isKindOfClass:[NSNull class]]) {
            
            NSMutableArray *cats = [[NSMutableArray alloc] init];
            
            for (NSDictionary *category in categories)
            {
                QuizModel *_quiz = [[QuizModel alloc] init];
                _quiz.qId = [[category objectForKey:@"id"] intValue];
                _quiz.qResult = [category objectForKey:@"result"];
                _quiz.qSource = [category objectForKey:@"source"];
                _quiz.qTitle = [category objectForKey:@"title"];
                _quiz.qType = [[category objectForKey:@"type"] intValue];
                _quiz.level = [[category objectForKey:@"level"] intValue];
                _quiz.order = [[category objectForKey:@"sort"] intValue];
                _quiz.country = [category objectForKey:@"country"];
                _quiz.genre = [category objectForKey:@"genre"];
                _quiz.coins = [[category objectForKey:kCoins] intValue];
                _quiz.itunesURL = [[category objectForKey:@"source"] objectForKey:@"itunes_url"];
                
                [cats addObject:_quiz];
            }
            return cats;
        }
    }
    
    return nil;
}

@end
