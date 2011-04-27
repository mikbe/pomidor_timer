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
- (void)setCycle;
- (void)setCountdown;
- (void)setBubbleIndicators;
- (void)resetBubbleIndicators;

@end

@implementation Pomidor_TimerAppDelegate

@synthesize window;

-(void)setClock {
    int secs = countDown % 60;
    int mins = countDown / 60;
    [timerDisplay setStringValue:[NSString stringWithFormat:@"%02i:%02i", mins, secs]];
}

- (void)setCycle {
    [cycleDisplay setStringValue:[NSString stringWithFormat:@"%02i", cycleCount]];
}

- (void)setCountdown {
    countDown = MAX_TIMER;
    NSLog(@"count: %i; mod8: %i", cycleCount, cycleCount % 8);
    if (cycleCount > 0)
    {
        if (cycleCount % 4 == 0) {
            countDown = [longBreak doubleValue] * 1;
        } else if (cycleCount % 2 != 0) {
            countDown = [shortBreak doubleValue] * 1;
        }
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // I thought Red would be cute but it's just annoying
    //[window setBackgroundColor:[NSColor colorWithCalibratedRed:1 green:0.0 blue:0.0 alpha:0.75]];
    
    alarmController = [[SoundController alloc] initWithSoundName:@"Purr" volume:[alarmVolume doubleValue]];
    tickController  = [[SoundController alloc] initWithSoundName:@"Tink" volume:[tickVolume doubleValue]];
    [self resetTimer:nil]; 
}

- (IBAction)startStopTimer:(id)sender {
    if (startStopTimerButton.title == @"stop") {
        [self stopTimer];
    }
    else  {
        [self startTimer];
    }
}

- (void)stopTimer {
    [timer invalidate];
    timer = nil;
    startStopTimerButton.title = @"start";
}

- (void)startTimer {
    [self setCountdown];
    [alarmController stopSoundLoop];
    startStopTimerButton.title = @"stop";
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerFiredMethod:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)setBubbleIndicators {
    if ([bubbleCounter4 state]) {
        [self resetBubbleIndicators];
    } else if ([bubbleCounter3 state]) {
        [bubbleCounter4 setState:NSOnState];   
    } else if ([bubbleCounter2 state]) {
        [bubbleCounter3 setState:NSOnState];   
    } else if ([bubbleCounter1 state]) {
        [bubbleCounter2 setState:NSOnState];   
    } else {
        [bubbleCounter1 setState:NSOnState];   
    }
}

- (void)resetBubbleIndicators {
    [bubbleCounter1 setState:NSOffState];
    [bubbleCounter2 setState:NSOffState];
    [bubbleCounter3 setState:NSOffState];
    [bubbleCounter4 setState:NSOffState];   
}

- (IBAction)resetTimer:(id)sender {
    countDown   = MAX_TIMER;
    cycleCount  = 0;
    [self resetBubbleIndicators];
    [self stopTimer];
    [self setClock];
    [self setCycle];
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
        cycleCount++;
        [self setBubbleIndicators];
        [alarmController startSoundLoop];
        [self startStopTimer:nil];
    } else {
        [tickController playSoundNow];
    }
}

@end
