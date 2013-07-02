//
//  CreateRideViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"
#import "LocationViewController.h"
#import "CarType.h"
#import "CarTypeViewController.h"
#import "ConfirmRideViewController.h"




@interface CreateRideViewController : UITableViewController <LocationViewControllerDelegate, CarTypeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *pickUpLocation;

@property (weak, nonatomic) IBOutlet UITableViewCell *dropOffLocation;

@property (weak, nonatomic) IBOutlet UITableViewCell *carType;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) Ride *ride;


- (IBAction)cancelPressed:(id)sender;




@end


