//
//  Ride.h
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEUser.h"
#import "Location.h"
#import "Car.h"
#import "CallResult.h"
#import "RideStatus.h"
@interface Ride : NSObject



@property int rideId;
@property int version;


@property (strong,nonatomic) RideStatus *rideStatus;
@property (strong, nonatomic) MEUser *driver;
@property (strong, nonatomic) MEUser *passenger;
@property (strong,nonatomic) NSDate *pickUpDate;

@property (strong,nonatomic) Location *pickUpLocation;
@property (strong,nonatomic) Location *dropOffLocation;

@property (strong,nonatomic) NSString *rating;
@property (strong,nonatomic) NSString *comments;


@property (strong, nonatomic) Car *car;

//TODO: to be implemented on the server side
@property (strong, nonatomic) NSString *addressComplement;
@property (strong,nonatomic) NSString *messageToTheDriver;


+ (Ride *) rideObject: (NSDictionary *) rideDictionary;

- (Ride *) createNewRideOnTheServer: (NSError **)error;

- (NSMutableDictionary *)createRideDictionary;

- (NSString *)stringPickUpDate;

- (NSString *)stringFullFormatPickUpDate;


@end
    