//
//  GameWebViewController.m
//  Enemy Unknown
//
//  Created by Beck Chen on 11/6/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "GameWebViewController.h"
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

/**
 * In viewDidLoad, we start loading the webpage and show an activity indicator and a progress view
 * for it. We also start loading the in-game sounds. Moreover, we register an observe for reachability 
 * changed notifications.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // show activity indicator and progress view
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
    
    // load webpage
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.webView.scrollView setDelaysContentTouches:NO];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom =  1.0;"];
	NSString *fullURL = @"http://enemyunknown.nodejitsu.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    self.webView.scrollView.bounces = NO;
    
    self.json = [[SBJsonParser alloc] init];
    
    // load in-game sounds
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.musicPlayer initInGameSound];

    // scale the webview to make it full-screen
    self.webView.bounds = CGRectMake(0, 0, 600, 800);
    CGRect frame = self.view.frame;
    CGSize correctSize;
    correctSize.width = MAX(frame.size.width, frame.size.height);
    correctSize.height = MIN(frame.size.width, frame.size.height);
    frame.size = correctSize;
    float scaleFactor = frame.size.width / 800;
    self.webView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
}

/**
 * Observer function for reachability changed notifications.
 * If the Internet becomes unavailable, show an alert and pop the previous view (lobby).
 */
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

/**
 * When the web page has finished loading, tell the server to start a game with the selected scenario.
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"mobileStartGame(\"%@\");",self.scenario]];
}

/**
 * When segue to end game view, tell it if we have won or not.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"End Game"]){
        EndGameViewController *vc = [segue destinationViewController];
        [vc setIWon:self.iWon];
    }
}

/**
 * Action for resign button.
 */
- (IBAction)resign:(UIButton *)sender
{
    [self.webView removeFromSuperview];
    [self.webView setDelegate:nil];
    self.webView = nil;
    [self gameWon:NO];
}

/**
 * Update the (fake) progress view.
 */
- (void)progressUpdate
{
    float actual = [self.progressView progress];
    self.progressView.progress = (1.0-actual)/2+actual;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(progressUpdate) userInfo:nil repeats:NO];
    
}

/**
 * Provide a way for Javascript code to call Objective-C method.
 * This dirty hack comes from:
 *     http://blog.techno-barje.fr//post/2010/10/06/UIWebView-secrets-part3-How-to-properly-call-ObjectiveC-from-Javascript/
 */
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

/**
 * Handle function calls with the provided name and arguments.
 */
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

#pragma mark - Javascript callbacks

/**
 * When the webpage has finished loading, we show the web view and hide the activity indicator
 * and the progress view.
 */
- (void)hasFinishedLoading
{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.musicPlayer.menuPlayer stop];
    [self.progressView setHidden:YES];
    [self.webView setHidden:NO];
    [self.loading setHidden:YES];
    [self.activityIndicator stopAnimating];
    
}

/**
 * When we have won/lost the game, stop all sounds and segue to end game view.
 */
- (void)gameWon:(BOOL)iWon
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

/**
 * Play a sound.
 */
- (void)playSound:(NSString *)sound
{
    NSLog(@"%@",sound);
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AVAudioPlayer *soundPlayer = [appDelegate.musicPlayer.inGameSounds objectForKey:sound];
    [soundPlayer play];
    
}

/**
 * Stop playing a sound.
 */
- (void)stopSound:(NSString *)sound
{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    AVAudioPlayer *soundPlayer = [appDelegate.musicPlayer.inGameSounds objectForKey:sound];
    [soundPlayer stop];
}

@end
