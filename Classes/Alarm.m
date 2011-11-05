//
//  Alarm.m
//  PandaAlarm
//
//  Created by James Lubowich on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"


@implementation Alarm

@synthesize sound, snooze, name, date, on;
@synthesize selectedDaysOfTheWeek, daysOfTheWeek;
@synthesize notification, alarmId;

#pragma mark -
#pragma mark Initialization

- (void)initSelectedDaysOfTheWeek{
    selectedDaysOfTheWeek = [[NSMutableDictionary alloc] init];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:YES] forKey:@"Mon"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Tue"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Wed"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Thu"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Fri"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Sat"];
    [selectedDaysOfTheWeek setObject:[NSNumber numberWithBool:NO] forKey:@"Sun"];
}

- (id)init{
    [super init];
    self.on = YES;
    self.snooze = YES;
    
    self.name = @"Alarm";
    self.sound = @"Xylophone";
    self.date = [NSDate date];
    self.alarmId = [self.date description];
        
    [self initSelectedDaysOfTheWeek];
    daysOfTheWeek = [[NSArray alloc] 
                     initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];

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
    if([string isEqualToString:@"Mon Tue Wed Thu Fri "])
        [string setString:@"Weekdays"];
    
    if([string isEqualToString:@"Mon Tue Wed Thu Fri Sat Sun "])
        [string setString:@"Everyday"];
    
    if([string isEqualToString:@"Sat Sun "])
        [string setString:@"Weekends"];
    
    [string autorelease];
    return string;
}

// extract hours and minutes from date and combine with today's date
- (void)setDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlagsHM = NSHourCalendarUnit|NSMinuteCalendarUnit;
    unsigned unitFlagsYMD = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDate *today = [NSDate date];
    
    NSDateComponents *todayYMD = [calendar components:unitFlagsYMD fromDate:today];
    NSDateComponents *alarmHM = [calendar components:unitFlagsHM fromDate:self.date];
    
    [alarmHM setYear:[todayYMD year]];
    [alarmHM setMonth:[todayYMD month]];
    [alarmHM setDay:[todayYMD day]];
    
    self.date = [calendar dateFromComponents:alarmHM];
}
- (void)scheduleNotification {
    NSLog(@"[Scheduling Alarm]");
    notification = [[UILocalNotification alloc] init];
    
    if (notification == nil)
        return;
    
    notification.fireDate = self.date;
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *todayYMDComps = [calendar components:unitFlags fromDate:today];
    NSDateComponents *alarmYMDComps = [calendar components:unitFlags fromDate:self.date];
    NSDate *todayYMD = [calendar dateFromComponents:todayYMDComps];
    NSDate *alarmYMD = [calendar dateFromComponents:alarmYMDComps];
    
    NSLog(@"Original:    %@", self.date);
    
    // if alarm was not set today, update the YMD
    if (![todayYMD isEqualToDate:alarmYMD]) {
        [self setDate];
        NSLog(@"Reset Day: %@", self.date);
    }
    
    //if date has already passed increment one day
    if([self.date compare:today] == NSOrderedAscending){
            self.date = [self.date dateByAddingTimeInterval:24*3600];
            NSLog(@"Incremented: %@", self.date);
    }
    
    notification.fireDate = self.date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    notification.alertBody = [NSString stringWithFormat:@"Wake up!!!"];
    notification.alertAction = @"View";

    // alarm has to be archived in notification
//    NSData *serialzedAlarm = [NSKeyedArchiver archivedDataWithRootObject:self];    
    NSDictionary *infoDict = [NSDictionary 
                              dictionaryWithObject:alarmId forKey:@"Id"];
    notification.userInfo = infoDict;
    notification.soundName = @"sound.aiff";
    notification.repeatInterval = NSMinuteCalendarUnit;

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)descheduleNotification {
    NSLog(@"Descheduling");
    if(notification == nil)
        return;
    if([notification.fireDate compare:[NSDate date]] == NSOrderedDescending){
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        NSLog(@"Cancelled Alarm");
    }
    [notification release];
    notification = nil;
}

- (void)turnOn{
    self.on = YES;
    [self scheduleNotification];
}

- (void)turnOff{
    self.on = NO;
    [self descheduleNotification];
}


#pragma mark -
#pragma mark NSCoding protocol

- (id)initWithCoder:(NSCoder *)aDecoder{
//    [super initWithCoder:aDecoder];
    if((self = [super init])){
        on = [aDecoder decodeBoolForKey:@"On"];
        snooze = [aDecoder decodeBoolForKey:@"Snooze"];

        name = [[aDecoder decodeObjectForKey:@"Name"] retain];
        sound = [[aDecoder decodeObjectForKey:@"Sound"] retain];
        date = [[aDecoder decodeObjectForKey:@"Date"] retain];
    
        selectedDaysOfTheWeek = [[aDecoder decodeObjectForKey:@"Selected Days"] retain];
        daysOfTheWeek = [[aDecoder decodeObjectForKey:@"Days of the Week"] retain];
        notification = [[aDecoder decodeObjectForKey:@"Notification"] retain];
        alarmId = [[aDecoder decodeObjectForKey:@"Id"] retain];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    //[super encodeWithCoder:aCoder];
    [aCoder encodeBool:on forKey:@"On"];
    [aCoder encodeBool:snooze forKey:@"Snooze"];
    
    [aCoder encodeObject:name forKey:@"Name"];
    [aCoder encodeObject:sound forKey:@"Sound"];
    [aCoder encodeObject:date forKey:@"Date"];
    
    [aCoder encodeObject:selectedDaysOfTheWeek forKey:@"Seleced Days"];
    [aCoder encodeObject:daysOfTheWeek forKey:@"Days of the Week"];

    [aCoder encodeObject:notification forKey:@"Notification"];
    [aCoder encodeObject:alarmId forKey:@"Id"];
}


#pragma mark -
#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone{
    Alarm *alarmCopy = [Alarm allocWithZone:zone];
    
    alarmCopy.on = on;
    alarmCopy.snooze = snooze;
    
    alarmCopy.name = name;
    alarmCopy.sound = sound;
    alarmCopy.date = [date copy];
    
    alarmCopy.selectedDaysOfTheWeek = [selectedDaysOfTheWeek mutableCopy];
    alarmCopy.daysOfTheWeek = daysOfTheWeek;

    alarmCopy.notification = notification;
    alarmCopy.alarmId = alarmId;
    return alarmCopy;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc{
    [selectedDaysOfTheWeek release];
    [daysOfTheWeek release];
    
    [name release];
    [sound release];
    [date release];
    
    [notification release];
    
    [super dealloc];
}

@end

/*
 id key;
 NSEnumerator *enumerator = [selectedDaysOfTheWeek keyEnumerator];
 while(key = [enumerator nextObject]){
 NSLog(@"key: %@ value: %d", key, [[selectedDaysOfTheWeek valueForKey:key]boolValue]);
 }
 
 enumerator = [alarmCopy.selectedDaysOfTheWeek keyEnumerator];
 while(key = [enumerator nextObject]){
 NSLog(@"copy key: %@ value: %d", key, [[selectedDaysOfTheWeek valueForKey:key]boolValue]);
 }
 */
