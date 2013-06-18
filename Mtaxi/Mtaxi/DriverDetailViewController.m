//
//  DriverDetailViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 18/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "DriverDetailViewController.h"

@interface DriverDetailViewController ()

@end

@implementation DriverDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) populateScreenFields{
    
    self.firstName.detailTextLabel.text = self.user.firstName;
    self.lastName.detailTextLabel.text = self.user.lastName;
    self.phone.detailTextLabel.text = self.user.phone;
    self.email.detailTextLabel.text = self.user.email;
    
    self.carType.detailTextLabel.text = self.user.driver.carType.description;
    self.taxiStand.detailTextLabel.text = self.user.driver.servedLocation.locationName;
    self.activeStatus.detailTextLabel.text = self.user.driver.activeStatus.description;
    
}



@end
