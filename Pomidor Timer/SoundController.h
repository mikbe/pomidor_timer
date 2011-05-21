//
//  AlarmController.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/26/11.
//  Copyright 2011 http://mikbe.tk 
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundController : NSObject <NSSoundDelegate> {
@private
    NSSound         *_sound;
    NSTimer         *_timer;

    double          _volume;

    BOOL            _repeat;
    double          _delay;
    
    
}

@property (readwrite)       BOOL        repeat;
@property (readwrite)       double      delay;

- (id)initWithSoundName:(NSString*)soundName volume:(double)volume;

- (double)volume;
- (void)setVolume: (double)volume;

- (void)playSound;
- (void)playSoundWithTimer;
- (void)playSoundWithTimer:(int)delay;

- (void)startSoundLoop;
- (void)stopSoundLoop;

@end
