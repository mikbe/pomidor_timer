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

- (void)pauseTimer;
- (void)startTimer;

- (void)restoreUserSettings;

@end

@implementation Pomidor_TimerAppDelegate
@synthesize pomidorWindow;


// Init
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    alarmController = [[SoundController alloc] initWithSoundName:@"Purr" volume:[alarmVolume doubleValue]];
    tickController  = [[SoundController alloc] initWithSoundName:@"Tink" volume:[tickVolume doubleValue]];
    
    statusMenuDisplay = [[[NSStatusBar systemStatusBar] statusItemWithLength:45.0] retain];
    [statusMenuDisplay setMenu:statusMenu];

    [self restoreUserSettings];
    state = [WorkStateModel new];
    [self resetTimer:nil]; 
}

- (void)restoreUserSettings {
    // this screams for refactoring to be dynamic
    userSettings = [NSUserDefaults standardUserDefaults];
    if ([userSettings objectForKey:@"longBreakMinutes"]) {
        [longBreakMinutes setIntegerValue:[userSettings integerForKey:@"longBreakMinutes"]];
    }
    if ([userSettings objectForKey:@"shortBreakMinutes"]) {
        [shortBreakMinutes setIntegerValue:[userSettings integerForKey:@"shortBreakMinutes"]];
    }
    if ([userSettings objectForKey:@"alarmVolume"]) {
        [alarmVolume setDoubleValue:[userSettings doubleForKey:@"alarmVolume"]];
    }
    if ([userSettings objectForKey:@"tickVolume"]) {
        [tickVolume setDoubleValue:[userSettings doubleForKey:@"tickVolume"]];
    }
}


- (void)setStateText {
    [statusText setStringValue:[state stateMessage]];
}

-(void)setClock {
    int secs = countDown % 60;
    int mins = countDown / 60;
    NSString* time = [NSString stringWithFormat:@"%02i:%02i", mins, secs];
    [timerDisplay setStringValue:time];
    [statusMenuDisplay setTitle:time];    
}

- (void)setWorkCountDisplay {
    [workCountDisplay setStringValue:[NSString stringWithFormat:@"%02i", [state workCount]]];
}

- (void)setCountdown {
    countDown = MAX_TIMER;
    if ([state currentState] == workState_StartLongBreak) {
        countDown = [longBreakMinutes doubleValue] * SECONDS;
    } else if ([state currentState] == workState_StartShortBreak) {
        countDown = [shortBreakMinutes doubleValue] * SECONDS;
    }
}

- (IBAction)startPauseTimer:(id)sender {
    if (startPauseTimerButton.title == @"pause") {
        [fastForwardButton setEnabled:NO];
        [self pauseTimer];
    }
    else  {
        [fastForwardButton setEnabled:YES];
        [self startTimer];
    }
    [self setStateText];
}

- (IBAction)fastForward:(id)sender {
    countDown = 1;
}

- (void)pauseTimer {
    [timer invalidate];
    timer = nil;
    startPauseTimerButton.title = @"start";
    [state pause];
}

- (void)startTimer {
    lastSecond = [[NSDate date] timeIntervalSince1970];
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
    [fastForwardButton setEnabled:NO];
    [self setCountdown];
    [self setStateText];
    [self setWorkCountDisplay];
    [self setBubbleIndicators];
    [self pauseTimer];
    [self setClock];
    [alarmController stopSoundLoop];
}

- (IBAction)showWindow:(id)sender {
    [pomidorWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)alarmVolumeChanged:(id)sender {
    [alarmController setVolume:[alarmVolume doubleValue]];
    [userSettings setDouble:[alarmVolume doubleValue] forKey:@"alarmVolume"];
    [userSettings synchronize];
}

- (IBAction)tickVolumeChanged:(id)sender {
    [tickController setVolume:[tickVolume doubleValue]];
    [userSettings setDouble:[tickVolume doubleValue] forKey:@"tickVolume"];
    [userSettings synchronize];
}

- (IBAction)shortBreakMinutesChanged:(id)sender {
    [userSettings setInteger:[shortBreakMinutes integerValue] forKey:@"shortBreakMinutes"];
    [userSettings synchronize];
}

- (IBAction)longBreakMinutesChanged:(id)sender {
    [userSettings setInteger:[longBreakMinutes integerValue] forKey:@"longBreakMinutes"];
    [userSettings synchronize];
}

- (void)timerFiredMethod:(NSTimer*)theTimer {
    int now = [[NSDate date] timeIntervalSince1970];
    if ( now >= lastSecond + 1) {
        countDown -= (now - lastSecond);
        lastSecond = now;
        [self setClock];
        if (countDown == 0) {
            [state stop];
            [fastForwardButton setEnabled:NO];
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
}

@end
