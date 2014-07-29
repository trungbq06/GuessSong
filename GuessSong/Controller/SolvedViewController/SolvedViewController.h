//
//  SolvedViewController.h
//  GuessSong
//
//  Created by Mr Trung on 7/14/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTLabel.h"

@interface SolvedViewController : UIViewController <MTLabelDelegate>

@property (nonatomic, retain) NSString              *result;
@property (nonatomic, assign) int                   coins;
@property (strong, nonatomic) IBOutlet MTLabel      *guessedWord;
@property (strong, nonatomic) IBOutlet UILabel      *lblCoins;
@property (strong, nonatomic) IBOutlet MTLabel      *lblFinish;
@property (strong, nonatomic) IBOutlet UILabel      *lblGuessed;
@property (strong, nonatomic) IBOutlet UIButton     *btnNext;
@property (strong, nonatomic) IBOutlet UIImageView  *imgCoins;
@property (nonatomic, assign) int                   startCoin;
@property (nonatomic, strong) NSTimer               *tUpdate;

// Data of the quiz
@property (nonatomic, retain) NSMutableArray        *quizData;
// Current quiz index
@property (nonatomic, assign) int                   idxQuiz;
@property (nonatomic, assign) int                   currLevel;
@property (nonatomic, assign) int                   currCoins;

- (IBAction)btnNextClick:(id)sender;


@end
