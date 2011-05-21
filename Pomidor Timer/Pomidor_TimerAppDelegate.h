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
    IBOutlet NSButton       *fastForwardHintButton;
        
    // Options tab
    IBOutlet NSTextField    *workPeriodMinutes;
    IBOutlet NSTextField    *longBreakMinutes;
    IBOutlet NSTextField    *shortBreakMinutes;
    
    IBOutlet NSSlider       *alarmVolume;
    IBOutlet NSSlider       *tickVolume;
    
    IBOutlet NSButton       *muteSoundsButton;
    
    
    // Status bar
    NSStatusItem            *menuBarDisplay;
    IBOutlet NSMenu         *statusMenu;
    IBOutlet NSMenuItem     *statusMenuDisplay;
    
@private
    NSWindow                *_pomidorWindow;
    NSTimer                 *_countdownTimer;
    NSTimer                 *_fadeTimer;
    NSTimer                 *_fastForwardHintTimer;
    
    CABasicAnimation        *_popupAnimation;
    CABasicAnimation        *_hideFormAnimation;
    
    int                     _lastSecond;
    
    int                     _countDown;
    SoundController         *_alarmController;
    SoundController         *_tickController;
    
    WorkStateModel          *_state;
    
    BOOL                    windowFading;
    
    #define                 SECONDS 60
    
    NSMenuItem              *_showWindow;
    
    NSUserDefaults          *_userSettings;
    NSTextField             *_shortBreakMinutesChanged;
    NSTextField             *_longBreakMinutesChanged;
    
    NSTrackingArea          *_fastForwardTrackingArea;
    
    // Fade controllers
    FadeController          *_fastForwardFadeController;
    FadeController          *_formFadeController;
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


@end
