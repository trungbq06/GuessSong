//
//  MainViewController.h
//  WhatsMyApps
//
//  Created by Emir Fithri on 6/16/14.
//  Copyright (c) 2014 emirBytes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworkingSynchronousSingleton.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface MoreAppViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *masterTable;
}

@property (nonatomic, retain) NSMutableArray    *appArray;
@property (nonatomic, retain) NSDictionary      *appDict;
@property (nonatomic, retain) UITableView       *masterTable;
@property (nonatomic, retain) UITextField       *devName;
@property (nonatomic, weak) IBOutlet UIView     *navigationBar;

- (IBAction)btnBackClick:(id)sender;

@end
