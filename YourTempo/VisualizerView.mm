//
//  VisualizerView.m
//  YourTempo
//
//  Created by Dave Cummings on 4/14/14.
//  Based on code by Xinrong Guo from "How To Make a Music Visualizer in iOS"
//

#import <QuartzCore/QuartzCore.h>

#import "VisualizerView.h"
#import "MeterTable.h"

@implementation VisualizerView {
    CAEmitterLayer *emitterLayer;
    MeterTable meterTable;
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        emitterLayer = (CAEmitterLayer *)self.layer;
        
        CGFloat width = MIN(frame.size.width, frame.size.height);
        CGFloat height = MAX(frame.size.width, frame.size.height);
        emitterLayer.emitterPosition = CGPointMake(width/2, height/2);
        emitterLayer.emitterSize = CGSizeMake(width-80, height-200);
        emitterLayer.emitterShape = kCAEmitterLayerRectangle;
        emitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.name = @"cell";
        CAEmitterCell *childCell = [CAEmitterCell emitterCell];
        childCell.name = @"childCell";
        childCell.lifetime = 1.0f / 60.0f;
        childCell.birthRate = 60.0f;
        childCell.velocity = 0.0f;
        
        childCell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
        
        cell.emitterCells = @[childCell];
        
        cell.color = [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5] CGColor];
        cell.redRange = 1.0;
        cell.greenRange = 1.0;
        cell.blueRange = 1.0;
        cell.alphaRange = 0.5;
        
        cell.redSpeed = 0.5;
        cell.greenSpeed = 0.5;
        cell.blueSpeed = 0.5;
        cell.alphaSpeed = 0.15f;
        
        cell.scale = 0.25f; // average particle size
        cell.scaleRange = 0.25f;
        
        cell.lifetime = 1.0f; // average lifespan
        cell.lifetimeRange = .25f;
        cell.birthRate = 80; // particles per second
        
        cell.velocity = 100.0f;
        cell.velocityRange = 300.0;
        cell.emissionRange = M_PI * 2;
        
        emitterLayer.emitterCells = @[cell];
        
        CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)randomizeCellColor
{
    CAEmitterCell* cell = emitterLayer.emitterCells[0];
    double rgb[3];
    double sum;
    for (int i = 0; i < 3; i++) {
        rgb[i] = (rand() % 3) / 2.0;
        sum += rgb[i];
    }
    if (sum < 1.0) {
        int i = rand()%3;
        rgb[i] = 1.0;
    }
    cell.color = [[UIColor colorWithRed:rgb[0] green:rgb[1] blue:rgb[2] alpha:0.8f] CGColor];
    emitterLayer.emitterCells = @[cell];
}

- (void)update
{
    float scale = 0.5;
    if (_audioPlayer.playing ) {
        [_audioPlayer updateMeters];
        
        float power = 0.0f;
        for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
            power += [_audioPlayer averagePowerForChannel:i];
        }
        power /= [_audioPlayer numberOfChannels];
        
        float level = meterTable.ValueAt(power);
        scale = level * 6;
    }
    
    [emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
}

@end