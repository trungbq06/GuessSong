//
//  CDLoad.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "CDLoad.h"
#import "CDModel.h"
#import "CDCommon.h"

@implementation CDLoad

#pragma mark - INIT DATA

- (void)setCompletionBlockWithSuccess:(void (^)(CDLoad *operation, id responseObject))_success failure:(void (^)(CDLoad *operation, NSError *error))_failure
{
    [self setCompletionBlock:^{
        if (errorMessage) {
            if (_failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _failure(self, errorMessage);
                });
            }
        }
        else{
            if (_success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _success(self, responseData);
                });
            }
        }
        [self setCompletionBlock:nil];
    }];
}

-(id)initWithData:(CDModel*)_data context:(NSManagedObjectContext*)_context success:(void (^)(CDLoad *operation, id responseObject))_success
          failure:(void (^)(CDLoad *operation, NSError *error))_failure
{
    self = [super init];
    if (self) {
        context = _context;
        loadData = [_data retain];
        
        [self setCompletionBlockWithSuccess:_success failure:_failure];
    }
    
    return self;
}

#pragma mark - MAIN

-(void)main
{
    [context setMergePolicy:NSErrorMergePolicy];
    if (responseData.retainCount > 0) {
        [responseData release];
    }
    if(loadData.limit == 0 && loadData.offset == 0){
        responseData = [[CDCommon getEntityName:loadData.entityName fromManagedObjectContext:context sortFieldName:loadData.softFieldName ascending:loadData.isAscending predicate:loadData.predicate error:&errorMessage resultType:loadData.resultType] retain];
    }
    else{
        responseData = [[CDCommon getEntityName:loadData.entityName fromManagedObjectContext:context sortFieldName:loadData.softFieldName ascending:loadData.isAscending predicate:loadData.predicate limit:loadData.limit offset:loadData.offset error:&errorMessage resultType:loadData.resultType] retain];
    }
}

#pragma mark - MEMORY MANAGER

-(void)dealloc
{
    if (loadData.retainCount > 0) {
        [loadData release];
    }
    if (errorMessage.retainCount > 0) {
        [errorMessage release];
    }
    if (responseData.retainCount > 0) {
        [responseData release];
    }
    
    [super dealloc];
}

@end
