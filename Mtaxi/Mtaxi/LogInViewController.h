//
//  AuthenticationViewController.h
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserServerController.h"
#import "SignInToken.h"
#import "PassengerSignUpViewController.h"
#import "DriverSignUpViewController.h"



@interface LogInViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end


