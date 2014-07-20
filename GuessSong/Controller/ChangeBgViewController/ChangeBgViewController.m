//
//  ChangeBgViewController.m
//  GuessSong
//
//  Created by TrungBQ on 7/19/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "ChangeBgViewController.h"
#import "UIViewController+CWPopup.h"

@interface ChangeBgViewController ()

@property (nonatomic, retain) NSArray *bgArray;

@end

@implementation ChangeBgViewController

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
    
    _bgArray = [NSArray arrayWithObjects:@"background",@"background_1",@"background_3",@"background_4",@"background_5",
                @"background_6",@"background_7",@"background_8",
                @"background_2",@"background_9",@"background_10",@"background_11",@"background_12",@"background_13",@"background_14",
                nil];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bgArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.imageView.image = [UIImage imageNamed:[_bgArray objectAtIndex:indexPath.row]];
    [cell.imageView setFrame:CGRectMake(10, 0, 100, 50)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bgName = [_bgArray objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:bgName forKey:kBackgroundImage];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clicked_done" object:nil];
}

@end
