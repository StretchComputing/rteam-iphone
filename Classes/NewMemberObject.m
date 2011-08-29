//
//  NewMemberObject.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMemberObject.h"


@implementation NewMemberObject
@synthesize firstName, lastName, email, phone, role, guardianOneName, guardianOneEmail, guardianOnePhone, guardianTwoName, guardianTwoEmail, guardianTwoPhone;

-(void)dealloc{
	
	[firstName release];
	[lastName release];
	[email release];
	[phone release];
	[role release];
    [guardianTwoPhone release];
    [guardianTwoEmail release];
    [guardianTwoName release];
    [guardianOneName release];
    [guardianOneEmail release];
    [guardianOnePhone release];
	[super dealloc];
	
}

@end
