//
//  CharacterGenerator.m
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "CharacterGenerator.h"

@implementation CharacterGenerator

- (id) init
{
    self = [super init];
    if (self) {
        _songChar = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void) setSongName:(NSString *)songName
{
    _songName = songName;
    
    [self generateResult];
}

- (void) generateResult
{    
    for (int position=0; position < [_songName length]; position++) {
        unichar ch = [_songName characterAtIndex:position];
        
        NSLog(@"%C", ch);
        if (ch) {
            [_songChar insertObject:[NSString stringWithFormat:@"%c", ch] atIndex:position];
        }
    }
}

@end
