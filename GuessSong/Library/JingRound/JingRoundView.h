//
//  JingRoundView.h
//  JingFM-RoundEffect

#import <UIKit/UIKit.h>

@protocol JingRoundViewDelegate <NSObject>

-(void) playStatusUpdate:(BOOL)playState;

@end

@interface JingRoundView : UIView

@property (strong, nonatomic) UIImageView *roundImageView;

@property (assign, nonatomic) id<JingRoundViewDelegate> delegate;

@property (strong, nonatomic) UIImage *roundImage;

@property (assign, nonatomic) BOOL isPlay;

@property (assign, nonatomic) float rotationDuration;

-(void) play;

-(void) pause;

@end
