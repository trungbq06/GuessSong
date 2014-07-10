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
        _wordOffset = [[NSMutableDictionary alloc] init];
        _wordResult = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void) setSongName:(NSString *)songName
{
    _songName = [songName uppercaseString];
    
    [self generateResult];
}

- (void) generateResult
{
    // Rest all object
    _currPos = 0;
    _remainingChar = 0;
    [_wordResult removeAllObjects];
    [_wordOffset removeAllObjects];
    [_songChar removeAllObjects];
    
    // Start generating object
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    int currWidth = 0;
    int iWord = 0;
    int iChar = 0;
    int screenWidth = appFrame.size.width;
    int line = 1;
    int startX = 0;
    int charLength = 0;
    
    NSArray *wordArray = [_songName componentsSeparatedByString:@" "];
    for (NSString *_word in wordArray) {
        currWidth += [_word length] * (WIDTH + CHAR_SPACING);
        charLength += [_word length];
        NSString *_nextWord = @"";
        if (iWord + 1 < [wordArray count])
            _nextWord = [wordArray objectAtIndex:iWord + 1];
        if ((currWidth + [_nextWord length] * (WIDTH + CHAR_SPACING)) > screenWidth) {
            startX = (screenWidth - currWidth) / 2;
            [_wordOffset setObject:[NSString stringWithFormat:@"%d,%d,%d", iChar, startX, charLength] forKey:[NSNumber numberWithInt:line]];
            line++;
            iChar = charLength;
            currWidth = 0;
        }
        
        iWord++;
    }
    startX = (screenWidth - currWidth) / 2;
    [_wordOffset setObject:[NSString stringWithFormat:@"%d,%d,%d", iChar, startX, charLength] forKey:[NSNumber numberWithInt:line]];
    int pos = 0;
    for (int position=0; position < [_songName length]; position++) {
        unichar ch = [_songName characterAtIndex:position];
        
        NSLog(@"%C", ch);
        if (ch) {
            NSString *_char = [NSString stringWithFormat:@"%c", ch];
            if (![_char isEqualToString:@" "]) {
                [_songChar insertObject:[_char uppercaseString] atIndex:pos];
                [_wordResult addObject:@""];
                pos++;
            }
        }
    }
}

- (BOOL) isSolved
{
    NSString *solveString = [_wordResult componentsJoinedByString:@""];
    NSString *targetString = [_songChar componentsJoinedByString:@""];
    if ([solveString isEqualToString:targetString]) {
        return TRUE;
    }
    
    return FALSE;
}

@end
