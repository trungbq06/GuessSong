//
//  CDDelete.h
//  PSAInspector
//
//  Created by quangdung156 on 9/9/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDModel;

@interface CDDelete : NSOperation
{
    NSManagedObjectContext* context;
    CDModel* deleteData;
    NSError* errorMessage;
    NSArray* responseData;
}

-(id)initWithData:(CDModel*)_data context:(NSManagedObjectContext*)_context success:(void (^)(CDDelete *operation, id responseObject))_success
          failure:(void (^)(CDDelete *operation, NSError *error))_failure;

@end
