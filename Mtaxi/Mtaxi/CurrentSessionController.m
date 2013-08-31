//
//  CurrentSessionController.m
//  Mtaxi
//
//  Created by Marcos Vilela on 23/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "CurrentSessionController.h"

@implementation CurrentSessionController

+ (CurrentSessionToken *)currentSessionToken{
    
    PDKeychainBindings *pdKeychainBindings = [PDKeychainBindings sharedKeychainBindings];
    
    NSString *username = [pdKeychainBindings stringForKey:@"username"];
    NSString *password = [pdKeychainBindings stringForKey:@"password"];
    NSString *userType = [pdKeychainBindings stringForKey:@"userType"];
    NSString *jsessionID = [pdKeychainBindings stringForKey:@"jsessionID"];
    NSString *apnsToken = [pdKeychainBindings stringForKey:@"apnsToken"];
    
    
    CurrentSessionToken *currentSessionToken = [[CurrentSessionToken alloc]initWithUsername:username password:password userType:userType andJsessionID:jsessionID andApnsToken:apnsToken];
    
    return currentSessionToken;
    
}

+ (BOOL)writeCurrentSessionToken:(CurrentSessionToken *)currentSessionToken{
    
   //TODO: write to disk in a background thread
    
    PDKeychainBindings *pdKeychainBindings = [PDKeychainBindings sharedKeychainBindings];
    
    [pdKeychainBindings setObject:currentSessionToken.username forKey:@"username"];
    [pdKeychainBindings setObject:currentSessionToken.password forKey:@"password"];
    [pdKeychainBindings setObject:currentSessionToken.userType forKey:@"userType"];
    [pdKeychainBindings setObject:currentSessionToken.jsessionID forKey:@"jsessionID"];
    [pdKeychainBindings setObject:currentSessionToken.apnsToken forKey:@"apnsToken"];
    
    return YES;
}


+ (BOOL)resetCurrentSession{
    
    PDKeychainBindings *pdKeychainBindings = [PDKeychainBindings sharedKeychainBindings];

    [pdKeychainBindings removeObjectForKey:@"username"];
    [pdKeychainBindings removeObjectForKey:@"password"];
    [pdKeychainBindings removeObjectForKey:@"userType"];
    [pdKeychainBindings removeObjectForKey:@"jsessionID"];
    //Leave the token
    
    
//    CurrentSessionToken *emptyCurrentSessionToken = [[CurrentSessionToken alloc]init];
//    
//    [CurrentSessionController writeCurrentSessionToken:emptyCurrentSessionToken];
    
    return YES;
}

@end
