//
//  PSAMCommon.m
//  PSAManager
//
//  Created by Thai Nguyen on 9/26/13.
//  Copyright (c) 2013 gulliver. All rights reserved.
//

#import "AppCommon.h"

@implementation AppCommon

#pragma mark - Check Network

static NSString *documentPath = nil;
static NSBundle *bundle = nil;

/*
 get document directory path
 */
+ (NSString *)documentDirectoryPath
{
    if (documentPath == nil){
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [_paths objectAtIndex:0];
    }
    return documentPath;
}

/*
 check network is available
 */
+ (BOOL)isNetworkAvailable
{
    //get value from NSUserDefault
    BOOL _networkAvaiable = [[NSUserDefaults standardUserDefaults] boolForKey:kNetworkAvailable];
    if (!_networkAvaiable) {
        //if network is error, show alert with not connection message
        UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:[AppCommon localizedStringForKey:@"manager"] message:[AppCommon localizedStringForKey:@"not_connection"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[AppCommon localizedStringForKey:@"OK"], nil];
        [_alert show];
        [_alert release];
    }
    return _networkAvaiable;
}

/*
 function check value avoid value is nil or null
 - if nil or null, reset value to @""
 */
+(NSString*)resetNullValueToString:(NSString*)_value
{
    if (_value == (id)[NSNull null] || _value == nil) {
        return @"";
    }
    else{
        
        return [AppCommon filterHTMLReservedCharacters:_value];
    }
}

/*
 replace characters of html
 */
+ (NSString *)filterHTMLReservedCharacters:(NSString *)string
{
	NSString *_newString = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	_newString = [_newString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	_newString = [_newString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	_newString = [_newString stringByReplacingOccurrencesOfString:@"&#37;" withString:@"%"];
    _newString = [_newString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
	return _newString;
}

/*
 calculate ratio
 */
+ (NSString *)getRatio:(NSString *)ok check:(NSString *)check
{
    if([check length] == 0 || [check isEqualToString:@"0"]){
        return @"";
    }
    
    if([ok length] == 0 || [ok isEqualToString:@"0"]){
        return @"0%";
    }
    
    NSInteger _nCheck = [check integerValue];
    NSInteger _nOk = [ok integerValue];
    
    if(_nCheck <= 0) return @"";
    if(_nOk <= 0) return @"0%";
    
    float _fRatio = (float)_nOk / (float)_nCheck * 100.0f;
    
    NSString *_strRatio = [NSString stringWithFormat:@"%0.1f%@", _fRatio, @"%"];
    
    return _strRatio;
}

/*
 remove all subview for view param
 */
+(void)removeAllSubviewForView:(UIView*)_v
{
    for (UIView* _subview in _v.subviews) {
        [AppCommon removeAllSubviewForView:_subview];
        [_subview removeFromSuperview];
    }
}

/*
 add , for number. sample: 1000 to 1,000
 */
+ (NSString*)getNumberFormatWithString:(NSString*)strNumber
{
    //return if number is nil
    if([strNumber length] == 0){
        return strNumber;
    }
    //get number object
    NSNumber *_number = [NSNumber numberWithDouble:[strNumber doubleValue]];
    // NSNumberFormatter
    NSNumberFormatter *_formatter = [[NSNumberFormatter alloc] init];
    NSLocale *_usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [_formatter setLocale:_usLocale];
    [_usLocale release];
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //[formatter setPositiveFormat:@",###"];
    
    NSString *_str = [_formatter stringForObjectValue:_number];
    [_formatter release];
    
    return _str;
}

/*
 disable multiple touch for all subviews
 */
+(void)disableMutiTouchAllSubviewForView:(UIView*)_v
{
    for (UIView* _subview in _v.subviews) {
        [AppCommon disableMutiTouchAllSubviewForView:_subview];
        [_subview setExclusiveTouch:YES];
    }
}

/*
 check column valid or invalid when receive responses from server
 */
+(BOOL)checkValidColumnTableTPurchasesOnServer:(NSString*)_column
{
    NSArray* _columns = [NSArray arrayWithObjects:
                         @"p_date",
                         @"p_no",
                         @"brand",
                         @"model",
                         @"registration_year",
                         @"gear",
                         @"sub_model",
                         @"model_year",
                         @"color",
                         @"brand_of_engine",
                         @"purchaser_plan",
                         @"condition_select",
                         @"manager_id",
                         @"pp",
                         @"mg_comment",
                         @"status",
                         @"updator", nil];
    
    BOOL _result = NO;
    for (NSString* _col in _columns) {
        if ([_column isEqualToString:_col]) {
            _result = YES;
            break;
        }
    }
    
    return _result;
}

#pragma mark - QUEUE MANAGER

/*
 cancel operation with address from operation queue
 */
+(void)cancelOperationAddress:(NSArray*)_address fromQueue:(NSOperationQueue*)_queue
{
    for (NSString* _ad in _address) {
        for (NSOperation* _operation in _queue.operations) {
            NSString* _operAd = [NSString stringWithFormat:@"%p", _operation];
            if ([_ad isEqualToString:_operAd]) {
                [_operation cancel];
            }
        }
    }
}

#pragma mark - NUMBER FORMAT DECIMAL

/*
 get number from decimal format. sample: 1,000 to 1000
 */
+(NSString*)getNumberFormatDecimal:(NSString*)_number
{
    if (_number == (id)[NSNull null] || _number == nil || [_number isEqualToString:@""]) {
        return @"";
    }
    
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [numberFormatter setLocale:usLocale];
    [usLocale release];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    NSNumber* _temp = [numberFormatter numberFromString:_number];
    
    return [numberFormatter stringFromNumber:_temp];
}

/*
 get number of decimal format. sample: 1000 to 1,000
 */
+(NSString*)getStringFromDecimal:(NSString*)_decimal
{
    if (_decimal == (id)[NSNull null] || _decimal == nil || [_decimal isEqualToString:@""]) {
        return @"";
    }
    
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [numberFormatter setLocale:usLocale];
    [usLocale release];
    
    NSNumber* _temp = [numberFormatter numberFromString:_decimal];
    
    return [_temp stringValue];
}

#pragma mark - LANGUAGE

/*
 set language for application
 */
+ (void)setLanguage:(NSString *)language {
    NSString *path = [[ NSBundle mainBundle ] pathForResource:language ofType:@"lproj" ];
    bundle = [[NSBundle bundleWithPath:path] retain];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLanguagechanged object:nil];
}

/*
 get localization from key
 */
+ (NSString *)localizedStringForKey:(NSString *)key
{
    return [bundle localizedStringForKey:key value:nil table:nil];
}

@end
