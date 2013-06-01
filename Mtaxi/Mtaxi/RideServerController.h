//
//  RideServerController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ride.h"
#import "Marshaller.h"
#import "CallResult.h"

@interface RideServerController : NSObject


+ (BOOL)createRide:(Ride *)ride error:(NSError *__autoreleasing *)error;

+ (void) retrievePassengerRides: (void (^)(NSMutableArray *, NSError *)) handler;


@end
