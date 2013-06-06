//
//  LocationServerController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 03/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//


#define getMostFrequentLocations [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/location/getMostFrequentLocations"]
//#define getMostFrequentLocations [NSURL URLWithString:@"http://localhost:8080/moovt/location/getMostFrequentLocations"]

#define locationSearchURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/location/search"]
//#define locationSearchURL [NSURL URLWithString:@"http://localhost:8080/moovt/location/search"]


#import "LocationServerController.h"


@implementation LocationServerController


+ (void) retrieveMostFrequentLocations: (void (^)(NSMutableArray *locations, NSError *error)) handler{
     
    
    NSURL *url = getMostFrequentLocations;
    
    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc]init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    [Helper callServerWithURLAsync:url inputDictionary:inputDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error) {
        
        if (error.code == 0) {
            
            NSMutableArray *locationsArray = [[NSMutableArray alloc]init];
            
            NSMutableArray *returnedLocationsArray = [outputDictionary objectForKey:@"locations"];
            
            for (NSDictionary *locationDictionary in returnedLocationsArray) {
                Location *location = [[Location alloc] init];
                
                BOOL success = [Marshaller marshallObject:location dictionary:locationDictionary error:&error];
                
                if (!success) {
                    handler(NULL, error);
                    return;
                }
                
               
                [locationsArray addObject:location];
            }
            
            handler(locationsArray,error);
            
            
        }else{
            handler(NULL,error);
        }
    }];
    
}


+ (void)searchLocations:(NSString *)enteredLocation completionHandler:(void (^)(NSArray *, NSError *))handler{

    NSURL *url = locationSearchURL;
    
    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc] init];

    [inputDictionary setObject:enteredLocation forKey:@"location"];
    
    [Helper callServerWithURLAsync:url inputDictionary:inputDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error){
        
        if (error.code == 0) {
            
            NSMutableArray *locationsArray = [[NSMutableArray alloc]init];
            
            NSMutableArray *returnedLocationsArray = [outputDictionary objectForKey:@"locations"];
            
            for (NSDictionary *locationDictionary in returnedLocationsArray) {
                
                Location *location = [[Location alloc] init];
                
                BOOL success = [Marshaller marshallObject:location dictionary:locationDictionary error:&error];
                
                if (!success) {
                    handler(NULL, error);
                    return;
                }
                
                [locationsArray addObject:location];
            }
            
            handler(locationsArray,error);
            
            
        }else{
            handler(NULL,error);
        }
    }];
}


@end
