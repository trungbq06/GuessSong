//
//  ViewController.m
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "StartViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "CDSingleton.h"
#import "CDCommon.h"
#import "CDModel.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GameCenterManager isGameCenterAvailable]) {
        _gameCenterManager = [[GameCenterManager alloc] init];
        [_gameCenterManager setDelegate:self];
        [_gameCenterManager authenticateLocalUser];
    } else {
        // The current device does not support Game Center.
    }
    
    // Insert new record to database
    NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:START_COINS], @"coins", [NSNumber numberWithInt:1], @"level", nil];
    NSArray *_data = [[NSArray alloc] initWithObjects:_uInfo, nil];
    
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        if ([responseObject count] == 0) {
            [_cdSingleton insertWithData:_data tableName:@"UserInfo" success:^(CDInsert *operation, id responseObject) {
                NSLog(@"Inserted succesfully!");
            } failure:^(CDInsert *operation, NSError *error) {
                
            }];
        }
    } failure:^(CDLoad *operation, NSError *error) {
        NSLog(@"Error %@", error);
    }];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
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
