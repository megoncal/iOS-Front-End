//
//  LocationServerController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 03/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Marshaller.h"

//#define getMostFrequentLocations [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/location/getMostFrequentLocations"]
//#define locationSearchURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/location/search"]

#define getMostFrequentLocations [NSURL URLWithString:@"http://localhost:8080/moovt/location/getMostFrequentLocations"]
#define locationSearchURL [NSURL URLWithString:@"http://localhost:8080/moovt/location/search"]


@interface LocationServerController : NSObject

+ (void) retrieveMostFrequentLocations: (void (^)(NSMutableArray *locations, NSError *error)) handler;

+ (void)searchLocations:(NSString *)enteredLocation completionHandler:(void (^)(NSArray *, NSError *))handler;


@end
