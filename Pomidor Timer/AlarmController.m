//
//  AlarmController.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/26/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import "AlarmController.h"

@interface AlarmController()

    // Private methods
    +(void)sound: (NSSound*)sound didFinishPlaying: (BOOL)finishedPlaying;
    +(void)playSound;

@end

@implementation AlarmController

static NSSound* alarmSound;
static NSString* soundName = @"Ping";
static double _volume = 1.0;
static bool keepPlaying = NO;

+(void)setVolume:(double)volume
{
    _volume = volume;
}

+(double)volume
{
    return _volume;
}

// Callback for sound being done, fired automajically by NSSound
+(void)sound: (NSSound*)sound didFinishPlaying: (BOOL)finishedPlaying
{
    if (finishedPlaying && keepPlaying) {
        [self playSound];
    }
}

+(void)playSound {
    [NSTimer scheduledTimerWithTimeInterval: 1
                                     target: self
                                   selector: @selector(playSoundThreaded)
                                   userInfo: nil
                                    repeats: NO];
}

// Callback for the timer thread that handles playing the sound
+(void)playSoundThreaded
{
    alarmSound = [NSSound soundNamed: soundName];
    [alarmSound setDelegate: self];
    [alarmSound setVolume: _volume];
    [alarmSound play];
}

+(void)startAlarm
{
    keepPlaying = YES;
    [self playSound];
}

+(void)stopAlarm
{
    keepPlaying = NO;
}

@end
