//
//  CallResult.m
//  BackendProject
//
//  Created by Eduardo Goncalves on 5/17/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "CallResult.h"

@implementation CallResult

//CallResult

+ (CallResult *)marshallObject:(NSDictionary *)callResultDictionary{
    
    CallResult *callResultObject = [[CallResult alloc] init];
    
    callResultObject.type = [callResultDictionary objectForKey:@"type"];
    callResultObject.code = [callResultDictionary objectForKey:@"code"];
    callResultObject.message = [callResultDictionary objectForKey:@"message"];
    
    return callResultObject;
}


@end
