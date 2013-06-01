//
//  DateHelper.h
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject


+ (NSString *) stringFormatOfLocalDateAndTime: (NSDate *)date;

+ (NSString *)stringFullFormatOfLocalDateAndTime: (NSDate *) date;



@end
