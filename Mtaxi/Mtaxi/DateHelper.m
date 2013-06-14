//
//  DateHelper.m
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper




+ (NSString *) stringFormatOfLocalDateAndTime: (NSDate *)date{
    
    NSString *stringDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    stringDate = [dateFormatter stringFromDate:date];
    
    return stringDate;
}


+ (NSString *)stringFullFormatOfLocalDateAndTime: (NSDate *) date {
    
    NSString *stringDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    stringDate = [dateFormatter stringFromDate:date];
    
    return stringDate;
}


@end
