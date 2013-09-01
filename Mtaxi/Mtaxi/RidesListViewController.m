
//
//  RidesListViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 19/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#define retrieveAllRidesURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/retrievePassengerRides"]
//#define retrieveAllRidesURL [NSURL URLWithString:@"http://localhost:8080/moovt/ride/retrievePassengerRides"]
//#define retrieveAllRidesURL [NSURL URLWithString:@"http://10.0.0.13:8080/moovt/ride/retrievePassengerRides"]

#import "RidesListViewController.h"

@interface RidesListViewController ()

@end

@implementation RidesListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listOfStatusCode = [[NSArray alloc] initWithObjects:@"UNASSIGNED", @"ASSIGNED", @"COMPLETED", @"CANCELED", nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing rides..."];
    
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(removeRide:) name:@"removeRide" object: nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    [self retrievePassengerRides];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return self.sectionedRides.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *ridesDictionary = [self.sectionedRides objectAtIndex:section];
    // Return the number of rows in the section.
    return [[[ridesDictionary allValues] objectAtIndex:0] count];;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSDictionary *ridesDictionary = [self.sectionedRides objectAtIndex:section];
    
    NSString *sectionHeader = [[ridesDictionary allKeys] objectAtIndex:0];
    
    return sectionHeader;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UITextField *from = (UITextField *)[cell viewWithTag:100];
    UITextField *to = (UITextField *)[cell viewWithTag:101];
    UITextField *time = (UITextField *)[cell viewWithTag:102];
    UITextField *date = (UITextField *)[cell viewWithTag:103];
    
    
    Ride *ride = [self retrieveRideFrom:self.sectionedRides atPosition:indexPath];
    
    from.text = ride.pickUpLocation.locationName;
    to.text = ride.dropOffLocation.locationName;
    time.text = [DateHelper descriptionTime:ride.pickUpDateTime];
    date.text = [DateHelper descriptionDate:ride.pickUpDateTime];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //instantiate the navigationController
    RideDetailViewController *rideDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RideDetailView"];
    rideDetailViewController.ride = [self retrieveRideFrom:self.sectionedRides atPosition:indexPath];
    [self.navigationController pushViewController:rideDetailViewController animated:YES];
}


- (IBAction)addRidePressed:(id)sender {
    
    //instantiate the navigationController
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRideNavigationController"];
    
    //present the navigationController
    [self presentViewController:navigationController animated:YES completion:nil];
    
    
}


- (void) splitRidesInSections{
    
    self.sectionedRides = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *sectionsDictionary = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *ridesForSection;
    
    for (Ride *ride in self.rides) {
        
        NSString *statusCode = ride.rideStatus.code;
        
        ridesForSection = [sectionsDictionary objectForKey:statusCode];
        
        if (ridesForSection == nil) {
            
            ridesForSection = [[NSMutableArray alloc]init];
            
            [ridesForSection addObject:ride];
            
            [sectionsDictionary setObject:ridesForSection forKey:statusCode];
            
        }else{
            [ridesForSection addObject:ride];
        }
    }
    
    
    for (NSString *statusCode in self.listOfStatusCode) {
        
        
        NSArray *sectionArray = [sectionsDictionary objectForKey:statusCode];
        
        if (sectionArray) {
            
            sectionArray = [sectionArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSDate *date1 = [(Ride *)obj1 pickUpDateTime];
                NSDate *date2 = [(Ride *) obj2 pickUpDateTime];
                return [date1 compare:date2];
                
            }];
            
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            
            NSString *tempKey = [(Ride *)[sectionArray objectAtIndex:0] rideStatus].description;
            
            NSMutableArray *sectionMutableArray = [sectionArray mutableCopy];
            
            [tempDictionary setObject:sectionMutableArray forKey:tempKey];
            
            [self.sectionedRides addObject:tempDictionary];
        }
        
    }
}

#pragma mark retrieve ride from sectioned rides using indexPath

-  (Ride *)retrieveRideFrom: (NSArray *)sectionedRides atPosition:(NSIndexPath *)indexPath{
    
    NSDictionary *ridesDictionary = [sectionedRides objectAtIndex:indexPath.section];
    
    NSArray *ridesArray = [[ridesDictionary allValues] objectAtIndex:0];
    
    return [ridesArray objectAtIndex:indexPath.row];
}

//-  (void)removeRide: (NSNotification *)notification{
//
//    NSDictionary *dictionary = [notification userInfo];
//
//    NSIndexPath *indexPath = [dictionary objectForKey:@"indexpath"];
//
//    NSDictionary *ridesDictionary = [self.sectionedRides objectAtIndex:indexPath.section];
//
//    NSMutableArray *sectionRides = [[ridesDictionary allValues] objectAtIndex:0];
//
//    [sectionRides removeObjectAtIndex:indexPath.row];
//}

#pragma mark - Integration with Server

- (void) retrievePassengerRides{
    
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbProgressHUD.labelText = @"Loading rides...";
    [RideServerController retrievePassengerRides:^(NSMutableArray *rides, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error.code == 0) {
                self.rides = rides;
                [self splitRidesInSections];
                [self.tableView reloadData];
            }
            
            [Helper handleServerReturn:error showMessageOnSuccess:NO viewController:self];
            
            
            
        });
        
    }];
    
}

- (void)refreshTableView{
    [RideServerController retrievePassengerRides:^(NSMutableArray *rides, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            if (error.code == 0) {
                self.rides = rides;
                [self splitRidesInSections];
                [self.tableView reloadData];
            }
            [Helper handleServerReturn:error showMessageOnSuccess:NO viewController:self];
        });
        
    }];
}



@end
