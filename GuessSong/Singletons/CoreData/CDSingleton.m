//
//  CDSingleton.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "CDSingleton.h"
#import "CDCommon.h"
#import "CDLoad.h"
#import "CDDelete.h"
#import "CDInsert.h"
#import "CDUpdate.h"

static CDSingleton* sharedCD = nil;

@implementation CDSingleton

@synthesize coreDataOperationQueue = _coreDataOperationQueue;

+(CDSingleton*)sharedCDSingleton
{
    static dispatch_once_t _coreDataDispatch;   //lock
    dispatch_once(&_coreDataDispatch, ^{        // This code is called at most once per app
        sharedCD = [[CDSingleton alloc] initWithFileStore:@"guess_song.sqlite"];
    });
    
    return sharedCD;
}

#pragma mark - INIT

- (id)initWithFileStore:(NSString*)_fileStore
{
    self = [super init];
    if ( self){
        //operation queue
        _coreDataOperationQueue = [[NSOperationQueue alloc] init];
        [_coreDataOperationQueue setMaxConcurrentOperationCount:1];
        //persistent store
        [CDCommon createPersistentStoreCoordinator:&_persistentStore withFileStoreName:_fileStore];
        //context
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:_persistentStore];
        [_context setMergePolicy:NSErrorMergePolicy];
        [_context setPropagatesDeletesAtEndOfEvent:YES];
        [_context setRetainsRegisteredObjects:NO];
    }
    
    return self;
}

#pragma mark - ACCESS DATA

-(NSString*)loadWithData:(CDModel*)_data success:(void (^)(CDLoad *operation, id responseObject))_success
                 failure:(void (^)(CDLoad *operation, NSError *error))_failure
{
    CDLoad* _load = [[CDLoad alloc] initWithData:_data context:_context success:_success failure:_failure];
    [_coreDataOperationQueue addOperation:_load];
    NSString *address = [NSString stringWithFormat:@"%p", _load];
    [_load release];
    
    return address;
}

-(NSString*)loadWithData:(CDModel*)_data success:(void (^)(CDLoad *operation, id responseObject))_success
failure:(void (^)(CDLoad *operation, NSError *error))_failure context:(NSManagedObjectContext*)context
{
    CDLoad* _load = [[CDLoad alloc] initWithData:_data context:context success:_success failure:_failure];
    [_coreDataOperationQueue addOperation:_load];
    NSString *address = [NSString stringWithFormat:@"%p", _load];
    [_load release];
    
    return address;
}

-(NSString*)deleteWithData:(CDModel*)_data success:(void (^)(CDDelete *operation, id responseObject))_success
                 failure:(void (^)(CDDelete *operation, NSError *error))_failure
{
    CDDelete* _delete = [[CDDelete alloc] initWithData:_data context:_context success:_success failure:_failure];
    [_coreDataOperationQueue addOperation:_delete];
    NSString *address = [NSString stringWithFormat:@"%p", _delete];
    [_delete release];
    
    return address;
}

-(NSString*)insertWithData:(NSArray*)_data tableName:(NSString*)_tableName success:(void (^)(CDInsert *operation, id responseObject))_success
                   failure:(void (^)(CDInsert *operation, NSError *error))_failure
{
    CDInsert* _insert = [[CDInsert alloc] initWithData:_data tableName:_tableName context:_context success:_success failure:_failure];
    [_coreDataOperationQueue addOperation:_insert];
    NSString *address = [NSString stringWithFormat:@"%p", _insert];
    [_insert release];
    
    return address;
}

-(NSString*)insertWithData:(NSArray*)_data tableName:(NSString*)_tableName success:(void (^)(CDInsert *operation, id responseObject))_success
failure:(void (^)(CDInsert *operation, NSError *error))_failure context:(NSManagedObjectContext*)context
{
    CDInsert* _insert = [[CDInsert alloc] initWithData:_data tableName:_tableName context:context success:_success failure:_failure];
    [_coreDataOperationQueue addOperation:_insert];
    NSString *address = [NSString stringWithFormat:@"%p", _insert];
    [_insert release];
    
    return address;
}

-(NSString*)updateWithData:(CDModel*)_data newData:(NSDictionary*)_newData success:(void (^)(CDUpdate *operation, id responseObject))_success
                   failure:(void (^)(CDUpdate *operation, NSError *error))_failure
{
    CDUpdate* _update = [[CDUpdate alloc] initWithData:_data newData:_newData context:_context success:_success failure:_failure];
    [_coreDataOperationQueue addOperation:_update];
    NSString *address = [NSString stringWithFormat:@"%p", _update];
    [_update release];
    
    return address;
}

-(NSManagedObjectContext*)getContextSingleton
{
    return _context;
}

-(NSPersistentStoreCoordinator*)getPersistentStore
{
    return _persistentStore;
}

#pragma mark - MEMORY MANAGER

- (void)dealloc
{
    if (_context.retainCount > 0) {
        [_context release];
    }
    if (_persistentStore.retainCount > 0) {
        [_persistentStore release];
    }
    if (_coreDataOperationQueue.retainCount > 0) {
        [_coreDataOperationQueue release];
    }
    
    [super dealloc];
}

@end
