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

+ (BOOL) marshallObject:(NSObject *) object dictionary:(NSDictionary *)dictionary error: (NSError **) error;
+ (BOOL) marshallDictionary:(NSMutableDictionary *)dictionary object: (NSObject *)object error: (NSError **) error;

@end
