//
//  PassengerInfoViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 18/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "PassengerInfoViewController.h"


@interface PassengerInfoViewController ()


@property (strong,nonatomic) UIBarButtonItem *cancelLeftBarButton;
@property (strong,nonatomic) UIBarButtonItem *menuLeftBarButton;


@end

@implementation PassengerInfoViewController{
    
    CGFloat animatedDistance;
    BOOL cancelPressed;
    
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //all uitextfields.
    self.uitextfields = @[self.email,self.firstName,self.lastName,self.phone];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [self retrievePassengerInformation];
}

- (void)populateScreenFields:(User *)user {
    self.email.text = user.email;
    self.firstName.text = user.firstName;
    self.lastName.text = user.lastName;
    self.phone.text = user.phone;
}

- (User *) createUserFromUI {
    
    User *user = [[User alloc] initWithUid:self.user.uid
                                andVersion:self.user.version
                              andFirstName:self.firstName.text
                               andLastName:self.lastName.text
                                  andPhone:self.phone.text
                                  andEmail:self.email.text];
    return user;
}

- (IBAction)signOutPressed:(id)sender {
    
    [CurrentSessionController resetCurrentSession];

    [(UINavigationController *)self.tabBarController.presentingViewController popToRootViewControllerAnimated:NO];
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)retrievePassengerInformation{
    
    
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbProgressHUD.labelText = @"Retrieving my info...";
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
    [UserServerController retrieveLoggedUserDetails:^(User *userFromServer, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error.code == 0) {
                self.user = userFromServer;
                [self populateScreenFields:userFromServer];
                
                //logged user info is displayed so prepare navigattion bar buttons
                //prepare navigation bar button
                self.cancelLeftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
                
                //add buttons to the navigation bar
                self.navigationItem.rightBarButtonItem = self.editButtonItem;
                
            }else{
                [Helper showMessage:error];
            }
            
        });
        
    }];
}


- (void)updatePassengerInformation{
    
    
    //No need to update if nothing changed
    if ([self.user.firstName isEqualToString:self.firstName.text] &&
        [self.user.lastName isEqualToString:self.lastName.text] &&
        [self.user.phone isEqualToString:self.phone.text] ) {
        return;
    }
    
    User *userFromUI = [self createUserFromUI];
    
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbProgressHUD.labelText = @"Updating my info...";
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
    [UserServerController updateLoggedUserDetails:userFromUI completionHandler:^(User *userFromServer, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error.code == 0) {
                self.user = userFromServer;
                [self populateScreenFields:userFromServer];
            }
            [Helper showMessage:error];
            
        });
    }];
}



#pragma mark - configure textField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
}
- (void)hideKeyboard{
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    //accept backspace anytime
    if ([string isEqualToString:@""]) {
        return YES;
    }
    else if (textField == self.firstName){
        
        NSError *error;
        if (![ScreenValidation validateNameInputString:string error:&error]) {
            [ScreenValidation showScreenValidationError:error];
            return NO;
        }
        
    }
    
    else if (textField == self.lastName){
        
        NSError *error;
        if (![ScreenValidation validateNameInputString:string error:&error]) {
            [ScreenValidation showScreenValidationError:error];
            return NO;
        }
        
    }
    
    else if (textField == self.phone){
        
        NSString *phoneNumberText = textField.text;
        
        if ([ScreenValidation maskedPhoneNumber:&phoneNumberText withRange:range]) {
            textField.text = phoneNumberText;
        }else{
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - configure table view

//////set all table rows to a non editable state
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


#pragma mark - fired actions

// cancel pressed fired method
- (void)cancelPressed{
    cancelPressed = YES;
    [self populateScreenFields:self.user];
    [self setEditing:NO animated:YES];
}


- (void)setEditing:(BOOL)flag animated:(BOOL)animated{
    
    if (flag == YES){
        
        // Change views to edit mode.
        self.firstName.enabled = YES;
        self.lastName.enabled = YES;
        self.phone.enabled = YES;
        
        //add cancel button to the navigation bar
        self.signout = self.navigationItem.leftBarButtonItem;
        self.navigationItem.leftBarButtonItem = self.cancelLeftBarButton;
        
        //to-do
        //add some look n feel into the edit mode screen
        
    }
    else {
        
        NSError *error;
        if ([ScreenValidation checkForEmptyUITextField:self.uitextfields error:&error]) {
            [ScreenValidation showScreenValidationError:error];
            return;
        }
        
        self.firstName.enabled = NO;
        self.lastName.enabled = NO;
        self.phone.enabled = NO;
        
        [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
        
        if (!cancelPressed) {
            [self updatePassengerInformation];
        }
        
        self.navigationItem.leftBarButtonItem = self.signout;
        cancelPressed = NO;
    }
    
    [super setEditing:flag animated:animated];
}


@end
