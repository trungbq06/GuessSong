//
//  CDInsert.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDInsert : NSOperation
{
    NSManagedObjectContext* context;
    NSArray* insertData;
    NSError* errorMessage;
    NSArray* responseData;
    NSString* tableName;
}

-(id)initWithData:(NSArray*)_data tableName:(NSString*)_tableName context:(NSManagedObjectContext*)_context success:(void (^)(CDInsert *operation, id responseObject))_success
          failure:(void (^)(CDInsert *operation, NSError *error))_failure;

@end
