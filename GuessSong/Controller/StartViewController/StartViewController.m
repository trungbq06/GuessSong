//
//  ViewController.m
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "StartViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworkingSynchronousSingleton.h"
#import "UIViewController+CWPopup.h"
#import "ChangeBgViewController.h"
#import "MoreAppViewController.h"
#import "AppDelegate.h"
#import "CDSingleton.h"
#import "CDCommon.h"
#import "CDModel.h"
#import "UIColor+Expand.h"
#import <POP/POP.h>

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *playURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:BG_MUSIC ofType:@"mp3"]];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:playURL error:&error];
    _audioPlayer.numberOfLoops = -1;
    
    _btnCoins.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    /* This push local notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    localNotification.alertBody = @"Your alert message";
    localNotification.alertBody = @"I missed you !";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    */
    
    [_navigationBar setBackgroundColor:[UIColor colorFromHex:@"#C73889"]];
    
    [_navigationBar setFrame:CGRectMake(0, 0, _navigationBar.frame.size.width, 40)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeCoins:) name:kNotifyDidChangeCoins object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDone:) name:kDoneClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDone:) name:@"clicked_done" object:nil];
    if ([GameCenterManager isGameCenterAvailable]) {
        _gameCenterManager = [[GameCenterManager alloc] init];
        [_gameCenterManager setDelegate:self];
        [_gameCenterManager authenticateLocalUser];
    } else {
        // The current device does not support Game Center.
    }
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                DLog_Low(@"FB Loggedin");
            }];
        }
    }
    
    [[AFNetworkingSynchronousSingleton sharedClient] getPath:@"http://apple.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([error code] != -1016) {
            NSString *_message = [error localizedDescription];
            
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" message:_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            _alert.tag = 1002;
            [_alert show];
        }
    }];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_audioPlayer pause];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_sound)
        [_audioPlayer play];
    
    int playRound = [[[NSUserDefaults standardUserDefaults] objectForKey:PLAY_ROUND] intValue];
    if (playRound % 5 == 0 && playRound > 0)
        [self performSelectorOnMainThread:@selector(loadIntersial) withObject:nil waitUntilDone:NO];
    else {
        [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

- (void) animation
{
    /*
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    basicAnimation.velocity = @1000;
    basicAnimation.springBounciness = 20;
    basicAnimation.springSpeed = 10;
    [basicAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [_btnPlay setFrame:normalFrame];
    }];
     */
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    basicAnimation.fromValue =[NSValue valueWithCGSize:CGSizeMake(1.1f, 1.1f)];
    basicAnimation.springSpeed = 10;
    basicAnimation.springBounciness = 10;
    
    [basicAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//        [_btnPlay setFrame:normalFrame];
//        [_btnPlay.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:30]];
    }];
    
    [_btnPlay.layer pop_addAnimation:basicAnimation forKey:@"positionAnimation"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _sound = TRUE;
    
    [self reloadBgImage];
    
    // Insert new record to database
    NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:START_COINS], kCoins, [NSNumber numberWithInt:1], @"level", @FALSE, kSound, nil];
    NSArray *_data = [[NSArray alloc] initWithObjects:_uInfo, nil];
    
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        DLog_Low(@"%@", responseObject);
        if ([responseObject count] == 0) {
            [_cdSingleton insertWithData:_data tableName:@"UserInfo" success:^(CDInsert *operation, id responseObject) {
                DLog_Low(@"Inserted succesfully!");
            } failure:^(CDInsert *operation, NSError *error) {
                
            }];
        }
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
    
    // Load coins and level from local database
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        //        NSLog(@"%@", responseObject);
        for (UserInfo *_userInfo in responseObject) {
            DLog_Low(@"Current coins: %@", _userInfo.coins);
            DLog_Low(@"Current level: %@", _userInfo.level);
            [_btnCoins setTitle:[NSString stringWithFormat:@"   %@", _userInfo.coins] forState:UIControlStateNormal];
            [_lbLevel setText:[NSString stringWithFormat:@"%@", _userInfo.level]];
            
            _sound = _userInfo.sound;
            
            if (!_userInfo.sound) {
                [_btnVolume setBackgroundImage:[UIImage imageNamed:@"volume_off"] forState:UIControlStateNormal];
            } else {
                [_btnVolume setBackgroundImage:[UIImage imageNamed:@"volume"] forState:UIControlStateNormal];
            }
            
            NSDate *updatedDate = _userInfo.updated_date;
            
            [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeGradient];
            [[AFNetworkingSynchronousSingleton sharedClient] getPath:[NSString stringWithFormat:@"%@%@", kServerURL, @""] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ([responseObject objectForKey:@"results"]) {
                    [SVProgressHUD showWithStatus:@"Download data ..." maskType:SVProgressHUDMaskTypeGradient];
                    NSDictionary *_parameter = [[NSDictionary alloc] initWithObjectsAndKeys:COUNTRY_CODE, @"country", nil];
                    [[AFNetworkingSynchronousSingleton sharedClient] getPath:[NSString stringWithFormat:@"%@%@", kServerURL, @"quiz/latest"] parameters:_parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [SVProgressHUD dismiss];
                        
                        // Save to database
                        NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:START_COINS], kCoins, [NSNumber numberWithInt:1], @"level", @FALSE, kSound, nil];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        DLog_Low(@"Error fetching data from server %@", error);
                        
                        NSString *_message = [error localizedDescription];
                        
                        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" message:_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        _alert.tag = 1002;
                        [_alert show];
                        
                        [SVProgressHUD dismiss];
                    }];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
}

- (void) reloadBgImage
{
    NSString *bgImage = [[NSUserDefaults standardUserDefaults] objectForKey:kBackgroundImage];
    if (!bgImage)
        bgImage = @"background";
    
//    bgImage = [bgImage stringByAppendingString:@".jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:bgImage]]];
}

#pragma mark - MORE APP
- (void)moreApp:(id)sender
{
    MoreAppViewController *_moreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MoreAppViewController"];
    
    [self presentViewController:_moreViewController animated:YES completion:nil];
}

#pragma mark - RATE APP
- (IBAction)share:(id)sender
{
    NSString *message = [NSString stringWithFormat:@"OMG! This is fantastic game! How can you defeat me on this game http://itunes.apple.com/app/id892274452"];
    NSArray *postItems = @[message];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)rate:(id)sender
{
    [self rateApp];
}

- (void) rateApp
{
    NSString *str = @"itms-apps://itunes.apple.com/app/id892274452";
    if (IS_IOS7 == 0) {
        str = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=id892274452";
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:RATED_APP];
}

#pragma mark - COINS CHANGED
- (void) didChangeCoins:(NSNotification*)_notification
{
    NSDictionary *_newCoins = _notification.userInfo;
    
    [_btnCoins setTitle:[NSString stringWithFormat:@"   %d", [[_newCoins objectForKey:kCoins] intValue]] forState:UIControlStateNormal];
}

#pragma mark - CHANGE BG
- (IBAction)changeBg:(id)sender
{
    ChangeBgViewController *_changeBg = [[ChangeBgViewController alloc] init];
    [_changeBg.view setFrame:CGRectMake(20, 50, 280, 400)];
    
    [self presentPopupViewController:_changeBg animated:YES completion:nil];
}

- (void) didClickDone:(NSNotification*) _notification
{
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            DLog_Low(@"popup view dismissed");
        }];
    }
    
    [self reloadBgImage];
}

#pragma mark - LOAD BANNER
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
    
    bannerShown = TRUE;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
}

- (void) loadIntersial
{
    if (!bannerShown) {
        DLog_Low(@"Loading intersial");
        
        interstitial_ = [[GADInterstitial alloc] init];
        interstitial_.adUnitID = MY_BANNER_INTERSITIAL_UNIT_ID;
        [interstitial_ setDelegate:self];
        [interstitial_ loadRequest:[GADRequest request]];
    }
}

#pragma mark - COINS CLICK
- (IBAction)btnCoinsClick:(id)sender {
    PurchaseViewController *_purchaseController = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
    
    [self presentPopupViewController:_purchaseController animated:YES completion:^{
        
    }];
}

- (IBAction)btnVolumeClick:(id)sender
{
    UIImage *_img = [UIImage imageNamed:@"volume"];
    if (_sound) {
        _img = [UIImage imageNamed:@"volume_off"];
    }
    _sound = !_sound;
    
    [_btnVolume setBackgroundImage:_img forState:UIControlStateNormal];
    
    [Helper updateSound:_sound success:nil];
    
    if (_sound)
        [_audioPlayer play];
    else
        [_audioPlayer stop];
}

#pragma mark GameCenterDelegateProtocol Methods
- (void) processGameCenterAuth: (NSError*) error
{
	if(error == NULL)
	{
		[_gameCenterManager reloadHighScoresForCategory: LEADER_BOARD_IDENTIFIER];
	}
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [bannerView_ removeFromSuperview];
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        CGRect frame = banner.frame;
        [banner setFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
        
        [UIView commitAnimations];
        bannerIsVisible = YES;
        [adView setHidden:!bannerIsVisible];
    }
}

//when any problems occured
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        DLog_Low(@"Banner Failed To Load");
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [UIView commitAnimations];
        bannerIsVisible = NO;
        [adView setHidden:!bannerIsVisible];
        
        [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
    }
}

- (void) loadBanner {
    CGRect appframe= [[UIScreen mainScreen] applicationFrame];
    
    if (IS_IPAD) {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(20.0,
                                                appframe.size.height - 90,
                                                GAD_SIZE_728x90.width,
                                                GAD_SIZE_728x90.height)];
    } else {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                appframe.size.height - 50,
                                                GAD_SIZE_320x50.width,
                                                GAD_SIZE_320x50.height)];
    }
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    bannerView_.delegate = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad.
    [bannerView_ loadRequest:[self request]];
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    //    request.testDevices = @[
    //                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
    //                            // the console when the app is launched.
    //                            GAD_SIMULATOR_ID
    //                            ];
    return request;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPlayClick:(id)sender {
    PlayViewController *_playController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
    [_playController setIdxQuiz:0];
    [_playController setCurrLevel:1];
    
    [self.navigationController pushViewController:_playController animated:YES];
}
@end
