//
//  MyRidesViewController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 15/07/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "MyRidesViewController.h"

@interface MyRidesViewController ()

@end

@implementation MyRidesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.listOfStatusCode = [[NSArray alloc] initWithObjects:@"UNASSIGNED", @"ASSIGNED", @"COMPLETED", nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing rides..."];
    
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [self retrieveMyRides];
}

#pragma mark - Integration with Server
- (void)retrieveMyRides{
    
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbProgressHUD.labelText = @"Loading rides...";
    
    [RideServerController retrieveDriverRides:^(NSMutableArray *rides, NSError *error) {
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
    [RideServerController retrieveDriverRides:^(NSMutableArray *rides, NSError *error) {
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
        
        
        NSArray *tempArray = [sectionsDictionary objectForKey:statusCode];
        
        if (tempArray) {
            
            tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSDate *date1 = [(Ride *)obj1 pickUpDateTime];
                NSDate *date2 = [(Ride *) obj2 pickUpDateTime];
                return [date1 compare:date2];
                
            }];
            
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            NSString *tempKey = [(Ride *)[tempArray objectAtIndex:0] rideStatus].description;
            [tempDictionary setObject:tempArray forKey:tempKey];
            [self.sectionedRides addObject:tempDictionary];
        }
        
    }
    
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




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Ride *ride = [self retrieveRideFrom:self.sectionedRides atPosition:indexPath];
    
    DriverRideDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverRideDetailView"];
    
    detailViewController.ride = ride;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - convenience methods


-  (Ride *)retrieveRideFrom: (NSArray *)sectionedRides atPosition:(NSIndexPath *)indexPath{
    
    NSDictionary *ridesDictionary = [sectionedRides objectAtIndex:indexPath.section];
    NSArray *ridesArray = [[ridesDictionary allValues] objectAtIndex:0];
    return [ridesArray objectAtIndex:indexPath.row];
}


@end
