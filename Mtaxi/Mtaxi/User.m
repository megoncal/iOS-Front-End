//
//  MEUser.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//


#import "User.h"

@implementation User

- (id) initWithUsername: (NSString *) userName andPassword: (NSString *) password andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPhone: (NSString *) phone andEmail: (NSString *) email andDriver: (Driver *) driver andPassenger: (Passenger *) passenger {
    if (self == [super init]) {
        self.username = userName;
        self.password = password;
        self.firstName = firstName;
        self.lastName = lastName;
        self.phone = phone;
        self.email = email;
        self.tenantname = @"WorldTaxi";
        self.driver = driver;
        self.passenger = passenger;
    }
    return self;
}

- (id) initWithUid: (int) uid andVersion: (int) version andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPhone: (NSString *) phone andEmail: (NSString *) email  {
    if (self == [super init]) {
        self.uid = uid;
        self.version = uid;
        self.username = nil;
        self.password = nil;
        self.firstName = firstName;
        self.lastName = lastName;
        self.phone = phone;
        self.email = email;
        self.tenantname = nil;
        self.driver = nil;
        self.passenger = nil;
    }
    return self;
}

@end