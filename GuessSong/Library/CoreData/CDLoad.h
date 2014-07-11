//
//  CDLoad.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDModel;

@interface CDLoad : NSOperation
{
    NSManagedObjectContext* context;
    CDModel* loadData;
    NSError* errorMessage;
    NSArray* responseData;
}

-(id)initWithData:(CDModel*)_data context:(NSManagedObjectContext*)_context success:(void (^)(CDLoad *operation, id responseObject))_success
          failure:(void (^)(CDLoad *operation, NSError *error))_failure;

@end
