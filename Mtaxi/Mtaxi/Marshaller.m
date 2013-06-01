//
//  Marshaller.m
//  Mtaxi
//
//  Created by Eduardo Goncalves on 5/27/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "Marshaller.h"

@implementation Marshaller


+ (BOOL) marshallObject:(NSObject *) object dictionary:(NSDictionary *)dictionary error: (NSError **) error{
    
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
        typeAttribute = [typeAttribute stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        typeAttribute = [typeAttribute stringByReplacingOccurrencesOfString:@"@" withString:@""];
        typeAttribute = [typeAttribute substringFromIndex:1];
        
        
        //TODO: Add if for the additional types that we have in our code
        if ([typeAttribute isEqualToString:@"NSString"]) {
            NSString * value = [dictionary objectForKey:propertyName];
            if (value == NULL) {
                value = [[NSString alloc]init];
            }
            NSLog(@"About to set the property (NSString) %@ with the value %@",propertyName, value);
            [object setValue:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"NSDate"]) {
            NSString * dictionaryValue = [dictionary objectForKey:propertyName];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
            NSDate *value;
            if (dictionaryValue == NULL) {
                value = [[NSDate alloc]init];
            }else{
                value = [dateFormatter dateFromString:dictionaryValue];
            }
            NSLog(@"About to set the property (NSDate) %@ with the value %@",propertyName, value);
            [object setValue:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"i"]) {
            //Because of id being a keyword in Objective C we changed it to uid.
            NSString *dictionaryPropertyName;
            if ([propertyName isEqualToString:@"uid" ]) {
                dictionaryPropertyName = @"id";
            } else {
                dictionaryPropertyName = propertyName;
            }
            NSString * dictionaryValue = [dictionary objectForKey:dictionaryPropertyName];
            int intValue = [dictionaryValue integerValue];
            
            NSLog(@"About to set the property (int) %@ with the value %i",propertyName, intValue);
            [object setValue:[NSNumber numberWithInt:intValue] forKey:propertyName];
            
        } else if ([typeAttribute isEqualToString:@"d"]) {
            NSString * dictionaryValue = [dictionary objectForKey:propertyName];
            float floatValue = [dictionaryValue floatValue];
            
            NSLog(@"About to set the property (float) %@ with the value %f",propertyName, floatValue);
            [object setValue:[NSNumber numberWithFloat:floatValue] forKey:propertyName];
            
        } else {
            //Check if the type is an class, obtain the sub dictionary, and if the subdictionary exists marshal the object.
            NSDictionary * subDictionary = [dictionary objectForKey:propertyName];
            if (subDictionary) {
                id innerObject = [[NSClassFromString(typeAttribute) alloc] init];
                if (innerObject){
                    NSLog(@"About to set the property %@ with the value %@",propertyName, innerObject);
                    [self marshallObject:innerObject dictionary:subDictionary error:error];
                    [object setValue:innerObject forKey:propertyName];
                }
                
            }
        }
    }
    return YES;
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


+ (BOOL)marshallDictionary:(NSMutableDictionary *)dictionary object: (NSObject *)object error: (NSError **) error {
    
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
            NSString * dictionaryPropertyName;
            if ([propertyName isEqualToString:@"uid" ]) {
                dictionaryPropertyName = @"id";
            } else {
                dictionaryPropertyName = propertyName;
            }
            int intValue = [[object valueForKey:propertyName] integerValue];
            NSNumber *value = [NSNumber numberWithInt:intValue];
            NSLog(@"About to add int %@ to key %@", value, propertyName);
            [dictionary setObject:value forKey:dictionaryPropertyName];
        } else if ([typeAttribute isEqualToString:@"d"]) {
            float floatValue = [[object valueForKey:propertyName] floatValue];
            NSNumber *value = [NSNumber numberWithFloat:floatValue];
            NSLog(@"About to add float %@ to key %@", value, propertyName);
            [dictionary setObject:value forKey:propertyName];
        } else {
            id innerObject = [object valueForKey:propertyName];
            if (innerObject){
                NSMutableDictionary *innerDictionary = [[NSMutableDictionary alloc] init];
                [self marshallDictionary:innerDictionary object:innerObject error:error];
                NSLog(@"About to add innerDictionary %@ to key %@", innerDictionary, propertyName);
                [dictionary setObject:innerDictionary forKey:propertyName];
            }
        }
    }
    
    return YES;
    
}

@end
