//
//  QuizModel.h
//  GuessSong
//
//  Created by TrungBQ on 7/13/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizModel : NSObject

// ID of this quiz
@property (nonatomic, assign) int           qId;
// Title of this quiz
@property (nonatomic, retain) NSString      *qTitle;
// Result of this quiz. It will be a string
@property (nonatomic, retain) NSString      *qResult;
// Source of this quiz. Depends on qType
@property (nonatomic, retain) NSDictionary  *qSource;
// Type of this quiz. It must be a song or image: 1 = song; 2 = image
@property (nonatomic, assign) int           qType;
// Level of this quiz
@property (nonatomic, assign) int           level;
// Order of this quiz. Order asecending normally
@property (nonatomic, assign) int           order;
// Country
@property (nonatomic, retain) NSString      *country;
// Genre
@property (nonatomic, retain) NSString      *genre;
@property (nonatomic, assign) int           coins;

@end
