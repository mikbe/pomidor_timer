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
    NSWindow                *pomidorWindow;
    NSTimer                 *timer;
    int                     lastSecond;
    
    int                     countDown;
    SoundController         *alarmController;
    SoundController         *tickController;
    
    WorkStateModel          *state;
    
    #define                 SECONDS 60
    #define                 MAX_TIMER (25 * SECONDS)
    
    NSMenuItem              *showWindow;
}

@property (assign) IBOutlet NSWindow *pomidorWindow;

// Timer tab
- (IBAction)startPauseTimer:(id)sender;
- (IBAction)fastForward:(id)sender;
- (IBAction)resetTimer:(id)sender;

// Options tab
- (IBAction)alarmVolumeChange:(id)sender;
- (IBAction)tickVolumeChanged:(id)sender;

// Status bar
- (IBAction)showWindow:(id)sender;

@end
