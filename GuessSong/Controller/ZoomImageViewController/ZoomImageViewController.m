//
//  ZoomImageViewController.m
//  GuessSong
//
//  Created by TrungBQ on 8/2/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "ZoomImageViewController.h"

@interface ZoomImageViewController ()

@end

@implementation ZoomImageViewController

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
    
    [_imageView setFrame:self.view.frame];
    [self.view addSubview:_imageView];
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
