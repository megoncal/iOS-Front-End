//
//  AvailableRidesViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 16/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "UnassignedRidesViewController.h"

@interface UnassignedRidesViewController ()

@end

@implementation UnassignedRidesViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [self retrieveUnassignedRidesInServedArea];
}

#pragma mark - Integration with Server
- (void)retrieveUnassignedRidesInServedArea{
    
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbProgressHUD.labelText = @"Loading rides...";
    [RideServerController retrieveUnassignedRidesInServedArea:^(NSMutableArray *rides, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error.code == 0) {
                
                NSArray *sorteArray = [rides sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    
                    NSDate *date1 = [(Ride *)obj1 pickUpDateTime];
                    NSDate *date2 = [(Ride *) obj2 pickUpDateTime];
                    return [date1 compare:date2];
                    
                    
                }];
                
                self.unassignedRides =  [sorteArray mutableCopy];
                
                [self.tableView reloadData];
                
            }else{
                [Helper showMessage:error];
            }
            
        });
        
    }];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return self.unassignedRides.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *from = (UILabel *)[cell viewWithTag:100];
    UILabel *to = (UILabel *)[cell viewWithTag:101];
    UILabel *time = (UILabel *)[cell viewWithTag:102];
    UILabel *date = (UILabel *)[cell viewWithTag:103];
    
    
    Ride *ride = [self.unassignedRides objectAtIndex:indexPath.row];
    
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
    NSLog(@"HERE %d",indexPath.row);
    Ride *ride = [self.unassignedRides objectAtIndex:indexPath.row];
    
    DriverRideDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverRideDetailView"];
    
    detailViewController.ride = ride;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
