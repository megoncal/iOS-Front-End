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
    self.ride.comment = self.comment.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Rating your ride...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSError *error;
        [RideServerController rateRide:self.ride error:&error];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Helper showMessage:error];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
    
    
}


@end
