//
//  PlayViewController.m
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "PlayViewController.h"
#import "UIColor+Expand.h"
#import "NSMutableArray+Shuffle.h"
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
    
    [self.view setBackgroundColor:[UIColor colorFromHex:@"#2E8CC7"]];
    
    // Init array object
    _charSquareArray = [[NSMutableArray alloc] initWithCapacity:0];
    _charSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _charGenerator = [[CharacterGenerator alloc] init];
    
    [self generateNewQuiz:@"You belong"];
}

- (void) generateNewQuiz:(NSString*) quizName
{
    [_charSquareArray removeAllObjects];
    
    [_charGenerator setSongName:quizName];
    
    int iChar = 0;
    int iLength = 0;
    int startX = 0;
    int offsetX = 0;
    int offsetY = OFFSETY;
    
    for (int line = 1;line <= [_charGenerator.wordOffset count];line++) {
        NSString *wordStr = [_charGenerator.wordOffset objectForKey:[NSNumber numberWithInt:line]];
        NSArray *wordArr = [wordStr componentsSeparatedByString:@","];
        
        // Current character index
        iChar = [[wordArr objectAtIndex:0] intValue];
        // Start X
        startX = [[wordArr objectAtIndex:1] intValue];
        // Length from current position
        iLength = [[wordArr objectAtIndex:2] intValue];
        offsetX = startX;
        
        for (int j = iChar;j < iLength;j++) {
            NSString *character = [_charGenerator.songChar objectAtIndex:j];
            CGRect frame = CGRectMake(offsetX, offsetY, WIDTH, WIDTH);
            
            // Init character object
            CharSquare *_char = [[CharSquare alloc] initWithChar:character andFrame:frame];
            [_char setICharPos:j];
            _char.delegate = self;
            
            [self.view addSubview:_char];
            offsetX += WIDTH + CHAR_SPACING;
            
            [_charSquareArray addObject:_char];
        }
        
        offsetY += LINE_SPACING;
    }
    
    // Calculate total needed source character
    int totalChar = [_charGenerator.songChar count];
    int totalRow = ceil((float)(totalChar * SOURCE_CHAR_WIDTH) / SOURCE_VIEW_WIDTH);
    int nTotalChar = floor((float)(totalRow * SOURCE_VIEW_WIDTH / SOURCE_CHAR_WIDTH));
    
    NSMutableArray *_sourceChar = [[NSMutableArray alloc] initWithArray:_charGenerator.songChar];
    
    // Need how many more character ???
    for (int i = 0;i< nTotalChar - totalChar;i++) {
        [_sourceChar addObject:[self randomChar]];
    }
    
    [_sourceChar shuffle];
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    // Draw source character
    int charPerRow = nTotalChar / totalRow;
    for (int i = 0;i < totalRow;i++) {
        offsetX = (appFrame.size.width - SOURCE_VIEW_WIDTH) / 2;
        offsetY = SOURCE_OFFSET_Y + i * LINE_SPACING;
        for (int j = 0;j < charPerRow;j++) {
            iChar = i * charPerRow + j;
            
            NSString *character = [_sourceChar objectAtIndex:iChar];
            NSLog(@"%d: %@", iChar, character);
            
            CGRect frame = CGRectMake(offsetX, offsetY, SOURCE_CHAR_WIDTH, SOURCE_CHAR_WIDTH);
            CharSource *_char = [[CharSource alloc] initWithChar:character andFrame:frame];
            _char.delegate = self;
            
            [self.view addSubview:_char];
            
            offsetX += SOURCE_CHAR_WIDTH + CHAR_SPACING;
            [_charSourceArray addObject:_char];
        }
    }
}

#pragma mark - CHAR SOURCE DELEGATE
- (void) charSourceClicked:(CharSource *)source
{
    for (int i = 0;i < [_charSquareArray count];i++) {
        CharSquare *_char = [_charSquareArray objectAtIndex:i];
        if ([_char.character isEqualToString:@""]) {
            _charGenerator.currPos = i;
            NSLog(@"New POS: %@ - %d", _char.character, i);
            break;
        }
    }
    
    NSLog(@"SOURCE %d - ALL %d", _charGenerator.currPos, [_charGenerator.songChar count]);
    
    CharSquare *_char = [_charSquareArray objectAtIndex:_charGenerator.currPos];
    
    [_charGenerator.wordResult replaceObjectAtIndex:_charGenerator.currPos withObject:source.character];
    if ([_char.character isEqualToString:@""]) {
        _charGenerator.remainingChar++;
        [_char setCharacter:source.character];
        [_char setCharSource:source];
        
        [source setHidden:YES];
        
        if (_charGenerator.remainingChar == [_charGenerator.songChar count]) {
            [self solving];
        }
    }
}

#pragma mark - SOLVING
- (void) solving
{
    [_charGenerator.wordResult removeAllObjects];
    for (int i = 0;i < [_charSquareArray count];i++) {
        CharSquare *_char = [_charSquareArray objectAtIndex:i];
        [_charGenerator.wordResult addObject:_char.character];
    }
    
    if ([_charGenerator isSolved])
        [self congratulation];
    else {
        [self sorry];
    }
}

#pragma mark - CONGRATULATION
- (void) congratulation
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Good Job" message:@"You got it" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void) sorry
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You didn't make it. Please try again !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - CHAR SQUARE DELEGATE
- (void) charSquareClicked:(CharSquare *)square
{
    if (square.charSource) {
        _charGenerator.remainingChar--;
        [square.charSource setHidden:NO];
        [square setCharSource:nil];
        
        if (square.iCharPos < _charGenerator.currPos) {
            _charGenerator.currPos = square.iCharPos;
        }
    }
}

- (NSString*) randomChar
{
    NSArray *_char = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"X", @"Y", nil];
    
    int random = rand() % [_char count];
    return [_char objectAtIndex:random];
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
