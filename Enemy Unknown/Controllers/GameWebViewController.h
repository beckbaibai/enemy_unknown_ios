//
//  GameWebViewController.h
//  Enemy Unknown
//
//  Created by Beck Chen on 11/6/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,retain) NSString *scenario;

@end
