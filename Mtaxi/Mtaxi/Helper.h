//
//  Helper.h
//  BackendProject
//
//  Created by Marcos Vilela on 23/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Car.h"
#import "ActiveStatus.h"
#import "CallResult.h"
#import "CurrentSession.h"

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
+(NSError *)createNSError:(CallResult *)callResultObject;
+ (void)callServerWithURLAsync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary completionHandler:(void (^)(NSDictionary *, NSError *))handler;
+ (BOOL)callServerWithURLSync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary myerror:(NSError **)myerror;



@end
