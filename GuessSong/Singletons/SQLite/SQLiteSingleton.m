//
//  SQLiteSingleton.m
//  PSAInspector
//
//  Created by Thai Nguyen on 9/11/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "SQLiteSingleton.h"
#import "AppCommon.h"
#import "FMDatabase.h"

@interface SQLiteSingleton()
@property (retain, nonatomic) FMDatabase *db;
@end


@implementation SQLiteSingleton

static SQLiteSingleton* sharedInstance = nil;

+ (SQLiteSingleton *)sharedSingleton
{
    sharedInstance = [[SQLiteSingleton alloc] initWithDBFile:@"psa.db"];
    return sharedInstance;
}

#pragma mark - INIT

- (id)initWithDBFile:(NSString *)dbFile
{
    self = [super init];
    if ( self){
        NSFileManager *_fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *_dbPath = [NSString stringWithFormat:@"%@/%@", [AppCommon documentDirectoryPath], dbFile];
        if (![_fileManager fileExistsAtPath:_dbPath]) {
            NSString *_tempPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFile];
            
            if (![_fileManager copyItemAtPath:_tempPath toPath:_dbPath error:&error]){
                NSLog(@"Error copy file:%@", error);
            }
        }
        
        self.db = [FMDatabase databaseWithPath:_dbPath];
    }
    
    return self;
}

@end
