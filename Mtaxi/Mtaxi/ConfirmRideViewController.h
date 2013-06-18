//
//  ConfirmRideViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 19/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"
#import "DateHelper.h"
#import "RideServerController.h"



@interface ConfirmRideViewController : UITableViewController

@property (strong,nonatomic) Ride *ride;



@property (weak, nonatomic) IBOutlet UITableViewCell *pickUpLocation;
@property (weak, nonatomic) IBOutlet UITableViewCell *dropOffLocation;
@property (weak, nonatomic) IBOutlet UITableViewCell *pickUpDate;
@property (weak, nonatomic) IBOutlet UITableViewCell *carType;
@property (weak, nonatomic) IBOutlet UITextField *pickUpLocationComplement;
@property (weak, nonatomic) IBOutlet UITextField *messageToTheDriver;




@end

