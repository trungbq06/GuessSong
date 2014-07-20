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

@interface StartViewController : UIViewController <GADBannerViewDelegate, GKGameCenterControllerDelegate, GameCenterManagerDelegate, GADInterstitialDelegate>
{
    //AdMob
    GADBannerView *bannerView_;
    
    ADBannerView *adView;
    BOOL bannerIsVisible;
    GADInterstitial *interstitial_;
    BOOL bannerShown;
}

@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (weak, nonatomic) IBOutlet UILabel        *lbLevel;
@property (weak, nonatomic) IBOutlet UIButton       *btnCoins;
@property (nonatomic, strong) IBOutlet UIView       *navigationBar;

- (IBAction)btnPlayClick:(id)sender;
- (IBAction)changeBg:(id)sender;

@end
