//
//  PassengerInfoViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 18/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserServerController.h"
#import "CurrentSessionController.h"
#import "CurrentSessionToken.h"
#import "ScreenValidation.h"

@interface PassengerInfoViewController : UITableViewController <UITextFieldDelegate>

//@property (assign, nonatomic) int uid;
//@property (assign, nonatomic) int version;


@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (strong, nonatomic) UIBarButtonItem *signout;

@property (strong, nonatomic) User *latestUserVersion;
@property (strong, nonatomic) User *tempUserVersion;

@property (strong, nonatomic) NSArray *uitextfields;


- (IBAction)signOutPressed:(id)sender;


- (void)retrievePassengerInformation;
- (void)updatePassengerInformation;
- (void) cancelPressed;


@end
