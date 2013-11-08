//
//  LobbyViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/7/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "LobbyViewController.h"
#import "GameWebViewController.h"

@interface LobbyViewController ()
@property (strong,nonatomic) NSArray *scenarioArray;
@property (nonatomic) NSString* scenarioSelected;
@end

@implementation LobbyViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.scenarioArray = [self scenarios];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.scenarioArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.scenarioArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
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
    }
    
}

-(NSArray *) scenarios{
    return [[NSArray alloc] initWithObjects:@"Slayer",@"Tutorial",@"Capture the Flag",@"Vampire Hunter",@"Zombie is King",@"Rock Paper Sissors",@"War zone", nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Start Game"])
    {
        GameWebViewController *vc = [segue destinationViewController];
        [vc setScenario:self.scenarioSelected];
    }
}

@end
