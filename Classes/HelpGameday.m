//
//  HelpGameday.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpGameday.h"

@implementation HelpGameday
@synthesize myScrollView;

-(void)viewDidLoad{
    
    self.title = @"Gameday Help";
    self.myScrollView.contentSize = CGSizeMake(320, 1210);
}

-(void)viewDidUnload{
    myScrollView = nil;
}

@end
