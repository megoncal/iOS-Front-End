//
//  Car.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "CarType.h"




@implementation CarType


//+ (void)retrieverCarTypes:(void (^)(NSArray *, NSError *))handler{
//    
//    NSURL *url = carTypeURL;
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        NSMutableArray *carTypes;
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        
//        if ([data length] > 0 && error == nil){
//            
//            NSLog(@"Http response status code: %i",httpResponse.statusCode);
//            
//            if (httpResponse.statusCode == 200) {
//                
//                //convert json data to NSDictionary
//                NSArray *returnedArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//                if (error == nil) {
//                    
//                    carTypes = [[NSMutableArray alloc] init];
//                    
//                    for (NSDictionary *dictionary in returnedArray) {
//                        CarType* car = [[CarType alloc]init];
//                        car.code = [dictionary objectForKey:@"code"];
//                        car.description = [dictionary objectForKey:@"description"];
//                        [carTypes addObject:car];
//                    }
//                    
//                }
//                
//            }
//            else{
//                error = [Helper createErrorForMEUserClass:@"Unexpected error."];
//            }
//        }else if ([data length] == 0 && error == nil){
//            //empty replay
//        }
//        else if (error != nil){
//            error = [Helper createErrorForMEUserClass:error.localizedDescription];
//        }
//        handler(carTypes,error);
//    }];
//    
//}


//
//+ (CarType *)createCarObject:(NSMutableDictionary *)car{
//    CarType *object = [[CarType alloc]init];
//    object.code = [car objectForKey:@"code"];
//    object.description = [car objectForKey:@"description"];
//    return object;
//}
//
//- (id) init



@end
