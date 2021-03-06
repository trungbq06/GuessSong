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
#import "AppDelegate.h"
#import <Social/Social.h>
#import "CharacterGenerator.h"
#import "JingRoundView.h"
#import <POP/POP.h>
#import "GameCenterManager.h"
#import "PurchaseViewController.h"
#import <GameKit/GameKit.h>
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "ZoomImageViewController.h"
#import "QuizModel.h"

@interface PlayViewController : UIViewController <CharSourceDelegate, CharSquarelegate, UIAlertViewDelegate, JingRoundViewDelegate, GKGameCenterControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext * context;

// Player to play song
@property (nonatomic, strong) AVPlayer              *songPlayer;
// Incorrect player
@property (nonatomic, strong) AVAudioPlayer         *wrongPlayer;
// Solved player
@property (nonatomic, strong) AVAudioPlayer         *tadaPlayer;
// Check if song is playing
@property (nonatomic, assign) BOOL                  isPlaying;
// Play button
@property (strong, nonatomic) UIButton              *playBtn;
// Char genrator object
@property (nonatomic, retain) CharacterGenerator    *charGenerator;
// Char allow user to input
@property (nonatomic, retain) NSMutableArray        *charSquareArray;
// Source char allow user to select from
@property (nonatomic, retain) NSMutableArray        *charSourceArray;
// Data of the quiz
@property (nonatomic, retain) NSMutableArray        *quizData;
// Current quiz
@property (nonatomic, retain) QuizModel             *quiz;
// Current quiz index
@property (nonatomic, assign) int                   idxQuiz;
@property (nonatomic, assign) int                   currLevel;
@property (nonatomic, assign) int                   currCoins;
@property (weak, nonatomic) IBOutlet UILabel        *lbLevel;
@property (weak, nonatomic) IBOutlet UIButton       *btnCoins;
@property (weak, nonatomic) IBOutlet JingRoundView  *playingRound;
@property (weak, nonatomic) IBOutlet UIButton       *btnNext;
@property (weak, nonatomic) IBOutlet UILabel        *lblGotCoins;
@property (nonatomic, weak) IBOutlet UIView         *navigationBar;
@property (nonatomic, retain) NSTimer               *sliderTimer;
@property (nonatomic, weak) IBOutlet UIImageView    *leftImage;
@property (nonatomic, weak) IBOutlet UIImageView    *rightImage;
@property (nonatomic, retain) GameCenterManager     *gameCenterManager;

@property (nonatomic, assign) int                   totalChar;
@property (nonatomic, assign) int                   removedChar;
@property (nonatomic, assign) int                   currentTime;
@property (nonatomic, retain) UIView                *dimView;
@property (nonatomic, assign) CGRect                leftOriginFrame;
@property (nonatomic, assign) CGRect                rightOriginFrame;
@property (nonatomic, assign) BOOL                  isLeftZoom;
@property (nonatomic, assign) BOOL                  isRightZoom;
@property (nonatomic, retain) UIView                *sourceCharView;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnShow;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnItunes;
@property (weak, nonatomic) IBOutlet UILabel  *lblPlus;
@property (nonatomic, assign) BOOL            sound;

- (IBAction)gotoNextGame:(id)sender;
- (IBAction)btnCoinsClick:(id)sender;
- (IBAction)playSong:(id)sender;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)showHint:(id)sender;
- (IBAction)deleteChar:(id)sender;
- (IBAction)skipLevel:(id)sender;
- (IBAction)shareFB:(id)sender;
- (IBAction)showTweetSheet:(id) sender;
- (IBAction)btnItunesClick:(id)sender;

@end
