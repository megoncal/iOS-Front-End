//
//  DriverRideDetailViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 17/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "DriverRideDetailViewController.h"

@interface DriverRideDetailViewController ()

@end

@implementation DriverRideDetailViewController


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
    
    self.from.detailTextLabel.text = self.ride.pickUpLocation.locationName;
    self.to.detailTextLabel.text = self.ride.dropOffLocation.locationName;
    self.passenger.detailTextLabel.text = self.ride.passenger.firstName;
    self.date.detailTextLabel.text = [DateHelper descriptionFullFormatOfLocalDateAndTime:self.ride.pickUpDateTime];
 
    self.pickUpLocationComplement.detailTextLabel.text = self.ride.pickUpLocationComplement;
    self.message.detailTextLabel.text = self.ride.messageToTheDriver;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   

    
}

- (IBAction)takePressed:(id)sender {
    
    NSError *error;
    
    [RideServerController assignRide:self.ride error:&error];
    
    [Helper showMessage:error];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
