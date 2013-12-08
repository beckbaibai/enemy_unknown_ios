//
//  TrailerViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/5/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()

@property (strong,nonatomic) MPMoviePlayerViewController *moviePlayerView;

@end

@implementation TrailerViewController

/**
 * In viewDidAppear:, we play the trailer and register an observer to get notified
 * when the playback finishes.
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playMovie];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlaybackFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayerView.moviePlayer];
}

/**
 * When playback finishes, we segue to main menu's view.
 */
- (void)onPlaybackFinish:(NSNotification*)notification
{
    [self performSegueWithIdentifier: @"trailerToMenu"
                              sender: self];

}

/**
 * When user taps the screen, we segue to main menu's view.
 */
- (IBAction)onTap:(UITapGestureRecognizer *)sender
{
    [self.moviePlayerView.moviePlayer stop];
    [self performSegueWithIdentifier: @"trailerToMenu"
                              sender: self];
}

/**
 * Play the trailer in full-screen mode.
 */
- (void)playMovie
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"m4v"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    self.moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.moviePlayerView.view setFrame: self.view.bounds];
    self.moviePlayerView.view.userInteractionEnabled = NO;
    self.moviePlayerView.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:self.moviePlayerView.view];
    
    [self.moviePlayerView.moviePlayer play];
}

@end
