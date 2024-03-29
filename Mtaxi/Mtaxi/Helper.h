//
//  Helper.h
//  BackendProject
//
//  Created by Marcos Vilela on 23/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "constant.h"
#import "Location.h"
#import "CarType.h"
#import "ActiveStatus.h"
#import "CallResult.h"
#import "CurrentSessionController.h"
#import "CurrentSessionToken.h"
#import "SignInToken.h"
#import "Marshaller.h"


@class Car;
@class Radius;
@class Location;

@interface Helper : NSObject

+(NSError *)createErrorForMEUserClass:(NSString *) message;

+(void)showErrorMEUserWithErrorString: (NSString *) errorMessage;

+(void)showErrorMEUserWithError: (NSError *) error;

+(void)showSuccessMEUser: (NSString *) message;

+(void)showSuccessMessage: (NSString *) message;
+(void)showErrorMessage: (NSString *) message;
+(void)showMessage: (NSError *) error;
+(NSError *)createNSError:(int) code message:(NSString *) message;
+(NSError *)createNSError:(NSString *) code type:(NSString *) type message:(NSString *) message;
+(NSError *)createNSError:(CallResult *)callResultObject;

+ (void)callServerWithURLAsync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary completionHandler:(void (^)(NSDictionary *, NSError *))handler;

+ (BOOL)callServerWithURLSync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary error:(NSError **)error;

+ (BOOL)callServerWithURLSync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary error:(NSError **)error isRetry: (BOOL) isRetry;

//TODO: When not connected, the message says Input Serialization Error

+(BOOL)signIn: (SignInToken *) signInToken
     userType: (NSString **) userType
        error: (NSError **) error;


+(void) handleServerReturn: (NSError *)error showMessageOnSuccess: (BOOL) showMessageOnSuccess viewController:(UIViewController *)viewController;

@end
