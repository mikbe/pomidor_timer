//
//  AlarmController.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/26/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlarmController : NSObject {
@private

}

+(void)startAlarm;
+(void)stopAlarm;
+(void)setVolume:(double)zeroToOne;
+(double)volume;


@end
