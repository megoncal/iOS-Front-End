//
//  RideServerController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"
#import "Ride.h"
#import "Marshaller.h"
#import "CallResult.h"
#import "RateRideToken.h"
#import "AssignRideToken.h"
#import "CancelRideToken.h"

@interface RideServerController : NSObject


+ (BOOL)createRide:(Ride *)ride error:(NSError *__autoreleasing *)error;

+ (void) retrievePassengerRides: (void (^)(NSMutableArray *, NSError *)) handler;

+ (BOOL) rateRide: (Ride *)ride error:(NSError *__autoreleasing *)error;

+ (BOOL) assignRide: (Ride *)ride error:(NSError *__autoreleasing *)error;

+ (BOOL) cancelRide: (Ride *)ride error:(NSError *__autoreleasing *)error;

+ (void) retrieveUnassignedRidesInServedArea: (void (^)(NSMutableArray *, NSError *)) handler;

+ (void) retrieveDriverRides: (void (^)(NSMutableArray *rides, NSError *error)) handler;

@end
