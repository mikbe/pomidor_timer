//
//  GrowlController.h
//  Pomidor Timer
//
//  Created by Mike Bethany on 5/19/11.
//  Copyright 2011 http://mikbe.tk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Growl.framework/Headers/GrowlApplicationBridge.h"
@interface GrowlController : NSObject <GrowlApplicationBridgeDelegate> {
@private
    
}

-(void) growlNotificationWasClicked:(id)clickContext;
-(void) growlAlarm:(NSString *)message title:(NSString *)title;
-(void) growlAlertWithClickContext:(NSString *)message title:(NSString *)title;

@end
