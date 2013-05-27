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


- (Ride *)createNewRideOnTheServer:(NSError *__autoreleasing *)error{
    
    NSURL *url = createRideURL;
    
    Ride *createdRide;
    
    NSMutableDictionary *createRideDictionary = self.createRideDictionary;
    
    NSMutableDictionary *outputDictionary;
   
    [Helper callServerWithURLSync:url inputDictionary:createRideDictionary outputDictionary:&outputDictionary myerror:error];

    //Create an error from the call Result - This maybe success or not
    *error = [Helper createNSError:[CallResult marshallObject:outputDictionary]];

    return createdRide;
}



+ (Ride *) rideObject : (NSDictionary *) rideDictionary{
    
    Ride *ride = [[Ride alloc] init];
    
    ride.rideId = [[rideDictionary objectForKey:@"id"] intValue];
    
    ride.version = [[rideDictionary objectForKey:@"version"] intValue];

    ride.rideStatus = [RideStatus rideStatusObject:[rideDictionary objectForKey:@"rideStatus"]];
    
    //TODO: Implement driver and passenger
    //driver
    //passenger
    
    NSString *pickUpDateString = [rideDictionary objectForKey:@"pickupDateTime"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
     NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormatter setTimeZone:gmt];
    
    ride.pickUpDate = [dateFormatter dateFromString:pickUpDateString];
    
    ride.pickUpLocation = [Location locationObject:[rideDictionary objectForKey:@"pickUpAddress"]];
    
    ride.dropOffLocation = [Location locationObject:[rideDictionary objectForKey:@"dropOffAddress"]];
    
    ride.rating = [rideDictionary objectForKey:@"rating"];
    
    ride.comments = [rideDictionary objectForKey:@"comments"];
    
    return ride;
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
