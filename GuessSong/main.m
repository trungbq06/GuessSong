//
//  main.m
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"vn", @"en", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize]; //to make the change immediate
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
