//
//  NoAnimationModalSegue.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/5/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "NoAnimationModalSegue.h"

@implementation NoAnimationModalSegue

- (void)perform
{
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
