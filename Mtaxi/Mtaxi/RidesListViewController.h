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

- (IBAction)addRidePressed:(id)sender;

@end
