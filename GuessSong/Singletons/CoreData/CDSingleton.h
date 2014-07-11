//
//  CDSingleton.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDLoad;
@class CDModel;
@class CDDelete;
@class CDInsert;
@class CDUpdate;

@interface CDSingleton : NSObject
{
    NSPersistentStoreCoordinator* _persistentStore;
    NSManagedObjectContext* _context;
}

@property (nonatomic, retain) NSOperationQueue* coreDataOperationQueue;

+(CDSingleton*)sharedCDSingleton;
-(NSString*)loadWithData:(CDModel*)_data success:(void (^)(CDLoad *operation, id responseObject))_success
                 failure:(void (^)(CDLoad *operation, NSError *error))_failure;
-(NSString*)loadWithData:(CDModel*)_data success:(void (^)(CDLoad *operation, id responseObject))_success
                 failure:(void (^)(CDLoad *operation, NSError *error))_failure context:(NSManagedObjectContext*)_context;
-(NSString*)deleteWithData:(CDModel*)_data success:(void (^)(CDDelete *operation, id responseObject))_success
                   failure:(void (^)(CDDelete *operation, NSError *error))_failure;
-(NSString*)insertWithData:(NSArray*)_data tableName:(NSString*)_tableName success:(void (^)(CDInsert *operation, id responseObject))_success
                   failure:(void (^)(CDInsert *operation, NSError *error))_failure;
-(NSString*)insertWithData:(NSArray*)_data tableName:(NSString*)_tableName success:(void (^)(CDInsert *operation, id responseObject))_success
                   failure:(void (^)(CDInsert *operation, NSError *error))_failure context:(NSManagedObjectContext*)_context;
-(NSString*)updateWithData:(CDModel*)_data newData:(NSDictionary*)_newData success:(void (^)(CDUpdate *operation, id responseObject))_success
                   failure:(void (^)(CDUpdate *operation, NSError *error))_failure;
-(NSManagedObjectContext*)getContextSingleton;
-(NSPersistentStoreCoordinator*)getPersistentStore;

@end
