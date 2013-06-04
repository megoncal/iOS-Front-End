//
//  RideDetailViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 28/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"
#import "DateHelper.h"
#import "DateHelper.h"

@interface RideDetailViewController : UITableViewController



@property (strong,nonatomic) Ride *ride;


@property (weak, nonatomic) IBOutlet UITableViewCell *status;


@property (weak, nonatomic) IBOutlet UITableViewCell *from;
@property (weak, nonatomic) IBOutlet UITableViewCell *to;
@property (weak, nonatomic) IBOutlet UITableViewCell *date;
@property (weak, nonatomic) IBOutlet UITableViewCell *driver;
@property (weak, nonatomic) IBOutlet UITableViewCell *pickUpLocationComplement;
@property (weak, nonatomic) IBOutlet UITableViewCell *message;


@property double rating;


@end
