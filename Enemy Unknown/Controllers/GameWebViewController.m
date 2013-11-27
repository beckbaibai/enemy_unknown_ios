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
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;

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
    [appDelegate.musicPlayer.menuPlayer pause];
//    // Delay execution of my block for 10 seconds.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
//        appDelegate.musicPlayer.menuPlayer.volume = 0.8;
//    });
    self.webView.bounds = CGRectMake(0, 0, 600, 800);
    CGRect frame = self.view.frame;
    CGSize correctSize;
    correctSize.width = MAX(frame.size.width, frame.size.height);
    correctSize.height = MIN(frame.size.width, frame.size.height);
    frame.size = correctSize;
    float scaleFactor = frame.size.width / 800;
    self.webView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    
    
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
    
    } else {
        NSLog(@"Unimplemented method '%@'", functionName);
    }
}

- (void)hasFinishedLoading
{
    [self.loadingImageView setHidden:YES];
  //  [self gameWon:YES];
}


-(void)gameWon:(BOOL) iWon
{
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

@end
