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
#import "EnemyUnknownAppDelegate.h"
#import "MusicController.h"

@interface MainMenuViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation MainMenuViewController

/**
 * In loadView, we load the game logo, which is a GIF animated picture, using OLImage library.
 */
- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 100, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

/**
 * In viewDidLoad, we authenticate local player for game center to determine whether game center
 * should be available to the current user, and start playing background music.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Authenticate local player for game center
    [self authenticateLocalPlayer];
	
    // Start playing background music
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MusicController *musicPlayer = [MusicController alloc];
    appDelegate.musicPlayer = musicPlayer;
    [appDelegate.musicPlayer initMenuMusic];
    [appDelegate.musicPlayer.menuPlayer play];
}

/**
 * In shouldPerformSegueWithIdentifier:sender:, we stop segue to In-App Purchase if
 * Internet is not available.
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"IAP"]) {
        // Test internet availability before segue to In-App Purchase
        EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        Reachability *reachablity = appDelegate.internetReachable;
        if (![reachablity isReachable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                            message:@"You must be connected to the Internet to purchase in-app items."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Game Center

/**
 * Action for "Game Center" button. Show the game center view.
 */
- (IBAction)gameCenterOpen:(UIButton *)sender
{
    [self showGameCenter];
}

/**
 * Authenticate local player for game center.
 */
- (void)authenticateLocalPlayer
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

/**
 * Show the game center view for current player.
 */
- (void)showGameCenter
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
    
    if (blockLocalPlayer.isAuthenticated) {
        // Player is authenticated, show the game center view
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateDefault;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    } else {
        // Player is not authenticated, show an alert view
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Game Center unavailable!"
                                                          message:@"\n If you did not login, click 'Ok' to login to game center.\n\n If game center is disabled, logout and then login again to renable game center for Enemy Unknown"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Ok", nil];
        [message show];
       
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Ok"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}

@end
