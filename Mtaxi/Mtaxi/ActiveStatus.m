//
//  ActiveStatus.m
//  BackendProject
//
//  Created by Marcos Vilela on 21/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "ActiveStatus.h"

@implementation ActiveStatus




+ (ActiveStatus *)createActiveStatusObject:(NSMutableDictionary *)activeStatus{
    ActiveStatus *object = [[ActiveStatus alloc]init];
    object.code = [activeStatus objectForKey:@"code"];
    object.description = [activeStatus objectForKey:@"description"];
    return object;
}



@end
