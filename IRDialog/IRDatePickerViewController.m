//
//  IRDatePickerView.m
//  IRDialog
//
//  Created by Muhammad Hijazi  on 9/3/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "IRDatePickerViewController.h"

@interface IRDatePickerViewController () {
    
    UIButton *overlayButton;
    
    
}

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar* toolBar;
@property (assign, nonatomic) UIDatePickerMode datePickerMode;

@end

@implementation IRDatePickerViewController

static float durationAnimation=0.3f;

- (id)initWithSelectedDate:(NSDate *)selectedDate datePickerMode:(UIDatePickerMode)datePickerMode{
    
    if (self = [super init]) {
        
        self.selectedDate = selectedDate;
        self.datePickerMode = datePickerMode;
    }
    return self;
}

- (void)show{
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = self.datePickerMode;
    
    if (self.selectedDate) {
        self.datePicker.date = self.selectedDate;
    }
    

    [self.view addSubview:self.datePicker];
    
    
    [self createToolbar];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    
    
    /** Animation */
    
    CGFloat winHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.datePicker.frame = CGRectMake(0, winHeight, 320, 216.0);
	
	//animate picker view
	self.datePicker.hidden  = NO;
    self.toolBar.hidden     = NO;
    
	[UIView animateWithDuration:durationAnimation animations:^(void){
        
		CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -216);
		self.datePicker.transform = transform;
        self.toolBar.transform= CGAffineTransformMakeTranslation(0, -216-50);
        
	}completion:^(BOOL finished){
        
	}];
    
	//animate overlaybutton
    
	overlayButton.hidden = NO;
    [UIView animateWithDuration:durationAnimation animations:^(void){
		overlayButton.alpha = 0.5;
        
	} completion:^(BOOL finished){
        
	}];
    
    [super becomeFirstResponder];
	
    
}

- (void) createToolbar {

	
	CGRect windowBounds = [[UIScreen mainScreen] bounds];
	
    
	self.datePicker.frame =CGRectMake(0, windowBounds.size.height,
                                      windowBounds.size.width, 216);
    
    
    overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    overlayButton.backgroundColor = [UIColor blackColor];
    overlayButton.frame = windowBounds;
    [overlayButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    overlayButton.alpha     =0.0;
    overlayButton.hidden    =YES;
    
    
    [self.view addSubview:overlayButton];
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.tintColor = [UIColor darkGrayColor];
    self.toolBar.translucent = YES;
    
    self.toolBar.hidden=YES;
    [self.toolBar sizeToFit];
    
    CGRect rect = self.datePicker.frame;
    rect.size.height = 50;
    self.toolBar.frame = rect;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerDoneClicked:)] ;
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(hide)] ;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolBar setItems:[NSArray arrayWithObjects:cancel, flexibleSpace,doneButton, nil]];
    
    [self.view addSubview:self.toolBar];
    [self.view bringSubviewToFront:self.datePicker];
    
    
}

#pragma mark Action

-(void) pickerDoneClicked:(UIBarButtonItem*) sender{
    
    
    if([self.delegate respondsToSelector:@selector(pickerDoneWithDate:)]){
        

        
        [self.delegate pickerDoneWithDate:self.datePicker.date];
        [self hide];
        
    }
    
}

- (void)hide {
    
	[UIView animateWithDuration:durationAnimation animations:^(void){
        
        
		self.datePicker.transform = CGAffineTransformMakeTranslation(0, 264);
        self.toolBar.transform=  CGAffineTransformMakeTranslation(0, 264+50);
        
	}completion:^(BOOL finished){
		[self.view removeFromSuperview];
	}];
	
	//animate overlaybutton
	[UIView animateWithDuration:durationAnimation animations:^(void){
		overlayButton.alpha = 0.0;
	}completion:^(BOOL finished){
		overlayButton.hidden=YES;
        
	}];
    
    
	
}

@end
