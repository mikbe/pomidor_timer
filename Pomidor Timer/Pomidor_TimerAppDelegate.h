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
    
    IBOutlet NSSlider       *alarmVolume;
    IBOutlet NSSlider       *tickVolume;
    IBOutlet NSTextField    *timerDisplay;
    IBOutlet NSButton       *startPauseTimerButton;
    IBOutlet NSTextField    *longBreak;
    IBOutlet NSTextField    *shortBreak;
    
    IBOutlet NSTextField    *statusText;
    
    IBOutlet NSTextField    *workCountDisplay;
    
    IBOutlet NSButton       *bubbleCounter0;
    IBOutlet NSButton       *bubbleCounter1;
    IBOutlet NSButton       *bubbleCounter2;
    IBOutlet NSButton       *bubbleCounter3;
    
@private
    NSWindow        *window;
    NSTimer         *timer;
    int             countDown;
    SoundController *alarmController;
    SoundController *tickController;
    
    WorkStateModel      *state;
    
    #define         SECONDS 60
    #define         MAX_TIMER (25 * SECONDS)
    
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)startPauseTimer:(id)sender;
- (IBAction)fastForward:(id)sender;
- (IBAction)resetTimer:(id)sender;

- (IBAction)alarmVolumeChange:(id)sender;
- (IBAction)tickVolumeChanged:(id)sender;

- (void)startTimer;
- (void)pauseTimer;

@end
