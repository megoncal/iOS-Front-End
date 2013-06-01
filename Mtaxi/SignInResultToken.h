//
//  SignInResultToken.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/30/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInResultToken : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *JSESSIONID;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *userType;

@end
