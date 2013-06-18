//
//  AssignRideToken.h
//  Mtaxi
//
//  Created by Marcos Vilela on 17/06/13.
//  Copyright (c) 2013 Moovt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignRideToken : NSObject

@property int uid;
@property int version;


-(id) initWithUid:(int)uid version:(int)version;


@end
