//
//  MusicController.h
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/15/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface MusicController : NSObject

@property (strong,nonatomic) AVAudioPlayer *menuPlayer;
@property (strong,nonatomic) NSDictionary *inGameSounds;

-(void)initMenuMusic;
-(void)initInGameSound;

@end
