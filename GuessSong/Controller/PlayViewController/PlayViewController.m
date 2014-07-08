//
//  PlayViewController.m
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVPlayer.h>

@interface PlayViewController ()

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)playSong:(id)sender
{
    [self playSong];
}

#pragma mark - PLAYING SONG
- (void) playSong
{
    if (!_isPlaying) {
        _isPlaying = TRUE;
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        
        NSString *playString = @"http://210.211.99.70/teenpro.vn/files/song/2012/08/07/5ba44f26374a8bcd6aca3eaed9d00d18.mp3";
        
        //Converts songURL into a playable NSURL
        NSURL *playURL = [NSURL URLWithString:playString];

        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playURL];

        _songPlayer = [AVPlayer playerWithPlayerItem:playerItem];
        // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_songPlayer];
        
        [_songPlayer play];
    } else {
        _isPlaying = FALSE;
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        [_songPlayer pause];
    }
}

#pragma mark - NOTIFICATION FINISH PLAYING
- (void) itemDidFinishPlaying:(NSNotification*) notification
{
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
