//
//  SolvedViewController.h
//  GuessSong
//
//  Created by Mr Trung on 7/14/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SolvedViewController : UIViewController

@property (nonatomic, retain) NSString              *result;
@property (nonatomic, assign) int                   coins;
@property (weak, nonatomic) IBOutlet UILabel        *guessedWord;

// Data of the quiz
@property (nonatomic, retain) NSMutableArray        *quizData;
// Current quiz index
@property (nonatomic, assign) int                   idxQuiz;
@property (nonatomic, assign) int                   currLevel;
@property (nonatomic, assign) int                   currCoins;

- (IBAction)btnNextClick:(id)sender;


@end
