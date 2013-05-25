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
        [self showSuccessMessage:error.localizedDescription];
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
            error = [self createNSError:0 message:callResultObject.message];
        } else {
            error = [self createNSError:0 message:@"Unexpected error. Please try again."];
            NSLog(@"An unexpected error of system type return %@",callResultObject.message);
        }
    }
    return error;
}

#pragma mark Location object

+ (NSMutableDictionary *)createLocationDictionary:(NSString *)locationName politicalName:(NSString *)politicalName latitude:(double)latitude longitude:(double)longitude locationType:(NSString *)locationType{
    
    NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
    
    [location setObject:locationName forKey:@"locationName"];
    [location setObject:politicalName forKey:@"politicalName"];
    [location setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [location setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [location setObject:locationType forKey:@"locationType"];
    
    return location;
}

+ (Location *)createLocationObject:(NSMutableDictionary *)location{
    Location *object = [[Location alloc]init];
    object.locationName = [location objectForKey:@"locationName"];
    object.politicalName = [location objectForKey:@"politicalName"];
    object.latitude = [[location objectForKey:@"latitude"] doubleValue];
    object.longitude = [[location objectForKey:@"longitude"] doubleValue];
    object.locationType =[location objectForKey:@"locationType"];
    
    return object;
}


#pragma mark Car object
+ (Car *)createCarObject:(NSMutableDictionary *)car{
    Car *object = [[Car alloc]init];
    object.code = [car objectForKey:@"code"];
    object.description = [car objectForKey:@"description"];
    return object;
}





#pragma mark ActiveStatus object

+ (ActiveStatus *)createActiveStatusObject:(NSMutableDictionary *)activeStatus{
    ActiveStatus *object = [[ActiveStatus alloc]init];
    object.code = [activeStatus objectForKey:@"code"];
    object.description = [activeStatus objectForKey:@"description"];
    return object;
}




//Calls a REST/JSON service with a dictionary and returns a dictionary

+ (BOOL)callServerWithURLSync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary outputDictionary:(NSDictionary**) outputDictionary myerror:(NSError **)myerror {
    
    //Convert the Dictionary to the data that will go into the body of the message
    NSError *serializationError = NULL;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:inputDictionary options:NSJSONWritingPrettyPrinted error:&serializationError];
    
    //Checks if the bodyData was generated successfully
    if (serializationError) {
        *myerror = [Helper createNSError:1 message:@"Input Searilization Error"] ;
        return NO;
    }
    
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
    //[NSThread sleepForTimeInterval:5];
    NSLog(@"Returned String: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    if ((callError) && ([data length] > 0)) {
        *myerror = [Helper createNSError:1 message:[NSString stringWithFormat:@"Error calling server (%@)", callError.localizedDescription]] ;
        return NO;
    }
    
    if (responseCode.statusCode != 200) {
        *myerror = [Helper createNSError:1 message:[NSString stringWithFormat:@"Server returned an unexpected status code (%d)", responseCode.statusCode]] ;
        return NO;
    }
    
    *outputDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
    
    if (serializationError) {
        *myerror = [Helper createNSError:1 message:@"Input Searilization Error"] ;
        return NO;
    }
    
    *myerror = [Helper createNSError:0 message:@"Synchronous call to server was successful"] ;
    return YES;
    
}

//Calls a REST/JSON service with a dictionary and returns a dictionary

+ (void)callServerWithURLAsync:(NSURL *) url inputDictionary:(NSMutableDictionary *) inputDictionary completionHandler:(void (^)(NSDictionary *, NSError *))handler {
    
    //Convert the Dictionary to the data that will go into the body of the message
    NSError *inputSerializationError = nil;
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
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        
        NSLog(@"Input String: %@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
        
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             //The following code is called upon completion of the async request
             NSDictionary *outputDictionary;
             NSError *callError;
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
             
             //[NSThread sleepForTimeInterval:5];
             NSLog(@"Returned String: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
          
             
             //Process the data received from the server
             if ([data length] > 0 && error == nil){
                 
                 NSError *serializationError = NULL;
                 
                 NSLog(@"Http response status code: %i",httpResponse.statusCode);
                 
                 if (httpResponse.statusCode == 200) {
                     outputDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
                     callError = serializationError;
                     
                 } else if (httpResponse.statusCode == 403){
                     //TODO: Not authorized error
                 }else{
                     callError = [Helper createErrorForMEUserClass:@"Unexpected error."];
                 }
             }
             
             else if (error != nil){
                 callError = [Helper createErrorForMEUserClass:error.localizedDescription];
             }
             
             
             else {
                 callError = [Helper createErrorForMEUserClass:@"Unexpected error."];
             }
             
             handler(outputDictionary, callError);
             
         }];
        
    } else {
        handler(NULL, inputSerializationError);
    }
}

@end
