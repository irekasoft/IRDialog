//
//  IRDatePickerView.h
//  IRDialog
//
//  Created by Muhammad Hijazi  on 9/3/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IRDatePickerDelegate;

@interface IRDatePickerView : UIViewController


- (id)initWithSelectedDate:(NSDate *)selectedDate datePickerMode:(UIDatePickerMode)datePickerMode;


@property (assign, nonatomic) id <IRDatePickerDelegate> delegate;

@property (strong, nonatomic) NSDate *selectedDate;

- (void)show;


@end

@protocol IRDatePickerDelegate <NSObject>

@optional

- (void)pickerDoneWithDate:(NSDate *)date;

@end