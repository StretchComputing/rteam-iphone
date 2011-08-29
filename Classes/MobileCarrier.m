//
//  MobileCarrier.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MobileCarrier.h"


@implementation MobileCarrier
@synthesize name, code;

-(void)dealloc{
    
    [name release];
    [code release];
    [super dealloc];
}
@end
