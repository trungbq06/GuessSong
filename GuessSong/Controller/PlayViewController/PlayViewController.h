//
//  PlayViewController.h
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>

@interface PlayViewController : UIViewController

@property (nonatomic, retain) AVPlayer *songPlayer;
@property (nonatomic, assign) BOOL isPlaying;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

- (IBAction)playSong:(id)sender;

@end
