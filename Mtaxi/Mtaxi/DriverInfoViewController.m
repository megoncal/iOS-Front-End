//
//  DriverInfoViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 18/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "DriverInfoViewController.h"



@interface DriverInfoViewController ()


@property (strong,nonatomic) UIBarButtonItem *cancelLeftBarButton;
@property (strong,nonatomic) UIBarButtonItem *menuLeftBarButton;


@end

@implementation DriverInfoViewController{
    
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
    self.uitextfields = @[self.email,self.firstName,self.lastName,self.phone, self.carDescription, self.taxiStand];

    
}


- (void)viewWillAppear:(BOOL)animated{
    //retrieve logged driver info
    [self retrieveDriverInformation];
    
    
}

#pragma mark - retrieveData
- (IBAction)signOutPressed:(id)sender {
    //    CurrentSession *currentSession = [CurrentSession currentSessionInformation];
    //    [currentSession logoutFromCurrentSession];
    
    //return the authentication navigation controller to the root VC, in this case the LogIn VC.
    [(UINavigationController *)self.tabBarController.presentingViewController popToRootViewControllerAnimated:NO];
    
    //erase the current session information from disk
    [CurrentSessionController resetCurrentSession];
    [self.tabBarController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)retrieveDriverInformation{
    
    [UserServerController retrieveLoggedUserDetails:^(User *user, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 0) {
                
                self.latestUserVersion = user;
                
                [self populateScreenFields:user];
                
                //logged user info is displayed so prepare navigattion bar buttons
                
                //prepare navigation bar button
                self.cancelLeftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
                
                
                //add buttons to the navigation bar
                self.addedNavigationItem.rightBarButtonItem = self.editButtonItem;
                
                
            }else{
                
                [Helper showMessage:error];
            }
            
        });
        
    }];
}

- (void) populateScreenFields: (User *) user{
    self.email.text = user.email;
    self.firstName.text = user.firstName;
    self.lastName.text = user.lastName;
    self.phone.text = user.phone;
    
    //driver
    self.taxiStand.text = user.driver.servedLocation.locationName;
    
    if ([user.driver.activeStatus.code isEqualToString:@"ENABLED"]) {
        self.activeStatus.on = TRUE;
    }else{
        self.activeStatus.on = FALSE;
    }
    
    self.carDescription.text = user.driver.carType.description;
    
}

#pragma mark - updateData

- (void)updateDriverInformation{
    
    if (self.email.text) {
        self.latestUserVersion.email = self.email.text;
    }
    if (self.firstName.text) {
        self.latestUserVersion.firstName = self.firstName.text;
    }
    if( self.lastName.text){
        self.latestUserVersion.lastName = self.lastName.text;
    }
    if(self.phone.text){
        self.latestUserVersion.phone = self.phone.text;
    }
    if (self.car) {
        self.latestUserVersion.driver.carType = self.car;
    }
    if (self.location) {
        self.latestUserVersion.driver.servedLocation = self.location;
    }
    if(self.activeStatus.on)
        self.latestUserVersion.driver.activeStatus.code = @"ENABLED";
    else
        self.latestUserVersion.driver.activeStatus.code = @"DISABLED";
    
    [UserServerController updateLoggedUserDetails:self.latestUserVersion completionHandler:^(User *user, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [Helper showMessage:error];
            if (error.code == 1) {
                self.latestUserVersion = self.tempUserVersion;
                [self populateScreenFields:self.latestUserVersion];
            }
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



#pragma mark - table view delegate

//////set all table rows to a non editable state
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.editing){
        
        if ([tableView cellForRowAtIndexPath:indexPath] == self.carCell) {
            CarTypeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CarTypeList"];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }else if ([tableView cellForRowAtIndexPath:indexPath] == self.servedLocationCell) {
            LocationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Location"];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    }
    
}

#pragma mark - fired actions

// cancel pressed fired method
- (void)cancelPressed{
    cancelPressed = YES;
    self.latestUserVersion = self.tempUserVersion;
    [self populateScreenFields:self.latestUserVersion];
    [self setEditing:NO animated:YES];
}



- (void)setEditing:(BOOL)flag animated:(BOOL)animated{
    
    
    if (flag == YES){
        
        // Change views to edit mode.
        self.firstName.enabled = YES;
        self.lastName.enabled = YES;
        self.phone.enabled = YES;
        self.taxiStand.enabled = YES;
        self.carDescription.enabled = YES;
        self.activeStatus.enabled = YES;
        self.activeStatusLabel.enabled = YES;
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
        self.tempUserVersion = [self.latestUserVersion copy];
        
        self.carCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.servedLocationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //add cancel button to the navigation bar
        self.signOut = self.navigationItem.leftBarButtonItem;
        self.addedNavigationItem.leftBarButtonItem = self.cancelLeftBarButton;
        
        //TODO: add some look n feel into the edit mode screen
        
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
        self.taxiStand.enabled = NO;
        self.carDescription.enabled = NO;
        self.activeStatus.enabled = NO;
        self.activeStatusLabel.enabled = NO;
        
        self.carCell.accessoryType = UITableViewCellAccessoryNone;
        self.servedLocationCell.accessoryType = UITableViewCellAccessoryNone;
        
        [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
        
        if (!cancelPressed) {
            // Save the changes on the server
            [self updateDriverInformation];
        }
        self.addedNavigationItem.leftBarButtonItem = self.signOut;
        cancelPressed = NO;
    }
    
    [super setEditing:flag animated:animated];
    
}

#pragma mark - CarTypeList View Controller delegate methods

- (void)carTypeViewControllerHasDone:(CarTypeViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)carTypeSelected:(CarType *)car AtViewController:(CarTypeViewController *)viewController{
    self.car = car;
    self.carDescription.text = car.description;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - Location View Controller delegate methods

- (void)locationSelected:(Location *)location atViewControler:(LocationViewController *)viewController{
    self.location = location;
    self.taxiStand.text = location.locationName;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationViewControllerCancelled:(LocationViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}



@end