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

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                NSLog(@"FB Loggedin");
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    int playRound = [[[NSUserDefaults standardUserDefaults] objectForKey:PLAY_ROUND] intValue];
    if (playRound % 5 == 0 && playRound > 0)
        [self performSelectorOnMainThread:@selector(loadIntersial) withObject:nil waitUntilDone:NO];
    else {
        [self performSelectorOnMainThread:@selector(loadBanner) withObject:nil waitUntilDone:NO];
    }
//    
//    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//    positionAnimation.velocity = @2000;
//    positionAnimation.springBounciness = 20;
//    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//        self.button.userInteractionEnabled = YES;
//    }];
//    [self.button.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadBgImage];
    
    // Insert new record to database
    NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:START_COINS], kCoins, [NSNumber numberWithInt:1], @"level", nil];
    NSArray *_data = [[NSArray alloc] initWithObjects:_uInfo, nil];
    
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject count] == 0) {
            [_cdSingleton insertWithData:_data tableName:@"UserInfo" success:^(CDInsert *operation, id responseObject) {
                NSLog(@"Inserted succesfully!");
            } failure:^(CDInsert *operation, NSError *error) {
                
            }];
        }
    } failure:^(CDLoad *operation, NSError *error) {
        NSLog(@"Error %@", error);
    }];
    
    // Load coins and level from local database
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
        //        NSLog(@"%@", responseObject);
        for (UserInfo *_userInfo in responseObject) {
            NSLog(@"Current coins: %@", _userInfo.coins);
            NSLog(@"Current level: %@", _userInfo.level);
            [_btnCoins setTitle:[NSString stringWithFormat:@"%@", _userInfo.coins] forState:UIControlStateNormal];
            [_lbLevel setText:[NSString stringWithFormat:@"%@", _userInfo.level]];
        }
    } failure:^(CDLoad *operation, NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (void) reloadBgImage
{
    NSString *bgImage = [[NSUserDefaults standardUserDefaults] objectForKey:kBackgroundImage];
    if (!bgImage)
        bgImage = @"background";
    
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
    
    [_btnCoins setTitle:[NSString stringWithFormat:@"%d", [[_newCoins objectForKey:kCoins] intValue]] forState:UIControlStateNormal];
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
            NSLog(@"popup view dismissed");
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
        NSLog(@"Loading intersial");
        
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
        NSLog(@"Banner Failed To Load");
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
