//
//  UserServerController.m
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/28/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "UserServerController.h"

@implementation UserServerController

+(BOOL)signIn: (SignInToken *) token
     userType: (NSString **) userType
        error: (NSError **) error {
    
    NSMutableDictionary *signInTokenDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *outputDictionary;
    
    BOOL success = [Marshaller marshallDictionary:signInTokenDictionary object:token error:error];

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
    
    
    CurrentSession *currentSession = [[CurrentSession alloc] init];
    
    //Obtain additionalInfo from the outputDictionary
    NSDictionary *additionalInfoDictionary = [outputDictionary objectForKey:@"additionalInfo"];
    currentSession.jsessionID = [additionalInfoDictionary objectForKey:@"JSESSIONID"];
    *userType = [additionalInfoDictionary objectForKey:@"userType"];
    [CurrentSession writeCurrentSessionInformationToPlistFile:currentSession];
    *error = [Helper createNSError:callResult];
    
    return YES;
}

#pragma mark - SignUp

+ (BOOL)signUpUser:(User *) user error:(NSError **) error {

    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *callResultDictionary;
    
    BOOL success = [Marshaller marshallDictionary:userDictionary object:user error:error];
    
    if (!success) {
        return NO;
    }
    
    success = [Helper callServerWithURLSync:signUpURL inputDictionary:userDictionary outputDictionary:&callResultDictionary error:error];
    
    if (!success) {
        //error has been assigned already, just return NO
        return NO;
    }
    
    //Marshal the objects
    CallResult *callResult=[[CallResult alloc] init];
    
    success = [Marshaller marshallObject:callResult dictionary:callResultDictionary error:error];
    
    if (!success) {
        return NO;
    }
    
    *error = [Helper createNSError:callResult];
    
    if ([callResult.code isEqualToString:@"ERROR"]){
        return NO;
    }
    
    return YES;
}



+(void)retrieveLoggedUserDetails:(void (^)(User *, NSError *))handler{
    
    User *userObject=[[User alloc] init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];
    
    [Helper callServerWithURLAsync:loggedUserDetails inputDictionary:bodyDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error)
     {
         //If not error set the handler object
         //TODO: What if there is an error
         if (error.code == 0) {
             NSDictionary *userDictionary = [outputDictionary objectForKey:@"user"];
             [Marshaller marshallObject: userObject dictionary:userDictionary error:&error];
             
             //TODO: Need to handle userType better
             //userObject.userType = @"passenger";
             
             handler(userObject,error);
         }else{
             handler(userObject,error);
         }
         
     }];
    
}

//TODO: Make this synchronous starting at the ViewController?
+(void)updateLoggedUserDetails:(User *)user completionHandler:(void (^)(User *, NSError *))handler{
    
    NSError *error = [[NSError alloc] init];
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *callResultDictionary;
    NSDictionary *outputDictionary;
    
    
    BOOL success = [Marshaller marshallDictionary:userDictionary object:user error:&error];
    if (!success) {
        handler (NULL,error);
        return;
        
    }
    
    success = [Helper callServerWithURLSync:updateLoggedUserURL inputDictionary:userDictionary outputDictionary:&outputDictionary error:&error];
    
    if (!success) {
        handler (NULL,error);
        return;
        
    }
    
    //Obtain specific dictionaries from the outputDictionary
    userDictionary = [outputDictionary objectForKey:@"user"];
    callResultDictionary = [outputDictionary objectForKey:@"result"];
    
    //Marshal the objects
    User *userObject=[[User alloc] init];
    CallResult *callResultObject=[[CallResult alloc] init];
    
    success  = [Marshaller marshallObject:userObject dictionary:userDictionary error:&error];
    if (!success) {
        handler (NULL,error);
        return;
        
    }
    
    //TODO: Need to handle userType better
    //userObject.userType = @"passenger";
    
    
    success = [Marshaller marshallObject:callResultObject dictionary:callResultDictionary error:&error];

    if (!success) {
        handler (NULL,error);
        return;
        
    }

    //Create an error from the call Result - This maybe success or not
    error = [Helper createNSError:callResultObject];
    handler(userObject, error);
}


@end
