//
//  Marshaller.m
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/27/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "Marshaller.h"

@implementation Marshaller


+ (void) marshallObject:(NSObject *) object dictionary:(NSDictionary *)dictionary {
    
    Class c = [object class];
    NSLog(@"Class is %@", c);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(c, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
        
        //Property Name
        const char * propertyNameAux = property_getName(property);
        NSString *propertyName = [[NSString alloc] initWithUTF8String:propertyNameAux];
        
        //Property Type
        const char * attributesAux = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:attributesAux];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        
        //TODO: Add if for the additional types that we have in our code
        if ([typeAttribute isEqualToString:@"T@\"NSString\""]) {
            NSString * dictionaryValue = [dictionary objectForKey:propertyName];
            NSLog(@"About to set the property %@ with the value %@",propertyName, dictionaryValue);
            [object setValue:dictionaryValue forKey:propertyName];
        } else {
            //Check if the type is an class, obtain the sub dictionary, and if the subdictionary exists marshal the object.
            NSDictionary * subDictionary = [dictionary objectForKey:propertyName];
            if (subDictionary) {
                id innerObject = [[NSClassFromString(propertyName) alloc] init];
                if (innerObject){
                    NSLog(@"About to set the property %@ with the value %@",propertyName, innerObject);
                    [self marshallObject:innerObject dictionary:subDictionary];
                    [object setValue:innerObject forKey:propertyName];
                }
            }
            
            
        }
        //TODO: userObject.userType = @"driver" /@"passenger"
        
    }
    
}
//+ (void)marshallObject:(NSDictionary *)userDictionary userObject:(MEUser *)userObject {
//    userObject.userId = [userDictionary objectForKey:@"id"];
//    userObject.version = [userDictionary objectForKey:@"version"];
//    userObject.username = [userDictionary objectForKey:@"username"];
//    userObject.firstName = [userDictionary objectForKey:@"firstName"];
//    userObject.lastName = [userDictionary objectForKey:@"lastName"];
//    userObject.phone = [userDictionary objectForKey:@"phone"];
//    userObject.email = [userDictionary objectForKey:@"email"];
//    id driver = [userDictionary objectForKey:@"driver"];
//    if (driver) {
//        userObject.userType = @"driver";
//        //to-do
//        //buscar informações do driver....
//
//        NSDictionary *driverExtraInformation = driver;
//
//        //servedLocation
//        NSMutableDictionary *driverServedLocation = [driverExtraInformation objectForKey:@"servedLocation"];
//        userObject.servedLocation = [Location locationObject:driverServedLocation];
//
//
//        //activeStatus
//        NSMutableDictionary *activeStatus = [driverExtraInformation objectForKey:@"activeStatus"];
//        userObject.activeStatus = [ActiveStatus createActiveStatusObject:activeStatus];
//
//
//        //carType
//        NSMutableDictionary *carType = [driverExtraInformation objectForKey:@"carType"];
//        userObject.carType = [Car createCarObject:carType];
//
//
//    }
//    else{
//        userObject.userType = @"passenger";
//    }
//}


+ (void)marshallDictionary:(NSMutableDictionary *)dictionary object: (NSObject *)object {
    
    Class c = [object class];
    NSLog(@"Class is %@", c);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(c, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //Property Name
        const char * propertyNameAux = property_getName(property);
        NSString *propertyName = [[NSString alloc] initWithUTF8String:propertyNameAux];
        
        //Property Type
        const char * attributesAux = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:attributesAux];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        typeAttribute = [typeAttribute stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        typeAttribute = [typeAttribute stringByReplacingOccurrencesOfString:@"@" withString:@""];
        typeAttribute = [typeAttribute substringFromIndex:1];
        
        
        //TODO: Add if for the additional types that we have in our code
        if ([typeAttribute isEqualToString:@"NSString"]) {
            NSString * value = [object valueForKey:propertyName];
            if (value == nil) {
                value = [[NSString alloc] init];
            }
            NSLog(@"About to add NSString ->%@<- to key ->%@<-", value, propertyName);
            [dictionary setObject:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"NSDate"]) {
            NSDate * dateValue = [object valueForKey:propertyName];
            if (dateValue == nil) {
                dateValue = [[NSDate alloc] init];
            }
            
            //TODO: Review this with Marcos
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
            
            NSString * value = [dateFormatter stringFromDate:dateValue ];
            
            NSLog(@"About to add NSDate/NSString ->%@<- to key ->%@<-", value, propertyName);
            [dictionary setObject:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"i"]) {
            int intValue = [[object valueForKey:propertyName] integerValue];
            NSNumber *value = [NSNumber numberWithInt:intValue];
            NSLog(@"About to add int %@ to key %@", value, propertyName);
            [dictionary setObject:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"d"]) {
            float floatValue = [[object valueForKey:propertyName] floatValue];
            NSNumber *value = [NSNumber numberWithFloat:floatValue];
            NSLog(@"About to add float %@ to key %@", value, propertyName);
            [dictionary setObject:value forKey:propertyName];
        } else {
            id innerObject = [object valueForKey:propertyName];
            if (innerObject){
                NSMutableDictionary *innerDictionary = [[NSMutableDictionary alloc] init];
                [self marshallDictionary:innerDictionary object:innerObject];
                NSLog(@"About to add innerDictionary %@ to key %@", innerDictionary, propertyName);
                [dictionary setObject:innerDictionary forKey:propertyName];
            }
        }
    }
    
}

//+ (void)marshallDictionary:(MEUser *)user updateLoggedUser:(NSMutableDictionary *)updateLoggedUser {
//
//    [updateLoggedUser setObject:user.version forKey:@"version"];
//    [updateLoggedUser setObject:user.firstName forKey:@"firstName"];
//    [updateLoggedUser setObject:user.lastName forKey:@"lastName"];
//    [updateLoggedUser setObject:user.phone forKey:@"phone"];
//
//    //TODO: Discuss this with Marcos
//    //    [updateLoggedUser setObject:user.username forKey:@"username"];
//    //    [updateLoggedUser setObject:user.version forKey:@"password"];
//
//    [updateLoggedUser setObject:user.email forKey:@"email"];
//
//
//    if ([user.userType isEqualToString:@"driver"]) {
//        NSMutableDictionary *driverInfo = [[NSMutableDictionary alloc] init];
//        [driverInfo setObject:user.carType.code forKey:@"carType"];
//        NSMutableDictionary *servedLocation = [user.servedLocation locationDictionary];
//        [driverInfo setObject:servedLocation forKey:@"servedLocation"];
//        [driverInfo setObject:user.activeStatus.code forKey:@"activeStatus"];
//        [updateLoggedUser setObject:driverInfo forKey:@"driver"];
//    }
//
//}

@end
