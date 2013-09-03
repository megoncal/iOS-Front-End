	//
//  AuthenticationViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//


#import "LogInViewController.h"

@interface LogInViewController ()



@end

@implementation LogInViewController

- (void)viewWillAppear:(BOOL)animated{
//    self.username.text = @"jgoodrider";
//    self.password.text = @"Welcome!1";
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //all uitextfields.
    self.uitextfields = @[self.username, self.password];
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];

}

//hide the keyboard from UITextField every time tableView is touched
- (void)hideKeyboard{
    [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
    }else if (buttonIndex == 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (void) signIn{
    
    NSError *error;
    NSString *returnedUser;
    
    SignInToken *signInToken = [[SignInToken alloc] initWithUsername:self.username.text andPassword:self.password.text];
    
    BOOL success = [UserServerController signIn:signInToken userType:&returnedUser error: &error];
    
    
    if (success) {
        if ([returnedUser isEqualToString:@"PASSENGER"]) {
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitPassenger"];
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitDriver"];
            [self presentViewController:controller animated:YES completion:nil];
            
        }
    }
    
    [Helper handleServerReturn:error showMessageOnSuccess:NO viewController:self];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //SignIn
    if (indexPath.section == 1 &&
        indexPath.row == 0) {
        
        NSError *error;
        //validate empty fields
        if([ScreenValidation checkForEmptyUITextField:self.uitextfields error:&error]){
            [ScreenValidation showScreenValidationError:error];
            return;
        }
        
        
        MBProgressHUD *mbProgressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbProgressHud.labelText = @"Signing in...";
        [ScreenValidation uitextFieldsResignFirstResponder:self.uitextfields];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self signIn];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        });
        
    }
    
    //SignUp - Passager
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    //SignUp - driver
    if (indexPath.section == 2 &&
        indexPath.row == 1) {
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }

    
    //reset password
    if (indexPath.section == 3 &&
        indexPath.row == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;
        alert.title = @"Enter Email";
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Ok"];
        alert.message = @"Please enter the email address for your account.";
        [alert show];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)passengerSignUpViewControllerHasDone:(PassengerSignUpViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)driverSignUpViewControllerHasDone:(DriverSignUpViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"SignUpPassenger"]) {
//        PassengerSignUpViewController *destViewControler = segue.destinationViewController;
//        destViewControler.delegate = self;
//    }else if([segue.identifier isEqualToString:@"SignUpDriver"]){
//        DriverSignUpViewController *destViewControler = segue.destinationViewController;
//        destViewControler.delegate = self;
//    }
//}

@end
