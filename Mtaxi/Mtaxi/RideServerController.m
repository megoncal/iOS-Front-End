//
//  RideServerController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//


#import "RideServerController.h"


@implementation RideServerController


+ (BOOL)createRide:(Ride *)ride error:(NSError *__autoreleasing *)error{
    
    NSURL *url = [NSURL URLWithString:createRideURL];
    
    NSMutableDictionary *rideDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *callResultDictionary;
    NSMutableDictionary *outputDictionary;
    
    //marshal the ride dictionary from the ride object
    BOOL success = [Marshaller marshallDictionary:rideDictionary object:ride error:error];
    
    if (!success) {
        return NO;
    }
    
    //call server sync passing the rideDictionary
    success = [Helper callServerWithURLSync:url inputDictionary:rideDictionary outputDictionary:&outputDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    callResultDictionary = [outputDictionary objectForKey:@"result"];
    CallResult *callResult = [[CallResult alloc]init];
    
    success = [Marshaller marshallObject:callResult dictionary:callResultDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    //Create an error from the call Result - This maybe success or not
    *error = [Helper createNSError:callResult];
    
    if ([callResult.code isEqualToString:@"ERROR"]) {
        return NO;
    }
    return YES;
}


#pragma mark - Integration with Server

+ (void) retrievePassengerRides: (void (^)(NSMutableArray *rides, NSError *error)) handler{
    
    
    NSURL *url = [NSURL URLWithString:allRidesURL];
    
    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc]init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    [Helper callServerWithURLAsync:url inputDictionary:inputDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error) {
        
        if (error.code == 0) {
        
            NSMutableArray *ridesArray = [[NSMutableArray alloc]init];
            NSMutableArray *returnedRidesArray = [outputDictionary objectForKey:@"rides"];
            
            for (NSDictionary *rideDictionary in returnedRidesArray) {
                Ride *ride = [[Ride alloc] init];
                NSLog(@"ride dictionary: %@", [rideDictionary description]);
                BOOL success = [Marshaller marshallObject:ride dictionary:rideDictionary error:&error];
                if (!success) {
                    handler(NULL, error);
                    return;
                }

                [ridesArray addObject:ride];
            }
            
            handler(ridesArray,error);
            
        
        }else{
            handler(NULL,error);
        }
    }];
    
}


+ (void) retrieveDriverRides: (void (^)(NSMutableArray *rides, NSError *error)) handler{
    
    
    NSURL *url = [NSURL URLWithString:driverRidesURL];
    
    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc]init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    [Helper callServerWithURLAsync:url inputDictionary:inputDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error) {
        
        if (error.code == 0) {
            
            NSMutableArray *ridesArray = [[NSMutableArray alloc]init];
            NSMutableArray *returnedRidesArray = [outputDictionary objectForKey:@"rides"];
            
            for (NSDictionary *rideDictionary in returnedRidesArray) {
                Ride *ride = [[Ride alloc] init];
                NSLog(@"ride dictionary: %@", [rideDictionary description]);
                BOOL success = [Marshaller marshallObject:ride dictionary:rideDictionary error:&error];
                if (!success) {
                    handler(NULL, error);
                    return;
                }

                [ridesArray addObject:ride];
            }
            
            handler(ridesArray,error);
            
            
        }else{
            handler(NULL,error);
        }
    }];
    
}



+(BOOL)rateRide:(Ride *)ride error:(NSError *__autoreleasing *)error{
    
    NSURL *url = [NSURL URLWithString:rateRideURL];
    
    NSMutableDictionary *rateRideDictionary = [[NSMutableDictionary alloc] init];
    
    RateRideToken *rateRideToken = [[RateRideToken alloc] initWithUid:ride.uid version:ride.version rating:ride.rating andComment:ride.comment];
    
    
    BOOL success = [Marshaller marshallDictionary:rateRideDictionary object:rateRideToken error:error];
    
    NSLog(@"%@",[rateRideDictionary description]);
    
    if (!success) {
        return NO;
    }
    
    NSMutableDictionary *callResultDictionary;
    NSMutableDictionary *outputDictionary;
    

    //call server sync passing the rideDictionary
    success = [Helper callServerWithURLSync:url inputDictionary:rateRideDictionary outputDictionary:&outputDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    callResultDictionary = [outputDictionary objectForKey:@"result"];
    
    CallResult *callResult = [[CallResult alloc]init];
    
    success = [Marshaller marshallObject:callResult dictionary:callResultDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    //Create an error from the call Result - This maybe success or not
    *error = [Helper createNSError:callResult];
    
    if ([callResult.code isEqualToString:@"ERROR"]) {
        return NO;
    }
    return YES;
}


+(BOOL)assignRide:(Ride *)ride error:(NSError *__autoreleasing *)error{
    
    NSURL *url = [NSURL URLWithString:assignRideURL];
    
    NSMutableDictionary *assignRideDictionary = [[NSMutableDictionary alloc] init];
    
    AssignRideToken *assignRideToken = [[AssignRideToken alloc] initWithUid:ride.uid version:ride.version];
    
    
    BOOL success = [Marshaller marshallDictionary:assignRideDictionary object:assignRideToken error:error];

    
    if (!success) {
        return NO;
    }
    
    NSMutableDictionary *callResultDictionary;
    NSMutableDictionary *outputDictionary;
    
    
    //call server sync passing the rideDictionary
    success = [Helper callServerWithURLSync:url inputDictionary:assignRideDictionary outputDictionary:&outputDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    callResultDictionary = [outputDictionary objectForKey:@"result"];
    
    CallResult *callResult = [[CallResult alloc]init];
    
    success = [Marshaller marshallObject:callResult dictionary:callResultDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    //Create an error from the call Result - This maybe success or not
    *error = [Helper createNSError:callResult];
    
    if ([callResult.code isEqualToString:@"ERROR"]) {
        return NO;
    }
    return YES;
}


+(BOOL)cancelRide:(Ride *)ride error:(NSError *__autoreleasing *)error{
    
    NSURL *url = [NSURL URLWithString:cancelRideURL];
    
    NSMutableDictionary *cancelRideDictionary = [[NSMutableDictionary alloc] init];
    
    CancelRideToken *cancelRideToken = [[CancelRideToken alloc] initWithUid:ride.uid version:ride.version];
    
    BOOL success = [Marshaller marshallDictionary:cancelRideDictionary object:cancelRideToken error:error];
    
    
    if (!success) {
        return NO;
    }
    
    NSMutableDictionary *callResultDictionary;
    NSMutableDictionary *outputDictionary;
    
    
    //call server sync passing the rideDictionary
    success = [Helper callServerWithURLSync:url inputDictionary:cancelRideDictionary outputDictionary:&outputDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    callResultDictionary = [outputDictionary objectForKey:@"result"];
    
    CallResult *callResult = [[CallResult alloc]init];
    
    success = [Marshaller marshallObject:callResult dictionary:callResultDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    //Create an error from the call Result - This maybe success or not
    *error = [Helper createNSError:callResult];
    
    if ([callResult.code isEqualToString:@"ERROR"]) {
        return NO;
    }
    return YES;
}



+ (void)retrieveUnassignedRidesInServedArea:(void (^)(NSMutableArray *, NSError *))handler{
    
    NSURL *url = [NSURL URLWithString:unassignedRidesURL];
    
    NSMutableDictionary *inputDictionary = [[NSMutableDictionary alloc]init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    [Helper callServerWithURLAsync:url inputDictionary:inputDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error) {
        
        if (error.code == 0) {
            
            NSMutableArray *ridesArray = [[NSMutableArray alloc]init];
            NSMutableArray *returnedRidesArray = [outputDictionary objectForKey:@"rides"];
            
            for (NSDictionary *rideDictionary in returnedRidesArray) {
                Ride *ride = [[Ride alloc] init];
                NSLog(@"ride dictionary: %@", [rideDictionary description]);
                BOOL success = [Marshaller marshallObject:ride dictionary:rideDictionary error:&error];
                if (!success) {
                    handler(NULL, error);
                    return;
                }
                
                NSLog(@"ride pickuplocation: %@", ride.pickUpLocation.locationName);
                [ridesArray addObject:ride];
            }
            
            handler(ridesArray,error);
            
            
        }else{
            handler(NULL,error);
        }
    }];
}

@end
