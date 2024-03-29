//
//  RideDetailViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 28/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "RideDetailViewController.h"

@interface RideDetailViewController ()

@end

@implementation RideDetailViewController{
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    

    [self populateScreenFields];

    [self enableRideActions];

    
}

- (void) populateScreenFields{
 
    self.status.detailTextLabel.text = self.ride.rideStatus.description;
    self.from.detailTextLabel.text = self.ride.pickUpLocation.locationName;
    self.to.detailTextLabel.text = self.ride.dropOffLocation.locationName;
    self.driver.detailTextLabel.text = self.ride.driver.firstName;
    self.date.detailTextLabel.text = [DateHelper descriptionFullFormatOfLocalDateAndTime:self.ride.pickUpDateTime];
    self.pickUpLocationComplement.textLabel.text = self.ride.pickUpLocationComplement;
    self.message.textLabel.text = self.ride.messageToTheDriver;

}


- (void) enableRideActions{
    if([self.ride.rideStatus.code isEqual:@"COMPLETED"]){
        self.navigationItem.rightBarButtonItem = NULL;
    }else if ([self.ride.rideStatus.code isEqual:@"UNASSIGNED"]){
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
        self.navigationItem.rightBarButtonItem = cancelButton;
    }
}

- (void) cancelPressed{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Canceling your ride...";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSError *error;
        
        [RideServerController cancelRide:self.ride error:&error];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [Helper handleServerReturn:error showMessageOnSuccess:YES viewController:self];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
    
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
    [self.message resignFirstResponder];
    
}
- (void)hideKeyboard{
    [self.message resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"RateRide"]) {
        RateRideViewController *viewController = (RateRideViewController *) segue.destinationViewController;
        viewController.ride = self.ride;
    }else if([segue.identifier isEqualToString:@"DriverDetail"]){
        DriverDetailViewController *driverDetailViewController = segue.destinationViewController;
        driverDetailViewController.user = self.ride.driver;
    }
}


 

@end
