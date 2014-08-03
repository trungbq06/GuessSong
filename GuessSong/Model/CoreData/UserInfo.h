//
//  UserInfo.h
//  GuessSong
//
//  Created by TrungBQ on 8/2/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) id quiz_data;
@property (nonatomic, retain) NSNumber * sound;
@property (nonatomic, retain) NSString * updated_date;
@property (nonatomic, retain) NSNumber * no_ads;

@end
