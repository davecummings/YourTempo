//
//  VisualizerView.h
//  YourTempo
//
//  Created by Dave Cummings on 4/14/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VisualizerView : UIView

- (void)randomizeCellColor;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
