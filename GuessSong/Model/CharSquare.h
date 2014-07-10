//
//  CharSquare.h
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharSource.h"

@protocol CharSquarelegate;

@interface CharSquare : UIView
{
    
}

- (id) initWithChar:(NSString *)character andFrame:(CGRect) frame;

// Current value of this character
@property (nonatomic, retain) NSString              *character;
@property (nonatomic, retain) UIButton              *charBtn;
// Source of this character
@property (nonatomic, retain) CharSource            *charSource;
@property (nonatomic, weak) id<CharSquarelegate>    delegate;
// Current this character position
@property (nonatomic, assign) int                   iCharPos;

@end

@protocol CharSquarelegate <NSObject>

- (void) charSquareClicked:(CharSquare*) square;

@end