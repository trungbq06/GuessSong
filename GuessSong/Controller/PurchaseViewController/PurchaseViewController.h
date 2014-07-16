//
//  PurchaseViewController.h
//  GuessSong
//
//  Created by Mr Trung on 7/15/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PurchaseViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView       *tableView;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;

- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnBuyClick:(id)sender;

@end
