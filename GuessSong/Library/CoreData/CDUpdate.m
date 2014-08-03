//
//  CDUpdate.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "CDUpdate.h"
#import "CDModel.h"
#import "CDCommon.h"

@implementation CDUpdate

#pragma mark - INIT DATA

- (void)setCompletionBlockWithSuccess:(void (^)(CDUpdate *operation, id responseObject))_success failure:(void (^)(CDUpdate *operation, NSError *error))_failure
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

-(id)initWithData:(CDModel*)_data newData:(NSDictionary*)_newData context:(NSManagedObjectContext*)_context success:(void (^)(CDUpdate *operation, id responseObject))_success
          failure:(void (^)(CDUpdate *operation, NSError *error))_failure
{
    self = [super init];
    if (self) {
        context = _context;
        updateData = [_data retain];
        newData = [_newData retain];
        
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
    responseData = [[CDCommon getEntityName:updateData.entityName fromManagedObjectContext:context sortFieldName:updateData.softFieldName ascending:updateData.isAscending predicate:updateData.predicate error:&errorMessage resultType:updateData.resultType] retain];
    for (NSManagedObject* _object in responseData) {
        for (NSString* _key in newData.allKeys) {
            NSString* _value = [newData objectForKey:_key];
            if (_value != (id)[NSNull null] && _value != nil) {
                [_object setValue:_value forKey:_key];
            }
            else{
                [_object setValue:@"" forKey:_key];
            }
        }
    }
    [context save:&errorMessage];
//    DLog_Low(@"load data: %@", responseData);
}

#pragma mark - MEMORY MANAGER

-(void)dealloc
{
    if (newData.retainCount > 0) {
        [newData release];
    }
    if (updateData.retainCount > 0) {
        [updateData release];
    }
//    if (errorMessage.retainCount > 0) {
//        [errorMessage release];
//    }
    if (responseData.retainCount > 0) {
        [responseData release];
    }
    
    [super dealloc];
}

@end
