//
//  PSAMCommon.h
//  PSAManager
//
//  Created by Thai Nguyen on 9/26/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCommon : NSObject

/*
 get document directory path
 */
+(NSString *)documentDirectoryPath;
/*
 check network is available
 */
+(BOOL)isNetworkAvailable;
/*
 function check value avoid value is nil or null
 - if nil or null, reset value to @""
 */
+(NSString*)resetNullValueToString:(NSString*)_value;
/*
 calculate ratio
 */
+(NSString *)getRatio:(NSString *)ok check:(NSString *)check;
/*
 remove all subview for view param
 */
+(void)removeAllSubviewForView:(UIView*)_v;
/*
 add , for number. sample: 1000 to 1,000
 */
+(NSString*)getNumberFormatWithString:(NSString*)strNumber;
/*
 disable multiple touch for all subviews
 */
+(void)disableMutiTouchAllSubviewForView:(UIView*)_v;
/*
 check column valid or invalid when receive responses from server
 */
+(BOOL)checkValidColumnTableTPurchasesOnServer:(NSString*)_column;
/*
 cancel operation with address from operation queue
 */
+(void)cancelOperationAddress:(NSArray*)_address fromQueue:(NSOperationQueue*)_queue;
/*
 get number from decimal format. sample: 1,000 to 1000
 */
+(NSString*)getNumberFormatDecimal:(NSString*)_number;
/*
 get number of decimal format. sample: 1000 to 1,000
 */
+(NSString*)getStringFromDecimal:(NSString*)_decimal;
/*
 set language for application
 */
+(void)setLanguage:(NSString *)language;
/*
 get localization from key
 */
+(NSString *)localizedStringForKey:(NSString *)key;
/*
 convert from status code and open id to string
 */
+(NSString*)getStatusStringFromCode:(int)_code openId:(NSString*)_openId;
/*
 convert string to damaged type
 */
+(NSInteger)convertStringToDamagedType:(NSString *)str;
/*
 convert damage code to full name
 */
+(NSString*)getTypeFullNameWithCode:(NSInteger)code;
/*
 color code
 */
+(UIColor*)redColor;
+(UIColor*)darkGrayColor;
+(UIColor*)lightGrayColor;

@end
