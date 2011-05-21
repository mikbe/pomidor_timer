//
//  FadeController.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 5/20/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import "FadeController.h"

@implementation FadeController

- (id)initWithControl:(id)fadeControl duration:(CGFloat)fadeDuration
{
    return [self initWithNotifyObject:nil withSelector:nil control:fadeControl duration:fadeDuration];
}

- (id)initWithNotifyObject:(id)callingObject withSelector:(SEL)callbackMethod control:(id)fadeControl duration:(CGFloat)fadeDuration
{
    self = [super init];
    if (self) {
        _callingObject  = callingObject;
        _callbackMethod = callbackMethod;
        _fadeControl    = fadeControl;
        _fadeDuration   = fadeDuration;
        _startTimer     = [NSTimer new];
        
        _animation = [CABasicAnimation animation];
        [_animation setDelegate:self];
        [_animation setDuration:fadeDuration];
        [_fadeControl setAnimations:[NSDictionary dictionaryWithObject:_animation forKey:@"alphaValue"]];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)clearTimer
{
    if (_startTimer != nil && [_startTimer isValid])
    {
        [_startTimer invalidate];
        _startTimer  = [NSTimer new];
    } 
}

- (void)fadeIn
{
    [self fade:NO];
}

- (void)fadeOut
{
    [self fade:YES];
}

- (void)toggleFade
{
    [self fade:(BOOL)[_fadeControl alphaValue]];
}

- (void)fade:(BOOL)fadeOut
{
    _alphaValue = !fadeOut;
    [self clearTimer];
    [[_fadeControl animator] setAlphaValue:_alphaValue];
}


- (void)fadeInWithWait:(double)wait
{
    [self clearTimer];
    _startTimer = [NSTimer scheduledTimerWithTimeInterval: wait
                                                   target: self
                                                 selector: @selector(fadeIn)
                                                 userInfo: nil 
                                                  repeats: NO];
}

- (void)fadeOutWithWait:(double)wait
{
    [self clearTimer];
    _startTimer = [NSTimer scheduledTimerWithTimeInterval: wait
                                                   target: self
                                                 selector: @selector(fadeOut)
                                                 userInfo: nil 
                                                  repeats: NO];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_callingObject performSelector:_callbackMethod withObject:[NSNumber numberWithBool:!_alphaValue]];
}


@end
