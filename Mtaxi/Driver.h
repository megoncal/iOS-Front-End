//
//  Driver.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/29/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarType.h"
#import "Location.h"
#import "ActiveStatus.h"

@interface Driver : NSObject

//driver information
@property (strong, nonatomic) Location *servedLocation;
@property (strong, nonatomic) ActiveStatus *activeStatus;
@property (strong, nonatomic) CarType *carType;


- (id) initWithStatus: (ActiveStatus *)activeStatus andCarType: (CarType *) carType andServedLocation: (Location *)servedLocation;

@end
