//
//  AFNetworkingSingleton.m
//  GWS-BS
//
//  Created by quangdung156 on 8/27/13.
//  Copyright (c) 2013 Gulliver. All rights reserved.
//

#import "AFNetworkingSingleton.h"
#import "AFJSONRequestOperation.h"

@implementation AFNetworkingSingleton

+ (AFNetworkingSingleton *)sharedClient
{
    static AFNetworkingSingleton *_sharedClient = nil;
    static dispatch_once_t onceToken;   //lock
    dispatch_once(&onceToken, ^{        // This code is called at most once per app
        _sharedClient = [[AFNetworkingSingleton alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

@end
