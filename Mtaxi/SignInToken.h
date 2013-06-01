//
//  LoginToken.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/29/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInToken : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *tenantname;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

-(id) initWithUsername: (NSString *)username andPassword:(NSString *)password;

@end
