//
//  Alarm.h
//  PandaAlarm
//
//  Created by James Lubowich on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Alarm : NSObject<NSCopying, NSCoding>{
    BOOL on;
	BOOL snoozeOn;
    
    NSString *name;
    NSString *sound;
	NSDate *date;
    
    NSMutableDictionary *selectedDaysOfTheWeek;
    NSArray *daysOfTheWeek;
        
    UILocalNotification *notification;
    NSString *alarmId;
}

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) BOOL snoozeOn;
@property (nonatomic, assign) BOOL reminderOn;
@property (nonatomic, assign) BOOL pandaOn;

@property (nonatomic, assign) NSInteger numberOfAlarms;
@property (nonatomic, assign) NSInteger repeatInterval;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sound;
@property (nonatomic, copy) NSDate *date;

@property (nonatomic, strong) NSMutableDictionary *selectedDaysOfTheWeek;
@property (nonatomic, strong) NSArray *daysOfTheWeek;

//@property (nonatomic, strong) NSMutableArray *scheduledNotifications;
@property (nonatomic, strong) UILocalNotification *notification;
@property (nonatomic, copy) NSString *alarmId;


- (NSString *)stringFromSelectedDaysOfTheWeek;
- (NSComparisonResult)compare:(Alarm *)other;
- (id)init;
- (void)turnOn;
- (void)turnOff;
- (void)scheduleNotification;
- (void)descheduleNotification;
- (void)setDate;

@end
