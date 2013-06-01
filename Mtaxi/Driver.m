//
//  Driver.m
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/29/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "Driver.h"

@implementation Driver

- (id) initWithStatus: (ActiveStatus *)activeStatus andCarType: (CarType *) carType andServedLocation: (Location *)servedLocation {
    if (self == [super init]) {
        self.activeStatus = activeStatus;
        self.carType = carType;
        self.servedLocation = servedLocation;
    }
    return self;
}
@end
