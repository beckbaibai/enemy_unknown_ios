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

@interface LobbyViewController ()
@property (strong,nonatomic) NSArray *scenarioArray;
@property (nonatomic) NSString* scenarioSelected;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@end

@implementation LobbyViewController

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scenarioArray = [self scenarios];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.scenarioArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [self.scenarioArray objectAtIndex:row];
}


-(NSArray *) scenarios
{
    return [[NSArray alloc] initWithObjects:@"Slayer",@"Tutorial",@"Capture the Flag",@"Vampire Hunter",@"Zombie is King",@"Rock Paper Sissors",@"War zone", nil];
}

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
        NSLog(@"%@",self.scenarioSelected);
    }
}

@end
