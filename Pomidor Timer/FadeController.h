//
//  FadeController.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 5/20/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface FadeController : NSObject {

@private

    NSTimer             *_startTimer; // Pause before the fade happens    
    
    NSObject            *_callingObject;
    SEL                  _callbackMethod;
    NSObject            *_fadeControl;
    CGFloat              _fadeDuration;
    CABasicAnimation    *_animation;
    
    CGFloat              _alphaValue;
    
}


- (id)initWithNotifyObject:(id)callingObject withSelector:(SEL)callbackMethod control:(id)fadeControl duration:(CGFloat)fadeDuration;

- (id)initWithControl:(id)fadeControl duration:(CGFloat)fadeDuration;

- (void)clearTimer;

- (void)fadeInWithWait:(double)wait;
- (void)fadeOutWithWait:(double)wait;

- (void)fadeIn;
- (void)fadeOut;

- (void)toggleFade;

- (void)fade:(BOOL)fadeIn;


@end
