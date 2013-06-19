//
//  DriverInfoViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 23/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CarTypeViewController.h"
#import "LocationViewController.h"
#import "CarType.h"
#import "Location.h"
#import "UserServerController.h"

@interface DriverInfoViewController : UITableViewController <UITextFieldDelegate, CarTypeViewControllerDelegate,LocationViewControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *addedNavigationItem;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *carDescription;
@property (weak, nonatomic) IBOutlet UITextField *servedLocation;


@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;

@property (weak, nonatomic) IBOutlet UITableViewCell *carCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *servedLocationCell;

@property (strong, nonatomic) User *user;

@property (strong, nonatomic)   CarType *car;
@property (strong, nonatomic)   Location *location;

- (IBAction)signOutPressed:(id)sender;

- (void)retrieveDriverInformation;
- (void) cancelPressed;



@end
