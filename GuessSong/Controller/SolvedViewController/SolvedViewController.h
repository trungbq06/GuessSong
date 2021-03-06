//
//  SolvedViewController.h
//  GuessSong
//
//  Created by Mr Trung on 7/14/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizModel.h"
#import "MTLabel.h"

@interface SolvedViewController : UIViewController <MTLabelDelegate>

@property (nonatomic, retain) NSString              *result;
@property (nonatomic, assign) int                   coins;
@property (strong, nonatomic) IBOutlet UILabel      *guessedWord;
@property (strong, nonatomic) IBOutlet UILabel      *lblCoins;
@property (strong, nonatomic) IBOutlet UILabel      *lblFinish;
@property (strong, nonatomic) IBOutlet UILabel      *lblGuessed;
@property (strong, nonatomic) IBOutlet UILabel      *lblCongrate;
@property (strong, nonatomic) IBOutlet UILabel      *coinsEarned;
@property (strong, nonatomic) IBOutlet UIButton     *btnNext;
@property (strong, nonatomic) IBOutlet UIButton     *btnDownload;
@property (strong, nonatomic) IBOutlet UIImageView  *imgCoins;
@property (nonatomic, assign) int                   startCoin;
@property (nonatomic, strong) NSTimer               *tUpdate;
@property (nonatomic, retain) QuizModel             *currQuiz;
@property (nonatomic, retain) NSArray               *finishArr;

// Data of the quiz
@property (nonatomic, retain) NSMutableArray        *quizData;
// Current quiz index
@property (nonatomic, assign) int                   idxQuiz;
@property (nonatomic, assign) int                   currLevel;
@property (nonatomic, assign) int                   currCoins;

- (IBAction)btnNextClick:(id)sender;
- (IBAction)btnDownloadClick:(id)sender;

@end
