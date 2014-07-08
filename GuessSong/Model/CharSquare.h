//
//  CharSquare.h
//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharSquare : UIView

- (id) initWithChar:(NSString *)character andFrame:(CGRect) frame;

@property (nonatomic, retain) NSString *character;

@end
