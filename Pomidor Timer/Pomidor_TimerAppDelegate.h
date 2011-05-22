//
//  Pomidor_TimerAppDelegate.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 3/26/11.
//  Copyright 2011 http://mikbe.tk 
//  All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

#import "Growl.framework/Headers/GrowlApplicationBridge.h"

#import "SoundController.h"
#import "WorkStateModel.h"
#import "FadeController.h"

@interface Pomidor_TimerAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSMenuDelegate, GrowlApplicationBridgeDelegate> {
    
    // Timer tab
    IBOutlet NSTabView      *timerTab;

    IBOutlet NSTextField    *timerDisplay;

    IBOutlet NSTextField    *statusText;
    
    IBOutlet NSTextField    *workCountDisplay;
    
    IBOutlet NSButton       *muteAlarmButton;
    
    IBOutlet NSButton       *bubbleCounter0;
    IBOutlet NSButton       *bubbleCounter1;
    IBOutlet NSButton       *bubbleCounter2;
    IBOutlet NSButton       *bubbleCounter3;
    
    IBOutlet NSButton       *startPauseTimerButton;  
    IBOutlet NSButton       *fastForwardButton;     
        
    // Options tab
    IBOutlet NSTextField    *workPeriodMinutes;
    IBOutlet NSTextField    *longBreakMinutes;
    IBOutlet NSTextField    *shortBreakMinutes;
    
    IBOutlet NSSlider       *alarmVolume;
    IBOutlet NSSlider       *tickVolume;
    
    IBOutlet NSButton       *muteSoundsButton;
    
    // Status bar
    IBOutlet NSMenu         *statusMenu;
    IBOutlet NSMenuItem     *statusMenuText;
    
@private
    NSWindow                *_pomidorWindow;
    NSTimer                 *_countdownTimer;
    
    NSTimer                 *_statusMenuPulseTimer;
    
    int                     _lastSecond; // Remembers the last second the countdown timer was fired incase the timer doesn't get fired e.g. system is busy
    int                     _countDown;  // count down time in seconds

    SoundController         *_alarmController;
    SoundController         *_tickController;
    
    WorkStateModel          *_state;
    
    #define                 SECONDS 60
    
    NSUserDefaults          *_userSettings;
    NSTextField             *_shortBreakMinutesChanged;
    NSTextField             *_longBreakMinutesChanged;
    
    // Fade controllers
    FadeController          *_formFadeController;
    
    BOOL                    _toggleMenuToggle;

    BOOL                    _alarmSounding; // look for a refactor
    
}

// Timer tab
- (IBAction)startPauseTimer:(id)sender;
- (IBAction)fastForward:(id)sender;
- (IBAction)resetTimer:(id)sender;

- (IBAction)muteAlarm:(id)sender;

// Options tab
- (IBAction)workPeriodMinutesChanged:(id)sender;
- (IBAction)shortBreakMinutesChanged:(id)sender;
- (IBAction)longBreakMinutesChanged:(id)sender;

- (IBAction)alarmVolumeChanged:(id)sender;
- (IBAction)tickVolumeChanged:(id)sender;

- (IBAction)muteSoundsChanged:(id)sender;

// Status bar
- (IBAction)toggleWindow:(id)sender;

// Fader callbacks
- (void)formFadeDone:(id)fadeOut;

- (void) pulseFormColor;


@end
