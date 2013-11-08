//
//  MainMenuViewController.m
//  Enemy Unknown
//
//  Created by Beck Chen on 11/7/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "MainMenuViewController.h"
#import "OLImage.h"
#import "OLImageView.h"

@interface MainMenuViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation MainMenuViewController

- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 96, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    assert(logoData!=nil);
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.mainView addSubview:self.logo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
