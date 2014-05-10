//
//  ViewController.m
//  YourTempo
//
//  Created by Dave Cummings on 4/8/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _visualizer = [[VisualizerView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:_visualizer atIndex:0];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_bpmLabel];
    
    [_bottomBar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [_bottomBar setBackgroundColor:[UIColor clearColor]];
    [_bottomBar.layer setBorderWidth:1];
    [_bottomBar.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    _player = [[AudioPlayer alloc] initWithLabel:_songLabel visualizer:_visualizer];
    StepCounter* counter = [[StepCounter alloc] initWithPlayer:_player label:_bpmLabel];
    
    if (!counter.hasM7) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
                                                        message:@"Your device does not support step counting. Automatic playback speed adjustment disabled. Use the slider to play with the tempo!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        _bpmLabel.text = [NSString stringWithFormat:@"%.1f bpm", _player.bpm];
    } else {
        [counter start];
        [_tempoSlider setHidden:YES];
    }
    
    [_player play];
    [self becomeFirstResponder];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
                [_player playOrStop];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [_player previousTrack];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [_player nextTrack];
                break;
                
            default:
                NSLog(@"Received %@", @(receivedEvent.subtype));
                break;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)tempoSliderChanged:(UISlider *)sender {
    double bpm = (sender.value + 0.5) * _player.bpm;
    _bpmLabel.text = [NSString stringWithFormat:@"%.1f bpm", bpm];
    [_player setBPM:bpm];
}

- (IBAction)dismissAboutModal:(UIStoryboardSegue *)segue
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)prevButtonPressed:(UIBarButtonItem *)sender {
    [_player previousTrack];
}

- (IBAction)playPauseButtonPressed:(UIBarButtonItem *)sender {
    UIBarButtonSystemItem icon;
    if (_player.isPlaying) {
        icon = UIBarButtonSystemItemPlay;
    } else {
        icon = UIBarButtonSystemItemPause;
    }
    NSMutableArray* items = [NSMutableArray arrayWithArray:_bottomBar.items];
    [items removeObjectAtIndex:3];
    UIBarButtonItem* newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:icon target:sender.target action:sender.action];
    newButton.tintColor = [UIColor whiteColor];
    [items insertObject:newButton atIndex:3];
    [_bottomBar setItems:items animated:NO];
    [_player playOrStop];
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    [_player nextTrack];
}
@end
