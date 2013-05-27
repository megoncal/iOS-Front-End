//
//  RideStatus.h
//  Mtaxi
//
//  Created by Marcos Vilela on 26/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RideStatus : NSObject


@property (strong,nonatomic) NSString *code;
@property (strong,nonatomic) NSString *description;


+(RideStatus *) rideStatusObject: (NSDictionary *)rideStatusDictionary;

@end
