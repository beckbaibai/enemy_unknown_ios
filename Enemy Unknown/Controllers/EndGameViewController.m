//
//  EndGameViewController.m
//  Enemy Unknown
//
//  Created by Frank Zhang on 11/19/13.
//  Copyright (c) 2013 Comp 446. All rights reserved.
//

#import "EndGameViewController.h"

@interface EndGameViewController ()

@end

@implementation EndGameViewController

- (IBAction)mainMenu:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) viewDidLoad
{
    if(self.iWon){
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"youwin1" ofType:@"png"];
        self.didWinImage.image = [UIImage imageWithContentsOfFile:filepath];
    }else{
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"youlose" ofType:@"png"];
        self.didWinImage.image = [UIImage imageWithContentsOfFile:filepath];
    }
}


@end
