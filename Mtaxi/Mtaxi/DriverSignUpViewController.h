//
//  DriverSignUpViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "User.h"
#import "CarTypeViewController.h"
#import "CarType.h"
#import "LocationViewController.h"
#import "Location.h"
#import "UserServerController.h"
#import "ScreenValidation.h"
#import "MBProgressHUD.h"


//@protocol DriverSignUpViewControllerDelegate;

@interface DriverSignUpViewController : UITableViewController <UITextFieldDelegate,CarTypeViewControllerDelegate, LocationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *carDescription;
@property (weak, nonatomic) IBOutlet UITextField *taxiStand;
@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;


@property (weak, nonatomic) IBOutlet UITableViewCell *signUpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *carCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *taxiStandCell;


@property (strong, nonatomic) Location *taxiStandLocation;
@property (strong,nonatomic) CarType *car;
@property (strong,nonatomic) Radius *radius; //radius served

//@property (nonatomic, assign) id<DriverSignUpViewControllerDelegate>delegate;

@property (strong,nonatomic) NSArray *uitextfields;


@end


//@protocol DriverSignUpViewControllerDelegate <NSObject>
//
//- (void) driverSignUpViewControllerHasDone: (DriverSignUpViewController *) viewController;
//
//@end
