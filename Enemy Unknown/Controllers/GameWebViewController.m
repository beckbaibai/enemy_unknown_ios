//
//  GameWebViewController.m
//  Enemy Unknown
//
//  Created by Beck Chen on 11/6/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "GameWebViewController.h"
#import "UIWebView+EUAdditions.h"
#import "SBJson.h"
#import "EnemyUnknownAppDelegate.h"
#import "EndGameViewController.h"


@interface GameWebViewController () <UIWebViewDelegate>
@property (nonatomic) BOOL iWon;
@property (strong, nonatomic) SBJsonParser *json;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *loading;


@end

@implementation GameWebViewController

- (IBAction)resign:(UIButton *)sender {
    [self.webView removeFromSuperview];
    [self.webView setDelegate:nil];
    self.webView = nil;
    [self gameWon:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setHidden:YES];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.progressView.progress=0.25;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(progressUpdate) userInfo:nil repeats:NO];
    
    // register internet availability observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.webView.scrollView setDelaysContentTouches:NO];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom =  1.0;"];
	NSString *fullURL = @"http://enemyunknown.nodejitsu.com";
    //NSString *fullURL = @"http://10.100.194.46:4004";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    self.webView.scrollView.bounces = NO;
    
    self.json = [[SBJsonParser alloc] init];
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.musicPlayer initInGameSound];

    self.webView.bounds = CGRectMake(0, 0, 600, 800);
    CGRect frame = self.view.frame;
    CGSize correctSize;
    correctSize.width = MAX(frame.size.width, frame.size.height);
    correctSize.height = MIN(frame.size.width, frame.size.height);
    frame.size = correctSize;
    float scaleFactor = frame.size.width / 800;
    self.webView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reachability = notification.object;
    if (![reachability isReachable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Internet Connection"
                                                        message:@"You must be connected to the Internet to play a game."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self gameWon:NO];;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Choose "slayer" scenario
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"mobileStartGame(\"%@\");",self.scenario]];
}

// Provide a way for Javascript code to call Objective-C method.
// This dirty hack comes from:
//     blog.techno-barje.fr//post/2010/10/06/UIWebView-secrets-part3-How-to-properly-call-ObjectiveC-from-Javascript/

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString hasPrefix:@"js-frame"]) {
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        NSString *function = (NSString *)[components objectAtIndex:1];
        NSString *argsAsString = [(NSString *)[components objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *args = (NSArray *)[self.json objectWithString:argsAsString];
        
        [self handleCall:function args:args];
        
        return NO;
    }
    
    return YES;
}

// Handle function calls with the provided name and arguments.

- (void)handleCall:(NSString *)functionName args:(NSArray *)args
{
    if ([functionName isEqualToString:@"endGame"]) {
        
        if ([args count] != 1)
            NSLog(@"endGame takes exactly 1 argument!");
        [self gameWon:(BOOL)args[0]];
        
    } else if ([functionName isEqualToString:@"alert"]) {
        NSLog(@"WENGWENGWENG!!");
        
    } else if ([functionName isEqualToString:@"hasFinishedLoading"]) {
        
        NSLog(@"hasFinishedLoading called");
        [self hasFinishedLoading];
    } else if ([functionName isEqualToString:@"playSound"]) {
        NSLog(@"playSound called");
        [self playSound:(NSString *)args[0]];
        
    } else if ([functionName isEqualToString:@"stopSound"]) {
        NSLog(@"stopSound called");
        [self stopSound:(NSString *)args[0]];
    
    } else {
        NSLog(@"Unimplemented method '%@'", functionName);
    }
}

- (void)hasFinishedLoading
{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.musicPlayer.menuPlayer stop];
    [self.progressView setHidden:YES];
    [self.webView setHidden:NO];
    [self.loading setHidden:YES];
    [self.activityIndicator stopAnimating];
    
}


-(void)gameWon:(BOOL) iWon
{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AVAudioPlayer *backgroundPlayer = [appDelegate.musicPlayer.inGameSounds objectForKey:@"background"];
    [backgroundPlayer stop];
    AVAudioPlayer *flagcapPlayer = [appDelegate.musicPlayer.inGameSounds objectForKey:@"flagcap"];
    [flagcapPlayer stop];
    [appDelegate.musicPlayer.menuPlayer play];
    self.iWon = iWon;
    [self performSegueWithIdentifier: @"End Game"
                              sender: self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"End Game"]){
        EndGameViewController *vc = [segue destinationViewController];
        [vc setIWon:self.iWon];
    }
}

-(void)playSound:(NSString *)sound{
    NSLog(@"%@",sound);
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AVAudioPlayer *soundPlayer = [appDelegate.musicPlayer.inGameSounds objectForKey:sound];
    [soundPlayer play];
    
}

-(void)stopSound:(NSString *)sound{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AVAudioPlayer *soundPlayer = [appDelegate.musicPlayer.inGameSounds objectForKey:sound];
    [soundPlayer stop];
}





-(void)progressUpdate {
    float actual = [self.progressView progress];
    self.progressView.progress = (1.0-actual)/2+actual;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(progressUpdate) userInfo:nil repeats:NO];
    
}


@end
