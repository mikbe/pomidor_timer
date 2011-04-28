//
//  AlarmController.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/26/11.
//  Copyright 2011 http://mikbe.tk 
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundController : NSObject {
@private
    NSSound         *sound;
    NSTimer         *timer;

    double          _volume;

    NSString*       _soundName;
    BOOL            _repeat;
    double          _delay;
    
    
}

@property (readwrite, copy) NSString*   soundName;
@property (readwrite)       BOOL        repeat;
@property (readwrite)       double      delay;

- (id)initWithSoundName:(NSString*)soundName volume:(double)volume;

- (double)volume;
- (void)setVolume: (double)volume;

- (void)playSound;
- (void)playSoundNow;
- (void)playSoundNowWithVolume:(double)volume;
- (void)playSoundNowWithSoundName:(NSString*)soundName;
- (void)playSoundWithSoundName:(NSString*)soundName volume:(double)volume delay:(int)delay;

- (void)startSoundLoop;
- (void)stopSoundLoop;

@end
