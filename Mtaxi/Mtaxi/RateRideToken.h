//
//  RateRideToken.h
//  Mtaxi
//
//  Created by Marcos Vilela on 15/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RateRideToken : NSObject

@property int uid;
@property int version;
@property double rating;
@property (strong, nonatomic) NSString *comment;

-(id) initWithUid:(int)uid version:(int)version rating:(double)rating andComment:(NSString *)comment;


@end
