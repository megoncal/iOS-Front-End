//
//  ConfirmRideViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 19/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "ConfirmRideViewController.h"

@interface ConfirmRideViewController ()

@end

@implementation ConfirmRideViewController{
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self populateInitialFields];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void) populateInitialFields{
    
    self.pickUpLocation.detailTextLabel.text = self.ride.pickUpLocation.locationName;
    self.dropOffLocation.detailTextLabel.text = self.ride.dropOffLocation.locationName;
    self.pickUpDate.detailTextLabel.text = [DateHelper descriptionFullFormatOfLocalDateAndTime:self.ride.pickUpDateTime];
    self.carType.detailTextLabel.text = self.ride.carType.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.messageToTheDriver resignFirstResponder];
    [self.pickUpLocationComplement resignFirstResponder];
    
}
- (void)hideKeyboard{
    [self.messageToTheDriver resignFirstResponder];
    [self.pickUpLocationComplement resignFirstResponder];
    
}

- (IBAction)donePressed:(id)sender {
    
    //Make sure the two Ride fields from this screen are populated
    self.ride.pickUpLocationComplement = self.pickUpLocationComplement.text;
    self.ride.messageToTheDriver = self.messageToTheDriver.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Creating your ride...";
    [self hideKeyboard];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSError *error;        
        [RideServerController createRide:self.ride error:&error];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [Helper handleServerReturn:error showMessageOnSuccess:YES viewController:self];
        
//        if (error.code==1) {
//            [Helper showMessage:error];
//        }
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
    });
    
    
}


@end
