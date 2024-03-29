//
//  PassengerSignUpViewController.h
//  
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserServerController.h"
#import "ScreenValidation.h"
#import "MBProgressHUD.h"

//@protocol PassengerSignUpViewControllerDelegate;

@interface PassengerSignUpViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;


//@property (nonatomic, assign) id<PassengerSignUpViewControllerDelegate>delegate;


@property (strong, nonatomic) NSArray *uitextfields;


@end


//@protocol PassengerSignUpViewControllerDelegate <NSObject>

//- (void) passengerSignUpViewControllerHasDone: (PassengerSignUpViewController *) viewController;

//@end