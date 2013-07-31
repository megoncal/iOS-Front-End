//
//  CancelRideToken.m
//  Mtaxi
//
//  Created by Marcos Vilela on 27/07/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "CancelRideToken.h"

@implementation CancelRideToken

-(id) initWithUid:(int)uid version:(int)version {
    if (self = [super init]) {
        self.uid = uid;
        self.version = version;
    }
    return self;
}
@end
