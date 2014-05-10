//
//  ViewController.h
//  YourTempo
//
//  Created by Dave Cummings on 4/8/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioPlayer.h"
#import "StepCounter.h"
#import "VisualizerView.h"

@interface ViewController : UIViewController

- (IBAction)tempoSliderChanged:(UISlider *)sender;
- (IBAction)dismissAboutModal:(UIStoryboardSegue *)segue;
- (IBAction)prevButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)playPauseButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender;


@property (readonly) AudioPlayer* player;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (strong, nonatomic) IBOutlet UISlider *tempoSlider;
@property (strong, nonatomic) IBOutlet UILabel *bpmLabel;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) VisualizerView *visualizer;

@end
