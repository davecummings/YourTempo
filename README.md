YourTempo
=========

YourTempo adjusts the playback speed of the song you're listening to be perfectly in-sync with your footsteps.

Created by Dave Cummings  
Carnegie Mellon University  
david.h.cummings@me.com

YourTempo requires the M7 coprocessor, which is only supported on iPhone 5s, iPad Air, and iPad Mini with Retina Display.

YourTempo is best used on long walks outdoors on a flat surface. Try to keep your pace consistent.

Your pace is computed from a running average of the time between the steps you take, given by CMStepCounter. CMStepCounter has a granualrity of about 2.5 seconds, so it may take up to 20 seconds to lock on to your pace.

Songs are played back through AVAudioPlayer. You may notice scratchiness or distortion, particularly of instrumentals. AVAudioPlayer's support for adjusted playback rate is omptimized for spoken word. So, unfortunately, the distortion is here to stay until Apple updates AVAudioPlayer's playback tempo algorithms.

To be able to adjust playback speed by a scalar, I had to precompute (using Capo) the tempo of a handful of arbitrarily chosen songs. Future versions of this app may allow you to choose songs from your Music library and compute their tempos on the fly.

Songs included in this app are intended for academic purposes only. All rights are reserved by their respective copyright holders.

VizualizerView based on a tutorial by Xinrong Guo ("How To Make a Music Visualizer in iOS") and MeterTable is provided by Apple Inc.

App icon includes an image sourced from "Metronome" by Philip Hogeboom from The Noun Project.
