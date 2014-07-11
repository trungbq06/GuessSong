//
//  AFNetworkingImageSingleton.h
//  PSAInspector
//
//  Created by quangdung156 on 10/2/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFNetworkingImageSingleton : AFHTTPClient

+ (AFNetworkingImageSingleton *)sharedClient;

@end
