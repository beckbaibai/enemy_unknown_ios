//
//  EndGameViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/19/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "EndGameViewController.h"
#import <GameKit/GameKit.h>
#import "OLImage.h"
#import "OLImageView.h"

@interface EndGameViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation EndGameViewController

- (IBAction)mainMenu:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 100, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    assert(logoData!=nil);
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

-(void) viewDidLoad
{
    if([GKLocalPlayer localPlayer].authenticated) {
        NSArray *arr = [[NSArray alloc] initWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
        GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
        if(board != nil) {
            board.timeScope = GKLeaderboardTimeScopeAllTime;
            board.range = NSMakeRange(1, 1);
            board.identifier = @"EnemyUnknownWins";
            [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                NSInteger wins = 0;
                if (error != nil) {
                    NSLog(@"Error retrieving player scores.");
                }
                if (scores != nil) {
                   wins = ((GKScore*)[scores objectAtIndex:0]).value;
                }
                
                if(self.iWon){
                    wins = wins + 1;
                    [self reportScore:wins forLeaderboardID:@"EnemyUnknownWins"];
                    
                    if(wins>=100){
                        [self reportAchievement:@"EnemyUnknownWin100Games" percentComplete:100.0];
                    }
                    else{
                        [self reportAchievement:@"EnemyUnknownWin100Games" percentComplete:wins*100/100.0];
                    }
                    if(wins>=50){
                        [self reportAchievement:@"EnemyUnknownWin50Games" percentComplete:100.0];
                    }
                    else{
                        [self reportAchievement:@"EnemyUnknownWin50Games" percentComplete:wins*100/50.0];
                    }
                    if(wins>=10){
                        [self reportAchievement:@"EnemyUnknownWin10Games" percentComplete:100.0];
                    }
                    else{
                        [self reportAchievement:@"EnemyUnknownWin10Games" percentComplete:wins*100/10.0];
                    }
                    if(wins>=1){
                        [self reportAchievement:@"EnemyUnknownWinAGame" percentComplete:100.0];
                    }
                }
            }];
        }
    }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Game Center unavailable!"
                                                              message:@"\n Scores cannot be recorded. \n\n If you did not login, click 'Ok' to login to game center.\n\n If game center is disabled, logout and then login again to renable game center for Enemy Unknown"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Ok", nil];
            [message show];
            
        
    }
    
    
    if(self.iWon){
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"youwin1" ofType:@"png"];
        self.didWinImage.image = [UIImage imageWithContentsOfFile:filepath];
    }else{
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"youlose" ofType:@"png"];
        self.didWinImage.image = [UIImage imageWithContentsOfFile:filepath];
    }
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
    achievement.showsCompletionBanner = YES;
    if (achievement)
    {
        achievement.percentComplete = percent;
        NSArray *achievements = @[achievement];
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error){
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Ok"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}

@end
