//
//  CharacterGenerator.h
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterGenerator : NSObject

@property (nonatomic, retain) NSString              *songName;
@property (nonatomic, retain) NSMutableArray        *songChar;
@property (nonatomic, retain) NSMutableDictionary   *wordOffset;
@property (nonatomic, retain) NSMutableArray        *wordResult;
@property (nonatomic, assign) int                   currPos;
@property (nonatomic, assign) int                   remainingChar;

- (BOOL) isSolved;

@end
