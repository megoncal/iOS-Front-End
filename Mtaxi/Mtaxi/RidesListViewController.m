
//
//  RidesListViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 19/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

//#define retrieveAllRidesURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/retrievePassengerRides"]
#define retrieveAllRidesURL [NSURL URLWithString:@"http://localhost:8080/moovt/ride/retrievePassengerRides"]


#import "RidesListViewController.h"

@interface RidesListViewController ()

@end

@implementation RidesListViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    self.sectionedRides = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *sectionsDictionary = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *ridesForSection;
    
    
    for (Ride *ride in self.rides) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        
        NSString *date = [dateFormatter stringFromDate:ride.pickUpDateTime];
      
        
        ridesForSection = [sectionsDictionary objectForKey:date];
        if (ridesForSection == nil) {
            ridesForSection = [[NSMutableArray alloc]init];
            [ridesForSection addObject:ride];
            [sectionsDictionary setObject:ridesForSection forKey:date];
                        
        }else{
            [ridesForSection addObject:ride];
        }
    }
    
    NSArray *sectionedRidesTemp = [sectionsDictionary allKeys];
    //populate the sectionedRides;
    for (NSString *date in sectionedRidesTemp) {
        NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc]init];
        [tempDictionary setValue:[sectionsDictionary objectForKey:date] forKey:date];
        [self.sectionedRides addObject:tempDictionary];
    }
    
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // create the parent view that will hold header Label
//	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 44.0)];
//	
//	// create the button object
//	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//	headerLabel.backgroundColor = [UIColor clearColor];
//	headerLabel.opaque = NO;
//	headerLabel.textColor = [UIColor blackColor];
//	headerLabel.highlightedTextColor = [UIColor whiteColor];
//	headerLabel.font = [UIFont boldSystemFontOfSize:15];
//	headerLabel.frame = CGRectMake(0.0, 0.0, 300.0, 44.0);
//    headerLabel.textAlignment = NSTextAlignmentRight;
//    
//	// If you want to align the header text as centered
//	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//    
//    NSDictionary *ridesDictionary = [self.sectionedRides objectAtIndex:section];
//    NSString *sectionHeaderText = [[ridesDictionary allKeys] objectAtIndex:0];
//    
//	headerLabel.text = sectionHeaderText; // i.e. array element
//	[customView addSubview:headerLabel];
//    
//	return customView;
//}


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
    UITextField *status = (UITextField *)[cell viewWithTag:103];
    
    
    Ride *ride = [self retrieveRideFrom:self.sectionedRides atPosition:indexPath];
    
    from.text = ride.pickUpLocation.locationName;
    to.text = ride.dropOffLocation.locationName;
    status.text = ride.rideStatus.description;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    time.text = [dateFormatter stringFromDate:ride.pickUpDateTime];
    
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


#pragma mark - Integration with Server

- (void) retrievePassengerRides{
    
    
    [RideServerController retrievePassengerRides:^(NSMutableArray *rides, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
    
             if (error.code == 0) {
                 self.rides = rides;
                 
                 [self.rides sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                     
                     NSDate *date1 = [(Ride *)obj1 pickUpDateTime];
                     NSDate *date2 = [(Ride *)obj2 pickUpDateTime];
                     
                     NSComparisonResult result = [date2 compare:date1];
                     
                     return result;
                 }];
                 
                 [self.tableView reloadData];
             }else{
                 [Helper showMessage:error];
             }

         });

    }];
 
}


#pragma mark retrieve ride from sectioned rides using indexPath

-  (Ride *)retrieveRideFrom: (NSArray *)sectionedRides atPosition:(NSIndexPath *)indexPath{
   
    NSDictionary *ridesDictionary = [sectionedRides objectAtIndex:indexPath.section];
    
    NSArray *ridesArray = [[ridesDictionary allValues] objectAtIndex:0];
    
    return [ridesArray objectAtIndex:indexPath.row];
}

@end
