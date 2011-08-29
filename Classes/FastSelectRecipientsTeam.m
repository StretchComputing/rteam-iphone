//
//  FastSelectRecipientsTeam.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastSelectRecipientsTeam.h"
#import "Team.h"
#import "FastSelectRecipients.h"
#import "rTeamAppDelegate.h"

@implementation FastSelectRecipientsTeam
@synthesize teamList, teamArray, fromWhere, messageOrPoll;


-(void)viewDidLoad{
	
	self.teamList.delegate = self;
	self.teamList.dataSource = self;
	self.teamList.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier: FirstLevelCell] autorelease];
	}
	
	//Configure the cell
	NSUInteger row = [indexPath row];
	
	
	Team *team = [self.teamArray objectAtIndex:row];
	cell.textLabel.textAlignment = UITextAlignmentLeft;
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	cell.textLabel.text = team.name;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSUInteger row = [indexPath row];
	
	Team *coachTeam = [self.teamArray objectAtIndex:row];
	
	FastSelectRecipients *tmp = [[FastSelectRecipients alloc] init];
	tmp.teamId = coachTeam.teamId;
	
	tmp.fromWhere = self.fromWhere; 
	tmp.messageOrPoll = self.messageOrPoll;
	
	[self.navigationController pushViewController:tmp animated:YES];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return [self.teamArray count];
	
}




-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	return @"";
	
}





-(void)viewDidUnload{
	teamList = nil;
	//teamArray = nil;
	//fromWhere = nil;
	//messageOrPoll = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	
	[teamList release];
	[teamArray release];
	[fromWhere release];
	[messageOrPoll release];
	[super dealloc];
	
}
@end