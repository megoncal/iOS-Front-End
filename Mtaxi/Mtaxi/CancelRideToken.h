//
//  CancelRideToken.h
//  Mtaxi
//
//  Created by Marcos Vilela on 27/07/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelRideToken : NSObject

@property int uid;
@property int version;


-(id) initWithUid:(int)uid version:(int)version;

@end
