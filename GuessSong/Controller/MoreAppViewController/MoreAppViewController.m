//
//  MainViewController.m
//  WhatsMyApps
//
//  Created by Emir Fithri on 6/16/14.
//  Copyright (c) 2014 emirBytes. All rights reserved.
//

#import "MoreAppViewController.h"
#import "UIViewController+CWPopup.h"

@interface MoreAppViewController ()

@end

@implementation MoreAppViewController

@synthesize masterTable;

int totalApps = 0;

-(BOOL)isInternetAvail {
	return ([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSASCIIStringEncoding error:nil ]!=NULL)?YES:false;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_appArray count];                                   //count number of row from counting array hear cataGorry is An Array
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(NSString *)getRatingText:(NSString *)ratingNo {
    
    NSString *res = @"-";
    
    float num = [ratingNo floatValue];
    if ((num>0)&&(num<=1.1)) res = @"✮";
    if ((num>1.1)&&(num<=1.6)) res = @"✮½";
    if ((num>1.6)&&(num<=2.1)) res = @"✮✮";
    if ((num>2.1)&&(num<=2.6)) res = @"✮✮½";
    if ((num>2.6)&&(num<=3.1)) res = @"✮✮✮";
    if ((num>3.1)&&(num<=3.6)) res = @"✮✮✮½";
    if ((num>3.6)&&(num<=4.1)) res = @"✮✮✮✮";
    if ((num>4.1)&&(num<=4.6)) res = @"✮✮✮✮½";
    if ((num>4.6)&&(num<=5.1)) res = @"✮✮✮✮✮";
    
    return res;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    NSDictionary *individualApp = [_appArray objectAtIndex:indexPath.row];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        UIImageView *iconImg = [[UIImageView alloc] init];
        iconImg.tag = 1;
        iconImg.frame = CGRectMake(5, 5, 50, 50);
        [iconImg.layer setBorderWidth:1.0f];
        [iconImg.layer setBorderColor:[[UIColor grayColor] CGColor]];
        iconImg.layer.cornerRadius = 5;
        iconImg.layer.masksToBounds = YES;
        
        [cell.contentView addSubview:iconImg];
        
        UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 3.0, 300.0, 30.0)];
        [appNameLabel setTag:2];
        [appNameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [appNameLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:appNameLabel];
        
        UILabel *appVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 25.0, 300.0, 30.0)];
        [appVersionLabel setTag:3];
        [appVersionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [appVersionLabel setFont:[UIFont systemFontOfSize:12.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:appVersionLabel];
        
        UILabel *appPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 30.0, 300.0, 30.0)];
        [appPriceLabel setTag:4];
        [appPriceLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        [appPriceLabel setFont:[UIFont systemFontOfSize:12.0]];
        // custom views should be added as subviews of the cell's contentView:
//        [cell.contentView addSubview:appPriceLabel];
        
    }
    
    for (UIView *view in [cell.contentView subviews]) {
        if (view.tag==1) {
            UIImageView *icn = (UIImageView *)view;
            icn.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.png", documentsDirectoryPath, [individualApp objectForKey:@"trackId"]]];
        }
        
        if (view.tag==2) {
            UILabel *lbl1 = (UILabel *)view;
            lbl1.text = [individualApp objectForKey:@"trackName"];
        }
        
        if (view.tag==3) {
            UILabel *lbl1 = (UILabel *)view;
            lbl1.text = [NSString stringWithFormat:@"Version: %@",[individualApp objectForKey:@"version"]];
        }
        
        if (view.tag==4) {
            UILabel *lbl1 = (UILabel *)view;
//            lbl1.text = [NSString stringWithFormat:@"Rate: %@", [self getRatingText:[individualApp objectForKey:@"averageUserRatingForCurrentVersion"]]];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *individualApp = [_appArray objectAtIndex:indexPath.row];
    
    NSString *trackViewURL = [individualApp objectForKey:@"trackViewUrl"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewURL]];
}

-(void)goSearch {
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&entity=software&attribute=softwareDeveloper", @"trung bui"];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFNetworkingSynchronousSingleton sharedClient] getPath:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _appDict = responseObject;
        
//        NSLog(@"%@",_appDict);
        
        _appArray = [NSMutableArray arrayWithArray:[_appDict objectForKey:@"results"]];
        
        totalApps = [_appArray count];
        
        // sort the array
        NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"trackName" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        NSArray *sorted = [_appArray sortedArrayUsingDescriptors:sortDescriptors];
        
        [_appArray removeAllObjects];
        [_appArray addObjectsFromArray:sorted];
        
        // save all icons locally with appID as name
        for (int i =0; i<totalApps; i++) {
            NSDictionary *individualApp = [_appArray objectAtIndex:i];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[individualApp objectForKey:@"trackId"]]];
            NSData *thedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[individualApp objectForKey:@"artworkUrl100"]]];
            [thedata writeToFile:localFilePath atomically:YES];
            
        }
        [SVProgressHUD dismiss];
        
        [self.masterTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The resquest cannot be completed. Please try again later !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_alert show];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _appDict = [[NSDictionary alloc] init];
    
    [self goSearch];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_navigationBar setFrame:CGRectMake(0, 0, _navigationBar.frame.size.width, 40)];
}

- (IBAction)btnBackClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
