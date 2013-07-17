//
//  DateHelper.m
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper


+ (NSString *) descriptionFormatOfLocalDateAndTime: (NSDate *)date{
    
    NSString *stringDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    stringDate = [dateFormatter stringFromDate:date];
    
    return stringDate;
}


+ (NSString *)descriptionFullFormatOfLocalDateAndTime: (NSDate *) date {
    
    NSString *stringDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    stringDate = [dateFormatter stringFromDate:date];
    
    return stringDate;
}

+ (NSString *)descriptionTime: (NSDate *) date{
   
    NSString *time;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    time = [dateFormatter stringFromDate:date];
    
    return time;
}

+ (NSString *)descriptionDate: (NSDate *) date{
    NSString *dateDescription;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [dateFormatter setTimeZone:gmt];
//    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
//    
//    dateDescription = [dateFormatter stringFromDate:date];
//    
//    NSLog(@"%@", dateDescription);
    
    NSString *fullMinusYear = [NSDateFormatter dateFormatFromTemplate:@"EEEE, MMMM dd" options:0 locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fullMinusYear];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];

    dateDescription = [dateFormatter stringFromDate:date];
    
    
    return dateDescription;
}


@end
