//
//  CDModel.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDModel : NSObject

@property (nonatomic, retain) NSPredicate* predicate;
@property (nonatomic, retain) NSString* entityName;
@property (nonatomic, retain) NSString* softFieldName;
@property (nonatomic) BOOL isAscending;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSFetchRequestResultType resultType;

@end
