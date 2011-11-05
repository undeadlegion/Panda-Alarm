//
//  RootViewController.m
//  Panda Alarm
//
//  Created by James Lubowich on 8/5/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//


#import "RootViewController.h"
#import "Alarm.h"
#import "AlarmDetailViewController.h"
#import "GameViewController.h"
#import "Panda_AlarmAppDelegate.h"

@implementation RootViewController

@synthesize alarmsList;
@synthesize selectedAlarm, backedUpAlarm;


#pragma mark -
#pragma mark View and init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //make the title of this page the same as the title of the app
	self.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	
	//add edit button
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	//add plus button
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
        target:self 
        action:@selector(addAlarm:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //show the navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //set target for AlarmDetailViewController's cancel and save buttons to self
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
        target:self 
        action:@selector(cancelFromAlarmDetailViewController:)];
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                 target:self 
                                                                                 action:@selector(savedAlarm:)];
    
    //initialize detail view controller
    alarmDetailViewController = [[AlarmDetailViewController alloc] init];
    alarmDetailViewController.navigationItem.leftBarButtonItem = cancelButton;
    alarmDetailViewController.navigationItem.rightBarButtonItem = saveButton;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //reload any changes
    [self.tableView reloadData];
}


- (void)initList:(NSMutableArray *)list {
    alarmsList = list;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [alarmsList count];
}

//returns cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

//loads each cell when scrolling
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"AlarmsListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //load cell from nib
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AlarmsListCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
     
    //get alarm representing this cell	
	Alarm *currentAlarm = [alarmsList objectAtIndex:indexPath.row];
    
    //update cell information
    [self updateCell:cell withAlarm:currentAlarm];
//cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

//sets up a cell to display an alarm
- (void)updateCell:(UITableViewCell *)cell withAlarm:(Alarm *)alarm {
    //update time label
    UILabel *time, *name, *amPm; 
	time = (UILabel *)[cell viewWithTag:1]; 
	
	//set date format
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm"];
	
	//convert to string 
	time.text = [formatter stringFromDate:alarm.date];
//time.textColor = [UIColor whiteColor];
    
    
    //update am/pm
    amPm = (UILabel *)[cell viewWithTag:5];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSHourCalendarUnit;
    NSDateComponents *components = [calendar components:flags fromDate:alarm.date];

    if(components.hour >= 12 && components.hour != 24){
        amPm.text = @"Pm";
        cell.backgroundColor = [UIColor darkGrayColor];
        time.textColor = [UIColor lightTextColor];
    }
    else{
        amPm.text = @"Am";
        cell.backgroundColor = [UIColor whiteColor];
        time.textColor = [UIColor darkGrayColor];
    }


	//update alarm on off switch
	UISwitch *onSwitch = (UISwitch *)[cell viewWithTag:2];
//	UISwitch *onSwitch = [[UISwitch alloc ] initWithFrame:CGRectZero];
    
    cell.accessoryView = onSwitch;
    onSwitch.on = alarm.on;

	    
	//update alarm name label
	name = (UILabel *)[cell viewWithTag:3];
	name.text = alarm.name;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"About to be deleted");
        // Delete the row from the data source.
        [alarmsList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        NSLog(@"Why are we inserting?");
    }   
}
/*
 Implement for custom animations
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UISwitch *on = (UISwitch *)[cell viewWithTag:2];
    [on setHidden:YES];    
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UISwitch *on = (UISwitch *)[cell viewWithTag:2];
    [on setHidden:NO];    
}
 */

#pragma mark Table view delegate

//pushes alarm detail view onto the stack
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //property retains selectedAlarm
    self.selectedAlarm = [alarmsList objectAtIndex:indexPath.row];

    //property copies selectedAlarm
    self.backedUpAlarm = selectedAlarm;
    
    //set controller to display selected alarm
    alarmDetailViewController.currentAlarm = selectedAlarm;
    alarmDetailViewController.title = @"Edit Alarm"; 
    
    //push controller onto the stack
    [self.navigationController pushViewController:alarmDetailViewController animated:YES];
}


#pragma mark -
#pragma mark Target action

- (void)savedAlarm:(id)sender{
    //update alarm
    [alarmDetailViewController updateAlarm];

    //alarm already exists in the list
    if([alarmDetailViewController.title isEqualToString:@"Edit Alarm"]){
        [alarmsList removeObject:selectedAlarm];
    }
    
    //add it to the list in ascending order
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlagsHM = NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *selectedHMComps = [calendar components:unitFlagsHM fromDate:selectedAlarm.date];
    NSDate *selectedHM = [calendar dateFromComponents:selectedHMComps];
    
    int i = 0;
    for (Alarm *alarm in alarmsList) {
        NSDateComponents *alarmHMComps = [calendar components:unitFlagsHM fromDate:alarm.date];
        NSDate *alarmHM = [calendar dateFromComponents:alarmHMComps];
        if([selectedHM compare:alarmHM] == NSOrderedAscending){
            break;
        }
        i++;
    }
    
    [alarmsList insertObject:selectedAlarm atIndex:i];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    [selectedAlarm turnOn];
}

- (void)cancelFromAlarmDetailViewController:(id)sender{

    //index of alarm being modified
    NSUInteger index = [alarmsList indexOfObject:selectedAlarm];
    
    //newly added alarm needs to be removed
    if([alarmDetailViewController.title isEqualToString: @"Add Alarm"]){
        [alarmsList removeObject:selectedAlarm];
    }
    //otherwise restore original alarm
    else{
        [alarmsList replaceObjectAtIndex:index withObject:backedUpAlarm];
    }

    //pop detail view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    NSInteger count = [[[UIApplication sharedApplication]scheduledLocalNotifications] count];
    NSLog(@"Alarms %d\n", [alarmsList count]);
    NSLog(@"Number scheduled: %i",count);
    if(count != 0)
        NSLog(@"Scheduled: %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
//    [(Panda_AlarmAppDelegate *)[[UIApplication sharedApplication] delegate] startGame];
        [super setEditing:editing animated:animated];
}

- (void) addAlarm:(id)sender {
    //added while in editing mode
    if([super isEditing])
        [super setEditing:NO animated:YES];
    
    //display a new alarm
    self.selectedAlarm = [[Alarm alloc] init];
        
    //retain count = 1

    //pass it to the view controller
    alarmDetailViewController.currentAlarm = selectedAlarm;
    
    //set title
    alarmDetailViewController.title = @"Add Alarm";
    
    //push controller onto stack
    [self.navigationController pushViewController:alarmDetailViewController animated:YES];
}


- (IBAction)toggleOnSwitch:(id)sender {
    NSLog(@"Toggled On Switch");
    //get index of selected cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    
    //grab status of the switch
    BOOL switchIsOn = ((UISwitch *)sender).isOn; 
    
    //get alarm that needs modification
    Alarm *modifiedAlarm = [alarmsList objectAtIndex:indexPath.row];

    //update modified alarm
    if(switchIsOn)
        [modifiedAlarm turnOn];
    else
        [modifiedAlarm turnOff];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    NSLog(@"RootViewController Dealloc Called");
    
}

@end
