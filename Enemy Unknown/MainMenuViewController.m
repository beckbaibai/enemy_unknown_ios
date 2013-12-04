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

- (void)loadView
{
    [super loadView];
    
    // Use OLImage and OLImageView instead of default UIImage and UIImageView in order to show gif
    self.logo = [[OLImageView alloc] initWithFrame:CGRectMake(312, 150, 400, 125)];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    NSData *logoData = [NSData dataWithContentsOfURL:fileURL];
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

- (IBAction)gameCenterOpen:(UIButton *)sender {
    [self showGameCenter];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self authenticateLocalPlayer];
	// Do any additional setup after loading the view.
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    MusicController *musicPlayer = [MusicController alloc];
    appDelegate.musicPlayer = musicPlayer;
    [appDelegate.musicPlayer initMenuPlayer];
    [appDelegate.musicPlayer.menuPlayer play];
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
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
    if(blockLocalPlayer.isAuthenticated){
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateDefault;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Game Center unavailable!"
                                                          message:@"\n If you did not login, click 'Ok' to login to game center.\n\n If game center is disabled, logout and then login again to renable game center for Enemy Unknown"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Ok", nil];
        [message show];
       
    }
    

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"IAP"]) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Ok"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
