//
//  RateRideToken.m
//  Mtaxi
//
//  Created by Marcos Vilela on 15/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "RateRideToken.h"

@implementation RateRideToken



-(id) initWithUid:(int)uid version:(int)version rating:(double)rating andComment:(NSString *)comment {
    if (self = [super init]) {
        self.uid = uid;
        self.version = version;
        self.rating = rating;
        self.comment = comment;
    }
    return self;
}


@end
