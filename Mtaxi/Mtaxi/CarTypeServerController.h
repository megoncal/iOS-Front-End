//
//  CarTypeServerController.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 6/4/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"
#import "Helper.h"
#import "Marshaller.h"

@interface CarTypeServerController : NSObject

//retrieve a list of car types from the server
+(void)retrieverCarTypes: (void (^)(NSArray *carTypes, NSError* error))handler;

@end
