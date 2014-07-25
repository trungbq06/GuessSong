//
//  SolvedViewController.m
//  GuessSong
//
//  Created by Mr Trung on 7/14/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "SolvedViewController.h"
#import "PlayViewController.h"
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
    
//    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finish_bg"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_guessedWord setText:_result];
    [_guessedWord setHidden:YES];
    [_lblCoins setText:[NSString stringWithFormat:@"You got %d coins", _coins]];
    
    if (_currLevel == [_quizData count] - 1) {
        [_btnNext setHidden:YES];
        
        CGRect frame = [[UIScreen mainScreen] applicationFrame];
        NSString *finish = @"Amazing! You finished all level! We will update new data soon. Please come back later!";
        UILabel *lbFinish = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, frame.size.width, frame.size.height)];
        [lbFinish setText:finish];
        
        [self.view addSubview:lbFinish];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animation];
}

- (void) animation
{
    [_guessedWord setHidden:NO];
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 10;
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
        
        [Helper updateNewCoins:_currCoins success:^{
            [_playController setCurrCoins:_currCoins];
            
            [self.navigationController pushViewController:_playController animated:YES];
        }];
    }
}

@end
