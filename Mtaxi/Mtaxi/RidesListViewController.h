//
//  RidesListViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 19/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateRideViewController.h"
#import "RideDetailViewController.h"
#import "RideServerController.h"
#import "DateHelper.h"
#import "MBProgressHUD.h"

@interface RidesListViewController : UITableViewController


@property (strong,nonatomic) NSMutableArray *rides;
//sectioned rides
//every array position has a nsdictionary with key as date and an array of ride as value
@property (strong, nonatomic) NSMutableArray *sectionedRides;

@property (strong,nonatomic) NSArray *listOfStatusCode;

- (IBAction)addRidePressed:(id)sender;



@end
