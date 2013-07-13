//
//  ScreenValidation.m
//  Mtaxi
//
//  Created by Marcos Vilela on 08/07/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "ScreenValidation.h"

@implementation ScreenValidation

+(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}


+(int)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    return length;
}

+ (BOOL)validateEmailWithString:(NSString*)email error:(NSError *__autoreleasing *)error
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        *error = [ScreenValidation createNSError:1 message:@"Please add a valid e-mail."];
        return NO;
    }
    return YES;
}


+ (BOOL) checkForEmptyUITextField: (NSArray*)uiTextFieldsArray error:(NSError *__autoreleasing *)error
{
    for (UITextField *uitextfield in uiTextFieldsArray) {
        if([uitextfield.text isEqualToString:@""]){
            *error = [ScreenValidation createNSError:1 message:@"Please fill up empty information before proceed"];
            return YES;
        }
    }
    return NO;
}

+ (void) uitextFieldsResignFirstResponder: (NSArray *)uiTextFieldsArray{
    for (UITextField *uitextefeld in uiTextFieldsArray) {
        [uitextefeld resignFirstResponder];
    }
}


+ (BOOL) maskedPhoneNumber: (NSString **)phoneNumberTextField withRange: (NSRange) range{
    int length = [ScreenValidation getLength:*phoneNumberTextField];
    if(length == 10) {
        if(range.length == 0)
            return NO;
    }
    if(length == 3) {
        NSString *num = [ScreenValidation formatNumber:*phoneNumberTextField];
        *phoneNumberTextField = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            *phoneNumberTextField = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6) {
        NSString *num = [ScreenValidation formatNumber:*phoneNumberTextField];
        *phoneNumberTextField = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            *phoneNumberTextField = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    return YES;
}

+ (BOOL)validateUsernameInputString:(NSString *)inputString error:(NSError *__autoreleasing *)error{
    
    NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *decimalDigitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *customPunctuationCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"_-."];
    
    NSMutableCharacterSet *validationCharacterSet = [letterCharacterSet mutableCopy];
    [validationCharacterSet formUnionWithCharacterSet:decimalDigitCharacterSet];
    [validationCharacterSet formUnionWithCharacterSet:customPunctuationCharacterSet];
        
    NSScanner *scanner = [NSScanner scannerWithString:inputString];

    if (![scanner scanCharactersFromSet:validationCharacterSet intoString:NULL]){
        *error = [ScreenValidation createNSError:1 message:@"You can only use letters, numbers and punctuation marks."];
        return NO;
    
    }
    return YES;
}


//TODO: bug when space character. not accepting space....
+ (BOOL) validateNameInputString: (NSString *)inputString  error:(NSError **)error{
    
    NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSScanner *scanner = [NSScanner scannerWithString:inputString];
    
    NSMutableCharacterSet *validationCharacterSet = [letterCharacterSet mutableCopy];
    [validationCharacterSet formUnionWithCharacterSet:whitespaceCharacterSet];
    
    if (![scanner scanCharactersFromSet:validationCharacterSet intoString:NULL]){
     
        *error = [ScreenValidation createNSError:1 message:@"You can only use letters and whitespace."];
        return NO;
        
    }
    
    return YES;
}


+(NSError *)createNSError:(int) code message:(NSString *) message{

    NSMutableDictionary* details = [[NSMutableDictionary alloc] initWithCapacity:1];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"com.moovt.mtaxi" code:code userInfo:details];
    return error;

}

+ (void)showScreenValidationError:(NSError *)error{
    if (error.code == 1){
        NSString *screenValidationError = error.localizedDescription;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Validation" message:screenValidationError  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


@end
