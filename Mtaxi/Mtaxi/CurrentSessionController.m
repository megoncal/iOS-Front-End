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
    
    
    CurrentSessionToken *currentSessionToken = [[CurrentSessionToken alloc]initWithUsername:username password:password userType:userType andJsessionID:jsessionID];
    
    return currentSessionToken;
    
}

+ (BOOL)writeCurrentSessionToken:(CurrentSessionToken *)currentSessionToken{
    
   //TODO: write to disk in a background thread
    
    PDKeychainBindings *pdKeychainBindings = [PDKeychainBindings sharedKeychainBindings];
    
    [pdKeychainBindings setObject:currentSessionToken.username forKey:@"username"];
    [pdKeychainBindings setObject:currentSessionToken.password forKey:@"password"];
    [pdKeychainBindings setObject:currentSessionToken.userType forKey:@"userType"];
    [pdKeychainBindings setObject:currentSessionToken.jsessionID forKey:@"jsessionID"];
    
    return YES;
}

+ (BOOL)resetCurrentSession{
    
    CurrentSessionToken *emptyCurrentSessionToken = [[CurrentSessionToken alloc]init];
    
    [CurrentSessionController writeCurrentSessionToken:emptyCurrentSessionToken];
    
    return YES;
}

@end
