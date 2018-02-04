//
//  Define.h
//
//  Created by Muhammad Hijazi Bin Bahaman on 7/20/12.
//  Copyright (c) 2012 Muhammad Hijazi Bin Bahaman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Define : NSObject

// general
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelString;

+ (BOOL) validateEmail: (NSString *) candidate;
+ (NSString *)dataFilePath:(NSString *)filename;
+ (UIImage *)getFromDiskWithFBID:(NSString *)fbid;

+ (NSURL*)urlForImageWithId:(NSString*)imageFilename;

// use this to get the specified string to be changed
+ (NSString *)stringFilteredEmailWithEmail:(NSString *)string;

// Path
+ (NSString *)stringPathForDocument:(NSString *)filename;

// calendar
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

// numbering
+ (NSString *)stringNumberCommaFromNumber:(NSNumber *)number;
+ (NSString *)stringNumberCommaFromInt:(int)number;

@end
