//
//  DateHelper.h
//  Mtaxi
//
//  Created by Marcos Vilela on 01/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject


+ (NSString *) descriptionFormatOfLocalDateAndTime: (NSDate *)date;

+ (NSString *) descriptionFullFormatOfLocalDateAndTime: (NSDate *) date;

+ (NSString *) descriptionTime: (NSDate *) date;

+ (NSString *) descriptionDate: (NSDate *) date;

@end
