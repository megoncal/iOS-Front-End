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

@interface PassengerInfoViewController : UITableViewController <UITextFieldDelegate>

@property (strong,nonatomic) User *user;


@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;





- (void)retrievePassengerInformation;
- (void)updatePassengerInformation;
- (void) cancelPressed;


@end
