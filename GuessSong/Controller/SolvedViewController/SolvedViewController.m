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
    
    [_lblFinish setLineHeight:18];
    [_lblFinish setFontColor:[UIColor colorFromHex:@"#11C214"]];
    [_lblFinish setFontHighlightColor:[UIColor clearColor]];
    [_lblFinish setFont:[UIFont fontWithName:@"Avenir" size:25.0]];
    [_lblFinish setTextAlignment:MTLabelTextAlignmentCenter];
    
    _guessedWord.delegate = self;
    [_guessedWord setLineHeight:18];
    [_guessedWord setFontColor:[UIColor colorFromHex:@"#11C214"]];
    [_guessedWord setFontHighlightColor:[UIColor clearColor]];
    [_guessedWord setFont:[UIFont fontWithName:@"Avenir-Heavy" size:32.0]];
    [_guessedWord setTextAlignment:MTLabelTextAlignmentCenter];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finish_bg"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_guessedWord setText:_result];
//    [_guessedWord setText:@"Co khi nao ta xa nhau roi hoi nguoi"];
    [_guessedWord setHidden:YES];
    [_lblCoins setText:@"1"];
    
    [_btnNext.layer setCornerRadius:10];
    [_btnNext.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_btnNext.layer setBorderWidth:2];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animation];
    
    [self animateCoin];
    
    if (_currLevel == [_quizData count]) {
        [_lblCoins setHidden:YES];
        [_imgCoins setHidden:YES];
        [_guessedWord setHidden:YES];
        [_btnNext setTitle:@"OK" forState:UIControlStateNormal];
        
        [_lblGuessed setHidden:YES];
        
        NSString *finish = @"Amazing! You finished all level! We will update new data soon. Please come back later!";
        [_lblFinish setText:finish];
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
        
        POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        //    basicAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
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

- (IBAction)btnNextClick:(id)sender
{
    if (_currLevel < [_quizData count]) {
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
