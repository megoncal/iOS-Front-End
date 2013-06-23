//
//  CurrentSessionController.h
//  Mtaxi
//
//  Created by Marcos Vilela on 23/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentSessionController.h"
#import "PDKeychainBindings.h"
#import "CurrentSessionToken.h"

@interface CurrentSessionController : NSObject


+ (CurrentSessionToken *)currentSessionToken;

+ (BOOL) writeCurrentSessionToken: (CurrentSessionToken *)currentSessionToken;

+ (BOOL) resetCurrentSession;

//
//- (BOOL)writeCurrentSessionInformationToPlistFile;
//
//- (BOOL)logoutFromCurrentSession;



@end
