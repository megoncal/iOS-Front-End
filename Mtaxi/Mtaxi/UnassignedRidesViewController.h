//
//  AvailableRidesViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 16/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RideServerController.h"
#import "DateHelper.h"

@interface UnassignedRidesViewController : UITableViewController


@property (strong, nonatomic) NSMutableArray *unassignedRides;

@end
