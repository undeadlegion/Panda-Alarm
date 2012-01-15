//
//  AlarmViewController.m
//  PandaAlarm
//
//  Created by James Lubowich on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"
#import "AlarmDetailViewController.h"
#import "RepeatDetailViewController.h"
#import "NameDetailViewController.h"
#import "DatePickerViewController.h"

@implementation AlarmDetailViewController
@synthesize repeatIntervalSlider, repeatIntervalLabel, numberOfAlarmsSlider, numberOfAlarmsLabel;
@synthesize myTableView, currentAlarm;
@synthesize beginCell, endCell, numberCell, intervalCell;
@synthesize nameCell, soundCell, repeatCell;
@synthesize reminderCell, snoozeCell, pandaWakeupCell;

#pragma mark -
#pragma mark View and init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //load options table
	[self.myTableView reloadData];	
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //update cells
    [self updateViewWithCurrentAlarm];
    
    //reload cells
	[self.myTableView reloadData];
}


- (void)updateViewWithCurrentAlarm {
    //update cells
    repeatCell.detailTextLabel.text = [currentAlarm stringFromSelectedDaysOfTheWeek];
    soundCell.detailTextLabel.text = currentAlarm.sound;
    nameCell.detailTextLabel.text = currentAlarm.name;
    //update snooze cell on/off

    numberOfAlarmsSlider.value = currentAlarm.numberOfAlarms; 
    [numberOfAlarmsSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    repeatIntervalSlider.value = currentAlarm.repeatInterval;
    [repeatIntervalSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
//    NSLog(@"Checking if setting date");
//    if (datePicker) {
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *timeText = [formatter stringFromDate:currentAlarm.date];
        NSLog(@"Setting Date %@", timeText);
        beginCell.detailTextLabel.text = timeText;
//    }
}

- (id)init{
    self = [super init];
	//initialize alarm for this view
	currentAlarm = [[Alarm alloc] init];
    [self initCells];
	return self;
}

- (void)initCells {
	//convert date to string 
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	NSString *timeText = [formatter stringFromDate:currentAlarm.date];
    
    beginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    beginCell.textLabel.text = @"First Alarm";
    beginCell.detailTextLabel.text = timeText;
    beginCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    endCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    endCell.textLabel.text = @"Last Alarm";
    endCell.detailTextLabel.text = timeText;
    endCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IntervalCell" owner:self options:nil];
    intervalCell = [topLevelObjects objectAtIndex:0];
    [(UILabel *)[intervalCell viewWithTag:1] setText:@"Interval"];
    repeatIntervalSlider = (UISlider *)[intervalCell viewWithTag:2];
    repeatIntervalLabel = (UILabel *)[intervalCell viewWithTag:3];
    repeatIntervalLabel.text = @"1 min";
    repeatIntervalSlider.maximumValue = 20;

    [repeatIntervalSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
   
    topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IntervalCell" owner:self options:nil];
    numberCell = [topLevelObjects objectAtIndex:0];
    [(UILabel *)[numberCell viewWithTag:1] setText:@"Number"];
    numberOfAlarmsSlider = (UISlider *)[numberCell viewWithTag:2];
    numberOfAlarmsLabel = (UILabel *)[numberCell viewWithTag:3];

    numberOfAlarmsLabel.text = @"1";
    numberOfAlarmsSlider.maximumValue = 10;
    [numberOfAlarmsSlider addTarget:self action:@selector(numberSliderChanged:) forControlEvents:UIControlEventValueChanged];

    nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    nameCell.textLabel.text = @"Name";
    nameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    soundCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    soundCell.textLabel.text = @"Sound";
    soundCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    repeatCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: nil];
    repeatCell.textLabel.text = @"Repeat";
    repeatCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    reminderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    reminderCell.textLabel.text = @"Wakeup Reminder";
    reminderCell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    snoozeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    snoozeCell.textLabel.text = @"Snooze";
    snoozeCell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    pandaWakeupCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    pandaWakeupCell.textLabel.text = @"Panda Wakeup";
    pandaWakeupCell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];

    
}

- (void)sliderChanged:(id)sender {
    NSLog(@"Repeat Interval Slider changed %d", (int)repeatIntervalSlider.value);
    repeatIntervalLabel.text = [NSString stringWithFormat:@"%d min", (int)repeatIntervalSlider.value];
    currentAlarm.repeatInterval = repeatIntervalSlider.value;
}

- (void)numberSliderChanged:(id)sender {
    NSLog(@"Number Slider Changed %d", (int)numberOfAlarmsSlider.value);
    numberOfAlarmsLabel.text = [NSString stringWithFormat:@"%d", (int)numberOfAlarmsSlider.value];
    currentAlarm.numberOfAlarms = numberOfAlarmsSlider.value;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIViewController *viewController = nil;
	switch (indexPath.section) {
		case 0:
            viewController = [[DatePickerViewController alloc] initWithAlarm:currentAlarm];
            [viewController loadView];
//            [viewController addObserver:self forKeyPath:@"datePicker.date" options:NSKeyValueObservingOptionNew context:NULL ];
//            datePicker = ((DatePickerViewController *)viewController).datePicker;
            if (indexPath.row == 0) {
                viewController.title = @"First Alarm";
            } else {
                viewController.title = @"Last Alarm";
            }
			break;
		case 1:				
			//viewController = [[SoundViewController alloc] init];
			break;
        case 2:
            break;
		case 3:
			viewController = [[NameDetailViewController alloc] initWithAlarm:currentAlarm];
			break;
            viewController = [[RepeatDetailViewController alloc] initWithAlarm:currentAlarm];
	}
	
	//push new view onto the stack
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"Observing shit!!");
}
#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Time";
        case 1:
            return @"Multiple Alarms";
        case 2:
            return @"Details";
        case 3:
            return @"Snooze";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 3;
        case 3:
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
            if (indexPath.row == 0) {
                return beginCell;
            }
        case 1:
            if (indexPath.row == 0) {
                return numberCell;
            } else if (indexPath.row == 1) {
                return intervalCell;
            }        
        case 2:				
            if (indexPath.row == 0) {
                return nameCell;
            } else if (indexPath.row == 1) {
                return soundCell;
            } else {
                return repeatCell;
            }
            
		case 3:
            if (indexPath.row == 0) {
                return reminderCell;
            } else if (indexPath.row == 1) {
                return snoozeCell;
            } else {
                return pandaWakeupCell;
            }
            
        default:
            NSLog(@"Returning empty cell");
            return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

#pragma mark -
#pragma mark Target action

//- (void)setAlarmDate {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//        
//    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
//                    |NSHourCalendarUnit|NSMinuteCalendarUnit;
//    NSDateComponents *pickerComps = [calendar components:unitFlags fromDate:currentAlarm.date];
//    currentAlarm.date = [calendar dateFromComponents:pickerComps];
//}

- (void)saveAlarmSettings {
    NSLog(@"[Saving Alarm Settings]");
    currentAlarm.sound = soundCell.detailTextLabel.text;
    currentAlarm.name = nameCell.detailTextLabel.text;
    currentAlarm.numberOfAlarms = (NSInteger)numberOfAlarmsSlider.value;
    currentAlarm.repeatInterval = (NSInteger)repeatIntervalSlider.value;
    // should settings just automatically save to the new alarm?
    
//    [self setAlarmDate];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (id)initWithAlarm:(Alarm *)alarm{
    [super init];
    
	currentAlarm = alarm;
	NSLog(@"current alarm %@", [self.currentAlarm time]);
	[self.datePicker setDate:alarm.time animated: NO];
	
	[self.myTableView reloadData];	

	//update alarm name label
	UILabel *name = (UILabel *)[nameCell viewWithTag:1];
	name.text = currentAlarm.name;
	
	UILabel *repeat = (UILabel *)[repeatCell viewWithTag:1];
	repeat.text = currentAlarm.repeat;
	
	self.soundCell.textLabel.text = @"Penis";//currentAlarm.sound;
	
	//UISwitch *onSwitch = (UISwitch *)[snoozeCell viewWithTag:2];
	//onSwitch.state = currentAlarm.snooze;
	
	self.nameCell.textLabel.text = currentAlarm.name;
	
	return self;
}
*/

@end
