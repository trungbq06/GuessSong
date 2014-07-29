//  GuessSong
//
//  Created by TrungBQ on 7/8/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CharSourceDelegate;

@interface CharSource : UIView

- (id) initWithChar:(NSString *)character andFrame:(CGRect) frame;

@property (nonatomic, weak) id<CharSourceDelegate>  delegate;
@property (nonatomic, retain) NSString              *character;
@property (nonatomic, retain) AVAudioPlayer         *audioPlayer;

@end

@protocol CharSourceDelegate <NSObject>

- (void) charSourceClicked:(CharSource*) source;

@end