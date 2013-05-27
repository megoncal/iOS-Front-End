//
//  RideStatus.m
//  Mtaxi
//
//  Created by Marcos Vilela on 26/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "RideStatus.h"

@implementation RideStatus


+(RideStatus *) rideStatusObject: (NSDictionary *)rideStatusDictionary{
    
    RideStatus *rideStatus = [[RideStatus alloc] init];
    rideStatus.code = [rideStatusDictionary objectForKey:@"code"];
    rideStatus.description = [rideStatusDictionary objectForKey:@"description"];
    
    return rideStatus;
}

@end
