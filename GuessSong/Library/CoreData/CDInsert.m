//
//  CDInsert.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "CDInsert.h"
#import "CDCommon.h"

@implementation CDInsert

#pragma mark - INIT DATA

- (void)setCompletionBlockWithSuccess:(void (^)(CDInsert *operation, id responseObject))_success failure:(void (^)(CDInsert *operation, NSError *error))_failure
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

//data is NSDictionary array
//dictionary sample: NSDictionary* _data = [[NSDictionary alloc] initWithObjectsAndKeys:@"item 1", @"title", @"photo.png", @"photo", nil];
-(id)initWithData:(NSArray*)_data tableName:(NSString*)_tableName context:(NSManagedObjectContext*)_context success:(void (^)(CDInsert *operation, id responseObject))_success
          failure:(void (^)(CDInsert *operation, NSError *error))_failure
{
    self = [super init];
    if (self) {
        context = _context;
        insertData = [_data retain];
        tableName = _tableName;
        
        [self setCompletionBlockWithSuccess:_success failure:_failure];
    }
    
    return self;
}

#pragma mark - MAIN

-(void)main
{
    [context setMergePolicy:NSErrorMergePolicy];
    for (NSDictionary* _item in insertData) {
        NSManagedObject* _insert = (NSManagedObject*)[CDCommon insertEntityName:tableName toManagedObjectContext:context];
        for (NSString* _key in [_item allKeys]) {
            if ([_item objectForKey:_key] != (id)[NSNull null] && [_item objectForKey:_key] != nil) {
                [_insert setValue:[_item objectForKey:_key] forKey:_key];
            }
            else{
                [_insert setValue:@"" forKey:_key];
            }
        }
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
    if (insertData.retainCount > 0) {
        [insertData release];
    }
    
    [super dealloc];
}

@end
