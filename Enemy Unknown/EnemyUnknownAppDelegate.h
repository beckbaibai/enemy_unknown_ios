//
//  Enemy_UnknownAppDelegate.h
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/5/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicController.h"
#import "PaymentQueueObserver.h"
#import "Reachability.h"

@interface EnemyUnknownAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) MusicController *musicPlayer;
@property (strong, nonatomic) PaymentQueueObserver *pqObserver;
@property (strong, nonatomic) Reachability *internetReachable;

@end
