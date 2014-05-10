//
//  AudioPlayer.m
//  YourTempo
//
//  Created by Dave Cummings on 4/8/14.
//  Copyright (c) 2014 Dave Cummings. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer {
    AVAudioPlayer* _avPlayer;
    NSArray* _songs;
    int curSongIdx;
}

- (AudioPlayer*)initWithLabel:(UILabel*)label visualizer:(VisualizerView*)visualizer
{
    _isPlaying = NO;
    NSURL* dataUrl = [[NSBundle mainBundle] URLForResource:@"Songs" withExtension:@"plist"];
    NSData* data = [NSData dataWithContentsOfURL:dataUrl];
    _songs = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
    
    _label = label;
    _visualizer = visualizer;
    
    [self initPlayer];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    return self;
}

- (void)initPlayer
{
    NSURL* songUrl = [[NSBundle mainBundle] URLForResource:_songs[curSongIdx][@"filename"] withExtension:@"m4a"];
    _avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:songUrl error:nil];
    
    _avPlayer.enableRate = YES;
    _avPlayer.meteringEnabled = YES;
    _bpm = [_songs[curSongIdx][@"tempo"] doubleValue];
    NSLog(@"song bpm %.f", _bpm);
    
    [_avPlayer setDelegate:self];
    
    [_avPlayer prepareToPlay];
    [_visualizer setAudioPlayer:_avPlayer];
    [_visualizer randomizeCellColor];
    
    NSArray *metadata = [[AVURLAsset assetWithURL:[_avPlayer url]] commonMetadata];
    NSString *artist, *album, *title;
    
    for (int i = 0; i < metadata.count; i++) {
        AVMetadataItem *metadatum = metadata[i];
        if ([metadatum.commonKey isEqual: @"artist"]) {
            artist = metadatum.stringValue;
        } else if ([metadatum.commonKey isEqual:@"album"]) {
            album = metadatum.stringValue;
        } else if ([metadatum.commonKey isEqual:@"title"]) {
            title = metadatum.stringValue;
        }
    }
    
    NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              artist, MPMediaItemPropertyArtist,
                              title, MPMediaItemPropertyTitle,
                              album, MPMediaItemPropertyAlbumTitle,
                              nil];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    
    _label.text = [NSString stringWithFormat:@"%@\n%@", title, artist];
}

- (void)play
{
    if (!_isPlaying) {
        [self playOrStop];
    }
}

- (void)playOrStop
{
    if (_avPlayer.isPlaying) {
        [_avPlayer stop];
        _isPlaying = NO;
    } else {
        [_avPlayer play];
        _isPlaying = YES;
    }
}

- (void)incrementTrackBy:(int)i
{
    double oldBpm = _avPlayer.rate * _bpm;
    curSongIdx = (curSongIdx+_songs.count+i) % _songs.count;
    if (_avPlayer.isPlaying) {
        [_avPlayer stop];
    }
    [self initPlayer];
    [self setBPM:oldBpm];
    [_avPlayer play];
}

- (void)previousTrack
{
    [self incrementTrackBy:-1];
}

- (void)nextTrack
{
    [self incrementTrackBy:1];
}

- (void)setBPM:(double)bpm
{
    _avPlayer.rate = bpm / _bpm;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self nextTrack];
}

@end
