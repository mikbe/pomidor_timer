//
//  StateModel.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/27/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import "WorkStateModel.h"
@interface WorkStateModel()

@end

@implementation WorkStateModel

@synthesize workCount=_workCount;

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (workStates)currentState {
    return _currentState;
}

- (NSString*)stateMessage {
    switch (_currentState) {
        case workState_Working:
            return @"Working";
        case workState_Paused:
            return @"Paused";
        case workState_StartShortBreak:
            return @"Start short break";
        case workState_ShortBreak:
            return @"On short break";
        case workState_StartLongBreak:
            return @"Start long break";
        case workState_LongBreak:
            return @"On long break";
        default:
            return @"Start working";
    }
}

- (void)reset {
    _currentState       = workState_StartWorking;
    _pausedState        = workState_StartWorking;
    _workCount          = 0;
}

// An alias for incrementState; in some cases it makes more sense symantically
- (void)start {
    [self incrementState];
}

// An alias for incrementState; in some cases it makes more sense symantically
- (void)stop {
    [self incrementState];
}

- (void)pause {
    switch (_currentState) {
        case workState_Working:
        case workState_ShortBreak:
        case workState_LongBreak:
            _pausedState = _currentState;
            _currentState = workState_Paused;
        default:
            break;
    }
}

- (void)incrementState {
    
    switch (_currentState) {
        case workState_Paused:
            _currentState = _pausedState;
            return;
        case workState_Working:
            _workCount++;
            if (_workCount % 4 == 0) {
                _currentState = workState_StartLongBreak;
            } else {
                _currentState = workState_StartShortBreak;
            }
            return;
        case workState_StartShortBreak:
            _currentState = workState_ShortBreak;
            return;
        case workState_StartLongBreak:
            _currentState = workState_LongBreak;
            return;
        case workState_ShortBreak:
        case workState_LongBreak:
            _currentState = workState_StartWorking;
            return;
        default:
            _currentState = workState_Working;
            return;
    }
}

@end
