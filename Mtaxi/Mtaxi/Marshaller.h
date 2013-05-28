//
//  Marshaller.h
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/27/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Marshaller : NSObject

+ (void) marshallObject:(NSObject *) object dictionary:(NSDictionary *)dictionary;
+ (void)marshallDictionary:(NSMutableDictionary *)dictionary object: (NSObject *)object;

@end
