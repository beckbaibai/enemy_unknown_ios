//
//  GameWebViewController.m
//  Enemy Unknown
//
//  Created by Beck Chen on 11/6/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "GameWebViewController.h"
#import "UIWebView+EUAdditions.h"

@interface GameWebViewController () <UIWebViewDelegate>

@end

@implementation GameWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *fullURL = @"http://enemyunknown.nodejitsu.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Test
    NSLog([self.webView title]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO: Dispose of any resources that can be recreated.
}

@end
