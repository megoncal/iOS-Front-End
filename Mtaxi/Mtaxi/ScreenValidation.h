//
//  ScreenValidation.h
//  Mtaxi
//
//  Created by Marcos Vilela on 08/07/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ScreenValidation : NSObject
 
+ (NSString*) formatNumber:(NSString*)mobileNumber;

+ (int) getLength:(NSString*)mobileNumber;

+ (BOOL) validateEmailWithString:(NSString*)email error:(NSError **)error;

+ (BOOL) checkForEmptyUITextField: (NSArray*)uiTextFieldsArray error:(NSError **)error;

+ (void) uitextFieldsResignFirstResponder: (NSArray *)uiTextFieldsArray;

+ (BOOL) maskedPhoneNumber: (NSString **)phoneNumberTextField withRange: (NSRange) range;

+ (BOOL) validateUsernameInputString: (NSString *)inputString  error:(NSError **)error;

+ (BOOL) validateNameInputString: (NSString *)inputString  error:(NSError **)error;

+ (void) showScreenValidationError:(NSError *)error;

+ (BOOL) validateUserUpdate: (User *)latestVersion oldVersion: (User *)oldVersion;

@end
