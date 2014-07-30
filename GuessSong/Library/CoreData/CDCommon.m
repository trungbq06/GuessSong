//
//  CDCommon.m
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "CDCommon.h"

@implementation CDCommon

#pragma mark - CREATE MANAGE OBJECT CONTEXT, PERSISTENT STORE COORDINATOR AND MANAGE OBJECT MODEL

+(NSString *)applicationDocumentsDirectory
{
    //return document directory root
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+(NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithFileStoreName:(NSString*)_fileName
{
    //check file exist into document directory
    //if not exist: copy file from bundle to document
	NSString *storePath = [[CDCommon applicationDocumentsDirectory] stringByAppendingPathComponent:_fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	//create url for persistent store coordinator
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	//create managed object model
    NSManagedObjectModel* _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    //option for persistient
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    //create persistent store coordinator
	NSError *error;
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel] autorelease];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        
		DLog_Med(@"Unresolved error: %@", [error userInfo]);
        return nil;
    }
    
    return persistentStoreCoordinator;
}

+(void)createPersistentStoreCoordinator:(NSPersistentStoreCoordinator**)_persistent withFileStoreName:(NSString*)_fileName
{
    //check file exist into document directory
    //if not exist: copy file from bundle to document
	NSString *storePath = [[CDCommon applicationDocumentsDirectory] stringByAppendingPathComponent:_fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	//create url for persistent store coordinator
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	//create managed object model
    NSManagedObjectModel* _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    //option for persistient
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    //create persistent store coordinator
	NSError *error;
    if ([(*_persistent) retainCount] > 0) {
        [(*_persistent) release];
    }
    (*_persistent) = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    if (![(*_persistent) addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        
		DLog_Med(@"Unresolved error: %@", [error userInfo]);
    }
}

+(void)createManagedObjectContext:(NSManagedObjectContext**)_context withFileStoreName:(NSString*)_fileName
{
    if (_fileName == (id)[NSNull null]) {
        DLog_Med(@"file name is nsnull");
        return;
    }
    
    //dealloc managed object context
    if ((*_context).retainCount > 0) {
        [(*_context) setPersistentStoreCoordinator:nil];
        [(*_context) release];
    }
    
    NSPersistentStoreCoordinator* _coordinator = [CDCommon persistentStoreCoordinatorWithFileStoreName:_fileName];
    if (_coordinator != nil) {
        (*_context) = [NSManagedObjectContext new];
        [(*_context) setPersistentStoreCoordinator:_coordinator];
    }
    
    DLog_Med(@"create managed object context success");
}

#pragma mark - INSERT ENTITY TO MANAGE OBJECT CONTEXT (ON RAM)

+(NSEntityDescription*)insertEntityName:(NSString*)_name toManagedObjectContext:(NSManagedObjectContext*)_context
{
    [_context lock];
    if (_context == (id)[NSNull null] || _context == nil) {
        DLog_Med(@"context nil");
        return nil;
    }
    
    NSEntityDescription* _entity = [NSEntityDescription insertNewObjectForEntityForName:_name inManagedObjectContext:_context];
    [_context unlock];
    
    return _entity;
}

#pragma mark - SAVE CHANGE IN FILE STORE

+(BOOL)saveManagedObjectContext:(NSManagedObjectContext*)_context
{
    [_context lock];
    //return if context null
    if (_context == (id)[NSNull null] || _context == nil) {
        DLog_Med(@"context nil");
        return NO;
    }
    
    NSError *error = nil;
    if (![_context save:&error]) {
        // Handle the error.
        DLog_Med(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    [_context unlock];
    return YES;
}

#pragma mark - GET ENTITY FROM MANAGED OBJECT CONTEXT
//get object with limit and offset
+(NSMutableArray*)getEntityName:(NSString*)_name fromManagedObjectContext:(NSManagedObjectContext*)_context sortFieldName:(NSString*)_field ascending:(BOOL)_ascend predicate:(NSPredicate*)_predicate limit:(NSInteger)_limit offset:(NSInteger)_offset error:(NSError**)_error resultType:(NSFetchRequestResultType)_type
{
    [_context lock];
    //return if context null
    if (_context == (id)[NSNull null] || _context == nil) {
        DLog_Med(@"context nil");
        return nil;
    }
    
    //create fetch request with entity descripti
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    [request setResultType:_type];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_name inManagedObjectContext:_context];
    [request setEntity:entity];
    //sort with field if field validate
    if (_field != (id)[NSNull null] && _field != nil && ![_field isEqualToString:@""]) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_field ascending:_ascend];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
    }
    //predicate for request
    //    NSPredicate* _predicate = [NSPredicate predicateWithFormat:@"(name like %@)AND(pass like %@)", @"*", @"*"];
    if (_predicate != (id)[NSNull null] && _predicate != nil) {
        [request setPredicate:_predicate];
    }
    
    [request setFetchLimit:_limit];
    [request setFetchOffset:_offset];
    
    @try {
        //execute request
        NSMutableArray *mutableFetchResults = [NSMutableArray arrayWithArray:[_context executeFetchRequest:request error:&(*_error)]];
        
        if (mutableFetchResults == nil) {
            // Handle the error.
            [request release];
            
            return nil;
        }
        else{
            //release request object
            [request release];
            [_context unlock];
            
            return mutableFetchResults;
        }
    }
    @catch (NSException *exc) {
        //release request object
        [request release];
        [_context unlock];
        
        return nil;
    }
}

+(NSMutableArray*)getEntityName:(NSString*)_name fromManagedObjectContext:(NSManagedObjectContext*)_context sortFieldName:(NSString*)_field ascending:(BOOL)_ascend predicate:(NSPredicate*)_predicate error:(NSError**)_error  resultType:(NSFetchRequestResultType)_type
{
    [_context lock];
    //return if context null
    if (_context == (id)[NSNull null] || _context == nil) {
        DLog_Med(@"context nil");
        return nil;
    }
    
    //create fetch request with entity description
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    [request setResultType:_type];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_name inManagedObjectContext:_context];
    [request setEntity:entity];
    //sort with field if field validate
    if (_field != (id)[NSNull null] && _field != nil && ![_field isEqualToString:@""]) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_field ascending:_ascend];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
    }
    //predicate for request
    //    NSPredicate* _predicate = [NSPredicate predicateWithFormat:@"(name like %@)AND(pass like %@)", @"*", @"*"];
    if (_predicate != (id)[NSNull null] && _predicate != nil) {
        [request setPredicate:_predicate];
    }
    
    @try {
        //execute request
        NSMutableArray *mutableFetchResults = [NSMutableArray arrayWithArray:[_context executeFetchRequest:request error:&(*_error)]];
        if (mutableFetchResults == nil) {
            // Handle the error.
            [request release];
            
            return nil;
        }
        else{
            //release request object
            [request release];
            
            [_context unlock];
            return mutableFetchResults;
        }
    }
    @catch (NSException *exception) {
        //release request object
        [request release];
        
        [_context unlock];
        return nil;
    }
}

@end
