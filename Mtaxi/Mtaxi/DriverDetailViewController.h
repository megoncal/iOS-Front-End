//
//  DriverDetailViewController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 18/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"



@interface DriverDetailViewController : UITableViewController


@property (strong,nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstName;
@property (weak, nonatomic) IBOutlet UITableViewCell *lastName;
@property (weak, nonatomic) IBOutlet UITableViewCell *phone;
@property (weak, nonatomic) IBOutlet UITableViewCell *email;
@property (weak, nonatomic) IBOutlet UITableViewCell *carType;
@property (weak, nonatomic) IBOutlet UITableViewCell *taxiStand;
@property (weak, nonatomic) IBOutlet UITableViewCell *activeStatus;

@end
