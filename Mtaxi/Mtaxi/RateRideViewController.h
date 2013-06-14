//
//  RateRideViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 13/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"
#import "RideServerController.h"

@interface RateRideViewController : UITableViewController

@property (strong,nonatomic) Ride *ride;

- (IBAction)savePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *rating;
@property (weak, nonatomic) IBOutlet UITextView *comment;

@end
