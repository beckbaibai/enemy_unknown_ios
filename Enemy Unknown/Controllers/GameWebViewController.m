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

@interface GameWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) SBJsonParser *json;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation GameWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//NSString *fullURL = @"http://enemyunknown.nodejitsu.com";
    NSString *fullURL = @"http://10.118.194.90:4004";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    self.webView.scrollView.bounces = NO;
    
    self.json = [[SBJsonParser alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
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
        NSLog(@"endGame called successfully!");
        
    } else if ([functionName isEqualToString:@"alert"]) {
        
        NSLog(@"WENGWENGWENG!!");
        
    } else {
        NSLog(@"Unimplemented method '%@'", functionName);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO: Dispose of any resources that can be recreated.
}

@end
