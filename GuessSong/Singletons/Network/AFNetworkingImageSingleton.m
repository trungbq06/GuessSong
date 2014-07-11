//
//  AFNetworkingImageSingleton.m
//  PSAInspector
//
//  Created by quangdung156 on 10/2/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "AFNetworkingImageSingleton.h"
#import "AFImageRequestOperation.h"

@implementation AFNetworkingImageSingleton

+ (AFNetworkingImageSingleton *)sharedClient
{
    static AFNetworkingImageSingleton *_sharedClientImage = nil;
    static dispatch_once_t onceToken;   //lock
    dispatch_once(&onceToken, ^{        // This code is called at most once per app
        _sharedClientImage = [[AFNetworkingImageSingleton alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedClientImage;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFImageRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"image/jpeg"];
    }
    
    return self;
}

@end
