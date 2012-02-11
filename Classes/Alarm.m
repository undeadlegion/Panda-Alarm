//
//  Alarm.m
//  PandaAlarm
//
//  Created by James Lubowich on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm
@synthesize on, snoozeOn, reminderOn, pandaOn;
@synthesize extraAlarms, repeatInterval;
@synthesize name, sound, date;
@synthesize selectedDaysOfTheWeek, daysOfTheWeek;
@synthesize scheduledNotifications, alarmId;

#pragma mark -
#pragma mark Initialization

- (void)initSelectedDaysOfTheWeek{
    selectedDaysOfTheWeek = [[NSMutableDictionary alloc] init];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Mon"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Tue"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Wed"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Thu"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Fri"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Sat"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Sun"];
}

- (id)init{
    self = [super init];
    on = YES;
    snoozeOn = YES;
    reminderOn = NO;
    pandaOn = NO;
    
    extraAlarms = 0;
    repeatInterval = 1;
    
    name = @"Alarm";
    sound = @"Xylophone";
    date = [NSDate date];
    alarmId = [self.date description];
        
    [self initSelectedDaysOfTheWeek];
    daysOfTheWeek = [[NSArray alloc] 
                     initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];
    scheduledNotifications = [[NSMutableArray alloc] init];
	return self;
}


#pragma mark -
#pragma mark Instance methods

- (NSString *)stringFromSelectedDaysOfTheWeek{
    
    NSMutableString * string = [[NSMutableString alloc] init];
    for(id day in daysOfTheWeek){
        //append selected days to the string
        if([[selectedDaysOfTheWeek valueForKey:(NSString*)day] boolValue] == YES)
            [string appendFormat:@"%@ ",(NSString*)day];
    }
    
    //check for special cases (weekends, everyday...)
    if ([string isEqualToString:@""])
        [string setString:@"Never"];
    
    if([string isEqualToString:@"Mon Tue Wed Thu Fri "])
        [string setString:@"Weekdays"];
    
    if([string isEqualToString:@"Mon Tue Wed Thu Fri Sat Sun "])
        [string setString:@"Everyday"];
    
    if([string isEqualToString:@"Sat Sun "])
        [string setString:@"Weekends"];
    
    return string;
}

// extract hours and minutes from date and combine with today's date
- (void)updateDateYMD{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlagsHM = NSHourCalendarUnit|NSMinuteCalendarUnit;
    unsigned unitFlagsYMD = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDate *today = [NSDate date];
    
    NSDateComponents *todayYMD = [calendar components:unitFlagsYMD fromDate:today];
    NSDateComponents *alarmHM = [calendar components:unitFlagsHM fromDate:self.date];
    
    [alarmHM setYear:[todayYMD year]];
    [alarmHM setMonth:[todayYMD month]];
    [alarmHM setDay:[todayYMD day]];
    [alarmHM setSecond:0];
    
    self.date = [calendar dateFromComponents:alarmHM];
}

- (void)scheduleNotifications {
    NSLog(@"[Scheduling Alarm]");
    
    // when alarm was set on a previous date
    [self updateDateYMD];
    
    // if time has already passed increment one day
    if([self.date compare:[NSDate date]] == NSOrderedAscending){
            self.date = [self.date dateByAddingTimeInterval:24*3600];
            NSLog(@"Incremented To: %@", self.date);
    }

    // schedule all the alarms
    for (int i =  0; i <= extraAlarms; i++) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        notification.fireDate = [self.date dateByAddingTimeInterval:(60*repeatInterval*i)];
        NSLog(@"Scheduled: %@", notification.fireDate);
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        notification.alertBody = [NSString stringWithFormat:@"Wake up!!!"];
        notification.alertAction = @"View";
           
        NSDictionary *infoDict = [NSDictionary 
                                  dictionaryWithObject:alarmId forKey:@"Id"];
        notification.userInfo = infoDict;
        notification.soundName = @"sound.aiff";
        
        [scheduledNotifications addObject:notification];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

}

- (void)turnOn {
    self.on = YES;
    [self scheduleNotifications];    
}

- (void)turnOff {
    self.on = NO;
    for (UILocalNotification *notif in scheduledNotifications) {
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
    }
    [scheduledNotifications removeAllObjects];
//    NSLog(@"Deleting saved notification");
//    NSLog(@"Saved Scheduled notifications before: %@", scheduledNotifications);
//    NSLog(@"Notifications before: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);    
//    NSLog(@"Saved Scheduled notifications after: %@", scheduledNotifications);    
}

- (void)turnOffNotification: (UILocalNotification *)notif {

    NSLog(@"System Notifications before: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);    
    NSLog(@"Scheduled Notifications Before:%d", [scheduledNotifications count]);

    // notif is not the same object as in the array, so remove the notification with the same date
    NSUInteger index = [scheduledNotifications indexOfObjectPassingTest: ^(UILocalNotification *scheduledNotif, NSUInteger index, BOOL *STOP) {
                            return [notif.fireDate isEqualToDate:scheduledNotif.fireDate]; 
                        }];
    [scheduledNotifications removeObjectAtIndex:index];
    [[UIApplication sharedApplication] cancelLocalNotification:notif];
    
    NSLog(@"System Notifications after: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]); 
    NSLog(@"Scheduled Notifications After:%d", [scheduledNotifications count]);

    if ([scheduledNotifications count] == 0) {
        self.on = NO;
    }
}

- (NSComparisonResult)compare:(Alarm *)other {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlagsHM = NSHourCalendarUnit|NSMinuteCalendarUnit;

    NSDateComponents *selfHMComponents = [calendar components:unitFlagsHM fromDate:self.date];
    NSDateComponents *otherHMComponents = [calendar components:unitFlagsHM fromDate:other.date];
    NSDate *selfHMDate = [calendar dateFromComponents:selfHMComponents];
    NSDate *otherHMDate = [calendar dateFromComponents:otherHMComponents];
    
    return [selfHMDate compare:otherHMDate];
}

- (void)refreshScheduledNotifications {
    NSDate *today = [NSDate date];

    
    NSIndexSet *indexSet = [scheduledNotifications indexesOfObjectsPassingTest:^(UILocalNotification *notif, NSUInteger idx, BOOL *stop) {
        if ([today compare:notif.fireDate] == NSOrderedDescending) {
            return YES;
        }
        return NO;
    }];
    [scheduledNotifications removeObjectsAtIndexes:indexSet];
}

#pragma mark -
#pragma mark NSCoding protocol

- (id)initWithCoder:(NSCoder *)aDecoder{
//    [super initWithCoder:aDecoder];
    if((self = [super init])){
        on = [aDecoder decodeBoolForKey:@"On"];
        snoozeOn = [aDecoder decodeBoolForKey:@"Snooze"];
        reminderOn = [aDecoder decodeBoolForKey:@"Reminder"];
        pandaOn = [aDecoder decodeBoolForKey:@"Panda"];
        
        extraAlarms = [aDecoder decodeIntegerForKey:@"Extra Alarms"];
        repeatInterval = [aDecoder decodeIntegerForKey:@"Repeat Interval"];

        name = [aDecoder decodeObjectForKey:@"Name"];
        sound = [aDecoder decodeObjectForKey:@"Sound"];
        date = [aDecoder decodeObjectForKey:@"Date"];
    
        selectedDaysOfTheWeek = [aDecoder decodeObjectForKey:@"Selected Days"];
        daysOfTheWeek = [aDecoder decodeObjectForKey:@"Days of the Week"];
        
        scheduledNotifications = [aDecoder decodeObjectForKey:@"Notifications"];
        alarmId = [aDecoder decodeObjectForKey:@"Id"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    //[super encodeWithCoder:aCoder];
    [aCoder encodeBool:on forKey:@"On"];
    [aCoder encodeBool:snoozeOn forKey:@"Snooze"];
    [aCoder encodeBool:reminderOn forKey:@"Reminder"];
    [aCoder encodeBool:pandaOn forKey:@"Panda"];
    
    [aCoder encodeInteger:extraAlarms forKey:@"Extra Alarms"];
    [aCoder encodeInteger:repeatInterval forKey:@"Repeat Interval"];
    
    [aCoder encodeObject:name forKey:@"Name"];
    [aCoder encodeObject:sound forKey:@"Sound"];
    [aCoder encodeObject:date forKey:@"Date"];
    
    [aCoder encodeObject:selectedDaysOfTheWeek forKey:@"Seleced Days"];
    [aCoder encodeObject:daysOfTheWeek forKey:@"Days of the Week"];

    [aCoder encodeObject:scheduledNotifications forKey:@"Notifications"];
    [aCoder encodeObject:alarmId forKey:@"Id"];
}


#pragma mark -
#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone{
    Alarm *alarmCopy = [Alarm allocWithZone:zone];
    
    alarmCopy.on = on;
    alarmCopy.snoozeOn = snoozeOn;
    alarmCopy.reminderOn = reminderOn;
    alarmCopy.pandaOn = pandaOn;
    
    alarmCopy.extraAlarms = extraAlarms;
    alarmCopy.repeatInterval = repeatInterval;
    
    alarmCopy.name = name;
    alarmCopy.sound = sound;
    alarmCopy.date = date;
    
    alarmCopy.selectedDaysOfTheWeek = [selectedDaysOfTheWeek mutableCopy];
    alarmCopy.daysOfTheWeek = [daysOfTheWeek copy];

    alarmCopy.scheduledNotifications = [scheduledNotifications mutableCopy];
    alarmCopy.alarmId = alarmId;
    return alarmCopy;
}
@end
