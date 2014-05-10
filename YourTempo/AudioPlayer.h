//
//  AudioPlayer.h
//  YourTempo
//
//  Created by Dave Cummings on 4/7/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "VisualizerView.h"

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate>

- (AudioPlayer*)initWithLabel:(UILabel*)label visualizer:(VisualizerView*)vizualizer;
- (void)play;
- (void)playOrStop;
- (void)previousTrack;
- (void)nextTrack;
- (void)setBPM:(double)bpm;

@property (readonly) double bpm;
@property (readonly) BOOL isPlaying;
@property (readwrite) UILabel* label;
@property (readonly) VisualizerView* visualizer;

@end
