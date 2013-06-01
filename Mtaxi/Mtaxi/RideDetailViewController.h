//
//  RideDetailViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 28/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"

@interface RideDetailViewController : UITableViewController



@property (strong,nonatomic) Ride *ride;

@property (weak, nonatomic) IBOutlet UITextField *pickUpLocation;
@property (weak, nonatomic) IBOutlet UITextField *dropOffLocation;
@property (weak, nonatomic) IBOutlet UITextField *pickUpDate;
@property (weak, nonatomic) IBOutlet UITextField *driverName;

@property (weak, nonatomic) IBOutlet UITextField *pickUpLocationComplement;
@property (weak, nonatomic) IBOutlet UITextField *messageToTheDriver;

@property (weak, nonatomic) IBOutlet UISlider *rating;


@property (weak, nonatomic) IBOutlet UITextField *comments;

@property (weak, nonatomic) IBOutlet UITextField *status;




@end
