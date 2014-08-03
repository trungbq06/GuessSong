//
//  SolvedViewController.m
//  GuessSong
//
//  Created by Mr Trung on 7/14/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "SolvedViewController.h"
#import "PlayViewController.h"
#import "StartViewController.h"
#import "UIColor+Expand.h"
#import <QuartzCore/QuartzCore.h>
#import "Helper.h"
#import <POP/POP.h>

@interface SolvedViewController ()

@end

@implementation SolvedViewController

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
    
    _finishArr = [NSArray arrayWithObjects:[Helper localizedString:@"Good Job"], [Helper localizedString:@"Amazing"],
                           [Helper localizedString:@"Great"],[Helper localizedString:@"Hooray"],
                           [Helper localizedString:@"Awesome"],[Helper localizedString:@"Incredible"], nil];
    
    int random = arc4random() % [_finishArr count];
    NSString *_finish = [_finishArr objectAtIndex:random];
    [_lblCongrate setText:[NSString stringWithFormat:@"%@ !" , [_finish uppercaseString]]];
    [_lblCongrate setTextColor:[UIColor colorFromHex:kYellowColor]];
    [_guessedWord setTextColor:[UIColor colorFromHex:kYellowColor]];
    [_lblCoins setTextColor:[UIColor colorFromHex:kYellowColor]];
    
    if (DATA_TYPE == 1)
        [_lblGuessed setText:[Helper localizedString:@"The song was"]];
    else {
        [_lblGuessed setText:[Helper localizedString:@"The word was"]];
    }
    
    [_coinsEarned setText:[Helper localizedString:@"Coins earned"]];
    
    [_lblFinish setTextColor:[UIColor colorFromHex:@"#FF1447"]];
    
    [_coinsEarned setHidden:YES];
    [_btnDownload setHidden:YES];
    [_lblCoins setHidden:YES];
    [_imgCoins setHidden:YES];
    [_guessedWord setHidden:YES];
    [_lblGuessed setHidden:YES];
    [_lblFinish setHidden:YES];
    
    /*
    [_lblFinish setLineHeight:18];
    [_lblFinish setFontColor:[UIColor colorFromHex:@"#ff7b23"]];
    [_lblFinish setFontHighlightColor:[UIColor clearColor]];
    [_lblFinish setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:25.0]];
    [_lblFinish setTextAlignment:MTLabelTextAlignmentCenter];
    */
    NSString *font = @"DINBold";
    if ([LANG_CODE isEqualToString:@"vi"]) {
        font = @"TimesNewRomanPS-BoldMT";
    }
    [_lblFinish setNumberOfLines:0];
    [_lblFinish setFont:[UIFont fontWithName:font size:25.0]];
//    [_lblFinish setTextColor:[UIColor colorFromHex:@"#ff7b23"]];
    [_lblFinish setTextAlignment:NSTextAlignmentCenter];
    
    /*
    _guessedWord.delegate = self;
    [_guessedWord setLineHeight:18];
    [_guessedWord setFontColor:[UIColor colorFromHex:@"#ff7b23"]];
    [_guessedWord setFontHighlightColor:[UIColor clearColor]];
    [_guessedWord setFont:[UIFont fontWithName:@"DINAlternate-Bold" size:32.0]];
    [_guessedWord setTextAlignment:MTLabelTextAlignmentCenter];
     */
    [_guessedWord setNumberOfLines:0];
    [_guessedWord setFont:[UIFont fontWithName:@"DINBold" size:30.0]];
    [_guessedWord setTextAlignment:NSTextAlignmentCenter];
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finish_bg"]]];
    [self.view setBackgroundColor:[UIColor colorFromHex:kBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (DATA_TYPE == 2) {
        NSString *string = [_result uppercaseString];
        if (string) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(5)
                                     range:NSMakeRange(0, [string length])];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINBold" size:35] range:NSMakeRange(0, [string length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHex:kYellowColor] range:NSMakeRange(0, [string length])];
            
            _guessedWord.attributedText = attributedString;
        }
    } else {
        [_guessedWord setText:[_result uppercaseString]];
    }
//    [_guessedWord setText:@"Co khi nao ta xa nhau roi hoi nguoi"];
    [_guessedWord setHidden:YES];
    
    [_btnNext.layer setCornerRadius:10];
    [_btnNext.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_btnNext.layer setBorderWidth:2];
    [_btnNext setBackgroundColor:[UIColor colorFromHex:@"#F2C200"]];
//    [_btnNext setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animation];
    
    [self animateCoin];
    
    if (_currLevel == [_quizData count]) {
        [_guessedWord setHidden:YES];
        [_lblFinish setHidden:NO];
        [_btnNext setTitle:@"OK" forState:UIControlStateNormal];

        NSString *finish = [Helper localizedString:@"You finished all level! We will update new data soon. Please come back later!"];
        [_lblFinish setText:finish];
    } else {
        [_coinsEarned setHidden:NO];
        if (DATA_TYPE == 1)
            [_btnDownload setHidden:NO];
        [_lblCoins setHidden:NO];
        [_imgCoins setHidden:NO];
        [_lblGuessed setHidden:NO];
        [_lblFinish setHidden:NO];
    }
}

- (void) animateCoin
{
    _startCoin = 1;
    NSTimeInterval tiCallRate = 1.0 / 15.0;
    _tUpdate = [NSTimer scheduledTimerWithTimeInterval:tiCallRate
                                               target:self
                                             selector:@selector(updateCoinLabel)
                                             userInfo:nil
                                              repeats:YES];
}

- (void) updateCoinLabel
{
    if (_startCoin < _coins)
        [_lblCoins setText:[NSString stringWithFormat:@"%d", ++_startCoin]];
    else {
        [_tUpdate invalidate];
        [_lblCoins setText:[NSString stringWithFormat:@"%d", _coins]];
        
        POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//        basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
        basicAnimation.fromValue =[NSValue valueWithCGSize:CGSizeMake(1.4f, 1.4f)];
        basicAnimation.springSpeed = 20;
        basicAnimation.springBounciness = 20;
        
        [_lblCoins.layer pop_addAnimation:basicAnimation forKey:@"positionAnimation"];
    }
}

- (void) animation
{
    [_guessedWord setHidden:NO];
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    CGRect normalFrame = _guessedWord.frame;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [_guessedWord setFrame:normalFrame];
    }];
    [_guessedWord pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setResult:(NSString *)result
{
    _result = result;
}

- (IBAction)btnDownloadClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_currQuiz.itunesURL]];
}

- (IBAction)btnNextClick:(id)sender
{
    if (_currLevel < [_quizData count]) {
        DLog_Low(@"Curr Quiz %d", _idxQuiz);
        PlayViewController *_playController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
        [_playController setIdxQuiz:_idxQuiz];
        [_playController setQuizData:_quizData];
        [_playController setCurrLevel:_currLevel + 1];
        
        _currCoins += _coins;
        
        [Helper updateNewCoins:_currCoins success:^{
            [_playController setCurrCoins:_currCoins];
            
            [self.navigationController pushViewController:_playController animated:YES];
        }];
    } else {
//        StartViewController *_startController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
