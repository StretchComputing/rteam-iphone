//
//  BoxScoreViewViewController.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoxScoreViewViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BoxScoreViewViewController
@synthesize  frontView, scoreUs, scoreThem, interval, nameUs, nameThem;

-(void)viewDidLoad{
    
    self.frontView.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:190.0/255.0 blue:34.0/255.0 alpha:1.0];
    
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 5.0;
    
    self.frontView.layer.masksToBounds = YES;
    self.frontView.layer.cornerRadius = 5.0;
}

-(void)viewDidUnload{
    
    self.frontView = nil;
    scoreThem = nil;
    scoreUs = nil;
    nameThem = nil;
    nameUs = nil;
    interval = nil;
    [super viewDidUnload];
}
@end
