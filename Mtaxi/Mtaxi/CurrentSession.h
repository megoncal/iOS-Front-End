//
//  CurrentSession.h
//  BackendProject
//
//  Created by Marcos Vilela on 28/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FILENAME;

@interface CurrentSession : NSObject

@property (strong,nonatomic) NSString *jsessionID;
@property (strong, nonatomic) NSDate *signInDate;
@property (strong,nonatomic) NSString *userType; //driver or passenger



+ (CurrentSession *)currentSessionInformation;

- (BOOL)writeCurrentSessionInformationToPlistFile;

- (BOOL)logoutFromCurrentSession;

@end
