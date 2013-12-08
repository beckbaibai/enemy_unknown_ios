//
//  LobbyViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/7/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "LobbyViewController.h"
#import "GameWebViewController.h"
#import "OLImage.h"
#import "OLImageView.h"
#import "EnemyUnknownAppDelegate.h"

@interface LobbyViewController ()

@property (strong,nonatomic) NSArray *scenarioArray;
@property (nonatomic) NSString* scenarioSelected;
@property (strong, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation LobbyViewController

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
    assert(logoData!=nil);
    UIImage *logoImage = [OLImage imageWithData:logoData];
    self.logo.image = logoImage;
    [self.view addSubview:self.logo];
}

/**
 * In viewDidLoad, we initialize the array of scenario names, and determine whether to show iAds
 * based on the user's past purchases.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scenarioArray = [self scenarios];
    
    // Check if user has bought the ad-free version of our app, and determine whether to show iAds.
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    BOOL bought = [storage boolForKey:@"EnemyUnknownAdFree"];
    self.hasAds = !bought;
    self.adView.hidden = YES;
}

/**
 * In shouldPerformSegueWithIdentifier:sender:, we stop segue to the game if
 * Internet is not available.
 */
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Start Game"]) {
        // Test internet availability before segue to the game
        EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        Reachability *reachablity = appDelegate.internetReachable;
        if (![reachablity isReachable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                            message:@"You must be connected to the Internet to play a game."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

/**
 * In prepareForSegue:sender:, we provided the game view controller with the
 * scenario that user has selected.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Start Game"])
    {
        NSInteger row = [self.scenario selectedRowInComponent:0];
        switch(row)
        {
            case 0:
                self.scenarioSelected = @"slayer";
                break;
            case 1:
                self.scenarioSelected = @"tutorial_1";
                break;
            case 2:
                self.scenarioSelected = @"captureflag";
                break;
            case 3:
                self.scenarioSelected = @"vampirehunter";
                break;
            case 4:
                self.scenarioSelected = @"zombieisbetter";
                break;
            case 5:
                self.scenarioSelected = @"rockpapersissors";
                break;
            case 6:
                self.scenarioSelected = @"warzone";
                break;
            default:
                self.scenarioSelected = @"slayer";
                break;
                
        }
        GameWebViewController *vc = [segue destinationViewController];
        [vc setScenario:self.scenarioSelected];
    }
}

/**
 * Action for back button. Pop out the previous view in navigation controller.
 */
- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.scenarioArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [self.scenarioArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Copperplate" size:20];
    label.text = [self.scenarioArray objectAtIndex:row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

# pragma mark - Banner View

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (self.hasAds) {
        // If user has not purchased the ad-free version, show iAds.
        self.adView.hidden = NO;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    self.adView.hidden = YES;
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.musicPlayer.menuPlayer pause];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    EnemyUnknownAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.musicPlayer.menuPlayer play];
    self.hasAds = NO;
    self.adView.hidden = YES;
}

#pragma mark - Helper functions

/**
 * Provide an array of available scenario names.
 */
- (NSArray *)scenarios
{
    return [[NSArray alloc] initWithObjects:@"Slayer", @"Tutorial", @"Capture the Flag", @"Vampire Hunter",
            @"Zombie is King", @"Rock Paper Sissors", @"War zone", nil];
}

@end
