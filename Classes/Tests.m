//
//  Tests.m
//  Panda Alarm
//
//  Created by James Lubowich on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tests.h"

@implementation Tests


- (void) testAlarmAlloc {
	Alarm *alarm = [[Alarm alloc] init];
	STAssertNotNil(alarm, @"Not being allocated");
	
}

//- (void) testAlarmCopy {
//    Alarm *alarm = [[Alarm alloc] init];
//    Alarm *copy = [alarm copy];
//    NSUInteger one = 1, four = 4;
//
//    
//    Alarm *anotherCopy = [alarm copy];
//    STAssertTrue(![anotherCopy isEqual:copy], @"Another Copy Equal");
//    
//    Alarm *copyOfCopy = [copy copy];
//    STAssertTrue(![copyOfCopy isEqual:copy], @"Copy of Copy equal");
//
//    
//    NSLog(@"Retain Count: %d", [alarm.daysOfTheWeek retainCount]);
//    
//    STAssertEquals([alarm retainCount], one, @"Retain Count Not 1");
//    STAssertEquals([copy retainCount], one, @"Retain Count Not 1");
//    STAssertEquals([anotherCopy retainCount], one, @"Retain Count Not 1");
//    STAssertEquals([copyOfCopy retainCount], one, @"Retain Count Not 1");
//    
//    STAssertEquals([alarm.daysOfTheWeek retainCount], four, @"Retain Count Not 4");
//    
//    [alarm release];
//    [copy release];
//    [anotherCopy release];
//    
//    STAssertEquals([copyOfCopy.daysOfTheWeek retainCount], one, @"Retain Count Not 1");
//}

- (void) testAlarmRelease {
    
}


- (void) testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

@end
