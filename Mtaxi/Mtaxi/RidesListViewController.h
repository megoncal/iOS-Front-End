//
//  RidesListViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 19/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateRideViewController.h"

@interface RidesListViewController : UITableViewController


@property (strong,nonatomic) NSMutableArray *rides;
//sectioned rides
//every array position has a nsdictionary with key as date and an array of ride as value
@property (strong, nonatomic) NSMutableArray *sectionedRides;

- (IBAction)addRidePressed:(id)sender;

@end
