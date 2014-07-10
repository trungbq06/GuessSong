//
//  WordSquare.m
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "CharSquare.h"


@implementation CharSquare

- (id) initWithChar:(NSString *)character andFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _character = @"";
        _charBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_charBtn];
        
        // Setup view
        [self.layer setCornerRadius:3];
        [self.layer setBorderWidth:1.0f];
        [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
        
        NSLog(@"Title %@", character);
        [_charBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_charBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_charBtn addTarget:self action:@selector(charClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (IBAction) charClick:(id)sender
{
    _character = @"";
    [_charBtn setTitle:_character forState:UIControlStateNormal];
    
    if ([_delegate respondsToSelector:@selector(charSquareClicked:)]) {
        [_delegate charSquareClicked:self];
    }
}

- (void) setCharacter:(NSString *)character
{
    _character = character;
    
    [_charBtn setTitle:character forState:UIControlStateNormal];
}

@end
