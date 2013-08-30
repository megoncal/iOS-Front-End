//
//  LoginToken.m
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/29/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "SignInToken.h"

@implementation SignInToken

-(id) initWithUsername: (NSString *)username andPassword:(NSString *)password {
    if (self = [super init]) {
        self.type = @"Self";
        self.tenantname = @"MTaxi";
        self.username = username;
        self.password = password;
    }
    return self;
}


-(id) initWithUsername: (NSString *)username andPassword:(NSString *)password andApnsToken:(NSString *)apnsToken {
    if (self = [super init]) {
        self.type = @"Self";
        self.tenantname = @"MTaxi";
        self.username = username;
        self.password = password;
        self.apnsToken = apnsToken;
    }
    return self;
}
@end
