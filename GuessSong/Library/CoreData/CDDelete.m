//
//  CDDelete.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "CDDelete.h"
#import "CDModel.h"
#import "CDCommon.h"

@implementation CDDelete

#pragma mark - INIT DATA

- (void)setCompletionBlockWithSuccess:(void (^)(CDDelete *operation, id responseObject))_success failure:(void (^)(CDDelete *operation, NSError *error))_failure
{
    [self setCompletionBlock:^{
        if (errorMessage) {
            if (_failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _failure(self, errorMessage);
                });
            }
        }
        else {
            if (_success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _success(self, responseData);
                });
            }
        }
        [self setCompletionBlock:nil];
    }];
}

-(id)initWithData:(CDModel*)_data context:(NSManagedObjectContext*)_context success:(void (^)(CDDelete *operation, id responseObject))_success
          failure:(void (^)(CDDelete *operation, NSError *error))_failure
{
    self = [super init];
    if (self) {
        context = _context;
        deleteData = [_data retain];
        
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
    responseData = [[CDCommon getEntityName:deleteData.entityName fromManagedObjectContext:context sortFieldName:deleteData.softFieldName ascending:deleteData.isAscending predicate:deleteData.predicate error:&errorMessage resultType:deleteData.resultType] retain];
    for (NSManagedObject* _item in responseData) {
        [context deleteObject:_item];
    }
    [context save:&errorMessage];
}

#pragma mark - MEMORY MANAGER

-(void)dealloc
{
    if (responseData.retainCount > 0) {
        [responseData release];
    }
    if (errorMessage.retainCount > 0) {
        [errorMessage release];
    }
    if (deleteData.retainCount > 0) {
        [deleteData release];
    }
    
    [super dealloc];
}

@end
