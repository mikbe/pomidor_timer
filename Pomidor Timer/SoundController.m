//
//  AlarmController.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 4/26/11.
//  Copyright 2011 http://mikbe.tk 
//  All rights reserved.
//

#import "SoundController.h"

@interface SoundController()

    // Private methods
    -(void)sound: (NSSound*)sound didFinishPlaying: (BOOL)finishedPlaying;

@end

@implementation SoundController

@synthesize soundName=_soundName;
@synthesize repeat=_repeat;
@synthesize delay=_delay;

- (id)init
{
    self = [super init];
    if (self) {
        _soundName   = @"Purr";
        _volume     = 0.5;
        _delay       = 1;
    }
    
    return self;
}

- (id)initWithSoundName:(NSString*)soundName volume:(double)volume
{
    self = [super init];
    if (self) {
        self.soundName  = soundName;
        _volume         = volume;
        _delay           = 1;
    }
    
    return self;
}

- (void)dealloc
{
    [_soundName release];
    [super dealloc];
}

-(void)setVolume: (double)volume
{
    _volume = volume;
    if (!_repeat) [self playSoundNow];
}

-(double)volume
{
    return _volume;
}

// Callback for sound being done, fired automajically by NSSound
-(void)sound:(NSSound*)sound didFinishPlaying:(BOOL)finishedPlaying
{
    if (finishedPlaying && _repeat) {
        [self playSound];
    }
}

-(void)playSound {
    [self playSoundWithSoundName:_soundName volume:_volume delay:_delay];
}

-(void)playSoundNow {
    [self playSoundWithSoundName:_soundName volume:_volume delay:0];
}

-(void)playSoundNowWithVolume:(double)volume {
    [self playSoundWithSoundName:_soundName volume:volume delay:0];
}

-(void)playSoundNowWithSoundName:(NSString*)soundName {
    [self playSoundWithSoundName:soundName volume:_volume delay:0];
}

-(void)playSoundWithSoundName:(NSString*)soundName volume:(double)volume delay:(int)delay {
    timer = [NSTimer scheduledTimerWithTimeInterval: delay
                                     target: self
                                   selector: @selector(playSoundThreaded)
                                   userInfo: nil
                                    repeats: NO];
}


// Callback for the timer thread that handles playing the sound
-(void)playSoundThreaded
{
    sound = [NSSound soundNamed:_soundName];
    [sound setDelegate: self];
    [sound setVolume: _volume];
    [sound play];
    timer = nil;
}

-(void)startSoundLoop
{
    _repeat = YES;
    [self playSound];
}

-(void)stopSoundLoop
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    _repeat = NO;
}

@end
