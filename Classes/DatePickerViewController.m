//
//  DatePickerViewController.m
//  Panda Alarm
//
//  Created by James Lubowich on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Alarm.h"

@implementation DatePickerViewController
@synthesize timeCell, datePicker, currentAlarm, tableView;

- (IBAction)dateChanged:(id)sender {
    [self setDateLabel:datePicker.date];
    currentAlarm.date = datePicker.date;
}

- (id)initWithAlarm:(Alarm *)alarm {
    self = [super initWithNibName:@"DatePickerViewController" bundle:nil];
    self.currentAlarm = alarm;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Time";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!timeCell) {
        timeCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        timeCell.textLabel.text = @"Time";
        [self setDateLabel:datePicker.date];
    }
    return timeCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}

#pragma mark - Target action


- (void)doneClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];    
    [datePicker setDate:currentAlarm.date];
    [self setDateLabel:datePicker.date];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneClicked:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setDateLabel:(NSDate *)date {
    //convert date to string 
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	NSString *timeText = [formatter stringFromDate:date];
    timeCell.detailTextLabel.text = timeText;
    [self.tableView reloadData];
}
@end
