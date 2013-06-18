//
//  RideServerController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#define createRideURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/createRide"]
#define allRidesURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/retrievePassengerRides"]
#define rateRideURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/closeRide"]
#define unassignedRidesUrl [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/retrieveUnassignedRideInServedArea"]
#define assignRideUrl [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/assignRideToDriver"]

//#define createRideURL [NSURL URLWithString:@"http://localhost:8080/moovt/ride/createRide"]
//#define retrieveAllRidesURL [NSURL URLWithString:@"http://localhost:8080/moovt/ride/retrievePassengerRides"]

#import <Foundation/Foundation.h>
#import "Ride.h"    
#import "Marshaller.h"
#import "CallResult.h"
#import "RateRideToken.h"
#import "AssignRideToken.h"

@interface RideServerController : NSObject


+ (BOOL)createRide:(Ride *)ride error:(NSError *__autoreleasing *)error;

+ (void) retrievePassengerRides: (void (^)(NSMutableArray *, NSError *)) handler;

+ (BOOL) rateRide: (Ride *)ride error:(NSError *__autoreleasing *)error;

+ (BOOL) assignRide: (Ride *)ride error:(NSError *__autoreleasing *)error;

+ (void) retrieveUnassignedRidesInServedArea: (void (^)(NSMutableArray *, NSError *)) handler;

@end
