//
//  RateRideViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 13/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "RateRideViewController.h"

@interface RateRideViewController ()

@end

@implementation RateRideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    self.comment.text = @"Insert your comments here...";
    self.comment.textColor = [UIColor lightGrayColor]; //optional
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (IBAction)savePressed:(id)sender {
    
    self.ride.rating = self.rating.value;
    
    if (![self.comment.text isEqualToString:@"Insert your comments here..."]){
         self.ride.comment = self.comment.text;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Rating your ride...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSError *error;
        [RideServerController rateRide:self.ride error:&error];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Helper handleServerReturn:error showMessageOnSuccess:NO viewController:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Insert your comments here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Insert your comments here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)hideKeyboard{
    [self.comment resignFirstResponder];
}


@end
