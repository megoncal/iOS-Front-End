//
//  MEUser.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

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
    
    NSMutableDictionary *servedLocation = [Helper createLocationDictionary:location.locationName politicalName:location.politicalName latitude:location.latitude longitude:location.longitude locationType:location.locationType];
    
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


+ (void)marshallObject:(NSDictionary *)userDictionary userObject:(MEUser *)userObject {
    userObject.userId = [userDictionary objectForKey:@"id"];
    userObject.version = [userDictionary objectForKey:@"version"];
    userObject.username = [userDictionary objectForKey:@"username"];
    userObject.firstName = [userDictionary objectForKey:@"firstName"];
    userObject.lastName = [userDictionary objectForKey:@"lastName"];
    userObject.phone = [userDictionary objectForKey:@"phone"];
    userObject.email = [userDictionary objectForKey:@"email"];
    id driver = [userDictionary objectForKey:@"driver"];
    if (driver) {
        userObject.userType = @"driver";
        //to-do
        //buscar informações do driver....
        
        NSDictionary *driverExtraInformation = driver;
        
        //servedLocation
        NSMutableDictionary *driverServedLocation = [driverExtraInformation objectForKey:@"servedLocation"];
        userObject.servedLocation = [Helper createLocationObject:driverServedLocation];
        
        
        //activeStatus
        NSMutableDictionary *activeStatus = [driverExtraInformation objectForKey:@"activeStatus"];
        userObject.activeStatus = [Helper createActiveStatusObject:activeStatus];
        
        
        
        //carType
        NSMutableDictionary *carType = [driverExtraInformation objectForKey:@"carType"];
        userObject.carType = [Helper createCarObject:carType];
        
    }
    else{
        userObject.userType = @"passenger";
    }
}


+ (void)marshallObject:(NSDictionary *)callResultDictionary callResultObject:(CallResult *)callResultObject {
    callResultObject.type = [callResultDictionary objectForKey:@"type"];
    callResultObject.code = [callResultDictionary objectForKey:@"code"];
    callResultObject.message = [callResultDictionary objectForKey:@"message"];
  
}


+ (void)marshallDictionary:(MEUser *)user updateLoggedUser:(NSMutableDictionary *)updateLoggedUser {
    [updateLoggedUser setObject:user.version forKey:@"version"];
    [updateLoggedUser setObject:user.firstName forKey:@"firstName"];
    [updateLoggedUser setObject:user.lastName forKey:@"lastName"];
    [updateLoggedUser setObject:user.phone forKey:@"phone"];
    //TODO: Discuss this with Marcos
    //    [updateLoggedUser setObject:user.username forKey:@"username"];
    //    [updateLoggedUser setObject:user.version forKey:@"password"];
    
    [updateLoggedUser setObject:user.email forKey:@"email"];
    
    
    if ([user.userType isEqualToString:@"driver"]) {
        NSMutableDictionary *driverInfo = [[NSMutableDictionary alloc] init];
        [driverInfo setObject:user.carType.code forKey:@"carType"];
        NSMutableDictionary *servedLocation = [Helper createLocationDictionary:user.servedLocation.locationName politicalName:user.servedLocation.politicalName latitude:user.servedLocation.latitude longitude:user.servedLocation.longitude locationType:user.servedLocation.locationType];
        [driverInfo setObject:servedLocation forKey:@"servedLocation"];
        [driverInfo setObject:user.activeStatus.code forKey:@"activeStatus"];
        [updateLoggedUser setObject:driverInfo forKey:@"driver"];
    }
}


//Calls a REST/JSON service with a dictionary and returns a dictionary

+ (void)callServerWithURL:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary callStatus:(NSError **)error {
    
    //Convert the Dictionary to the data that will go into the body of the message
    NSError *inputSerializationError = NULL;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:inputDictionary options:NSJSONWritingPrettyPrinted error:&inputSerializationError];
    
    //Checks if the bodyData was generated successfully
    if (!inputSerializationError) {
        
        //Call server
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:bodyData];
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        NSString *jsessiond = [CurrentSession currentSessionInformation].jsessionID;
        [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessiond] forHTTPHeaderField:@"Cookie"];
        
        NSHTTPURLResponse *responseCode = NULL;
        NSError *callError = NULL;
        
        NSLog(@"Input String: %@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);

        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&callError];
    
        
        NSLog(@"Returned String: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        [NSThread sleepForTimeInterval:10];
        
        //Process the data received from the server
        if ([data length] > 0 && callError == nil){
            
            if (responseCode.statusCode == 200) {
                //convert json data to NSDictionary that was passed as a reference
                
                NSError *serializationError = NULL;
                
                *outputDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
            }
            else if (responseCode.statusCode == 403){
                
                // TODO: Is this really possible
                *error = [Helper createErrorForMEUserClass:@"Unauthorized access."];
                
                
            }
            else{
                *error = [Helper createErrorForMEUserClass:@"Unexpected error."];
            }
        }else if ([data length] == 0 && error == nil){
            //TODO: Is this possible
        }
        else if (*error != NULL){
            *error = [Helper createErrorForMEUserClass:callError.localizedDescription];
        }
        
    }
    
}






+ (void)getErrorAndMessage:(NSString **)message_p error_p:(NSError **)error_p callResultObject:(CallResult *)callResultObject {
    if ([callResultObject.code isEqualToString:@"SUCCESS"]) {
        *message_p = callResultObject.message;
    } else {
        if ([callResultObject.type isEqualToString:@"USER"]) {
            *error_p = [Helper createErrorForMEUserClass:*message_p];
            *message_p = callResultObject.message;
        } else {
            *error_p = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            *message_p = @"Unexpected error. Please try again.";
        }
    }
}


+(void)retrieveLoggedUserDetails:(void (^)(MEUser *, NSError *))handler{
    
    NSError *error;
    MEUser *userObject=[[MEUser alloc] init];
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *outputDictionary;
    
    [self callServerWithURL:loggedUserDetails inputDictionary:bodyDictionary outputDictionary:&outputDictionary callStatus:&error];
    
    //If not error set the handler object
    //TODO: What if there is an error
    if (!error) {
        NSDictionary *userDictionary = [outputDictionary objectForKey:@"user"];
        [MEUser marshallObject:userDictionary userObject:userObject];
        handler(userObject,error);
    }
    
    
}

+(void)updateLoggedUserDetails:(MEUser *)user completionHandler:(void (^)(MEUser *, NSError *, NSString *))handler{
    
    NSError *error;
    MEUser *userObject=[[MEUser alloc] init];
    CallResult *callResultObject=[[CallResult alloc] init];
    
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    [MEUser marshallDictionary:user updateLoggedUser:userDictionary];
    
    NSDictionary *outputDictionary;

    [MEUser callServerWithURL:updateLoggedUserURL inputDictionary:userDictionary outputDictionary:&outputDictionary callStatus:&error];

    //TODO: What if there is an error
    if (!error) {
        NSDictionary *userDictionary = [outputDictionary objectForKey:@"user"];
        //TODO: Test this once the server code is adjusted
        NSDictionary *callResultDictionary = [outputDictionary objectForKey:@"result"];
        [MEUser marshallObject:userDictionary userObject:userObject];
        [MEUser marshallObject:callResultDictionary callResultObject:callResultObject];
        //handler(userObject,error);
        
        NSString *message;
        [self getErrorAndMessage:&message error_p:&error callResultObject:callResultObject];
        
        NSLog(@"TEST %@",message);

        handler(userObject, error, message);
    }
}




@end
