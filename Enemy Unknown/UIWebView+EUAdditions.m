//
//  UIWebView+EUAdditions.m
//  Enemy Unknown
//
//  Created by Beck Chen on 11/6/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "UIWebView+EUAdditions.h"

@implementation UIWebView (EUAdditions)

- (NSString *)title
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
