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
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworkingSynchronousSingleton.h"
#import "CDSingleton.h"
#import "CDModel.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"
#import "DataParser.h"
#import "UIViewController+CWPopup.h"
#import "SolvedViewController.h"

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
    
    [_lbLevel setFont:[UIFont fontWithName:FONT_FAMILY size:30]];
    [_btnCoins.titleLabel setFont:[UIFont fontWithName:FONT_FAMILY size:15]];
    
    [_navigationBar setBackgroundColor:[UIColor colorFromHex:NAV_BG_COLOR]];
    [_navigationBar setFrame:CGRectMake(0, 0, _navigationBar.frame.size.width, 40)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeCoins:) name:kNotifyDidChangeCoins object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickDone:) name:kDoneClick object:nil];
    
    int playRound = [[[NSUserDefaults standardUserDefaults] objectForKey:PLAY_ROUND] intValue];
    playRound++;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:playRound] forKey:PLAY_ROUND];
    
    [self.view setBackgroundColor:[UIColor colorFromHex:@"#24A3BD"]];
    
    _playingRound.delegate = self;
    _playingRound.roundImage = [UIImage imageNamed:@"cd_play"];
    _playingRound.rotationDuration = 8.0;
    _playingRound.isPlay = NO;
    
    if (!IS_IPHONE_5) {
        [_playingRound setFrame:CGRectMake(_playingRound.frame.origin.x, _playingRound.frame.origin.y - 30, _playingRound.frame.size.width, _playingRound.frame.size.height)];
    }
    
    CGPoint center = CGPointMake(_playingRound.frame.origin.x + _playingRound.frame.size.width / 2.0, _playingRound.frame.origin.y + _playingRound.frame.size.height / 2.0);
    
    UIImage *stateImage;
    if (_isPlaying) {
        stateImage = [UIImage imageNamed:PAUSE_IMAGE];
    }else{
        stateImage = [UIImage imageNamed:PLAY_IMAGE];
    }
    
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_playBtn setCenter:center];
    [_playBtn setBackgroundImage:stateImage forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playSong:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
//    [self.view sendSubviewToBack:_playBtn];
    
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    // Load coins and level from local database
    [_cdSingleton loadWithData:_cdModel success:^(CDLoad *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        for (UserInfo *_userInfo in responseObject) {
            DLog_Low(@"Current coins: %@", _userInfo.coins);
            _sound = [_userInfo.sound boolValue];
            _currCoins = [_userInfo.coins intValue];
            [_btnCoins setTitle:[NSString stringWithFormat:@"   %@", _userInfo.coins] forState:UIControlStateNormal];
            [_lbLevel setText:[NSString stringWithFormat:@"%@", _userInfo.level]];
            _currLevel = [_userInfo.level intValue];
            _idxQuiz = [_userInfo.level intValue] - 1;
            
            DLog_Low(@"Index %d", _idxQuiz);
            
            if (_idxQuiz < [_quizData count]) {
                // Initiate quiz data
                _quiz = [_quizData objectAtIndex:_idxQuiz];
            
                [self generateGame];
            } else {
                [self finishGame];
            }
        }
    } failure:^(CDLoad *operation, NSError *error) {
        DLog_Low(@"Error %@", error);
    }];
    
    /*
    [_cdSingleton deleteWithData:_cdModel success:^(CDDelete *operation, id responseObject) {
        NSLog(@"Deleted");
    } failure:^(CDDelete *operation, NSError *error) {
        NSLog(@"Delete Error");
    }];
     */
    
    // Init array object
    _charSquareArray = [[NSMutableArray alloc] initWithCapacity:0];
    _charSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _charGenerator = [[CharacterGenerator alloc] init];
    
    
    for (NSString *family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        for (NSString *font in [UIFont fontNamesForFamilyName:family])
        {
            NSLog(@"\t%@", font);
        }
    }
    
    
    // Load data for the first time
    if (!_quizData) {
        
    } else {
        [SVProgressHUD dismiss];
    }
    
    NSURL *playURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:KWRONG_MP3 ofType:@"mp3"]];

    _wrongPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:playURL error:nil];
    
    NSURL *playURL2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:kTADA_MP3 ofType:@"mp3"]];

    _tadaPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:playURL2 error:nil];
    
    _removedChar = 0;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *bgImage = [[NSUserDefaults standardUserDefaults] objectForKey:kBackgroundImage];
    if (!bgImage)
        bgImage = @"background";
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:bgImage]]];
    [self.view setBackgroundColor:[UIColor colorFromHex:@"#00c3bb"]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isPlaying = TRUE;
    [self playSong];
}

#pragma mark - DID CHANGE COINS
- (void) didChangeCoins:(NSNotification*) _notification
{
    NSDictionary *_newCoins = _notification.userInfo;
    
    [_btnCoins setTitle:[NSString stringWithFormat:@"   %d", [[_newCoins objectForKey:kCoins] intValue]] forState:UIControlStateNormal];
    
    [self setCurrCoins:(_currCoins + [[_newCoins objectForKey:kCoins] intValue])];
}

- (void) didClickDone:(NSNotification*) _notification
{
    [self dismissPopup];
}

- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            DLog_Low(@"popup view dismissed");
        }];
    }
}

#pragma mark - JINGROUND DELEGATE
- (void) playStatusUpdate:(BOOL)playState
{
    _isPlaying = playState;
    
    [self playSong];
}

#pragma mark - NEXT GAME
- (void) nextGame
{
    _idxQuiz++;
    if (_idxQuiz < [_quizData count]) {
        PlayViewController *_playController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
        [_playController setIdxQuiz:_idxQuiz];
        [_playController setQuizData:_quizData];
        [_playController setCurrLevel:_currLevel + 1];
        
        if ([_charGenerator isSolved])
            _currCoins += _quiz.coins;
        [Helper updateNewCoins:_currCoins success:^{
            [Helper updateLevel:_currLevel + 1 success:^{
                [_playController setCurrCoins:_currCoins];
                
                [self.navigationController pushViewController:_playController animated:YES];
            }];
        }];
    }
}

- (void) generateGame
{
    if (_quiz) {
        [self generateNewQuiz:_quiz.qResult];
        DLog_Low(@"RESULT: %@", _quiz.qResult);
    }
}

- (void) updateCoins:(int) coins
{
    NSDictionary *_uInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:coins], kCoins, [NSNumber numberWithInt:1], @"level", nil];
    CDSingleton *_cdSingleton = [CDSingleton sharedCDSingleton];
    
    CDModel* _cdModel = [[CDModel alloc] init];
    _cdModel.entityName = @"UserInfo";
    
    // Update to database
    [_cdSingleton updateWithData:_cdModel newData:_uInfo success:^(CDUpdate *operation, id responseObject) {
        DLog_Low(@"Updated success");
    } failure:^(CDUpdate *operation, NSError *error) {
        DLog_Low(@"Update error");
    }];
}

- (void) generateNewQuiz:(NSString*) quizName
{
    [_charSquareArray removeAllObjects];
    
    [_charGenerator setSongName:quizName];
    
//    [_playingRound.roundImageView setImageWithURL:[NSURL URLWithString:[_quiz.qSource objectForKey:@"thumbnail"]]];
    
    [_lbLevel setText:[NSString stringWithFormat:@"%d", _currLevel]];
    
    int iChar = 0;
    int iLength = 0;
    int startX = 0;
    int offsetX = 0;
    int offsetY = OFFSETY;
    int sOffsetY = SOURCE_OFFSET_Y;
    DLog_Low(@"%d - %d - %@", IS_IPHONE, IS_WIDE_SCREEN, [ [UIDevice currentDevice] model ]);
    
    if (!IS_IPHONE_5) {
        offsetY -= 50;
        sOffsetY -= 60;
        int decrease = 45;
        
        [_btnFacebook setFrame:CGRectMake(_btnFacebook.frame.origin.x, _btnFacebook.frame.origin.y - decrease, _btnFacebook.frame.size.width, _btnFacebook.frame.size.height)];
        [_btnShow setFrame:CGRectMake(_btnShow.frame.origin.x, _btnShow.frame.origin.y - decrease, _btnShow.frame.size.width, _btnShow.frame.size.height)];
        [_btnDelete setFrame:CGRectMake(_btnDelete.frame.origin.x, _btnDelete.frame.origin.y - decrease, _btnDelete.frame.size.width, _btnDelete.frame.size.height)];
        [_btnNext setFrame:CGRectMake(_btnNext.frame.origin.x, _btnNext.frame.origin.y - decrease, _btnNext.frame.size.width, _btnNext.frame.size.height)];
    }
    
    offsetY += (sOffsetY - offsetY) / 2 - ([_charGenerator.wordOffset count] * WIDTH/2);
    
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
            [self.view sendSubviewToBack:_char];
            offsetX += WIDTH + CHAR_SPACING;
            
            [_charSquareArray addObject:_char];
        }
        
        offsetY += LINE_SPACING;
    }
    
    // Calculate total needed source character
    int totalChar = [_charGenerator.songChar count];
    int totalRow = ceil((float)(totalChar * SOURCE_CHAR_WIDTH) / SOURCE_VIEW_WIDTH);
    int nTotalChar = (float)(totalRow * (floor)(SOURCE_VIEW_WIDTH / SOURCE_CHAR_WIDTH));
    
    NSMutableArray *_sourceChar = [[NSMutableArray alloc] initWithArray:_charGenerator.songChar];
    int charPerRow = nTotalChar / totalRow;
    
    // Need how many more character ???
    for (int i = 0;i< nTotalChar - totalChar;i++) {
        [_sourceChar addObject:[self randomChar:_sourceChar]];
    }
    
    [_sourceChar shuffle];
    
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    
    // Draw source character
    for (int i = 0;i < totalRow;i++) {
        offsetX = (appFrame.size.width - SOURCE_VIEW_WIDTH) / 2 - CHAR_SPACING * 3;
        offsetY = sOffsetY + i * SOURCE_LINE_SPACING;
        for (int j = 0;j < charPerRow;j++) {
            iChar = i * charPerRow + j;
            
            NSString *character = [_sourceChar objectAtIndex:iChar];
//            NSLog(@"%d: %@", iChar, character);
            
            CGRect frame = CGRectMake(offsetX, offsetY, SOURCE_CHAR_WIDTH, SOURCE_CHAR_WIDTH);
            CharSource *_char = [[CharSource alloc] initWithChar:character andFrame:frame];
            _char.delegate = self;
            
            [self.view addSubview:_char];
            [self.view sendSubviewToBack:_char];
            
            offsetX += SOURCE_CHAR_WIDTH + CHAR_SPACING;
            [_charSourceArray addObject:_char];
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(animation) userInfo:nil repeats:YES];
    
    _totalChar = [_charSourceArray count];
}

- (void) animation
{
    // Animate button
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    basicAnimation.fromValue =[NSValue valueWithCGSize:CGSizeMake(1.4f, 1.4f)];
    basicAnimation.springSpeed = 5;
    basicAnimation.springBounciness = 10;
    
    [basicAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        //        [_btnPlay setFrame:normalFrame];
        //        [_btnPlay.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:30]];
    }];
    
    [_btnShow.layer pop_addAnimation:basicAnimation forKey:@"positionAnimation"];
}

#pragma mark - CHAR SOURCE DELEGATE
- (void) charSourceClicked:(CharSource *)source
{
    for (int i = 0;i < [_charSquareArray count];i++) {
        CharSquare *_char = [_charSquareArray objectAtIndex:i];
        if ([_char.character isEqualToString:@""]) {
            _charGenerator.currPos = i;
//            DLog_Low(@"New POS: %@ - %d", _char.character, i);
            break;
        }
    }
    
//    DLog_Low(@"SOURCE %d - ALL %lu", _charGenerator.currPos, (unsigned long)[_charGenerator.songChar count]);
    
    CharSquare *_char = [_charSquareArray objectAtIndex:_charGenerator.currPos];
    
    [_charGenerator.wordResult replaceObjectAtIndex:_charGenerator.currPos withObject:source.character];
    if ([_char.character isEqualToString:@""]) {
        _charGenerator.remainingChar++;
        [_char setCharacter:source.character];
        [_char setCharSource:source];
        
        [source setHidden:YES];
        
        if (_charGenerator.remainingChar == [_charGenerator.songChar count]) {
            [self solving:TRUE];
        }
    }
}

#pragma mark - CHAR SQUARE DELEGATE
- (void) charSquareClicked:(CharSquare *)square
{
    if (square.charSource) {
        _charGenerator.remainingChar--;
        [square.charSource setHidden:NO];
        
        // Animate the source
        [square.charSource setAlpha:0.0];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^ {
                             [square.charSource setAlpha:1.0];
                         }
                         completion:nil];
        
        [square setCharSource:nil];
        
        if (square.iCharPos < _charGenerator.currPos) {
            _charGenerator.currPos = square.iCharPos;
        }
        
        if (_charGenerator.remainingChar + 1 == [_charGenerator.songChar count]) {
            [self resetColor];
        }
    }
}

#pragma mark - SOLVING
- (BOOL) solving:(BOOL) showAlert
{
    [_charGenerator.wordResult removeAllObjects];
    for (int i = 0;i < [_charSquareArray count];i++) {
        CharSquare *_char = [_charSquareArray objectAtIndex:i];
        [_charGenerator.wordResult addObject:_char.character];
    }
    
    if ([_charGenerator isSolved])
        if (showAlert)
            [self congratulation];
        else
            return TRUE;
    else {
        if (showAlert) {
            [self solveFailed];
            
            [self sorry];
        } else
            return FALSE;
    }
    
    return FALSE;
}

- (void) solveFailed
{
    for (CharSquare *_char in _charSquareArray) {
        [_char colorFail];
    }
    
    [_wrongPlayer play];
}

- (void) resetColor
{
    for (CharSquare *_char in _charSquareArray) {
        [_char resetColor];
    }
}

#pragma mark - UIALERTVIEW DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            [self nextGame];
        }
    } else if (alertView.tag == 1002) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (alertView.tag == kShowHintAlert && buttonIndex == 1) {
        // Show a character hint
        [self showCharHint];
        
        [_btnCoins setTitle:[NSString stringWithFormat:@"   %d", _currCoins] forState:UIControlStateNormal];
    } else if (alertView.tag == kDeleteAlert && buttonIndex == 1) {
        // Delete wrong character
        [self deleteWrongChar];
        
        [_btnCoins setTitle:[NSString stringWithFormat:@"   %d", _currCoins] forState:UIControlStateNormal];
    } else if (alertView.tag == kSkipAlert && buttonIndex == 1) {
        // Skip this game
        _currCoins -= kSkipCoins;
        
        [self nextGame];
        
        [_btnCoins setTitle:[NSString stringWithFormat:@"   %d", _currCoins] forState:UIControlStateNormal];
    }
}

#pragma mark - CONGRATULATION
- (BOOL) congratulation
{
//    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView *_dimBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)];
//    [_dimBg setBackgroundColor:[UIColor blackColor]];
//    [_dimBg setAlpha:0.6];
//    
//    [self.view addSubview:_dimBg];
    
    [_tadaPlayer play];
    
    SolvedViewController *_solvedController = [self.storyboard instantiateViewControllerWithIdentifier:@"SolvedViewController"];
    [_solvedController setResult:_quiz.qResult];
    [_solvedController setCoins:_quiz.coins];
    
    [_solvedController setIdxQuiz:_idxQuiz];
    [_solvedController setCurrCoins:_currCoins];
    [_solvedController setQuizData:_quizData];
    [_solvedController setCurrLevel:_currLevel];
    [_solvedController setCurrQuiz:_quiz];
    
    [Helper updateLevel:_currLevel + 1 success:^{
        [self presentPopupViewController:_solvedController animated:YES completion:nil];
    }];
    
    return TRUE;
}

- (void) finishGame
{
    [_tadaPlayer play];
    
    SolvedViewController *_solvedController = [self.storyboard instantiateViewControllerWithIdentifier:@"SolvedViewController"];
    [_solvedController setResult:_quiz.qResult];
    [_solvedController setCoins:_quiz.coins];
    
    [_solvedController setIdxQuiz:_idxQuiz];
    [_solvedController setCurrCoins:_currCoins];
    [_solvedController setQuizData:_quizData];
    [_solvedController setCurrLevel:_currLevel - 1];
    [_solvedController setCurrQuiz:_quiz];
    
    [self presentPopupViewController:_solvedController animated:YES completion:nil];
}

- (BOOL) sorry
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You didn't make it. Please try again !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
    return FALSE;
}

#pragma mark - ACTION IMPLEMENTATION
- (IBAction)showHint:(id)sender
{
    if ([self checkCoins:kShowCoins]) {
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Correct character", @"Correct character") message:NSLocalizedString(@"Do you want to reveal a character for 15 coins", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        _alertView.tag = kShowHintAlert;
        [_alertView setDelegate:self];
        [_alertView show];
    }
}

- (void) showCharHint
{
    _currCoins -= kShowCoins;
    
    [Helper updateNewCoins:_currCoins success:nil];
    
    int iChar = arc4random() % [_charSquareArray count];
    
    CharSquare *_char = [_charSquareArray objectAtIndex:iChar];
    NSString *_currChar = [_charGenerator.songChar objectAtIndex:iChar];
    
    if (_charGenerator.remainingChar < [_charGenerator.songChar count]) {
        if (!_char.isHint) {
            [self chooseSource:_currChar];
            
            if ([_char.character isEqualToString:@""]) {
                _charGenerator.remainingChar++;
                [_char setCharacter:_currChar];
            } else {
                if (![_char.character isEqualToString:_currChar]) {
                    [_char.charSource setHidden:NO];
                    [_char setCharacter:_currChar];
                }
            }
            [_char showHint];
            
            if (_charGenerator.remainingChar == [_charGenerator.songChar count]) {
                if (![self solving:FALSE]) {
                    _charGenerator.remainingChar--;
                    [self showCharHint];
                } else {
                    [self congratulation];
                }
            }
        } else {
            [self showCharHint];
        }
    }
}

- (void) chooseSource:(NSString*)_char
{
    for (CharSquare *_source in _charSourceArray) {
        if ([_source.character isEqualToString:_char] && ![_source isHidden]) {
            [_source removeFromSuperview];
            [_charSourceArray removeObject:_source];
            break;
        }
    }
}

- (IBAction)deleteChar:(id)sender
{
    if ([self checkCoins:kDeleteCoins]) {
        int toRemoveChar = _totalChar - [_charSquareArray count];
        
        if (_removedChar < toRemoveChar) {
            UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remove character", @"Remove character") message:NSLocalizedString(@"Do you want to delete a wrong character for 10 coins", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            _alertView.tag = kDeleteAlert;
            [_alertView setDelegate:self];
            [_alertView show];
        } else {
            
        }
    }
}

- (void) deleteWrongChar
{
    BOOL removed = FALSE;
    
    for (int i = 0;i < [_charSourceArray count];i++) {
        CharSource *_source = [_charSourceArray objectAtIndex:i];
        if (![_charGenerator.songChar containsObject:_source.character] && ![_source.character isEqualToString:@""]) {
            [_source removeFromSuperview];
            [_source setCharacter:@""];
            [_charSourceArray removeObject:_source];
            removed = TRUE;
            break;
        }
    }
    if (!removed) {
        for (int i = 0;i < [_charSquareArray count];i++) {
            CharSquare *_square = [_charSquareArray objectAtIndex:i];
            if (![_charGenerator.songChar containsObject:_square.character] && ![_square.character isEqualToString:@""]) {
                [_square setCharacter:@""];
                
                [_square.charSource removeFromSuperview];
                [_charSourceArray removeObject:_square.charSource];
                removed = TRUE;
                break;
            } else {
//                NSLog(@"CHAR %@", _square.character);
            }
        }
    }
    
    if (removed) {
        _removedChar++;
        _currCoins -= kDeleteCoins;
        [Helper updateNewCoins:_currCoins success:nil];
    }
}

- (IBAction)skipLevel:(id)sender
{
    if ([self checkCoins:kSkipCoins]) {
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Skip Level", @"Skip Level") message:NSLocalizedString(@"Do you want to skip this level for 30 coins", @"") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        _alertView.tag = kSkipAlert;
        [_alertView setDelegate:self];
        [_alertView show];
    }
}

- (BOOL) checkCoins:(int) _neededCoins
{
    if (_currCoins < _neededCoins) {
        [self buyCoins];
        
        return FALSE;
    }
    
    return TRUE;
}

- (IBAction)shareFB:(id)sender
{
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
//        [appDelegate.session closeAndClearTokenInformation];
        
        FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
        params.link = [NSURL URLWithString:kServerURL];
        params.picture = [NSURL URLWithString:@"https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-xpa1/t1.0-9/10513289_10202084649312804_5356930935114971960_n.jpg"];
        params.name = @"Guess The Song";
        params.caption = @"Can you guess these song ?";
        /*
        FBPhotoParams *params = [[FBPhotoParams alloc] initWithPhotos:[NSArray arrayWithObjects:[self screenshot], nil]];
         */
        [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if(error) {
                DLog_Low(@"Error: %@", error.description);
            } else {
                DLog_Low(@"Success!");
            }
        }];
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            
        }];
    }
    
    /*
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if (composeViewController) {
            [composeViewController addImage:[UIImage imageNamed:@"MyImage"]];
            [composeViewController addURL:[NSURL URLWithString:@"http://www.google.com"]];
            NSString *initialTextString = @"Check out this Tweet!";
            [composeViewController setInitialText:initialTextString];
            [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
                if (result == SLComposeViewControllerResultDone) {
                    NSLog(@"Posted");
                } else if (result == SLComposeViewControllerResultCancelled) {
                    NSLog(@"Post Cancelled");
                } else {
                    NSLog(@"Post Failed");
                }
            }];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
    }
     */
}

- (UIImage *) screenshot {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedScreen;
    
    NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/capturedImage.jpg"]];
    [UIImageJPEGRepresentation(capturedScreen, 0.95) writeToFile:imagePath atomically:YES];
    
    return imagePath;
}

- (NSString*) randomChar:(NSMutableArray*)_sourceChar
{
    NSMutableArray *_char = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"X", @"Y", nil];
    
    for (int i = 0;i < [_sourceChar count];i++) {
        NSString *_cChar = [_sourceChar objectAtIndex:i];
        [_char removeObject:_cChar];
    }
    
    int random = rand() % [_char count];
    return [_char objectAtIndex:random];
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - GOTO NEXT GAME
- (IBAction)gotoNextGame:(id)sender {
    [self nextGame];
}

- (IBAction)btnCoinsClick:(id)sender {
    [self buyCoins];
}

- (void) buyCoins
{
    PurchaseViewController *_purchaseController = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseViewController"];
    
    [self presentPopupViewController:_purchaseController animated:YES completion:^{
        
    }];
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
        [_playingRound setIsPlay:_isPlaying];
        [_playBtn setBackgroundImage:[UIImage imageNamed:PAUSE_IMAGE] forState:UIControlStateNormal];
        
        if (!_songPlayer) {
            NSString *playString = [_quiz.qSource objectForKey:@"preview_url"];
            
            //Converts songURL into a playable NSURL
            NSURL *playURL = [NSURL URLWithString:playString];

            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playURL];

            _songPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        }
        
        [_songPlayer play];
    } else {
        _isPlaying = FALSE;
        [_playingRound setIsPlay:_isPlaying];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        
        [_songPlayer pause];
    }
}

#pragma mark - NOTIFICATION FINISH PLAYING
- (void) itemDidFinishPlaying:(NSNotification*) notification
{
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    
    [_playingRound setIsPlay:NO];
    _isPlaying = FALSE;
    [_songPlayer pause];
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
