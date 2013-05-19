//
//  Ride.h
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Car.h"

@interface Ride : NSObject


@property (strong,nonatomic) Location *pickUpLocation;
@property (strong,nonatomic) Location *dropOffLocation;
@property (strong, nonatomic) Car *car;

@property (strong,nonatomic) NSDate *pickUpDate;


@end
    