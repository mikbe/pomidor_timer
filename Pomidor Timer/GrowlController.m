//
//  GrowlController.m
//  Pomidor Timer
//
//  Created by Mike Bethany on 5/19/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import "GrowlController.h"


@implementation GrowlController

- (id)init
{
    self = [super init];
    if (self) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    
    return self;
}


- (void) growlNotificationWasClicked:(id)clickContext{
    if (clickContext && [clickContext isEqualToString:@"alarmClickContext"])
        [self alarmClicked];
    return;
}

/* Simple method to make an alert with growl that has no click context */
-(void) growlAlarm:(NSString *)message title:(NSString *)title{
    [GrowlApplicationBridge notifyWithTitle:title
                                description:message
                           notificationName:@"Alarm"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];
}

/* Simple method to make an alert with growl that has a click context */
-(void) growlAlertWithClickContext:(NSString *)message title:(NSString *)title{
    [GrowlApplicationBridge notifyWithTitle:title
                                description:message
                           notificationName:@"example"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:@"alarmClickContext"];
}

/* An example click context */
-(void) alarmClicked{
    /* code to execute when alert is clicked */
    NSLog(@"Alarm clicked");
    return;
}



- (void)dealloc
{
    [super dealloc];
}

@end
