//
//  StringGameViewController.m
//  Panda Alarm
//
//  Created by James Lubowich on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringGameViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation StringGameViewController
@synthesize alphaNumericLabel, textField, levelLabel, giveUpButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    level = 1;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //create vibrating timer
    vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(vibrateFire:) userInfo:nil repeats:YES];
    
//    NSURL *anUrl = [[mediaItems objectAtIndex: 0] valueForProperty:MPMediaItemPropertyAssetURL];
//    AVPlayer *audioPlayerMusic = [[[AVPlayer alloc] initWithURL:anUrl] retain];                      
//    [audioPlayerMusic play];


    // instantiate a music player
    MPMusicPlayerController *myPlayer =
    [MPMusicPlayerController iPodMusicPlayer];
    // assign a playback queue containing all media items on the device
    [myPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
    myPlayer.volume = 1.0;
//    myPlayer.useApplicationAudioSession = NO;
    // start playing from the beginning of the queue
    [myPlayer play];

    [self startGame];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Instance Methods
- (void)startGame{
    alphaNumericLabel.hidden = NO;
    textField.hidden = YES;
    levelLabel.text = [NSString stringWithFormat:@"Level %d", level];
    [self scheduleNextTimer];
}

- (void)endGame{
    [vibrateTimer invalidate];
    [[MPMusicPlayerController iPodMusicPlayer] pause];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)vibrateFire:(NSTimer *) theTimer{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void)scheduleNextTimer{
    
    double timerInterval = 0;
    NSUInteger stringLength = 0;
    switch (level) {
        case 1:
            timerInterval = 3;
            stringLength = 4;
            break;
        case 2:
            timerInterval = .5;
            stringLength = 4;
            break;
        case 3:
            timerInterval = 4;
            stringLength = 6;
            break;
        default:
            break;
    }
    alphaNumericLabel.text =  [self genRandStringLength:stringLength];
    timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
}

- (void)timerFire:(NSTimer *)theTimer{
    if(alphaNumericLabel.hidden == NO){
        alphaNumericLabel.hidden = YES;
        textField.hidden = NO;
    }
    timer = nil;
}

- (IBAction)nextWord:(id)sender{
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
    [self startGame];
}

- (IBAction)textTyped:(id)sender{
    if([textField.text isEqualToString:alphaNumericLabel.text]){
        if (level == 3) {
            [self endGame];
        }
        else{
            textField.text = @"";
            level++;
            [self startGame];
        }
    }
    else{
        textField.text = @"";
        [self startGame];
    }
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
NSString *numbers = @"0123456789";

-(NSString *) genRandStringLength: (NSUInteger) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    NSUInteger maxNumerals = len/2;
    
    for (int i=0; i<len; i++) {
        unichar c;
        if(maxNumerals> 0 && (arc4random()%2 == 0 || i + maxNumerals == len)){
            c = [numbers characterAtIndex: arc4random()%[numbers length]];
            maxNumerals--;
        }
        else
            c = [letters characterAtIndex: arc4random()%[letters length]];
        [randomString appendFormat: @"%c", c];
    }
    return randomString;
}

@end
