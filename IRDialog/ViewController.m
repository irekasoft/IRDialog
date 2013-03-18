//
//  ViewController.m
//  IRDialog
//
//  Created by Muhammad Hijazi  on 7/3/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "ViewController.h"
#import "IRDialogViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self openDialog:nil];    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (IBAction)openDialog:(id)sender {
    
    IRDialogViewController *dialogVC = [[IRDialogViewController alloc] initWithNibName:@"IRDialogViewController" bundle:nil];
    
    [self presentViewController:dialogVC animated:YES completion:nil];
    
}


@end
