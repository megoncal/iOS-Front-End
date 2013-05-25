//
//  Ride.m
//  Mtaxi
//
//  Created by Marcos Vilela on 18/05/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//


#import "Ride.h"

#define createRideURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/ride/createRide"]

@implementation Ride


- (void)createRideOnTheServer:(void (^)(NSError *, CallResult *))handler{
    
    NSError *error;
    
    NSMutableDictionary *createRideDictionary = self.createRideDictionary;
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:createRideDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURL *url = createRideURL;
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSLog(@"Input String: %@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPBody:bodyData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        CallResult *callResultObject;
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            NSLog(@"Http response status code: %i",httpResponse.statusCode);
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *callResultDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (error == nil) {
                   
                   callResultObject = [CallResult marshallObject:callResultDictionary];
                }
                
            }
            else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error."];
            }
        }else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
        handler(error,callResultObject);
    }];
}


- (NSMutableDictionary *) createRideDictionary{
    

    NSMutableDictionary *createRideDictionary = [[NSMutableDictionary alloc]init];
    
    [createRideDictionary setObject:self.pickUpLocation.locationDictionary forKey:@"pickUpLocation"];
    
    [createRideDictionary setObject:self.dropOffLocation.locationDictionary forKey:@"dropOffLocation"];

    [createRideDictionary setObject:self.stringPickUpDate forKey:@"pickupDateTime"];
    
    return createRideDictionary;

}


- (NSString *)stringPickUpDate{
    
    NSString *stringDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    stringDate = [dateFormatter stringFromDate:self.pickUpDate];
    
    return stringDate;
}


- (NSString *)stringFullFormatPickUpDate{
    
    NSString *stringDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    stringDate = [dateFormatter stringFromDate:self.pickUpDate];
    
    return stringDate;
}



@end
