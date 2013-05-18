//
//  CallResult.h
//  BackendProject
//
//  Created by Eduardo Goncalves on 5/17/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallResult : NSObject

@property (strong,nonatomic) NSString *type;
@property (strong, nonatomic) NSString *code;
@property (strong,nonatomic) NSString *message;

@end
