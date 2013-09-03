//
//  UserServerController.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/28/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "constant.h"
#import "Helper.h"
#import "CarType.h"
#import "CurrentSessionController.h"
#import "Location.h"
#import "ActiveStatus.h"
#import "CallResult.h"
#import "Marshaller.h"
#import "User.h"
#import "SignInToken.h"

@interface UserServerController : NSObject

//logIn methods

+(BOOL)signIn: (SignInToken *) token userType: (NSString **) userType error: (NSError **) error;

+(BOOL)signUpUser:(User *) user error:(NSError **) error;

+(void)retrieveLoggedUserDetails: (void (^)(User *meUser, NSError* error))handler;

+(void)updateLoggedUserDetails:(User *)user completionHandler: (void (^)(User *user, NSError* result))handler;


@end
