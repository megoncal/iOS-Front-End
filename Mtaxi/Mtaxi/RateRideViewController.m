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


- (IBAction)savePressed:(id)sender {
    
    
    self.ride.rating = self.rating.value;
    self.ride.comment = self.comment.text;
    
    NSError *error;
    [RideServerController rateRide:self.ride error:&error];
    [Helper showMessage:error];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
