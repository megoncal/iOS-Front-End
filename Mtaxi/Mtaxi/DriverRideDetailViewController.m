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
    
    if (![self.ride.rideStatus.code isEqual:@"UNASSIGNED"]) {
        self.navigationItem.rightBarButtonItem = NULL;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) populateScreenFields{
    
    self.status.detailTextLabel.text = self.ride.rideStatus.description;
    self.from.detailTextLabel.text = self.ride.pickUpLocation.locationName;
    self.to.detailTextLabel.text = self.ride.dropOffLocation.locationName;
    self.passenger.detailTextLabel.text = self.ride.passenger.firstName;
    self.date.detailTextLabel.text = [DateHelper descriptionFullFormatOfLocalDateAndTime:self.ride.pickUpDateTime];
    self.pickUpLocationComplement.textLabel.text = self.ride.pickUpLocationComplement;
    self.message.textLabel.text = self.ride.messageToTheDriver;
    
//    NSLog(@"HEREEEEE %@",self.ride.messageToTheDriver);
        
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Taking ride...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSError *error;
        [RideServerController assignRide:self.ride error:&error];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Helper showMessage:error];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"PassengerDetail"]){
        PassengerDetailViewController *passengerDetailViewController = segue.destinationViewController;
        passengerDetailViewController.user = self.ride.passenger;
    }
}

@end
