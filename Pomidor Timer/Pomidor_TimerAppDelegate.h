//
//  Pomidor_TimerAppDelegate.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 3/26/11.
//  Copyright 2011 http://mikbe.tk All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AlarmController.h"

@interface Pomidor_TimerAppDelegate : NSObject <NSApplicationDelegate> {
    
    IBOutlet NSSlider       *soundVolume;
    IBOutlet NSTextField    *timerDisplay;
    IBOutlet NSButton       *startStopTimerButton;
    IBOutlet NSTextField    *longBreak;
    IBOutlet NSTextField    *shortBreak;
    IBOutlet NSButtonCell   *timeCounter15;
    IBOutlet NSButtonCell   *timeCounter30;
    
@private
    NSWindow    *window;
    NSInteger   *maxTime;
    NSTimer     *timer;
    int         countDown;
    #define     MAX_TIMER (2 * 1)
    NSSound     *alarmSound;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)startStopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;

@end
