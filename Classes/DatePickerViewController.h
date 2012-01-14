//
//  DatePickerViewController.h
//  Panda Alarm
//
//  Created by James Lubowich on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;

@interface DatePickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableViewCell *timeCell;
    
}

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) Alarm *currentAlarm;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction)dateChanged:(id)sender;
- (id)initWithAlarm:(Alarm *)alarm;
- (void)setDateLabel:(NSDate *)date;
@end
