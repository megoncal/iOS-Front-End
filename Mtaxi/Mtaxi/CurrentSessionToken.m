//
//  CurrentSession.m
//  BackendProject
//
//  Created by Marcos Vilela on 28/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "CurrentSessionToken.h"

//NSString * const FILENAME = @"CurrentSession.plist";

@implementation CurrentSessionToken




- (id)initWithUsername:(NSString *)username password:(NSString *)password userType:(NSString *)userType andJsessionID:(NSString *)jsessionID{
    
    if (self = [super init]) {
        self.username = username;
        self.userType = userType;
        self.password = password;
        self.jsessionID = jsessionID;
    }
    return self;
}


//#pragma mark - CurrentSessionInformation

//+ (CurrentSession *)currentSessionInformation{
//    
//    CurrentSession *currentSession;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:FILENAME];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:path]) {
//        NSDictionary *currentSessionPlistfile = [[NSDictionary alloc] initWithContentsOfFile:path];
//        currentSession = [[CurrentSession alloc] init];
//        currentSession.jsessionID = [currentSessionPlistfile objectForKey:@"jsessionid"];
//        currentSession.userType = [currentSessionPlistfile objectForKey:@"userType"];
//    }
//    return currentSession;
//}
//
//
//#pragma mark - PlistFile
//
//- (BOOL) writeCurrentSessionInformationToPlistFile{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:FILENAME];
//    
//    NSDictionary *currentSessionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                              self.jsessionID, @"jsessionid",
//                                              self.userType, @"userType",
//                                              nil];
//    
//    NSLog(@"About to write currentSession Info to file ->%@<-", FILENAME);
//    
//    return [currentSessionDictionary writeToFile:path atomically:YES];
//}
//
//- (BOOL)logoutFromCurrentSession{
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:FILENAME];
//    
//    NSError *error;
//    
//    NSLog(@"About to delete currentSession file ->%@<-", FILENAME);
//    
//    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
//    {
//        return NO;
//    }
//    
//    return YES;
//}
//
@end
