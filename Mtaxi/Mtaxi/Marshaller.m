//
//  Marshaller.m
//  Mtaxi
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
        
        
        //Because of id being a keyword in Objective C we changed it to uid.
        NSString *dictionaryPropertyName;
        if ([propertyName isEqualToString:@"uid" ]) {
            dictionaryPropertyName = @"id";
        } else {
            dictionaryPropertyName = propertyName;
        }
        
        NSString * dictValue = [dictionary objectForKey:dictionaryPropertyName];
        
        if ([typeAttribute isEqualToString:@"NSString"]) {
            NSString * value;
            if ( (dictValue == nil) || ([dictValue isKindOfClass:[NSNull class]]) ){
                value = [[NSString alloc] init];
            } else {
                value = dictValue;
            }
            NSLog(@"About to set the property (NSString) %@ with the value %@",propertyName, value);
            [object setValue:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"NSDate"]) {
            NSDate *value;
            if ( (dictValue == nil) || ([dictValue isKindOfClass:[NSNull class]]) )  {
                value = [[NSDate alloc] init];
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [dateFormatter setTimeZone:gmt];
                value = [dateFormatter dateFromString:dictValue];
            }
            NSLog(@"About to set the property (NSDate) %@ with the value %@",propertyName, value);
            [object setValue:value forKey:propertyName];
        } else if ([typeAttribute isEqualToString:@"i"]) {
            int intValue;
            if (dictValue == nil) {
                intValue = 0;
            } else {
                intValue = [dictValue integerValue];
            }
            
            NSLog(@"About to set the property (int) %@ with the value %i",propertyName, intValue);
            [object setValue:[NSNumber numberWithInt:intValue] forKey:propertyName];
            
        } else if ([typeAttribute isEqualToString:@"d"]) {
            float floatValue;
            if ( (dictValue == nil) || ([dictValue isKindOfClass:[NSNull class]]) ) {
                floatValue = 0;
            } else {
                floatValue = [dictValue floatValue];
            }
            NSLog(@"About to set the property (float) %@ with the value %f",propertyName, floatValue);
            [object setValue:[NSNumber numberWithFloat:floatValue] forKey:propertyName];
            
        } else {
            //Check if the type is an class, obtain the sub dictionary, and if the subdictionary exists marshal the object.
            
            id subDictionary = [dictionary objectForKey:propertyName];
            
            //verificar com o Eduardo.. adicionei esse if pois estava marshalling object quando subdicitonary == null;
            if (subDictionary) {
                if (![subDictionary isKindOfClass:[NSNull class]] ) {
                    
                    id innerObject = [[NSClassFromString(typeAttribute) alloc] init];
                    if (innerObject){
                        NSLog(@"About to set the property %@ with the value %@",propertyName, innerObject);
                        [self marshallObject:innerObject dictionary:subDictionary error:error];
                        [object setValue:innerObject forKey:propertyName];
                    }
                    
                }
            }
        }
    }
    return YES;
}


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
        
        
        id value = [object valueForKey:propertyName];
        if (!value) {
            continue;
        }
        
        NSString * dictionaryPropertyName;
        
        if ([propertyName isEqualToString:@"uid" ]) {
            dictionaryPropertyName = @"id";
        } else {
            dictionaryPropertyName = propertyName;
        }
        
        if ([typeAttribute isEqualToString:@"NSString"]) {
            NSLog(@"About to add NSString ->%@<- to key ->%@<-", value, propertyName);
            [dictionary setObject:(NSString *)value forKey:dictionaryPropertyName];
            
        } else if ([typeAttribute isEqualToString:@"NSDate"]) {
            
//            NSDate * dateValue = (NSDate *) value;
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//            [dateFormatter setTimeZone:gmt];
//            NSString * stringValue = [dateFormatter stringFromDate:dateValue ];
            
            NSString *stringValue = [DateHelper descriptionFormatOfLocalDateAndTime:(NSDate *)value];
            
            NSLog(@"About to add NSDate/NSString ->%@<- to key ->%@<-", stringValue, propertyName);
            
            [dictionary setObject:stringValue forKey:dictionaryPropertyName];
            
        } else if ([typeAttribute isEqualToString:@"i"]) {
            int intValue = [value integerValue];
            NSNumber *numberValue = [NSNumber numberWithInt:intValue];
            
            NSLog(@"About to add int %@ to key %@", value, propertyName);
            [dictionary setObject:numberValue forKey:dictionaryPropertyName];
        } else if ([typeAttribute isEqualToString:@"d"]) {
            
            float floatValue = [value floatValue];
            NSNumber *numberValue = [NSNumber numberWithFloat:floatValue];
            NSLog(@"About to add float %@ to key %@", value, propertyName);
            [dictionary setObject:numberValue forKey:dictionaryPropertyName];
        } else {
            
            NSMutableDictionary *innerDictionary = [[NSMutableDictionary alloc] init];
            [self marshallDictionary:innerDictionary object:value error:error];
            NSLog(@"About to add innerDictionary %@ to key %@", innerDictionary, propertyName);
            [dictionary setObject:innerDictionary forKey:dictionaryPropertyName];
        }
    }
    
    return YES;
    
}

@end
