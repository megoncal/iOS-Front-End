//
//  AssignRideToken.m
//  Mtaxi
//
//  Created by Marcos Vilela on 17/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "AssignRideToken.h"

@implementation AssignRideToken


-(id) initWithUid:(int)uid version:(int)version {
    if (self = [super init]) {
        self.uid = uid;
        self.version = version;
    }
    return self;
}




@end
