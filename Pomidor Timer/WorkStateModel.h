//
//  StateModel.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/27/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    workState_StartWorking,
    workState_Working,
    workState_Paused,
    workState_StartShortBreak,
    workState_ShortBreak,
    workState_StartLongBreak,
    workState_LongBreak
} workStates;


@interface WorkStateModel : NSObject {

    @private
    workStates _pausedState;
    workStates _currentState;
}

- (void)reset;
- (void)start;
- (void)stop;
- (void)pause;
- (void)incrementState;

- (workStates)currentState;

@property (readonly) int workCount;

- (NSString*)stateMessage;

@end
