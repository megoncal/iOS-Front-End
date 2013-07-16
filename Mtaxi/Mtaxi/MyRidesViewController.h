//
//  MyRidesViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 15/07/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RideServerController.h"
#import "DateHelper.h"
#import "DriverRideDetailViewController.h"
#import "MBProgressHUD.h"

@interface MyRidesViewController : UITableViewController


@property (strong, nonatomic) NSMutableArray *myRides;


@end
