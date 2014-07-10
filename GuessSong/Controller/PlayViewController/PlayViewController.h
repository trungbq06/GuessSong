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
#import "CharSquare.h"
#import "CharSource.h"
#import "Helper.h"
#import "CharacterGenerator.h"

@interface PlayViewController : UIViewController <CharSourceDelegate, CharSquarelegate>

// Player to play song
@property (nonatomic, retain) AVPlayer              *songPlayer;
// Check if song is playing
@property (nonatomic, assign) BOOL                  isPlaying;
// Play button
@property (weak, nonatomic) IBOutlet UIButton       *playBtn;
// Char genrator object
@property (nonatomic, retain) CharacterGenerator    *charGenerator;
// Char allow user to input
@property (nonatomic, retain) NSMutableArray        *charSquareArray;
// Source char allow user to select from
@property (nonatomic, retain) NSMutableArray        *charSourceArray;

- (IBAction)playSong:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end
