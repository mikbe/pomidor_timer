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
    -(void)loadSound:(NSString*)soundName;

@end

@implementation SoundController

@synthesize repeat=_repeat;
@synthesize delay=_delay;

- (id)init
{
    self = [super init];
    if (self) {
        [self initWithSoundName:@"Purr" volume:0.5];
    }
    
    return self;
}

- (id)initWithSoundName:(NSString*)soundName volume:(double)volume
{
    self = [super init];
    if (self) {
        _volume     = volume;
        _delay      = .2;
        [self loadSound:soundName];
    }
    return self;
}

- (void)dealloc
{
    [_sound release];
    [super dealloc];
}

-(void)loadSound:(NSString*)soundName {
    _sound = [NSSound soundNamed:soundName];
}

-(void)setVolume: (double)volume
{
    _volume = volume;
    if (!_repeat) [self playSound];
}

-(double)volume
{
    return _volume;
}

// Callback for sound being done, fired automajically by NSSound
-(void)sound:(NSSound*)sound didFinishPlaying:(BOOL)finishedPlaying
{
    if (finishedPlaying && _repeat) {
        [self playSoundWithTimer];
    }
}

-(void)playSoundWithTimer {
    [self playSoundWithTimer:_delay];
}
-(void)playSoundWithTimer:(int)delay {
    _timer = [NSTimer scheduledTimerWithTimeInterval: delay
                                     target: self
                                   selector: @selector(playSound)
                                   userInfo: nil
                                    repeats: NO];
}

// Callback for the timer thread that handles playing the sound
-(void)playSound
{
    [_sound setDelegate: self];
    [_sound setVolume: _volume];
    [_sound play];
    _timer = nil;
}

-(void)startSoundLoop
{
    _repeat = YES;
    [self playSoundWithTimer];
}

-(void)stopSoundLoop
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _repeat = NO;
}

@end
