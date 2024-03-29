//
//  SignUpViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "PassengerSignUpViewController.h"

@interface PassengerSignUpViewController ()

@end

@implementation PassengerSignUpViewController{
    
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
    self.uitextfields = @[self.username, self.password,self.email,self.firstName,self.lastName,self.phone];
    
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
    
    for (UITextField *uitextfield in self.uitextfields) {
        uitextfield.text = @"";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Configurationn

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
    
    //SignUp
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        
        NSError * error;
        
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
            
            NSError * error;
            
            Passenger *passenger = [[Passenger alloc] init];
            User *user = [[User alloc] initWithUsername:self.username.text andPassword: self.password.text andFirstName: self.firstName.text andLastName: self.lastName.text andPhone: self.phone.text andEmail: self.email.text andDriver: nil andPassenger: passenger];
            
            BOOL success = [UserServerController signUpUser:user error:&error];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if (success) {
                
                UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitPassenger"];
                [self presentViewController:controller animated:YES completion:nil];
            }

            [Helper handleServerReturn:error showMessageOnSuccess:NO viewController:self];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        });
        
    }
}


@end
