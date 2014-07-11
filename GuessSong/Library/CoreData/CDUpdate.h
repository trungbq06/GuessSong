//
//  CDUpdate.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDModel;
@class CDCommon;

@interface CDUpdate : NSOperation
{
    NSManagedObjectContext* context;
    CDModel* updateData;
    NSError* errorMessage;
    NSArray* responseData;
    NSDictionary* newData;
}

-(id)initWithData:(CDModel*)_data newData:(NSDictionary*)_newData context:(NSManagedObjectContext*)_context success:(void (^)(CDUpdate *operation, id responseObject))_success
          failure:(void (^)(CDUpdate *operation, NSError *error))_failure;

@end
