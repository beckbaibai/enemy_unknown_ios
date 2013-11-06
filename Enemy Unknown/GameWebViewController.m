//
//  GameWebViewController.m
//  Enemy Unknown
//
//  Created by Beck Chen on 11/6/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "GameWebViewController.h"

@interface GameWebViewController ()

@end

@implementation GameWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *fullURL = @"http://enemyunknown.nodejitsu.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
