//
//  AFNetworkingSingleton.h
//  GWS-BS
//
//  Created by quangdung156 on 8/27/13.
//  Copyright (c) 2013 Gulliver. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFNetworkingSingleton : AFHTTPClient

+ (AFNetworkingSingleton *)sharedClient;

@end
