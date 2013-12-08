//
//  LobbyViewController.h
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/7/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface LobbyViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet ADBannerView *adView;
@property (strong, nonatomic) IBOutlet UIPickerView *scenario;
@property (nonatomic) bool hasAds;

@end
