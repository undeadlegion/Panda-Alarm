//
//  Panda_AlarmAppDelegate.h
//  Panda Alarm
//
//  Created by James Lubowich on 8/5/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@class RootViewController;

@interface Panda_AlarmAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;
    RootViewController *rootViewController; 
    NSMutableArray *alarmsList;   
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet RootViewController *rootViewController;

- (void)startGame;
- (void)turnOffAlarmWithId:(NSString*) AlarmId;
@end