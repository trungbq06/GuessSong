//
//  CDModel.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

/* ===sample code to run===
  CDModel* _data = [[CDModel alloc] init];
 _data.predicate = [NSPredicate predicateWithFormat:@"(title like %@)", @"*"];
 _data.entityName = @"Items";
 _data.softFieldName = @"title";
 _data.isAscending = YES;
 [_data release];
 */

#import "CDModel.h"

@implementation CDModel

@synthesize predicate = _predicate, entityName = _entityName, softFieldName = _softFieldName, isAscending = _isAscending, limit = _limit, offset = _offset, resultType = _resultType;

-(id)init
{
    self = [super init];
    if (self) {
        _resultType = NSManagedObjectResultType;
    }
    
    return self;
}

-(void)dealloc
{
    if (_predicate.retainCount > 0) {
        [_predicate release];
    }
    if (_entityName.retainCount > 0) {
        [_entityName release];
    }
    if (_softFieldName.retainCount > 0) {
        [_softFieldName release];
    }
    
    [super dealloc];
}

@end
