//
//  UserInfo.h
//  GuessSong
//
//  Created by TrungBQ on 7/30/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSDictionary *quiz_data;
@property (nonatomic, retain) NSNumber * sound;
@property (nonatomic, retain) NSDate * updated_date;

@end
