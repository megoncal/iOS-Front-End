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
        self.tenantname = @"MTaxi";
        self.driver = driver;
        self.passenger = passenger;
    }
    return self;
}

- (id) initWithUid: (int) uid andVersion: (int) version andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPhone: (NSString *) phone andEmail: (NSString *) email  {
    if (self == [super init]) {
        self.uid = uid;
        self.version = version;
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

- (id) initWithUid: (int) uid andVersion: (int) version andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPhone: (NSString *) phone andEmail: (NSString *) email andDriver: (Driver *) driver andPassenger: (Passenger *) passenger {
    if (self == [super init]) {
        self.uid = uid;
        self.version = version;
        self.username = nil;
        self.password = nil;
        self.firstName = firstName;
        self.lastName = lastName;
        self.phone = phone;
        self.email = email;
        self.tenantname = nil;
        self.driver = driver;
        self.passenger = passenger;
    }
    return self;
}

- (id)copy{
    
    User *user = [[User alloc] init];
    
    user.uid = self.uid;
    user.version = self.version;
    user.username = self.username;
    user.password = self.password;
    user.firstName = self.firstName;
    user.lastName = self.lastName;
    user.phone = self.phone;
    user.email = self.email;
    user.tenantname = self.tenantname;
    user.driver = self.driver;
    user.passenger = self.passenger;
    
    return user;
}

@end
