//
//  ViewController.h
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "GADInterstitial.h"
#import "GameCenterManager.h"
#import "PlayViewController.h"
#import "DataParser.h"
#import "Helper.h"

@interface StartViewController : UIViewController <GADBannerViewDelegate, GKGameCenterControllerDelegate, GameCenterManagerDelegate, GADInterstitialDelegate>
{
    //AdMob
    GADBannerView *bannerView_;
    
    ADBannerView *adView;
    BOOL bannerIsVisible;
    GADInterstitial *interstitial_;
    BOOL bannerShown;
}

@property (nonatomic, assign) BOOL                  noAds;
@property (nonatomic, retain) AVAudioPlayer         *audioPlayer;
@property (nonatomic, retain) GameCenterManager     *gameCenterManager;
@property (weak, nonatomic) IBOutlet UILabel        *lbLevel;
@property (weak, nonatomic) IBOutlet UIButton       *btnCoins;
@property (nonatomic, strong) IBOutlet UIView       *navigationBar;
@property (nonatomic, strong) IBOutlet UIButton     *btnPlay;
@property (nonatomic, strong) IBOutlet UIButton     *btnVolume;

@property (nonatomic, assign) BOOL                  sound;

// Data of the quiz
@property (nonatomic, retain) NSMutableArray        *quizData;

- (IBAction)btnPlayClick:(id)sender;
- (IBAction)changeBg:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)rate:(id)sender;
- (IBAction)moreApp:(id)sender;
- (IBAction)btnVolumeClick:(id)sender;
- (IBAction)showLeaderboard:(id)sender;

@end
