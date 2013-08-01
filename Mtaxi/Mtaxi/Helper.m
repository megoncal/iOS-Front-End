//
//  Helper.m
//  BackendProject
//
//  Created by Marcos Vilela on 23/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//



#import "Helper.h"


@implementation Helper

+(NSError *)createErrorForMEUserClass:(NSString *) message{
    NSMutableDictionary *errorDetails = [[NSMutableDictionary alloc] init];
    [errorDetails setValue:message forKey:@"error"];
    NSError  *error = [NSError errorWithDomain:@"MEUser" code:1 userInfo:errorDetails];
    return error;
}

+ (void)showErrorMEUserWithError:(NSError *)error{
    
    NSString *errorMessage = [[error userInfo] objectForKey:@"error"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

+(void)showErrorMEUserWithErrorString: (NSString *) errorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

+(void)showSuccessMEUser: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

+(void)showSuccessMessage: (NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


+(void)showErrorMessage: (NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

+(void)showMessage: (NSError *) error {
    if (error.code == 0) {
        [self showSuccessMessage:error.localizedDescription];
    } else {
        [self showErrorMessage:error.localizedDescription];
    }
}

+ (void)handleServerReturn:(NSError *)error showMessageOnSuccess:(BOOL)showMessageOnSuccess viewController:(UIViewController *)viewController {
    
    if (error.code == 0 && showMessageOnSuccess) {
        [self showSuccessMessage:error.localizedDescription];
        return;
    }
    
    if (error.code == 1) {
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    
    if (error.code == 100) {
        
        UIViewController *signInController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"LogInNavigationController"];
        [viewController presentViewController:signInController animated:YES completion:nil];
        
        return;
    }
    
    
    
    
}

+(NSError *)createNSError:(int) code message:(NSString *) message{
    NSMutableDictionary* details = [[NSMutableDictionary alloc] initWithCapacity:1];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"com.moovt.mtaxi" code:code userInfo:details];
    return error;
}

+ (NSError *)createNSError:(CallResult *)callResultObject {
    NSError *error;
    if ([callResultObject.code isEqualToString:@"SUCCESS"]) {
        error = [self createNSError:0 message:callResultObject.message];
    } else {
        if ([callResultObject.type isEqualToString:@"USER"]) {
            error = [self createNSError:1 message:callResultObject.message];
        } else {
            error = [self createNSError:1 message:@"Unexpected error. Please try again."];
        }
    }
    return error;
}

+(NSError *)createNSError:(NSString *) code type:(NSString *) type message:(NSString *) message {
    CallResult *callResult = [[CallResult alloc] init];
    callResult.type = type;
    callResult.message = message;
    callResult.code = code;
    return [self createNSError:callResult];
    
}

+ (BOOL)retrySync:(NSURL *) url outputDictionary:(NSDictionary **)outputDictionary inputDictionary:(NSMutableDictionary *)inputDictionary error:(NSError **)error  {
    
    //search for login details in the keychain and then try to sigin
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    if (currentSessionToken.username &&
        currentSessionToken.password) {
        
        NSString *returnedUser;
        
        SignInToken *token = [[SignInToken alloc] initWithUsername:currentSessionToken.username andPassword:currentSessionToken.password];
        
        BOOL success = [self signIn:token userType:&returnedUser error:error];
        //NOTE: if the sign in function returned yes but does not logged the user in.. then a infinite loop could happen. the sign in functional has been reviewd to make sure that only returns yes if the user has been succeed log in.
        
        
        if (!success) {
            *error = [Helper createNSError:100 message:(*error).localizedDescription];
            [CurrentSessionController resetCurrentSession];
            return NO;
        }else{
            *error = nil;
            success = [self callServerWithURLSync:url inputDictionary:inputDictionary outputDictionary:outputDictionary error:error isRetry:YES];
            if (!success) {   
                *error = [Helper createNSError:100 message:@"Unauthorized"];
                return NO;
            }
            
            *error = [Helper createNSError:0 message:@"Synchronous call to server was successful"] ;
            return YES;
            
        }
        
    } else {
        *error = [Helper createNSError:100 message:@"Unauthorized"];
        return NO;
    }
}

+ (BOOL)callServerWithURLSync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary error:(NSError **)error {
    return [self callServerWithURLSync:url inputDictionary:inputDictionary outputDictionary:outputDictionary error:error isRetry:NO];
}


//Calls a REST/JSON service with a dictionary and returns a dictionar
+ (BOOL)callServerWithURLSync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary error:(NSError **)error isRetry: (BOOL) isRetry {
    
    //Convert the Dictionary to the data that will go into the body of the message
    NSError *serializationError = NULL;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:inputDictionary options:NSJSONWritingPrettyPrinted error:&serializationError];
    
    //Checks if the bodyData was generated successfully
    if (serializationError) {
        *error = [Helper createNSError:1 message:@"Input Searilization Error"] ;
        return NO;
    }
    
    //Call server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    NSString *jsessionID = currentSessionToken.jsessionID;
    //    NSString *jsessiond = [CurrentSession currentSessionInformation].jsessionID;
    [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessionID] forHTTPHeaderField:@"Cookie"];
    
    NSHTTPURLResponse *responseCode = NULL;
    //   NSError *callError = NULL;
    
    NSLog(@"Input String: %@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:error];
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"Returned String: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    //TODO: correct
    if ((*error) || ([data length] == 0)) {
        *error = [Helper createNSError:1 message:(*error).localizedDescription] ;
        return NO;
    }
    
    if (responseCode.statusCode == 403) {
        (*error) = nil;
        //We only retry once
        if (isRetry) {
            return NO;
        } else {
            return [self retrySync:url outputDictionary:outputDictionary inputDictionary:inputDictionary error:error];
        }
    }
    
    if (responseCode.statusCode != 200) {
        *error = [Helper createNSError:1 message:[NSString stringWithFormat:@"Server returned an unexpected status code (%d)", responseCode.statusCode]] ;
        return NO;
    }
    
    *outputDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
    
    if (serializationError) {
        *error = [Helper createNSError:1 message:@"Input Searilization Error"] ;
        return NO;
    }
    
    *error = [Helper createNSError:0 message:@"Synchronous call to server was successful"] ;
    return YES;
    
}

//Calls a REST/JSON service with a dictionary and returns a dictionary

+ (void)callServerWithURLAsync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary completionHandler:(void (^)(NSDictionary *, NSError *))handler {
    
    //Convert the Dictionary to the data that will go into the body of the message
    NSError *serializationError = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:inputDictionary options:NSJSONWritingPrettyPrinted error:&serializationError];
    
    //Checks if the bodyData was generated successfully
    if (serializationError) {
        handler(NULL, serializationError);
        return;
    }
    
    //Call server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    NSString *jsessionID = currentSessionToken.jsessionID;
    
    
    //NSString *jsessiond = [CurrentSession currentSessionInformation].jsessionID;
    [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessionID] forHTTPHeaderField:@"Cookie"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    NSLog(@"Input String: %@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *callError)
     {
         //The following code is called upon completion of the async request
         NSError *serializationError;
         NSDictionary *outputDictionary;
         NSError *error;
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
         
         //[NSThread sleepForTimeInterval:5];
         NSLog(@"Returned String: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
         
         
         if ((callError) || ([data length] == 0)) {
             error = [Helper createNSError:1 message:callError.localizedDescription] ;
             handler(outputDictionary, error);
             return;
             
         }

         
         if (httpResponse.statusCode == 403) {
             error = nil;
             [self retrySync:url outputDictionary:&outputDictionary inputDictionary:inputDictionary error:&error];
             handler(outputDictionary, error);
             return;
         }
         
         if (httpResponse.statusCode != 200) {
             error = [Helper createNSError:1 message:[NSString stringWithFormat:@"Server returned an unexpected status code (%d)", httpResponse.statusCode]];
             handler(outputDictionary, error);
             return;
         }
         
         outputDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
         
         if (serializationError) {
             error = [Helper createNSError:1 message:@"Input Searilization Error"] ;
             
             handler(outputDictionary, error);
             return;
         }
         
         error = [Helper createNSError:0 message:@"Synchronous call to server was successful"] ;
         
         
         handler(outputDictionary, error);
         
     }];
}


+(BOOL)signIn: (SignInToken *) signInToken
     userType: (NSString **) userType
        error: (NSError **) error {
    
    NSMutableDictionary *signInTokenDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *outputDictionary;
    
    CurrentSessionToken *currentSessionToken = [CurrentSessionController currentSessionToken];
    
    //Apend the apnsToken from the currentSessionToken to the signInToken
    signInToken.apnsToken = currentSessionToken.apnsToken;
    
    BOOL success = [Marshaller marshallDictionary:signInTokenDictionary object:signInToken error:error];
    
    if (!success) {
        return NO;
    }
    
    success = [Helper callServerWithURLSync:signInURL inputDictionary:signInTokenDictionary outputDictionary:&outputDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    //Marshal the objects
    CallResult *callResult=[[CallResult alloc] init];
    
    //Obtain result dictionary from the outputDictionary
    NSDictionary *callResultDictionary = [outputDictionary objectForKey:@"result"];
    
    
    success = [Marshaller marshallObject:callResult dictionary:callResultDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    if ([callResult.code isEqualToString:@"ERROR"]){
        *error = [Helper createNSError:callResult];
        return NO;
    }
    
    
    
    //Obtain additionalInfo from the outputDictionary
    NSDictionary *additionalInfoDictionary = [outputDictionary objectForKey:@"additionalInfo"];
    *userType = [additionalInfoDictionary objectForKey:@"userType"];
    currentSessionToken.jsessionID = [additionalInfoDictionary objectForKey:@"JSESSIONID"];
    currentSessionToken.userType = *userType;
    currentSessionToken.username = signInToken.username;
    currentSessionToken.password = signInToken.password;
    
    success = [CurrentSessionController writeCurrentSessionToken:currentSessionToken];
    
    if (!success) {
        *error = [Helper createNSError:120 message:@"Unable to write to keychain."];
        return NO;
    }
    
    
    *error = [Helper createNSError:callResult];
    
    return YES;
}



@end
