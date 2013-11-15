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

@end

@implementation MainMenuViewController

- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 150, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    assert(logoData!=nil);
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

- (IBAction)gameCenterOpen:(UIButton *)sender {
    [self showGameCenter];
    [self reportScore:10 forLeaderboardID:@"EnemyUnknownWins"];
    [self reportAchievement:@"EnemyUnknownWinAGame" percentComplete:100.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self authenticateLocalPlayer];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) authenticateLocalPlayer
{
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
        localPlayer.authenticateHandler = ^(UIViewController *receivedViewController, NSError *error){
            if (receivedViewController != nil)
            {
                [self presentViewController:receivedViewController animated:YES completion:nil];
            }
            else if (blockLocalPlayer.isAuthenticated)
            {
                 NSLog(@"Game center now available");
            }
            else
            {
                NSLog(@"Game center not available");
            }
        };

}

- (void)showGameCenter
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateDefault;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportScore:(int64_t)score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
    }];
}

- (void) reportAchievement: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        NSArray *achievements = @[achievement];
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error){
         }];
    }
}

@end
