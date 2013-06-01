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

}

- (void)viewWillAppear:(BOOL)animated{
    self.username.text = @"";
    self.password.text = @"";
    self.email.text = @"";
    self.firstName.text = @"";
    self.lastName.text = @"";
    self.phoneNumber.text = @"";
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
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
}
- (void)hideKeyboard{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
}


- (IBAction)cancelPressed:(id)sender {
    [[self delegate] passengerSignUpViewControllerHasDone:self];
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
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


#pragma mark - tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SignUp
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        NSError * error;
        
        Passenger *passenger = [[Passenger alloc] init];
        User *user = [[User alloc] initWithUsername:self.username.text andPassword: self.password.text andFirstName: self.firstName.text andLastName: self.lastName.text andPhone: self.phoneNumber.text andEmail: self.email.text andDriver: nil andPassenger: passenger];
        
        BOOL success = [UserServerController signUpUser:user error:&error];
        
        if (!success) {
            [Helper showMessage:error];
        } else {
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitPassenger"];
            [self presentViewController:controller animated:YES completion:nil];
        }
     
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}


@end
