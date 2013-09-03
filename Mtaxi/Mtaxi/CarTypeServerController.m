//
//  CarTypeServerController.m
//  Mtaxi
//
//  Created by Eduardo Goncalves on 6/4/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "CarTypeServerController.h"

@implementation CarTypeServerController

//retrieve a list of car types from the server
+(void)retrieverCarTypes: (void (^)(NSArray *carTypes, NSError* error))handler {
 
    
    //The server call to retrieve the logged user details contains a blank message (i.e. {})
    NSMutableDictionary *bodyDictionary = [[NSMutableDictionary alloc] init];
    
    NSURL *url = [NSURL URLWithString:carTypeURL];
    [Helper callServerWithURLAsync:url inputDictionary:bodyDictionary completionHandler:^(NSDictionary *outputDictionary, NSError *error)
     {
         //If not error set the handler object
         if (error.code == 0) {
             NSDictionary *carTypesDictionary = [outputDictionary objectForKey:@"carTypes"];
             NSMutableArray *carTypes = [[NSMutableArray alloc] init];
             for (NSDictionary *aCarTypeDictionary in carTypesDictionary) {
                 CarType *carType = [[CarType alloc] init];
                 BOOL success = [Marshaller marshallObject: carType dictionary:aCarTypeDictionary error:&error];
                 if (!success) {
                     handler (nil,error);
                 }
                 [carTypes addObject:carType];
             }
             
             handler(carTypes,error);
         } else{
             handler(nil,error);
         }
         
     }];
}
@end
