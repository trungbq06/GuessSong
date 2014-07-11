//
//  WordSquare.m
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "CharSquare.h"
#import "UIColor+Expand.h"

@implementation CharSquare

- (id) initWithChar:(NSString *)character andFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _character = @"";
        _charBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self setBackgroundColor:[UIColor colorFromHex:@"#363636"]];
        [self addSubview:_charBtn];
        
        // Setup view
        [self.layer setCornerRadius:4];
        [self.layer setBorderWidth:1.0f];
        [self.layer setBorderColor:[[UIColor clearColor] CGColor]];
        
        NSLog(@"Title %@", character);
        [_charBtn.titleLabel setFont:[UIFont fontWithName:FONT_FAMILY size:22]];
        [_charBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_charBtn addTarget:self action:@selector(charClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (IBAction) charClick:(id)sender
{
    if (!_isHint) {
        _character = @"";
        [_charBtn setTitle:_character forState:UIControlStateNormal];
        
        if ([_delegate respondsToSelector:@selector(charSquareClicked:)]) {
            [_delegate charSquareClicked:self];
        }
    }
}

- (void) setCharacter:(NSString *)character
{
    _character = character;
    
    [_charBtn setTitle:character forState:UIControlStateNormal];
}

- (void) colorFail
{
    if (!_isHint)
        [_charBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

- (void) resetColor
{
    if (!_isHint)
        [_charBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void) showHint
{
    _isHint = TRUE;
    [_charBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_charBtn.titleLabel setFont:[UIFont fontWithName:FONT_FAMILY size:26]];
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
