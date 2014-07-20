//
//  SolvedViewController.m
//  GuessSong
//
//  Created by Mr Trung on 7/14/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "SolvedViewController.h"
#import "PlayViewController.h"

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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setResult:(NSString *)result
{
    _result = result;
    
    [_guessedWord setText:_result];
}

- (IBAction)btnNextClick:(id)sender
{
    PlayViewController *_playController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
    [_playController setIdxQuiz:_idxQuiz];
    [_playController setQuizData:_quizData];
    [_playController setCurrLevel:_currLevel + 1];
    
    [Helper updateNewCoins:_currCoins success:^{
        [_playController setCurrCoins:_currCoins];
        
        [self.navigationController pushViewController:_playController animated:YES];
    }];
}

@end
