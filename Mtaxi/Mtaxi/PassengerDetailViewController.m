//
//  PassengerDetailViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 18/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "PassengerDetailViewController.h"

@interface PassengerDetailViewController ()

@end

@implementation PassengerDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self populateScreenFields];
    
}


- (void) populateScreenFields{
    
    self.firstName.detailTextLabel.text = self.user.firstName;
    self.lastName.detailTextLabel.text = self.user.lastName;
    self.phone.detailTextLabel.text = self.user.phone;
    self.email.detailTextLabel.text = self.user.email;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
