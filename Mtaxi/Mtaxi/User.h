//
//  MEUser.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//




#import "Driver.h"
#import "Passenger.h"


@interface User : NSObject



@property (assign, nonatomic) int uid;
@property (assign, nonatomic) int version;
@property (strong, nonatomic) NSString *userType; //DRIVER or PASSENGER
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *tenantname;


@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) Driver *driver;
@property (strong, nonatomic) Passenger *passenger;

- (id) initWithUsername: (NSString *) userName andPassword: (NSString *) password andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPhone: (NSString *) phone andEmail: (NSString *) email  andDriver: (Driver *) driver andPassenger: (Passenger *) passenger;

@end
