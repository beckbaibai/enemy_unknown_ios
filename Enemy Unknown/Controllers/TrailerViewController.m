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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playMovie];
}

-(void)playMovie
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    MPMoviePlayerViewController *moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [moviePlayerView.view setFrame: self.view.bounds];
    moviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:moviePlayerView.view];
    [moviePlayerView.moviePlayer play];
}

@end
