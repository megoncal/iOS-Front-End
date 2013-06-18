//
//  DriverRideDetailViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 17/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"
#import "DateHelper.h"
#import "RideServerController.h"

@interface DriverRideDetailViewController : UITableViewController


@property (strong,nonatomic) Ride *ride;





@property (weak, nonatomic) IBOutlet UITableViewCell *from;
@property (weak, nonatomic) IBOutlet UITableViewCell *to;
@property (weak, nonatomic) IBOutlet UITableViewCell *date;
@property (weak, nonatomic) IBOutlet UITableViewCell *passenger;
@property (weak, nonatomic) IBOutlet UITableViewCell *pickUpLocationComplement;
@property (weak, nonatomic) IBOutlet UITableViewCell *message;

- (IBAction)takePressed:(id)sender;

@end
