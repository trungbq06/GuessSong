//
//  PurchaseViewController.m
//  GuessSong
//
//  Created by Mr Trung on 7/15/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "PurchaseViewController.h"
#import "SVProgressHUD.h"
#import "UIViewController+CWPopup.h"
#import "PurchaseTableViewCell.h"
#import "AFNetworkingSynchronousSingleton.h"

#define kRemoveAdsProductIdentifier @"com.dragon.GuessSongApp"

@interface PurchaseViewController ()
{
    NSArray *_products;
    NSMutableDictionary *_coins;
}

@end

@implementation PurchaseViewController

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
    
    [_tableView registerNib:[UINib nibWithNibName:@"PurchaseTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PurchaseTableViewCell"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height - 50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];

    [[AFNetworkingSynchronousSingleton sharedClient] getPath:[NSString stringWithFormat:@"%@%@", kServerURL, @"quiz/products"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self validateProductIdentifiers:[responseObject objectForKey:@"identifiers"]];
        
        _coins = [responseObject objectForKey:@"coins"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        UIAlertView *_alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alertView show];
    }];
}

#pragma mark - UIALERTVIEW DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDoneClick object:nil];
}

#pragma mark - RETRIEVE PRODUCT INFORMATION
// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for(SKProduct *aProduct in response.products){
        DLog_Low(@"%@", aProduct.productIdentifier);
    }
    _products = response.products;
    
    [self displayStoreUI]; // Custom method
    
    [SVProgressHUD dismiss];
}

- (void) displayStoreUI
{
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW DELEGATE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseTableViewCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PurchaseTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.pTitle.text = [NSString stringWithFormat:@"%@", product.localizedTitle];
    [cell.pCoins setText:[NSString stringWithFormat:@"$ %@", product.price]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - DONE CLICK
- (IBAction)btnDoneClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDoneClick object:nil];
}

#pragma mark - BUY CLICK
- (IBAction)btnBuyClick:(id)sender
{
    DLog_Low(@"User requests to buy $500");
    
    if([SKPaymentQueue canMakePayments]){
        DLog_Low(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        DLog_Low(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}
/*
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    } else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}
*/
- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    DLog_Low(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            DLog_Low(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase

            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    [SVProgressHUD dismiss];
    for(SKPaymentTransaction *transaction in transactions){
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing:
                DLog_Low(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                [SVProgressHUD showWithStatus:@"Processing ..." maskType:SVProgressHUDMaskTypeBlack];
                break;
            case SKPaymentTransactionStatePurchased: {
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                NSNumber *_addCoins = [_coins objectForKey:transaction.payment.productIdentifier];
                
                [Helper updateCoins:[_addCoins intValue]];
                
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"You purchased %d coins !", [_addCoins intValue]]];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                DLog_Low(@"Transaction state -> Purchased");
                
                break;
            }
            case SKPaymentTransactionStateRestored:
                DLog_Low(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    DLog_Low(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void) dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
