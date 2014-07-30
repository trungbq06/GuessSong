//
//  UserInfo.h
//  GuessSong
//
//  Created by Mr Trung on 7/12/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber   *coins;
@property (nonatomic, retain) NSNumber   *level;
@property (nonatomic, assign) BOOL       sound;
@property (nonatomic, retain) NSString   *quizData;
@property (nonatomic, retain) NSString   *updatedDate;

@end
