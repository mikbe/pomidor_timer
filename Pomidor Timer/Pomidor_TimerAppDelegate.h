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

@interface Pomidor_TimerAppDelegate : NSObject <NSApplicationDelegate> {
    
    IBOutlet NSSlider       *alarmVolume;
    IBOutlet NSSlider       *tickVolume;
    IBOutlet NSTextField    *timerDisplay;
    IBOutlet NSButton       *startStopTimerButton;
    IBOutlet NSTextField    *longBreak;
    IBOutlet NSTextField    *shortBreak;
    
    IBOutlet NSTextField    *cycleDisplay;
    
    IBOutlet NSButton       *bubbleCounter1;
    IBOutlet NSButton       *bubbleCounter2;
    IBOutlet NSButton       *bubbleCounter3;
    IBOutlet NSButton       *bubbleCounter4;
    
@private
    NSWindow        *window;
    NSTimer         *timer;
    int             countDown;
    int             cycleCount; // How many times we've done a 25 min cycle
    SoundController *alarmController;
    SoundController *tickController;
    
    #define         MAX_TIMER (4 * 1)
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)startStopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)alarmVolumeChange:(id)sender;
- (IBAction)tickVolumeChanged:(id)sender;
- (void)startTimer;
- (void)stopTimer;

@end
