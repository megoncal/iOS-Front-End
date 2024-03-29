//
//  DriverSignUpViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "DriverSignUpViewController.h"

@interface DriverSignUpViewController ()

@end

@implementation DriverSignUpViewController{
    CGFloat animatedDistance;
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //all uitextfields.
    self.uitextfields = @[self.username, self.password,self.email,self.firstName,self.lastName,self.phone, self.carDescription, self.taxiStand];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    //    self.username.text = @"";
    //    self.password.text = @"";
    //    self.email.text = @"";
    //    self.firstName.text = @"";
    //    self.lastName.text = @"";
    //    self.phoneNumber.text = @"";
    //    self.carType.text = @"";
    //    self.servedMetro.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Configuration

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

#pragma mark - uitextfield delegate methods

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
    
    //email validation
    if (textField == self.email) {
        //UIAlertView *alert;
        NSError *error;
        if (![ScreenValidation validateEmailWithString:textField.text error:&error]){
            [ScreenValidation showScreenValidationError:error];
            self.email.text = @"";
            
        }
    }
    
    
    //keyboard dismiss configuration
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    //accept backspace anytime
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if(textField == self.username){
        
        NSError *error;
        
        if (![ScreenValidation validateUsernameInputString:string error:&error]) {
            [ScreenValidation showScreenValidationError:error];
            return NO;
        }
        
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




#pragma mark - tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if ([self.tableView cellForRowAtIndexPath:indexPath] == self.signUpCell) {
        
        NSError *error;
        //check if the user left empty information
        if ([ScreenValidation checkForEmptyUITextField:self.uitextfields error:&error]) {
            [ScreenValidation showScreenValidationError:error];
            return;
        };
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Signing up...";
        [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            NSError *error;

            ActiveStatus *activeStatus = [[ActiveStatus alloc]init];
            if (self.activeStatus.on) {
                activeStatus = [activeStatus initWithCode:@"ENABLED"];
            }else{
                activeStatus = [activeStatus initWithCode:@"DISABLED"];
            }
            
            Driver *driver = [[Driver alloc] initWithStatus:activeStatus andCarType:self.car andServedLocation: self.taxiStandLocation];
            
            User *user = [[User alloc] initWithUsername:self.username.text andPassword: self.password.text andFirstName: self.firstName.text andLastName: self.lastName.text andPhone: self.phone.text andEmail: self.email.text andDriver: driver andPassenger: nil];
            
            
            BOOL success = [UserServerController signUpUser:user error:&error];
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (success) {
                //save username, password and usertype (encrypted)
                CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
                currentSessionToken.username = self.username.text;
                currentSessionToken.password = self.password.text;
                currentSessionToken.userType = @"PASSENGER";
                [CurrentSessionController writeCurrentSessionToken:currentSessionToken];
                
                UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitDriver" ];
                
                [(UINavigationController *)self.tabBarController.presentingViewController popToRootViewControllerAnimated:NO];
                
                [self presentViewController:controller animated:YES completion:nil];
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [Helper handleServerReturn:error showMessageOnSuccess:NO viewController:self];
            
            
        });
        
    } else if ([self.tableView cellForRowAtIndexPath:indexPath] == self.carCell){
        
        CarTypeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CarTypeList"];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
        
    } else if ([self.tableView cellForRowAtIndexPath:indexPath] == self.taxiStandCell){
        
        
        LocationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Location"];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    
    
}


#pragma mark - implemented protocols

- (void)carTypeViewControllerHasDone:(CarTypeViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)carTypeSelected:(CarType *)car AtViewController:(CarTypeViewController *)viewController{
    self.car = car;
    self.carDescription.text = car.description;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)locationSelected:(Location *)location atViewControler:(LocationViewController *)viewController{
    self.taxiStandLocation = location;
    self.taxiStand.text = location.locationName;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationViewControllerCancelled:(LocationViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end


