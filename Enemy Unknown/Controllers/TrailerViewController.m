//
//  TrailerViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/5/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()

@end

@implementation TrailerViewController



-(IBAction)playMovie:(id)sender
{
    NSString *filepath   =    [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"m4v"];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    MPMoviePlayerViewController *moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    [moviePlayerView.view setFrame: CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.height, [[UIScreen mainScreen] applicationFrame].size.width)];
    //moviePlayerView.moviePlayer.controlStyle = MPMediaTypeMusicVideo;
    [self.view addSubview:moviePlayerView.view];
    [moviePlayerView.moviePlayer setFullscreen:YES];
    [moviePlayerView.moviePlayer play];
    
}

@end
