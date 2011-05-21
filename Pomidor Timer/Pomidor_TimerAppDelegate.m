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


- (void)showWindow;

- (void)growlAlarm:(NSString *)message title:(NSString *)title;
- (void)soundAlarm;

- (void)setForm;

@end

@implementation Pomidor_TimerAppDelegate


// Init
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    NSColor *color = [NSColor whiteColor];
    NSFont *font = [NSFont fontWithName:@"Silom" size:36.0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     color, NSForegroundColorAttributeName, 
                                     style, NSParagraphStyleAttributeName,
                                     font, NSFontAttributeName,
                                     nil];
    
    NSAttributedString *attrString = [[NSAttributedString alloc]
                                      initWithString:@"Mute\nAlarm" attributes:attrsDictionary];
    
    [muteAlarmButton setAttributedTitle:attrString];
    [style release];
    [attrString release]; 
    
    windowFading = NO;
    [_pomidorWindow setDelegate:self];
    [statusMenu setDelegate:self];
    [NSApp setDelegate:self];
    
    statusMenuDisplay = [[[NSStatusBar systemStatusBar] statusItemWithLength:45.0] retain];
    [statusMenuDisplay setMenu:statusMenu];

    [self restoreUserSettings];
    _alarmController = [[SoundController alloc] initWithSoundName:@"Blow" volume:[alarmVolume doubleValue]];
    _tickController  = [[SoundController alloc] initWithSoundName:@"Tick" volume:[tickVolume doubleValue]];
    _state = [WorkStateModel new];
    [self resetTimer:nil];
    
}

- (void)awakeFromNib{
    
    NSRect buttFrame = [fastForwardButton frame];
    NSRect viewFrame = [timerTab frame];
    // There has got to be a better/correct way to get the tracking area of an object.
    // I should also be turning off the tracking when the timer tab isn't active.
    NSRect correctedFrame = NSMakeRect(buttFrame.origin.x + 5, 
                                  (viewFrame.size.height - buttFrame.size.height) - (buttFrame.origin.y + viewFrame.origin.y + 10),
                                  buttFrame.size.width  + 10, 
                                  buttFrame.size.height + 5);
    
    [GrowlApplicationBridge setGrowlDelegate:self];
    _fastForwardTrackingArea = [[NSTrackingArea alloc] 
                                initWithRect: correctedFrame
                                options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow )
                                owner: self
                                userInfo:nil];
    
    [timerTab addTrackingArea:_fastForwardTrackingArea];
    _formFadeController = [[FadeController alloc] initWithNotifyObject:self withSelector:@selector(formFadeDone:) control:_pomidorWindow duration:0.15];
    _fastForwardFadeController = [[FadeController alloc] initWithControl:fastForwardHintButton duration:0.2];
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [_fastForwardFadeController fadeInWithWait:1.25];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [_fastForwardFadeController fadeOutWithWait:0.25];
}

- (void)formFadeDone:(id)fadeOut
{
    BOOL fadedOut = [(NSNumber*)fadeOut boolValue];
    if (fadedOut)
    { 
        [_pomidorWindow orderOut:nil]; 
    }
}

- (BOOL)windowShouldClose:(id)sender
{
    [self toggleWindow:nil];
    return NO;
}

- (void)showWindow {
    [_pomidorWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

// Fired by clicking dock icon
-(BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)visibleWindows {
    
    [self toggleWindow:nil];
    return NO;
}

// Fired when application loses focus
- (void)applicationWillResignActive:(NSNotification *)aNotification
{
    [_formFadeController toggleFade];
}

// Fired by clicking on menubar timer
-(void)menuWillOpen:(NSMenu *)menu {
    [self toggleWindow:nil];
}

- (void)toggleWindow:(id)sender
{
    if ([_pomidorWindow alphaValue] == 0.0)
    {
        [_pomidorWindow makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];
    }
    [_formFadeController toggleFade];
}

- (void)restoreUserSettings {
    // this screams for refactoring to be dynamic
    _userSettings = [NSUserDefaults standardUserDefaults];
    if ([_userSettings objectForKey:@"muteSoundsState"]) {
        [muteSoundsButton setState:[_userSettings integerForKey:@"muteSoundsState"]];
    }
    if ([_userSettings objectForKey:@"workPeriodMinutes"]) {
        [workPeriodMinutes setIntegerValue:[_userSettings integerForKey:@"workPeriodMinutes"]];
    }
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

-(void) growlAlarm:(NSString *)message title:(NSString *)title
{
    [GrowlApplicationBridge notifyWithTitle:title
                                description:message
                           notificationName:@"Alarm"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:@"alarmClickContext"];
}

- (void) growlNotificationWasClicked:(id)clickContext{
    if (clickContext && [clickContext isEqualToString:@"alarmClickContext"])
        [self showWindow];
    return;
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
    _countDown = [workPeriodMinutes doubleValue] * SECONDS;
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
    [self setClock];
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
    [self muteAlarm:nil];
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

-(void)setForm{
    [fastForwardButton setEnabled:NO];
    [self setStateText];
    [self setWorkCountDisplay];
    [self setBubbleIndicators];
    [self pauseTimer];
    [self setCountdown];
}

- (IBAction)resetTimer:(id)sender {
    [_state reset];
    [self setForm];
    [self setClock];
    [self muteAlarm:nil];
}

-(void)soundAlarm {
    [NSApp requestUserAttention:NSCriticalRequest];
    [self growlAlarm:[[_state stateMessage] stringByAppendingString:@" done"] title:@"Pomidor Timer"];
    if ([muteSoundsButton state] == NSOffState) {
        [muteAlarmButton setHidden:NO];
        [_alarmController startSoundLoop];
    }
}

- (IBAction)muteAlarm:(id)sender {
    [_alarmController stopSoundLoop];
    [muteAlarmButton setHidden:YES];
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

- (IBAction)workPeriodMinutesChanged:(id)sender {
    if ([_state currentState] == workState_StartWorking) {
        _countDown = [workPeriodMinutes doubleValue] * SECONDS;
        [self setClock];
    } 
    [_userSettings setInteger:[workPeriodMinutes integerValue] forKey:@"workPeriodMinutes"];
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


- (IBAction)muteSoundsChanged:(id)sender {
    [_userSettings setInteger:[muteSoundsButton state] forKey:@"muteSoundsState"];
    [_userSettings synchronize];
}

- (void)timerFiredMethod:(NSTimer*)theTimer {
    int now = [[NSDate date] timeIntervalSince1970];
    if ( now >= _lastSecond + 1) {
        _countDown -= (now - _lastSecond);
        _lastSecond = now;
        [self setClock];
        if (_countDown <= 0) {
            _countDown = 0;
            [_state stop];
            [self setForm];
            [self soundAlarm];
        } else if ([muteSoundsButton state] == NSOffState) {
            [_tickController playSound];
        }
    }
}
  
@end