//
//  StepCounter.h
//  YourTempo
//
//  Created by Dave Cummings on 4/8/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#import "AudioPlayer.h"

@interface StepCounter : NSObject

- (StepCounter*)initWithPlayer:(AudioPlayer*)player label:(UILabel*)label;
- (void)start;
- (void)stop;
- (void)changeTempoFromDate:(NSDate*)timestamp withStepCount:(NSInteger)numberOfSteps;

@property (readonly) BOOL hasM7;
@property (readonly) BOOL isCounting;
@property (readwrite) UILabel* label;

@end
