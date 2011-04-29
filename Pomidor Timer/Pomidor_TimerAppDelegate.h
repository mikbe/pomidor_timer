//
//  Pomidor_TimerAppDelegate.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 3/26/11.
//  Copyright 2011 http://mikbe.tk 
//  All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SoundController.h"
#import "WorkStateModel.h"

@interface Pomidor_TimerAppDelegate : NSObject <NSApplicationDelegate> {
    
    // Timer tab
    IBOutlet NSTextField    *timerDisplay;
    IBOutlet NSButton       *startPauseTimerButton;  
    IBOutlet NSButton       *fastForwardButton;     
    
    IBOutlet NSTextField    *statusText;
    IBOutlet NSTextField    *workCountDisplay;
    
    IBOutlet NSButton       *bubbleCounter0;
    IBOutlet NSButton       *bubbleCounter1;
    IBOutlet NSButton       *bubbleCounter2;
    IBOutlet NSButton       *bubbleCounter3;
    
    // Options tab
    IBOutlet NSTextField    *longBreakMinutes;
    IBOutlet NSTextField    *shortBreakMinutes;
    IBOutlet NSSlider       *alarmVolume;
    IBOutlet NSSlider       *tickVolume;
    
    // Status bar
    NSStatusItem            *menuBarDisplay;
    IBOutlet NSMenu         *statusMenu;
    IBOutlet NSMenuItem     *statusMenuDisplay;
    
@private
    NSWindow                *_pomidorWindow;
    NSTimer                 *_countdownTimer;
    NSTimer                 *_fadeTimer;
    
    int                     _lastSecond;
    
    int                     _countDown;
    SoundController         *_alarmController;
    SoundController         *_tickController;
    
    WorkStateModel          *_state;
    
    #define                 SECONDS 60
    #define                 MAX_TIMER (25 * SECONDS)
    
    NSMenuItem              *_showWindow;
    
    NSUserDefaults          *_userSettings;
    NSTextField             *_shortBreakMinutesChanged;
    NSTextField             *_longBreakMinutesChanged;
}

// Timer tab
- (IBAction)startPauseTimer:(id)sender;
- (IBAction)fastForward:(id)sender;
- (IBAction)resetTimer:(id)sender;

// Options tab
- (IBAction)alarmVolumeChanged:(id)sender;
- (IBAction)tickVolumeChanged:(id)sender;
- (IBAction)shortBreakMinutesChanged:(id)sender;
- (IBAction)longBreakMinutesChanged:(id)sender;

// Status bar
- (IBAction)toggleWindow:(id)sender;

@end
