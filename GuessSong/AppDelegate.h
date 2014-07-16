//
//  AppDelegate.h
//  GuessSong
//
//  Created by TrungBQ on 7/6/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Pushwoosh/PushNotificationManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FBSession *session;

@end
