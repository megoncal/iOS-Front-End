//
//  CurrentSession.h
//  BackendProject
//
//  Created by Marcos Vilela on 28/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString * const FILENAME;

@interface CurrentSessionToken : NSObject


@property (strong,nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong,nonatomic) NSString *userType;
@property (strong,nonatomic) NSString *jsessionID;
@property (strong,nonatomic) NSString *apnsToken;


-(id) initWithUsername: (NSString *)username password:(NSString *)password userType:(NSString *)userType andJsessionID:(NSString *)jsessionID andApnsToken:(NSString *)andApnsToken;

//+ (CurrentSession *)currentSessionInformation;
//
//- (BOOL)writeCurrentSessionInformationToPlistFile;
//
//- (BOOL)logoutFromCurrentSession;

@end
