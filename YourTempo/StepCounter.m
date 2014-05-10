//
//  StepCounter.m
//  YourTempo
//
//  Created by Dave Cummings on 4/8/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import "StepCounter.h"

#import "StepCounter.h"

@implementation StepCounter {
    CMStepCounter* _sCounter;
    AudioPlayer* _player;
}

StepCounter* _self;
NSDate* _lastTimestamp;
NSMutableArray* _lastTimespans;
NSNumber* _totalLastTimespans;
NSInteger _lastStepCount;
NSMutableArray* _lastStepCounts;
NSNumber* _totalLastStepCounts;

const int MAX_Q_LEN = 6;

- (StepCounter*)initWithPlayer:(AudioPlayer *)player label:(UILabel *)label
{
    _self = self;
    
    if ([CMStepCounter isStepCountingAvailable]) {
        _hasM7 = YES;
    } else {
        _hasM7 = NO;
    }
    
    _player = player;
    _sCounter = [[CMStepCounter alloc] init];
    _label = label;
    
    return self;
}

- (void)start {
    if (!_isCounting) {
        [_sCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:1 withHandler:stepHandler];
        _isCounting = true;
    }
}

- (void)stop {
    if (_isCounting) {
        [_sCounter stopStepCountingUpdates];
        _isCounting = false;
    }
}

- (void)changeTempoFromDate:(NSDate*)timestamp withStepCount:(NSInteger)numberOfSteps
{
    NSNumber *dSteps = [NSNumber numberWithInteger:(numberOfSteps - _lastStepCount)];
    _totalLastStepCounts = [self recomputeSum:_lastStepCounts withSum:_totalLastStepCounts andNewElement:dSteps];
    NSNumber *dSeconds = [NSNumber numberWithDouble:[timestamp timeIntervalSinceDate:_lastTimestamp]];
    _totalLastTimespans = [self recomputeSum:_lastTimespans withSum:_totalLastTimespans andNewElement:dSeconds];
    
    
    double bpm = [_totalLastStepCounts doubleValue] * 60.0 / [_totalLastTimespans doubleValue];
    NSLog(@"%@ steps in %@ seconds (%@ bpm)", @([dSteps intValue]), @([dSeconds floatValue]), @(bpm));
    NSString* ish = ([_lastStepCounts count] == MAX_Q_LEN) ? @"" : @"~";

    _label.text = [NSString stringWithFormat:@"%@%.1f bpm", ish, bpm];
    [_player setBPM:bpm];
}

- (NSNumber*)recomputeSum:(NSMutableArray*)queue withSum:sum andNewElement:(NSNumber*)newItem
{
    [queue insertObject:newItem atIndex:0];
    sum = [NSNumber numberWithDouble:([newItem doubleValue] + [sum doubleValue])];
    
    if ([queue count] > MAX_Q_LEN) {
        NSNumber* last = [queue lastObject];
        [queue removeLastObject];
        sum = [NSNumber numberWithDouble:([sum doubleValue] - [last doubleValue])];
        return sum;
    }
    
    return sum;
}

void (^stepHandler)(NSInteger, NSDate*, NSError*) = ^(NSInteger numberOfSteps, NSDate* timestamp, NSError* error) {
    if (_lastTimespans == NULL) {
        if (_lastStepCounts == NULL) {
            _lastStepCounts = [[NSMutableArray alloc] init];
            _totalLastStepCounts = [NSNumber numberWithDouble:0.0];
            _totalLastTimespans = [NSNumber numberWithDouble:0.0];
            _self.label.text = @"Walk around some more!";
        } else {
            _lastTimestamp = timestamp;
            _lastStepCount = numberOfSteps;
            _lastTimespans = [[NSMutableArray alloc] init];
            _self.label.text = @"Just a few more steps!";
        }
    } else {
        [_self changeTempoFromDate:timestamp withStepCount:numberOfSteps];
    }
};

@end