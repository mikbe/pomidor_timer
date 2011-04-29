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

- (void)fade:(NSTimer *)theTimer;

- (void)fadeWindow;
- (void)showWindow;
- (void)startFading:(BOOL)fadeOut;

@end

@implementation Pomidor_TimerAppDelegate


// Init
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [_pomidorWindow setDelegate:self];
    [statusMenu setDelegate:self];
    
    statusMenuDisplay = [[[NSStatusBar systemStatusBar] statusItemWithLength:45.0] retain];
    [statusMenuDisplay setMenu:statusMenu];

    [self restoreUserSettings];
    _alarmController = [[SoundController alloc] initWithSoundName:@"Blow" volume:[alarmVolume doubleValue]];
    _tickController  = [[SoundController alloc] initWithSoundName:@"Tick" volume:[tickVolume doubleValue]];

    _state = [WorkStateModel new];
    [self resetTimer:nil]; 
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)visibleWindows {
    [self toggleWindow:nil];
    return YES;
}

-(void)menuWillOpen:(NSMenu *)menu {
    [self toggleWindow:nil];
}

- (void)restoreUserSettings {
    // this screams for refactoring to be dynamic
    _userSettings = [NSUserDefaults standardUserDefaults];
    if ([_userSettings objectForKey:@"longBreakMinutes"]) {
        [longBreakMinutes setIntegerValue:[_userSettings integerForKey:@"longBreakMinutes"]];
    }
    if ([_userSettings objectForKey:@"shortBreakMinutes"]) {
        [shortBreakMinutes setIntegerValue:[_userSettings integerForKey:@"shortBreakMinutes"]];
    }
    if ([_userSettings objectForKey:@"alarmVolume"]) {
        [alarmVolume setDoubleValue:[_userSettings doubleForKey:@"alarmVolume"]];
    }
    if ([_userSettings objectForKey:@"tickVolume"]) {
        [tickVolume setDoubleValue:[_userSettings doubleForKey:@"tickVolume"]];
    }
}

- (void)setStateText {
    [statusText setStringValue:[_state stateMessage]];
}

-(void)setClock {
    int secs = _countDown % 60;
    int mins = _countDown / 60;
    NSString* time = [NSString stringWithFormat:@"%02i:%02i", mins, secs];
    [timerDisplay setStringValue:time];
    [statusMenuDisplay setTitle:time];    
}

- (void)setWorkCountDisplay {
    [workCountDisplay setStringValue:[NSString stringWithFormat:@"%02i", [_state workCount]]];
}

- (void)setCountdown {
    _countDown = MAX_TIMER;
    if ([_state currentState] == workState_StartLongBreak) {
        _countDown = [longBreakMinutes doubleValue] * SECONDS;
    } else if ([_state currentState] == workState_StartShortBreak) {
        _countDown = [shortBreakMinutes doubleValue] * SECONDS;
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
    _countDown = 1;
}

- (void)pauseTimer {
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    startPauseTimerButton.title = @"start";
    [_state pause];
}

- (void)startTimer {
    _lastSecond = [[NSDate date] timeIntervalSince1970];
    [self setClock];
    [_alarmController stopSoundLoop];
    startPauseTimerButton.title = @"pause";
    // Special case where I want the bubbles to turn off when you're done with your long break
    if ([_state currentState] == workState_StartWorking && [_state workCount] != 0 && [_state workCount] % 4 == 0) [self resetBubbleIndicators];
    [_state start];
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerFiredMethod:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)setBubbleIndicators {
    for (int cycleCount = 0; cycleCount < 4; cycleCount++) {
        int bubbleState = NSOffState;
        int workCycle = ([_state workCount] - 1);
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
    [_state reset];
    [fastForwardButton setEnabled:NO];
    [self setCountdown];
    [self setStateText];
    [self setWorkCountDisplay];
    [self setBubbleIndicators];
    [self pauseTimer];
    [self setClock];
    [_alarmController stopSoundLoop];
}

- (IBAction)toggleWindow:(id)sender {
    if ([_pomidorWindow isVisible]){
        [self fadeWindow];
    } else {
        [self showWindow];
    }
}

- (IBAction)alarmVolumeChanged:(id)sender {
    [_alarmController setVolume:[alarmVolume doubleValue]];
    [_userSettings setDouble:[alarmVolume doubleValue] forKey:@"alarmVolume"];
    [_userSettings synchronize];
}

- (IBAction)tickVolumeChanged:(id)sender {
    [_tickController setVolume:[tickVolume doubleValue]];
    [_userSettings setDouble:[tickVolume doubleValue] forKey:@"tickVolume"];
    [_userSettings synchronize];
}

- (IBAction)shortBreakMinutesChanged:(id)sender {
    [_userSettings setInteger:[shortBreakMinutes integerValue] forKey:@"shortBreakMinutes"];
    [_userSettings synchronize];
}

- (IBAction)longBreakMinutesChanged:(id)sender {
    [_userSettings setInteger:[longBreakMinutes integerValue] forKey:@"longBreakMinutes"];
    [_userSettings synchronize];
}

- (void)timerFiredMethod:(NSTimer*)theTimer {
    int now = [[NSDate date] timeIntervalSince1970];
    if ( now >= _lastSecond + 1) {
        _countDown -= (now - _lastSecond);
        _lastSecond = now;
        [self setClock];
        if (_countDown == 0) {
            [_state stop];
            [fastForwardButton setEnabled:NO];
            [self setStateText];
            [self setWorkCountDisplay];
            [self setBubbleIndicators];
            [self pauseTimer];
            [self setCountdown];
            [_alarmController startSoundLoop];
        } else {
            [_tickController playSound];
        }
    }
}

- (BOOL)windowShouldClose:(id)sender
{
    [self toggleWindow:nil];
    return NO;
}

- (void)fadeWindow {
    [self startFading:YES];
}

- (void)showWindow {
    [self startFading:NO];
}

- (void)startFading:(BOOL)fadeOut {
    [_pomidorWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    _fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fade:) userInfo:[NSNumber numberWithBool:fadeOut] repeats:YES] retain]; 
}

- (void)fade:(NSTimer *)theTimer
{
    BOOL fadeOut = [((NSNumber *)[theTimer userInfo]) boolValue];
    if ((fadeOut && [_pomidorWindow alphaValue] > 0.0) || (!fadeOut && [_pomidorWindow alphaValue] < 1.0)) {
        [_pomidorWindow setAlphaValue:([_pomidorWindow alphaValue] - (0.2 * fadeOut) + (0.2 * !fadeOut))];
    } else {
        [_fadeTimer invalidate];
        [_fadeTimer release];
        _fadeTimer = nil;
        if (fadeOut) {
            [NSApp deactivate];
            [_pomidorWindow orderOut:nil];
        }
    }
}


@end
