//
//  Panda_AlarmAppDelegate.m
//  Panda Alarm
//
//  Created by James Lubowich on 8/5/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Panda_AlarmAppDelegate.h"
#import "RootViewController.h"
#import "Alarm.h"
#import "GameViewController.h"
#import "StringGameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation Panda_AlarmAppDelegate
@synthesize window, navigationController, rootViewController, alarmsList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"FINISHED LAUNCHING");
    
    //restore saved settings
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AlarmList.archive"];
    alarmsList = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    // CHANGE AFTER TESTING
    alarmsList = nil;
    [application cancelAllLocalNotifications];

    
    // no saved settings
    if(alarmsList == nil) {
        NSLog(@"Using Defualt Alarms");
        alarmsList = [[NSMutableArray alloc] init];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    } else {
        NSLog(@"Using Archived Alarms");
    }
    
    // inject list
    rootViewController.alarmsList = alarmsList;

    //check if opened by an alarm
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notif != nil){
        NSLog(@"App opened by Notifciation in DidFinishLaunching");
        [self turnOffAlarmWithId: [notif.userInfo objectForKey:@"Id"] notification:notif ];
        [self startGame];
    }
    
    NSError *setCategoryError = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session
     setCategory: AVAudioSessionCategorySoloAmbient//AVAudioSessionCategoryPlayback
     error: &setCategoryError];
     
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    
    //make view visible
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void) _showAlert:(NSString*)pushmessage withTitle:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)startDotGame {
    UIViewController *gameViewController;
    
    gameViewController = [[GameViewController alloc] init];
    
    UIViewController *topViewController = [navigationController topViewController];
    NSLog(@"top view controller before: %@", [topViewController class]);
    [navigationController pushViewController:gameViewController animated:NO];
    
    topViewController = [navigationController topViewController];
    NSLog(@"top view controller after: %@", [topViewController class]);

}
- (void)startGame{
    UIViewController *gameViewController;
    
//    if(arc4random()%2 == 0)
//        gameViewController = [[GameViewController alloc] init];
//    else
         gameViewController = [[StringGameViewController alloc] init];
    
    UIViewController *topViewController = [navigationController topViewController];
    NSLog(@"top view controller before: %@", [topViewController class]);
    [navigationController pushViewController:gameViewController animated:NO];

    
    topViewController = [navigationController topViewController];
    NSLog(@"top view controller after: %@", [topViewController class]);

}

- (void)turnOffAlarmWithId:(NSString*)alarmId notification:(UILocalNotification *) notif {
    Alarm *firingAlarm;
    for (Alarm *alarm in alarmsList) {
        if([alarm.alarmId isEqualToString:alarmId]){
            firingAlarm = alarm;
            break;
        }
    }
    [firingAlarm turnOffNotification:notif];
}

- (void)refreshAlarmsList {
    for (Alarm *alarm in alarmsList) {
        [alarm refreshScheduledNotifications];
    }
}

// Handle the notificaton when the app is running
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"Did Receive Local Notification %@",notif);
    NSLog(@"Class of top view controller %@", [[navigationController topViewController] class]);
    NSLog(@"Notifications before: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);    
    
    [self turnOffAlarmWithId: [notif.userInfo objectForKey:@"Id"] notification:notif];
    
    NSLog(@"Notifications after: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    
    // ignore if already playing a game
    UIViewController *topViewController = [navigationController topViewController];
    if([topViewController isKindOfClass:[GameViewController class]]
    ||[topViewController isKindOfClass:[StringGameViewController class]]){
        NSLog(@"Receied Notification while in game: ignored");
        return;
    }
    [self startGame];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Will Terminate");
    
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AlarmList.archive"];
    [NSKeyedArchiver archiveRootObject:rootViewController.alarmsList toFile:archivePath];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"Did become active");
}
- (void)applicationWillResignActive:(UIApplication *)application{
    NSLog(@"Resigned Active");
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"Did enter Background");
    NSString *archivePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AlarmList.archive"];
    [NSKeyedArchiver archiveRootObject:rootViewController.alarmsList toFile:archivePath];
}
- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"Will enter Foreground");
    [self refreshAlarmsList];
}



@end
