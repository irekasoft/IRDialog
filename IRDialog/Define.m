//
//  Define.m
//
//  Created by Muhammad Hijazi Bin Bahaman on 7/20/12.
//  Copyright (c) 2012 Muhammad Hijazi Bin Bahaman. All rights reserved.
//

#import "Define.h"

@implementation Define

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    NSLog(@"validate %d",[emailTest evaluateWithObject:candidate]);
    return [emailTest evaluateWithObject:candidate];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelString{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelString otherButtonTitles:nil];
    [alert show];

    
}

+ (NSString *)dataFilePath:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:filename];
    
}


+ (NSString *)stringFilteredEmailWithEmail:(NSString *)string{
    

    NSString *result = [string stringByReplacingOccurrencesOfString:@"@" withString:@" [at] "];
    
    return result;
    
}

#pragma mark -  File System
#pragma mark ===============

+ (NSString *)stringPathForDocument:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:filename];
    
}

#pragma mark - Calendar

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

#pragma mark - numbering

+ (NSString *)stringNumberCommaFromNumber:(NSNumber *)number{
    
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setGroupingSize:3];
	[numberFormatter setGroupingSeparator:@","];
	[numberFormatter setUsesGroupingSeparator:YES];
	
	NSString *commaString = [numberFormatter stringFromNumber:number];
	
	return commaString;
}

+ (NSString *)stringNumberCommaFromInt:(int)number{
    
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init] ;
	[numberFormatter setGroupingSize:3];
	[numberFormatter setGroupingSeparator:@","];
	[numberFormatter setUsesGroupingSeparator:YES];
	
	NSString *commaString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:number]];

	return commaString;
}

@end
