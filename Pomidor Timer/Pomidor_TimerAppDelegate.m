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

- (void) toggleMenuTextColor;
- (void) setMenuTextWithColor:(NSColor *)textColor backgroundColor:(NSColor *)backgroundColor text:(NSString *)textString;
- (void) startMenuAlarm;
- (void) stopMenuAlarm;

- (void) enableConfigurableControls;
- (void) disableConfigurableControls;
- (void) setConfigurableControls:(BOOL)enabled;

- (void)setVolumeButtonState;

@end

@implementation Pomidor_TimerAppDelegate


// Init
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    NSColor *color  = [NSColor whiteColor];
    NSFont  *font   = [NSFont fontWithName:@"Silom" size:36.0];
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
    
    [_pomidorWindow setDelegate:self];
    [statusMenu     setDelegate:self];
    [NSApp          setDelegate:self];
    
    statusMenuText = [[[NSStatusBar systemStatusBar] statusItemWithLength:60.0] retain];
    [statusMenuText setMenu:statusMenu];

    [self restoreUserSettings];
    _alarmController    = [[SoundController alloc] initWithSoundName:@"Blow" volume:[alarmVolume doubleValue]];
    _tickController     = [[SoundController alloc] initWithSoundName:@"Tick" volume:[tickVolume doubleValue]];
    _state              = [WorkStateModel new];
    [self resetTimer:nil];
    
}

- (void)awakeFromNib{

    [GrowlApplicationBridge setGrowlDelegate:self];
    _formFadeController         = [[FadeController alloc] initWithNotifyObject:self withSelector:@selector(formFadeDone:) control:_pomidorWindow duration:0.2];
    
}

- (void)formFadeDone:(id)fadeOut
{
    BOOL fadedOut = [(NSNumber*)fadeOut boolValue];
    if (fadedOut)
    { 
        [_pomidorWindow orderOut:nil]; 
    }
}

- (void)showWindow {
    [_pomidorWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    [_formFadeController fadeIn];
}

// fired when user clicks on close window
- (BOOL)windowShouldClose:(id)sender
{
    if (_alarmSounding)
    { [self muteAlarm:nil]; }

    [self toggleWindow:nil];
    return NO;
}

- (void)windowDidMiniaturize:(NSNotification *)notification {
    //[_formFadeController fadeIn];
}

// Fired by clicking dock icon
-(BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)visibleWindows {
    
    if (_alarmSounding)
    { [self muteAlarm:nil]; }
    
    [self toggleWindow:nil];
    return NO;
}

// Fired when application loses focus
- (void)applicationWillResignActive:(NSNotification *)aNotification
{
    if (_alarmSounding)
    { [self muteAlarm:nil]; }

    [_formFadeController toggleFade];
}

// Fired by clicking on menubar timer
-(void)menuWillOpen:(NSMenu *)menu {
    if (_alarmSounding)
    { [self muteAlarm:nil]; }

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
    [statusMenuText setTitle:time];    
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
    if ([startPauseTimerButton state] == NSOffState) {
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
    [startPauseTimerButton setState:NSOffState];
    [_state pause];
}

- (void)startTimer {
    _lastSecond = [[NSDate date] timeIntervalSince1970];
    [self setClock];
    [self muteAlarm:nil];
    
    // Special case where I want the bubbles to turn off when you're done with your long break
    if ([_state currentState] == workState_StartWorking && [_state workCount] != 0 && [_state workCount] % 4 == 0) [self resetBubbleIndicators];
    [_state start];
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timerFiredMethod:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void) enableConfigurableControls{
    [self setConfigurableControls:YES];
}

- (void) disableConfigurableControls{
    [self setConfigurableControls:NO];
}

- (void) setConfigurableControls:(BOOL)enabled{
    [muteSoundsButton   setEnabled:enabled];
    [longBreakMinutes   setEnabled:enabled];
    [shortBreakMinutes  setEnabled:enabled];
    [workPeriodMinutes  setEnabled:enabled];
    if ([muteSoundsButton state] == NSOffState)
    {   [tickVolume     setEnabled:enabled];    }
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

- (void)setForm{
    [fastForwardButton setEnabled:NO];
    [self setVolumeButtonState];
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

- (void)setVolumeButtonState {
    [alarmVolume    setEnabled:![muteSoundsButton state]];
    [tickVolume     setEnabled:![muteSoundsButton state]];
}

- (void)soundAlarm {
    _alarmSounding = YES;
    [self disableConfigurableControls];
    [NSApp requestUserAttention:NSCriticalRequest];
    [self growlAlarm:[[_state stateMessage] stringByAppendingString:@" done"] title:@"Pomidor Timer"];
    [self pulseFormColor];
    [self startMenuAlarm];
    
    [muteAlarmButton setHidden:NO];
    [self showWindow];
    
    if ([muteSoundsButton state] == NSOffState) {
        [_alarmController startSoundLoop];
    }
}

- (IBAction)muteAlarm:(id)sender {
    _alarmSounding = NO;
    [self enableConfigurableControls];
    [[[_pomidorWindow contentView] layer] removeAllAnimations];
    [[[_pomidorWindow contentView] layer] setFilters:nil];
    [_alarmController stopSoundLoop];
    [muteAlarmButton setHidden:YES];
    [self stopMenuAlarm];
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
    [self setVolumeButtonState];
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

- (void) pulseFormColor
{
    CIFilter *whitePointFilter = [CIFilter filterWithName:@"CIWhitePointAdjust"];
    [whitePointFilter setDefaults];
    [whitePointFilter setName:@"whitePointFilter"];
    
    CABasicAnimation* whitePointAnimation   = [CABasicAnimation animation];
    whitePointAnimation.keyPath             = @"filters.whitePointFilter.inputColor";
    whitePointAnimation.fromValue           = [CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    whitePointAnimation.toValue             = [CIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.8];
    whitePointAnimation.duration            = 0.67;
    whitePointAnimation.autoreverses        = YES;
    whitePointAnimation.repeatCount         = HUGE_VALF;
    whitePointAnimation.timingFunction      = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];

    [[[_pomidorWindow contentView] layer] setFilters:[NSArray arrayWithObjects: whitePointFilter, nil]];
    [[[_pomidorWindow contentView] layer] addAnimation:whitePointAnimation forKey:@"whitePointAnimation"];
}

- (void) startMenuAlarm
{
    [self stopMenuAlarm];
    [self toggleMenuTextColor];
    _statusMenuPulseTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3
                                                   target: self
                                                 selector: @selector(toggleMenuTextColor)
                                                 userInfo: nil 
                                                  repeats: YES];
    
}

- (void) stopMenuAlarm
{
    if (_statusMenuPulseTimer != nil && [_statusMenuPulseTimer isValid])
    {
        [_statusMenuPulseTimer invalidate];
        [_statusMenuPulseTimer release];
        _statusMenuPulseTimer = nil;
        
    }  
    [statusMenuText setTitle:[timerDisplay stringValue]];
}

- (void) toggleMenuTextColor
{
    // I could read the current attributedTitle setting but it's a lot of work
    //  through a really poorly designed interface when a simple toggle will do.
    _toggleMenuToggle = !_toggleMenuToggle;
    if (_toggleMenuToggle) {
        [self setMenuTextWithColor:[NSColor redColor] backgroundColor:[NSColor colorWithCalibratedRed:0.3 green:0.3 blue:0.3 alpha:0.2] text:@" Alarm "];
    } else {
        [statusMenuText setTitle:[timerDisplay stringValue]];
    }
}


- (void) setMenuTextWithColor:(NSColor *)textColor backgroundColor:(NSColor *)backgroundColor text:(NSString *)textString
{
    NSFont *stringFont = [[NSFontManager sharedFontManager] fontWithFamily:@"Helvetica Neue" traits:0 weight:10 size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    backgroundColor, NSBackgroundColorAttributeName,
                                    textColor, NSForegroundColorAttributeName,
                                    stringFont, NSFontAttributeName,
                                    nil];
    
    NSAttributedString *attributedString = [[[NSAttributedString alloc]
                                 initWithString:textString
                                 attributes:attributes] autorelease];
    
    [statusMenuText setAttributedTitle:attributedString];
    
}


@end