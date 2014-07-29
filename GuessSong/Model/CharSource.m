//
//  CharSource.m
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "CharSource.h"

@implementation CharSource

- (id) initWithChar:(NSString *)character andFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _character = character;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"source_bg"]]];
        [self addSubview:button];
        
        // Setup view
        [self.layer setCornerRadius:4];
        [self.layer setBorderWidth:1.0f];
        [self.layer setBorderColor:[[UIColor clearColor] CGColor]];
        
        [button setTitle:character forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:FONT_FAMILY size:26]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"source_bg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"source_bg_active"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(charClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSURL *playURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click_on" ofType:@"mp3"]];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:playURL error:&error];
    }
    
    return self;
}

- (IBAction) charClick:(id)sender
{
    [_audioPlayer play];
    if ([_delegate respondsToSelector:@selector(charSourceClicked:)]) {
        [_delegate charSourceClicked:self];
    }
}

@end
