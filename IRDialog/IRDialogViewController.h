//
//  IRDialogViewController.h
//  IRDialog
//
//  Created by Muhammad Hijazi  on 7/3/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRDialogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *sections; // of string
@property (strong, nonatomic) NSArray *rowTitles; // of string
@property (strong, nonatomic) NSArray *rowTypes; // of string




@end
