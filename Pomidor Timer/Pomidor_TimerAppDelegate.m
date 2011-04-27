//
//  Pomidor_TimerAppDelegate.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 3/26/11.
//  Copyright 2011 http://mikbe.tk 
//  All rights reserved.
//

#import "Pomidor_TimerAppDelegate.h"

@interface Pomidor_TimerAppDelegate()

- (void)setClock;
- (void)setWorkCountDisplay;
- (void)setCountdown;
- (void)setBubbleIndicators;
- (void)resetBubbleIndicators;

- (void)setStateText;

@end

@implementation Pomidor_TimerAppDelegate

@synthesize window;


// Init
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    alarmController = [[SoundController alloc] initWithSoundName:@"Purr" volume:[alarmVolume doubleValue]];
    tickController  = [[SoundController alloc] initWithSoundName:@"Tink" volume:[tickVolume doubleValue]];
    state = [WorkStateModel new];
    [self resetTimer:nil]; 
}


- (void)setStateText {
    [statusText setStringValue:[state stateMessage]];
}

-(void)setClock {
    int secs = countDown % 60;
    int mins = countDown / 60;
    [timerDisplay setStringValue:[NSString stringWithFormat:@"%02i:%02i", mins, secs]];
}

- (void)setWorkCountDisplay {
    [workCountDisplay setStringValue:[NSString stringWithFormat:@"%02i", [state workCount]]];
}

- (void)setCountdown {
    countDown = MAX_TIMER;
    if ([state currentState] == workState_StartLongBreak) {
        countDown = [longBreak doubleValue] * SECONDS;
    } else if ([state currentState] == workState_StartShortBreak) {
        countDown = [shortBreak doubleValue] * SECONDS;
    }
}

- (IBAction)startPauseTimer:(id)sender {
    if (startPauseTimerButton.title == @"pause") {
        [self pauseTimer];
    }
    else  {
        [self startTimer];
    }
    [self setStateText];
}

- (void)pauseTimer {
    [timer invalidate];
    timer = nil;
    startPauseTimerButton.title = @"start";
    [state pause];
}

- (void)startTimer {
    [self setClock];
    [alarmController stopSoundLoop];
    startPauseTimerButton.title = @"pause";
    // Special case where I want the bubbles to turn off when you're done with your long break
    if ([state currentState] == workState_StartWorking && [state workCount] != 0 && [state workCount] % 4 == 0) [self resetBubbleIndicators];
    [state start];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerFiredMethod:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)setBubbleIndicators {
    for (int cycleCount = 0; cycleCount < 4; cycleCount++) {
        int bubbleState = NSOffState;
        int workCycle = ([state workCount] - 1);
        if ( workCycle > -1 && (workCycle % 4) >= cycleCount ) {
            bubbleState = NSOnState;
        }
        [[self valueForKey:[NSString stringWithFormat:@"bubbleCounter%i", cycleCount]] setState:bubbleState];
    }
}


- (void)resetBubbleIndicators {
    for (int cycleCount = 0; cycleCount < 4; cycleCount++) {
        [[self valueForKey:[NSString stringWithFormat:@"bubbleCounter%i", cycleCount]] setState:NSOffState];
    }
}


- (IBAction)resetTimer:(id)sender {
    [state reset];
    [self setCountdown];
    [self setStateText];
    [self setWorkCountDisplay];
    [self setBubbleIndicators];
    [self pauseTimer];
    [self setClock];
    [alarmController stopSoundLoop];
}

- (IBAction)alarmVolumeChange:(id)sender {
    [alarmController setVolume:[alarmVolume doubleValue]];
}

- (IBAction)tickVolumeChanged:(id)sender {
    [tickController setVolume:[tickVolume doubleValue]];
}

- (void)timerFiredMethod:(NSTimer*)theTimer {
    countDown--;
    [self setClock];
    if (countDown == 0) {
        [state stop];
        [self setStateText];
        [self setWorkCountDisplay];
        [self setBubbleIndicators];
        [self pauseTimer];
        [self setCountdown];
        [alarmController startSoundLoop];
    } else {
        [tickController playSoundNow];
    }
}

@end
