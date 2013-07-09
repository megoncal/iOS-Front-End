//
//  TaxiStandAddressViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 06/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController{
    BOOL searchingLocation;
    BOOL locationNotFound;
}
    

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    
    if ([currentSessionToken.userType isEqualToString:@"PASSENGER"]) {
        [self retrieveMostFrequentLocations];
    }
    
    [self prepareSearchedLocationsArray];

}   

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareSearchedLocationsArray{
    self.zeroLocations = [[NSArray alloc] initWithObjects:@"", nil];
    self.searchedLocations = self.zeroLocations;
}

- (void) retrieveMostFrequentLocations{
    
    [LocationServerController retrieveMostFrequentLocations:^(NSMutableArray *locations, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
    
            if (error.code == 0) {
                self.bookmark = locations;
                [self.mainTableView reloadData];
            }else{
                [Helper showMessage:error];
            }
            
        });

    }];
    
}




- (IBAction)cancelPressed:(id)sender {
    [self.delegate locationViewControllerCancelled:self];
}


#pragma mark - tableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        [self.delegate locationSelected:[self.searchedLocations objectAtIndex:indexPath.row] atViewControler:self];
        
    }else{
        
       [self.delegate locationSelected:[self.bookmark objectAtIndex:indexPath.row] atViewControler:self];
        
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *inventoryTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inventoryTableIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inventoryTableIdentifier];
    }
    
    if (tableView  == self.searchDisplayController.searchResultsTableView) {
    
        if (searchingLocation) {
            cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"SearchingCell"];
            UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)[cell viewWithTag:100];
            [activityIndicatorView startAnimating];
        }
        else if (locationNotFound){
            cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"LocationNotFound"];
        }
        else{
            cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"Cell"];
            
            id temp = [self.searchedLocations objectAtIndex:indexPath.row];
            
            if ([temp isKindOfClass:[Location class]]) {
                Location *location = temp;
                cell.textLabel.text = location.locationName;
                cell.detailTextLabel.text = location.politicalName;
            }else{
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"";
            }
        }
    }
    else{
        Location *location = [self.bookmark objectAtIndex:indexPath.row];
        cell.textLabel.text = location.locationName;
        cell.detailTextLabel.text = location.politicalName;
    }
    
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return self.searchedLocations.count;
        
    }
    else{
        return self.bookmark.count;
    }
    
    
}




#pragma mark - searchBarMethods

- (BOOL) searchDisplayController: (UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searchingLocation = YES;
    locationNotFound = NO;
    
    self.searchedLocations = self.zeroLocations;
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    
    
    [LocationServerController searchLocations:searchBar.text completionHandler:^(NSArray *locationsArray, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error.code == 0) {
                if (locationsArray.count > 0) {
                    self.searchedLocations = locationsArray;
                    searchingLocation = NO;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }else{
                    locationNotFound = YES;
                    searchingLocation = NO;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }
            }else{
                [Helper showMessage:error];
            }
            
        });

        
    }];
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchingLocation = NO;
    locationNotFound = NO;
    self.searchedLocations = self.zeroLocations;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    locationNotFound = NO;
}

@end
