//
//  ActiveStatus.m
//  BackendProject
//
//  Created by Marcos Vilela on 21/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "ActiveStatus.h"

@implementation ActiveStatus

-(id) initWithCode: (NSString *)code {
    if (self == [super init]) {
        self.code = code;
    }
    return self;
}

@end
