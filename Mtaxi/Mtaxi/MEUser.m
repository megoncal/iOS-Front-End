//
//  MEUser.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

//#define loggedUserDetails [NSURL URLWithString:@"http://localhost:8080/moovt/user/retrieveLoggedUserDetails"]
//#define signInURL [NSURL URLWithString:@"http://localhost:8080/moovt/login/authenticateUser"]
//#define signUpURL [NSURL URLWithString:@"http://localhost:8080/moovt/user/createUser"]
//#define updateLoggedUserURL [NSURL URLWithString:@"http://localhost:8080/moovt/user/updateLoggedUser"]

#define loggedUserDetails [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/retrieveLoggedUserDetails"]
#define signInURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/login/authenticateUser"]
#define signUpURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/createUser"]
#define updateLoggedUserURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/updateLoggedUser"]



#import "MEUser.h"

@implementation MEUser



#pragma mark - SignIn

+ (NSError *)signInWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Type:(NSString *)type UserType:(NSString *__autoreleasing *) userType{
    
    NSError *error;
    
    
    
    NSMutableDictionary *authenticateDictionary = [[NSMutableDictionary alloc] init];
    
    [authenticateDictionary setObject:type forKey:@"type"];
    [authenticateDictionary setObject:tenantName forKey:@"tenantname"];
    [authenticateDictionary setObject:username forKey:@"username"];
    [authenticateDictionary setObject:password forKey:@"password"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:authenticateDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = signInURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSURLResponse *response;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    
                    NSString *code = [returnedDictionary objectForKey:@"code"];
                    NSString *message = [returnedDictionary objectForKey:@"message"];
                    NSString *jsessionid = [returnedDictionary objectForKey:@"JSESSIONID"];
                    NSString *type = [returnedDictionary objectForKey:@"type"];
                    NSString *returnedUserType = [returnedDictionary objectForKey:@"userType"];
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        CurrentSession *currentSession = [[CurrentSession alloc] init];
                        currentSession.jsessionID = jsessionid;
                        *userType = returnedUserType;
                        [CurrentSession writeCurrentSessionInformationToPlistFile:currentSession];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            error = [Helper createErrorForMEUserClass:message];
                        }
                        else{
                            error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                        }
                    }
                    
                }
            }else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
    }
    return error;
}

#pragma mark - SignUp

+ (NSError *)signUpWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Email:(NSString *)email FirstName:(NSString *)firstName LastName:(NSString *)lastName PhoneNumber:(NSString *)phoneNumber Locale:(NSString *)locale{
    
    
    NSError *error;
    
    NSMutableDictionary *passengerSignUpDictionary = [[NSMutableDictionary alloc] init];
    
    [passengerSignUpDictionary setObject:tenantName forKey:@"tenantname"];
    [passengerSignUpDictionary setObject:email forKey:@"email"];
    [passengerSignUpDictionary setObject:username forKey:@"username"];
    [passengerSignUpDictionary setObject:password forKey:@"password"];
    [passengerSignUpDictionary setObject:firstName forKey:@"firstName"];
    [passengerSignUpDictionary setObject:lastName forKey:@"lastName"];
    [passengerSignUpDictionary setObject:phoneNumber forKey:@"phone"];
    [passengerSignUpDictionary setObject:locale forKey:@"locale"];
    
    //to-do
    NSMutableDictionary *passengerExtraInformation = [[NSMutableDictionary alloc] init];
    [passengerSignUpDictionary setObject:passengerExtraInformation forKey:@"passenger"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:passengerSignUpDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = signUpURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSURLResponse *response;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    
                    NSString *code = [returnedDictionary objectForKey:@"code"];
                    NSString *message = [returnedDictionary objectForKey:@"message"];
                    NSString *type = [returnedDictionary objectForKey:@"type"];
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        
                        //to-do
                        //remove the signIn method from here
                        NSString *returnedUser;
                        error = [MEUser signInWithUsername:username Password:password TenantName:@"WorldTaxi" Type:@"self" UserType:&returnedUser];
                        
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            error = [Helper createErrorForMEUserClass:message];
                        }
                        else{
                            error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                        }
                    }
                    
                }
            }else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
    }else{
        error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
    }
    
    return error;
}

+ (NSError *)signUpWithDriverUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Email:(NSString *)email FirstName:(NSString *)firstName LastName:(NSString *)lastName PhoneNumber:(NSString *)phoneNumber Locale:(NSString *)locale CarType:(Car *)carType ServedLocation:(Location *)location ActiveStatus:(NSString *)activeStatus RadiusServed:(Radius *)radiusServed{
    
    
    NSError *error;
    
    NSMutableDictionary *driverExtraInformation = [[NSMutableDictionary alloc] init];
    
    [driverExtraInformation setObject:carType.code forKey:@"carType"];
    
    NSMutableDictionary *servedLocation = [location locationDictionary];
    
    [driverExtraInformation setObject:servedLocation forKey:@"servedLocation"];
    
    [driverExtraInformation setObject:activeStatus forKey:@"activeStatus"];
    
    
    NSMutableDictionary *driverSignUpDictionary = [[NSMutableDictionary alloc] init];
    
    [driverSignUpDictionary setObject:tenantName forKey:@"tenantname"];
    [driverSignUpDictionary setObject:email forKey:@"email"];
    [driverSignUpDictionary setObject:username forKey:@"username"];
    [driverSignUpDictionary setObject:password forKey:@"password"];
    [driverSignUpDictionary setObject:firstName forKey:@"firstName"];
    [driverSignUpDictionary setObject:lastName forKey:@"lastName"];
    [driverSignUpDictionary setObject:phoneNumber forKey:@"phone"];
    [driverSignUpDictionary setObject:locale forKey:@"locale"];
    [driverSignUpDictionary setObject:driverExtraInformation forKey:@"driver"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:driverSignUpDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    if (error == nil) {
        
        NSURL *url = signUpURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSURLResponse *response;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    
                    NSString *code = [returnedDictionary objectForKey:@"code"];
                    NSString *message = [returnedDictionary objectForKey:@"message"];
                    NSString *type = [returnedDictionary objectForKey:@"type"];
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        
                        //to-do
                        //remove signIn from here
                        NSString *returnedUserType;
                        error = [MEUser signInWithUsername:username Password:password TenantName:@"WorldTaxi" Type:@"self" UserType:&returnedUserType];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            error = [Helper createErrorForMEUserClass:message];
                        }
                        else{
                            error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                            
                        }
                    }
                    
                }
            }else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
    }else{
        error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
    }
    
    return error;
    
}



+(void)retrieveLoggedUserDetails:(void (^)(MEUser *, NSError *))handler{
    
    MEUser *userObject=[[MEUser alloc] init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];
    
    //[self callServerWithURLSync:loggedUserDetails inputDictionary:bodyDictionary outputDictionary:&outputDictionary callStatus:&error];
    
    [Helper callServerWithURLAsync:loggedUserDetails inputDictionary:bodyDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error)
     {
         //If not error set the handler object
         //TODO: What if there is an error
         if (error.code == 0) {
             NSDictionary *userDictionary = [outputDictionary objectForKey:@"user"];
             //[MEUser marshallObject:userDictionary userObject:userObject];
             [Marshaller marshallObject: userObject dictionary:userDictionary];
             //TODO: Need to handle userType better
             userObject.userType = @"passenger";
             handler(userObject,error);
         }else{
             handler(userObject,error);
         }
         
     }];
    
}

//TODO: Make this synchronous starting at the ViewController?
+(void)updateLoggedUserDetails:(MEUser *)user completionHandler:(void (^)(MEUser *, NSError *))handler{
    
    NSError *myerror = [[NSError alloc] init];
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *callResultDictionary;
    NSDictionary *outputDictionary;
    
    
    [Marshaller marshallDictionary:userDictionary object:user];
    
    
    
    BOOL success = [Helper callServerWithURLSync:updateLoggedUserURL inputDictionary:userDictionary outputDictionary:&outputDictionary myerror:&myerror];
    
    if (!success) {
        handler (NULL,myerror);
        return;
        
    }
    
    //Obtain specific dictionaries from the outputDictionary
    userDictionary = [outputDictionary objectForKey:@"user"];
    callResultDictionary = [outputDictionary objectForKey:@"result"];
    
    //Marshal the objects
    MEUser *userObject=[[MEUser alloc] init];
    CallResult *callResultObject=[[CallResult alloc] init];
    
    //[MEUser marshallObject:userDictionary userObject:userObject];
    [Marshaller marshallObject:userObject dictionary:userDictionary];
    //TODO: Need to handle userType better
    userObject.userType = @"passenger";
    
    [Marshaller marshallObject:callResultObject dictionary:callResultDictionary];
    
    //Create an error from the call Result - This maybe success or not
    myerror = [Helper createNSError:callResultObject];
    handler(userObject, myerror);
}





@end
