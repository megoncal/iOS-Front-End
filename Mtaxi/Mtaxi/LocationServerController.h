//
//  LocationServerController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 03/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"
#import "Location.h"
#import "Marshaller.h"



@interface LocationServerController : NSObject

+ (void) retrieveMostFrequentLocations: (void (^)(NSMutableArray *locations, NSError *error)) handler;

+ (void)searchLocations:(NSString *)enteredLocation completionHandler:(void (^)(NSArray *, NSError *))handler;


@end
