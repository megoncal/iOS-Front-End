//
//  Ride.m
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//


#import "Ride.h"

#define createRideURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/createRide"]

@implementation Ride


- (void)createRideOnTheServer:(void (^)(Ride * , NSError *))handler{
    
    NSURL *url = createRideURL;
    
    NSMutableDictionary *createRideDictionary = self.createRideDictionary;
    
    [Helper callServerWithURLAsync:url inputDictionary:createRideDictionary completionHandler:^(NSDictionary *outputDictionay, NSError *error) {
        
        CallResult *callResultObject;
        Ride *ride;
        if (error.code == 0) {
            callResultObject = [CallResult marshallObject:outputDictionay];
            //TODO: Marshall returned ride and result;
             error = [Helper createNSError:callResultObject];
        }
        
        //Create an error from the call Result - This maybe success or not
       
        
        handler(ride,error);
        
    }];
}


- (NSMutableDictionary *) createRideDictionary{
    

    NSMutableDictionary *createRideDictionary = [[NSMutableDictionary alloc]init];
    
    [createRideDictionary setObject:self.pickUpLocation.locationDictionary forKey:@"pickUpLocation"];
    
    [createRideDictionary setObject:self.dropOffLocation.locationDictionary forKey:@"dropOffLocation"];

    [createRideDictionary setObject:self.stringPickUpDate forKey:@"pickupDateTime"];
    
    [createRideDictionary setObject:self.car.code forKey:@"carType"];
    
    return createRideDictionary;

}


- (NSString *)stringPickUpDate{
    
    NSString *stringDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    stringDate = [dateFormatter stringFromDate:self.pickUpDate];
    
    return stringDate;
}


- (NSString *)stringFullFormatPickUpDate{
    
    NSString *stringDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    stringDate = [dateFormatter stringFromDate:self.pickUpDate];
    
    return stringDate;
}



@end
