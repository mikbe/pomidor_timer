//
//  Pomidor_TimerAppDelegate.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Pomidor_TimerAppDelegate.h"

@interface Pomidor_TimerAppDelegate()

@end

@implementation Pomidor_TimerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // I thought Red would be cute but it's just annoying
    //[window setBackgroundColor:[NSColor colorWithCalibratedRed:1 green:0.0 blue:0.0 alpha:0.75]];   
}

-(IBAction)startStopTimer:(id)sender {
    if (startStopTimerButton.title == @"stop") {
        [timer invalidate];
        timer = nil;
        startStopTimerButton.title = @"start";
    }
    else  {
        startStopTimerButton.title = @"stop";
        countDown = MAX_TIMER;
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(timerFiredMethod:)
                                               userInfo:nil
                                                repeats:YES];
    }
    
}

- (IBAction)resetTimer:(id)sender {
    [AlarmController stopAlarm];
}

- (void)timerFiredMethod:(NSTimer*)theTimer {
    countDown--;
    int secs = countDown % 60;
    int mins = countDown / 60;
    NSLog(@"%i %02i:%02i", countDown, mins, secs);
    [timerDisplay setStringValue:[NSString stringWithFormat:@"%02i:%02i", mins, secs]];

    if (countDown == 0)
    {
        [AlarmController startAlarm];
        [self startStopTimer:nil];
    }
    
}

@end
