//
//  MusicPlayer.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/15/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "MusicController.h"

@implementation MusicController

-(void)initMenuPlayer{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"mp3"];
    NSData *sampleData = [[NSData alloc] initWithContentsOfFile:soundFilePath];
    NSError *audioError = nil;
    self.menuPlayer = [[AVAudioPlayer alloc] initWithData:sampleData error:&audioError];
    if(audioError != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError);
    }
    else {
        [self.menuPlayer setNumberOfLoops: -1];
    }
}


@end
