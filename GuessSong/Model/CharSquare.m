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
        _character = character;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:button];
        
        // Setup view
        [self.layer setCornerRadius:3];
        [self.layer setBorderWidth:1.0f];
        [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
        
        NSLog(@"Title %@", character);
        [button setTitle:character forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(charClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (IBAction) charClick:(id)sender
{
    UIButton *button = (UIButton*) sender;
    [button setTitle:@"" forState:UIControlStateNormal];
}

@end
