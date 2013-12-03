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

-(void)initInGameSound{
    NSString *soundFilePath1 = [[NSBundle mainBundle] pathForResource:@"attack_1" ofType:@"mp3"];
    NSData *sampleData1 = [[NSData alloc] initWithContentsOfFile:soundFilePath1];
    NSError *audioError1 = nil;
    AVAudioPlayer *attack_1player = [[AVAudioPlayer alloc] initWithData:sampleData1 error:&audioError1];
    if(audioError1 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError1);
    }
    else {
        [attack_1player setNumberOfLoops: 1];
    }
    NSString *soundFilePath2 = [[NSBundle mainBundle] pathForResource:@"attack_2" ofType:@"mp3"];
    NSData *sampleData2 = [[NSData alloc] initWithContentsOfFile:soundFilePath2];
    NSError *audioError2 = nil;
    AVAudioPlayer *attack_2player = [[AVAudioPlayer alloc] initWithData:sampleData2 error:&audioError2];
    if(audioError2 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError2);
    }
    else {
        [attack_2player setNumberOfLoops: 1];
    }
    NSString *soundFilePath3 = [[NSBundle mainBundle] pathForResource:@"attack1" ofType:@"mp3"];
    NSData *sampleData3 = [[NSData alloc] initWithContentsOfFile:soundFilePath3];
    NSError *audioError3 = nil;
    AVAudioPlayer *attack1player = [[AVAudioPlayer alloc] initWithData:sampleData3 error:&audioError3];
    if(audioError3 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError3);
    }
    else {
        [attack1player setNumberOfLoops: 1];
    }
    NSString *soundFilePath4 = [[NSBundle mainBundle] pathForResource:@"attack2" ofType:@"mp3"];
    NSData *sampleData4 = [[NSData alloc] initWithContentsOfFile:soundFilePath4];
    NSError *audioError4 = nil;
    AVAudioPlayer *attack2player = [[AVAudioPlayer alloc] initWithData:sampleData4 error:&audioError4];
    if(audioError4 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError4);
    }
    else {
        [attack2player setNumberOfLoops: 1];
    }
    NSString *soundFilePath5 = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"mp3"];
    NSData *sampleData5 = [[NSData alloc] initWithContentsOfFile:soundFilePath5];
    NSError *audioError5 = nil;
    AVAudioPlayer *backgroundplayer = [[AVAudioPlayer alloc] initWithData:sampleData5 error:&audioError5];
    if(audioError5 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError5);
    }
    else {
        [backgroundplayer setNumberOfLoops: -1];
    }
    NSString *soundFilePath6 = [[NSBundle mainBundle] pathForResource:@"die" ofType:@"mp3"];
    NSData *sampleData6 = [[NSData alloc] initWithContentsOfFile:soundFilePath6];
    NSError *audioError6 = nil;
    AVAudioPlayer *dieplayer = [[AVAudioPlayer alloc] initWithData:sampleData6 error:&audioError6];
    if(audioError6 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError6);
    }
    else {
        [dieplayer setNumberOfLoops: 1];
    }
    NSString *soundFilePath7 = [[NSBundle mainBundle] pathForResource:@"flagcap" ofType:@"mp3"];
    NSData *sampleData7 = [[NSData alloc] initWithContentsOfFile:soundFilePath7];
    NSError *audioError7 = nil;
    AVAudioPlayer *flagcapplayer = [[AVAudioPlayer alloc] initWithData:sampleData7 error:&audioError7];
    if(audioError7 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError7);
    }
    else {
        [flagcapplayer setNumberOfLoops: -1];
    }
    NSString *soundFilePath8 = [[NSBundle mainBundle] pathForResource:@"gothit" ofType:@"mp3"];
    NSData *sampleData8 = [[NSData alloc] initWithContentsOfFile:soundFilePath8];
    NSError *audioError8 = nil;
    AVAudioPlayer *gothitplayer = [[AVAudioPlayer alloc] initWithData:sampleData8 error:&audioError8];
    if(audioError8 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError8);
    }
    else {
        [gothitplayer setNumberOfLoops: 1];
    }
    NSString *soundFilePath9 = [[NSBundle mainBundle] pathForResource:@"kill" ofType:@"mp3"];
    NSData *sampleData9 = [[NSData alloc] initWithContentsOfFile:soundFilePath9];
    NSError *audioError9 = nil;
    AVAudioPlayer *killplayer = [[AVAudioPlayer alloc] initWithData:sampleData9 error:&audioError9];
    if(audioError9 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError9);
    }
    else {
        [killplayer setNumberOfLoops: 1];
    }
    NSString *soundFilePath10 = [[NSBundle mainBundle] pathForResource:@"ko" ofType:@"mp3"];
    NSData *sampleData10 = [[NSData alloc] initWithContentsOfFile:soundFilePath10];
    NSError *audioError10 = nil;
    AVAudioPlayer *koplayer = [[AVAudioPlayer alloc] initWithData:sampleData10 error:&audioError10];
    if(audioError10 != nil) {
        NSLog(@"An audio error occurred: \"%@\"", audioError10);
    }
    else {
        [koplayer setNumberOfLoops: 1];
    }

    self.inGameSounds  = [[NSDictionary alloc] initWithObjectsAndKeys:
                          attack_1player,@"attack_1",
                          attack_2player,@"attack_2",
                          attack1player,@"attack1",
                          attack2player,@"attack2",
                          backgroundplayer,@"background",
                          dieplayer,@"die",
                          flagcapplayer,@"flagcap",
                          gothitplayer,@"gothit",
                          killplayer,@"kill",
                          koplayer,@"ko",
                          nil];
}



@end
