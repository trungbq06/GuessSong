//
//  CDCommon.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDCommon : NSObject

//CREATE MANAGE OBJECT CONTEXT, PERSISTENT STORE COORDINATOR AND MANAGE OBJECT MODEL
+(void)createPersistentStoreCoordinator:(NSPersistentStoreCoordinator**)_persistent withFileStoreName:(NSString*)_fileName;
+(void)createManagedObjectContext:(NSManagedObjectContext**)_context withFileStoreName:(NSString*)_fileName;
+(NSString *)applicationDocumentsDirectory;
+(NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithFileStoreName:(NSString*)_fileName;
//INSERT ENTITY TO MANAGE OBJECT CONTEXT (ON RAM)
+(NSEntityDescription*)insertEntityName:(NSString*)_name toManagedObjectContext:(NSManagedObjectContext*)_context;
//SAVE CHANGE IN FILE STORE
+(BOOL)saveManagedObjectContext:(NSManagedObjectContext*)_context;
//GET ENTITY FROM MANAGED OBJECT CONTEXT
+(NSMutableArray*)getEntityName:(NSString*)_name fromManagedObjectContext:(NSManagedObjectContext*)_context sortFieldName:(NSString*)_field ascending:(BOOL)_ascend predicate:(NSPredicate*)_predicate error:(NSError**)_error resultType:(NSFetchRequestResultType)_type;
+(NSMutableArray*)getEntityName:(NSString*)_name fromManagedObjectContext:(NSManagedObjectContext*)_context sortFieldName:(NSString*)_field ascending:(BOOL)_ascend predicate:(NSPredicate*)_predicate limit:(NSInteger)_limit offset:(NSInteger)_offset error:(NSError**)_error resultType:(NSFetchRequestResultType)_type;

@end
