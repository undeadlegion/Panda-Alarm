//
//  GameViewController.m
//  Panda Alarm
//
//  Created by James Lubowich on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"

@implementation GameViewController

- (id)init {
    self = [super initWithNibName:@"GameViewController" bundle:nil];
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    [gameView addGestureRecognizer:singleTap];
    tapsLeft = 5;
    timer = nil;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self startGame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)startGame{
    //create vibrating timer
    vibrateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(vibrateFire:) userInfo:nil repeats:YES];
    
    // instantiate a music player
    MPMusicPlayerController *myPlayer =
    [MPMusicPlayerController applicationMusicPlayer];
    // assign a playback queue containing all media items on the device
    [myPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
    myPlayer.volume = 1.0;
    // start playing from the beginning of the queue
    [myPlayer play];
    
}
- (void)endGame{
    [timer invalidate];
    [vibrateTimer invalidate];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    [[MPMusicPlayerController applicationMusicPlayer] pause];
}

- (void)vibrateFire:(NSTimer *) theTimer{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}


- (void)screenTapped:(id)sender{
//    NSLog(@"Screen Tapped object %@", sender);
    
    CGPoint point = [singleTap locationInView:gameView];
    if([gameView containsPoint:point]){
        tapsLeft--;
        if(tapsLeft == 0){
            [self endGame];
        }
        else{
            [gameView setRandomCenter];
            [gameView setNeedsDisplay];
            [self setNextTimer];
        }
    }
    
//    NSLog(@"Point (%f, %f)", point.x, point.y);
}

- (void)setNextTimer{
    if(timer != nil)
        [timer invalidate];
    
    double interval = 0.0;
    switch(tapsLeft){
        case 4:
            interval = .85;
            [gameView setRadius:150];
            break;
        case 3:
            interval = .85;
            [gameView setRadius:115];
            break;
        case 2:
            interval = .55;
            [gameView setRadius:80];
            break;
        case 1:
            interval = .45;
            [gameView setRadius:65];
            break;
    }
    timer = [[NSTimer alloc] initWithFireDate:
    [NSDate dateWithTimeIntervalSinceNow:.1] interval:interval target:self selector:
             @selector(timerFireMethod:) userInfo:nil repeats:YES];
    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
    [currentRunLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}
             
- (void)timerFireMethod: (NSTimer *)theTimer{
    [gameView setRandomCenter];
    [gameView setNeedsDisplay];
}


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




@end
