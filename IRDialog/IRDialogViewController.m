//
//  IRDialogViewController.m
//  IRDialog
//
//  Created by Muhammad Hijazi  on 7/3/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "Define.h"
#import <QuartzCore/QuartzCore.h>

#import "IRDialogViewController.h"
#import "IRPickerView.h"
#import "IRDatePickerView.h"

@interface IRDialogViewController () <IRPickerViewDelegate, IRDatePickerDelegate> {
    
    BOOL isKeyboardShowed;
    
    UITableViewCell *currentCell;
    
    CGRect normalTableViewFrame;
    CGRect keyboardRect;
    
    UIToolbar *toolbar;
    
    BOOL keyboardVisible;
    int currentTextFieldTag;
    int currentPickerRow;
    int currentIndexForPicker;
    int currentIndexForDatePicker;
    
    NSDate *birthdate;
    
}

/**
 * the table view cell is not consistently show the data so we have to save in this array
 */
@property (strong, nonatomic) NSMutableArray *dataInRows; // of string
@property (strong, nonatomic) IRPickerView      *picker;
@property (strong, nonatomic) IRDatePickerView  *datePicker;
@end

@implementation IRDialogViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sections = @[@"Personal Information",
                      @"Company Info",
                      @"Other  Info"];
    
    self.rows = @[
                     @[@[@"First Name"  ,@"text"],
                       @[@"Last Name"   ,@"text"],
                       @[@"Address"     ,@"text"],
                       @[@"City"        ,@"text"],
                       @[@"Birthdate"   ,@"picker-date"],
                       @[@"State"       ,@"picker-state"],
                       @[@"Email"       ,@"text-email"],
                       @[@"Phone No."   ,@"text-number"]],
                    
                     @[@[@"Name"        ,@"text"],
                       @[@"Address"     ,@"text"]],
                     
                     @[@[@"Name",       @"text"],
                       @[@"Address"     ,@"text"]],
                     
                     ];


    self.dataInRows = [NSMutableArray array];
    
        
    for (int i = 0; i < [self.rows count]; i++) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int j = 0; j <[self.rows[i] count]; j++) {

            [array addObject:[NSNull null]];

        }
        [self.dataInRows addObject:array];

    }
    
    [self addNotifications];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    

}





- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.tableView endEditing:YES];
     
}


#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR] 

#pragma mark -

- (UIToolbar *) accessoryView
{
    
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEdit)];
    
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
	toolbar.tintColor = [UIColor darkGrayColor];
	toolbar.translucent = YES;
    
    
    
	NSMutableArray *items = [NSMutableArray array];
	
	[items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[items addObject:doneButtonItem];
	toolbar.items = items;

	return toolbar;
}

- (void)doneEdit{
    
    [self.tableView endEditing:YES];
    
}

#pragma mark Actions

- (void)action{
    
    NSLog(@"action");
    BOOL hasEmpty = NO;
    
    NSLog(@"%@",self.dataInRows);

    
    for (int i = 0; i < [self.rows count]; i++) {
    
        
        for (int j = 0; j <[self.rows[i] count]; j++) {


            if ([self.dataInRows[i][j] isKindOfClass:[NSNull class]] ||
                [self.dataInRows[i][j] isEqualToString:@""]) {
                hasEmpty = YES;
            }
        }
        
        
    }
    
    if (hasEmpty) {
        
        [Define showAlertViewWithTitle:@"Error" message:@"Please enter all the forms" cancelButtonTitle:@"OK"];
        
    }else{
        
        [Define showAlertViewWithTitle:@"Good" message:@"Form are completed." cancelButtonTitle:@"OK"];
        
    }
}

#pragma mark notifications

- (void)addNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)removeNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Keyboard notifications



- (void) resizeForKeyboard:(NSNotification*)aNotification {

    
    BOOL up = aNotification.name == UIKeyboardWillShowNotification;
    
    if (keyboardVisible == up)
        return;
    
    keyboardVisible = up;
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationOptions animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
                     animations:^{
                         CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
                         const UIEdgeInsets oldInset = self.tableView.contentInset;
                         self.tableView.contentInset = UIEdgeInsetsMake(oldInset.top, oldInset.left,  up ? keyboardFrame.size.height : 0, oldInset.right);
                         self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
                     }
                     completion:^(BOOL finished) {
                         
                         NSIndexPath *indexPath = [IRDialogViewController indexPathFromTag:currentTextFieldTag];
                         [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 35;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section < [self.sections count] -1 ) {
        return nil;
    }
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(50, 30, 230, 50);
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    
    [customView addSubview:button];

    return customView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section < [self.sections count] -1) {
        return 10;
    }else {
        return 120; // set for footer button
    }
    

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.rows[indexPath.section][indexPath.row][1] isEqualToString:@"picker-state"]){
        
        NSLog(@"open picker");
        currentPickerRow = [IRDialogViewController tagFromIndexPath:indexPath];

        
        self.picker = [[IRPickerView alloc]
                                initWithOptions:@[@"Selangor",@"Sabah",@"Pulau Pinang"]
                                withSelectedIndex:currentIndexForPicker];
        self.picker.delegate = self;
        [self.tableView endEditing:YES];
        [self.picker show];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if ([self.rows[indexPath.section][indexPath.row][1] isEqualToString:@"picker-date"]){

        currentIndexForDatePicker = [IRDialogViewController tagFromIndexPath:indexPath];
        self.datePicker = [[IRDatePickerView alloc] initWithSelectedDate:birthdate datePickerMode:UIDatePickerModeDate];
        self.datePicker.delegate = self;
        [self.tableView endEditing:YES];
        [self.datePicker show];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

#pragma mark Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.sections count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sections[section];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.rows[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;

    CellIdentifier = self.rows[indexPath.section][indexPath.row][0];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    

    CGFloat yOffset = -5;
    
    // images
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellTextLabel.png"]];
    imageView.frame = CGRectMake(0, 0, 110, 34);
    [cell.contentView addSubview:imageView];
    
    // add label
    CGFloat labelWidth =  cell.frame.size.width * 0.40;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, yOffset, labelWidth, cell.frame.size.height)];
    label.text = [self.rows[indexPath.section][indexPath.row][0] uppercaseString];
    label.font = [UIFont fontWithName:@"Gill Sans" size:13];
    label.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:label];
    
    // Add a UITextField
    
    CGFloat xOffset =  cell.frame.size.width * 0.35;
    CGFloat width =  cell.frame.size.width * 0.60;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(xOffset, yOffset, width, cell.frame.size.height)];
    textField.font = [UIFont fontWithName:@"Gill Sans" size:13];
    textField.tag = [IRDialogViewController tagFromIndexPath:indexPath];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if ([self.dataInRows[indexPath.section][indexPath.row] isKindOfClass:[NSString class]]){

        textField.text = self.dataInRows[indexPath.section][indexPath.row];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([self.rows[indexPath.section][indexPath.row][1] isEqualToString:@"text"]) {

        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;

        
    } else if ([self.rows[indexPath.section][indexPath.row][1] isEqualToString:@"text-number"]){
        textField.keyboardType = UIKeyboardTypePhonePad;
        
    } else if ([self.rows[indexPath.section][indexPath.row][1] isEqualToString:@"text-email"]){
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
    }else {
        
        textField.userInteractionEnabled = NO;
    }

    textField.delegate = self;
    textField.inputAccessoryView = [self accessoryView];
    
    if (indexPath.row == [self.rows count] - 1) {
        
        textField.returnKeyType = UIReturnKeyDone;
        
    }else{
        
        textField.returnKeyType = UIReturnKeyNext;
    }

    [cell.contentView addSubview:textField];    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)  {
        
        // Create the path (with only the top-left corner rounded)
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.contentView.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft
                                                             cornerRadii:CGSizeMake(9.1, 9.1)];
        
        // Create the shape layer and set its path
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        
        // Set the newly created shape layer as the mask for the image view's layer
        cell.contentView.layer.mask = maskLayer;

        
    }else if (indexPath.row == [self.rows[indexPath.section] count] - 1){
        
        
        // Create the path (with only the top-left corner rounded)
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.contentView.bounds
                                                       byRoundingCorners:UIRectCornerBottomLeft
                                                             cornerRadii:CGSizeMake(9.1, 9.1)];
        
        // Create the shape layer and set its path
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = cell.contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        
        // Set the newly created shape layer as the mask for the image view's layer
        cell.contentView.layer.mask = maskLayer;
        
    }
    
}



#pragma mark Delegate Text Field

- (void) textFieldDidBeginEditing:(UITextField *)textField {

    
    currentTextFieldTag = textField.tag;
    
    NSIndexPath *indexPath = [IRDialogViewController indexPathFromTag:currentTextFieldTag];
    
    if (keyboardVisible == YES) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    
    NSInteger nextTag = textField.tag + 1;
   
    // Try to find next responder
    UIResponder* nextResponder = [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextTag inSection:0]].contentView viewWithTag:nextTag];
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSIndexPath *indexPath = [IRDialogViewController indexPathFromTag:textField.tag];
    
    [self.dataInRows[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:textField.text];
    
}

#pragma mark IRPicker view delegate

- (void) pickerDoneClicked:(NSString *)name forIndex:(int)index{
    currentIndexForPicker= index;
    
    NSIndexPath *indexPath = [IRDialogViewController indexPathFromTag:currentPickerRow];
    
    [self.dataInRows[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:name];
    [self.tableView reloadData];
}

- (void)pickerDoneWithDate:(NSDate *)date{
    
    birthdate = date;
    
    NSIndexPath *indexPath = [IRDialogViewController indexPathFromTag:currentIndexForDatePicker];
    
    [self.dataInRows[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[IRDialogViewController stringFromDate:birthdate withFormat:@"dd-MM-yyyy"]];
    [self.tableView reloadData];
    
   
}

#pragma mark -


- (void)viewDidUnload{
    
    [super viewDidUnload];
    [self removeNotifications];
    
}

#pragma mark Helper

+ (NSString *)stringFromDate:(NSDate*)date withFormat:(NSString*)dateFormat{
    
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setLocale:locale];
	[format setDateFormat:dateFormat];
    
    // get time
    return [NSString stringWithFormat:@"%@",
            [format stringFromDate:date]];
    
}


+ (int)tagFromIndexPath:(NSIndexPath *)indexPath{
    
    return 1000 * indexPath.section + indexPath.row;
    
}

+ (NSIndexPath *)indexPathFromTag:(int)tag{

    NSIndexPath *indexPath = nil;
    int section = tag / 1000;
    int row = tag - (section * 1000);
    indexPath = [NSIndexPath indexPathForRow:row inSection:section];

    return indexPath;
}

@end
