//
//  CreateRideViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "CreateRideViewController.h"

@interface CreateRideViewController ()

@end

@implementation CreateRideViewController{
    UITableViewCell *selectedCell;
}


- (Ride *) ride{
    if (_ride == nil) {
        _ride = [[Ride alloc]init];
    }
    return _ride;
}


- (void)viewDidLoad
{
    [super viewDidLoad];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ( selectedCell == self.pickUpLocation ||
         selectedCell == self.dropOffLocation) {
        
        LocationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Location"];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else if (selectedCell == self.carType){
        CarTypeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CarTypeList"];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    
}


#pragma mark - implemented protocols

- (void)carTypeViewControllerHasDone:(CarTypeViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)carTypeSelected:(CarType *)car AtViewController:(CarTypeViewController *)viewController{
    self.ride.carType = car;
    self.carType.detailTextLabel.text = car.description;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)locationSelected:(Location *)location atViewControler:(LocationViewController *)viewController{
   
    //do something
    if (selectedCell == self.pickUpLocation){
        
        self.ride.pickUpLocation = location;
        self.pickUpLocation.detailTextLabel.text = location.locationName;
        
    }else if (selectedCell == self.dropOffLocation){
        self.ride.dropOffLocation = location;
        self.dropOffLocation.detailTextLabel.text = location.locationName;
    }
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationViewControllerCancelled:(LocationViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


   
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"RideConfirmation"]){
        
        self.ride.pickUpDateTime = self.datePicker.date;
        
        ConfirmRideViewController *confirmRideViewController = segue.destinationViewController;
        
        confirmRideViewController.ride = self.ride;
    }
}



- (IBAction)cancelPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
}




@end
