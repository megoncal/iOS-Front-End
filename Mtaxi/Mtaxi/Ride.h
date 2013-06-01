//
//  Ride.h
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Location.h"
#import "CarType.h"
#import "CallResult.h"
#import "RideStatus.h"
#import "Marshaller.h"

@interface Ride : NSObject



@property int uid;
@property int version;


@property (strong,nonatomic) RideStatus *rideStatus;

@property (strong, nonatomic) User *driver;
@property (strong, nonatomic) User *passenger;
@property (strong,nonatomic) NSDate *pickUpDate;

@property (strong,nonatomic) Location *pickUpLocation;
@property (strong,nonatomic) Location *dropOffLocation;

@property (strong,nonatomic) NSString *rating;
@property (strong,nonatomic) NSString *comments;


@property (strong, nonatomic) CarType *car;

//TODO: to be implemented on the server side
@property (strong, nonatomic) NSString *pickUpLocationComplement;
@property (strong,nonatomic) NSString *messageToTheDriver;


//+ (Ride *) rideObject: (NSDictionary *) rideDictionary;
//
//- (Ride *) createNewRideOnTheServer: (NSError **)error;
//
//- (NSMutableDictionary *)createRideDictionary;
//
//- (NSString *)stringPickUpDate;
//
//- (NSString *)stringFullFormatPickUpDate;


@end
    