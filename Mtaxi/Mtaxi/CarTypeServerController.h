//
//  CarTypeServerController.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 6/4/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#define carTypeURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/driver/getCarTypeEnum"]


//#define carTypeURL [NSURL URLWithString:@"http://localhost:8080/moovt/driver/getCarTypeEnum"]

#import <Foundation/Foundation.h>
#import "Helper.h"
#import "Marshaller.h"

@interface CarTypeServerController : NSObject

//retrieve a list of car types from the server
+(void)retrieverCarTypes: (void (^)(NSArray *carTypes, NSError* error))handler;

@end
