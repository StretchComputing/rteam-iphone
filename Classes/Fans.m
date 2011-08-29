//
//  Players.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Fans.h"
#import "Player.h"
#import "NewPlayer.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "Base64.h"
#import "InviteFan2.h"
#import "Fan.h"

@implementation Fans
@synthesize fans, teamName, teamId, userRole, currentIcon, currentMemberId, error, fanTable, fanActivity, fanActivityLabel, barActivity,
fanPics;


-(void)viewWillAppear:(BOOL)animated{
	
	[self.tabBarController.navigationItem setRightBarButtonItem:nil];

	[self.barActivity startAnimating];
	[self performSelectorInBackground:@selector(getAllFans) withObject:nil];
}



- (void)viewDidLoad {
	self.currentMemberId = @"";
	self.currentIcon = [[UIImageView alloc] init];

	self.fanTable.delegate = self;
	self.fanTable.dataSource = self;
	
	self.fanTable.hidden = YES;
	[self.fanActivity startAnimating];
	
	self.barActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(95, 32, 20, 20)];
	//set the initial property
	self.barActivity.hidesWhenStopped = YES;
	self.barActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	
	[self.navigationController.view addSubview:self.barActivity];
	
	//Header to be displayed if there are no players
	UIView *headerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 75)]
	 autorelease];
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 73, 320, 1)];
	UIColor *color = [[UIColor alloc] initWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
	line2.backgroundColor = color;
	[headerView addSubview:line2];
    [line2 release];
	[color release];
	
	//Only display header if there are no teams
	NSInteger numTeams = [fans count];
	if (numTeams == 0) {
		UILabel *headerLabel =
		[[[UILabel alloc]
		  initWithFrame:CGRectMake(10, 1, 320, 40)]
		 autorelease];
		headerLabel.text = NSLocalizedString(@"You currently have no fan contacts.", @"");
		headerLabel.textColor = [UIColor blackColor];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.font = [UIFont boldSystemFontOfSize:16];
		headerLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:headerLabel];
	}
	
	
	UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	b.frame = CGRectMake(85, 40, 150, 30);
	[b setTitle:@"Invite A Fan" forState:UIControlStateNormal];
	[b setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[b addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
	
	headerView.backgroundColor = [UIColor whiteColor];
	
	if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		[headerView addSubview:b];
		
	}else {
		if (numTeams > 0){
			
			headerView = nil;
		}
	}
	
	
	//self.fanTable.tableHeaderView = headerView;
	
}


-(void)getAllFans{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *token = @"";
	NSArray *playerArray = [NSArray array];
	self.fanPics = [NSMutableArray array];

	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI getListOfTeamMembers:self.teamId :token :@"fan" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			playerArray = [response valueForKey:@"members"];
			
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.error = @"*Error connecting to server";
					break;
				default:
					//Log the status code?
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
	self.fans = playerArray;
	
	for (int i = 0; i < [self.fans count]; i++) {
		[self.fanPics addObject:@""];
	}
	
	[pool drain];
	
	[self performSelectorOnMainThread:@selector(finishedFans) withObject:nil waitUntilDone:NO];

	
}

-(void)finishedFans{
	
	self.fanTable.hidden = NO;
	
	[self.fanActivity stopAnimating];
	self.fanActivityLabel.hidden = YES;
	[self.barActivity stopAnimating];
	[self performSelectorInBackground:@selector(getPicsFans) withObject:nil];

	[self.fanTable reloadData];
	
}


-(IBAction)create{
	
	InviteFan2 *nextController = [[InviteFan2 alloc] init];
	nextController.teamId = self.teamId;
	nextController.addDone = true;
	[self.navigationController pushViewController:nextController animated:YES];		
	
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.fans count];
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
	Fan *controller = [fans objectAtIndex:row];

	if ((controller.firstName == nil) || ([controller.firstName isEqualToString:@" "])) {
		cell.textLabel.text = controller.email;
	}else{
		cell.textLabel.text = controller.firstName;
		
	}
	
	if ([[self.fanPics objectAtIndex:row] isEqualToString:@""]) {
		cell.imageView.image = [UIImage imageNamed:@"profile1.png"];
	}else {
		
		NSData *profileData = [Base64 decode:[self.fanPics objectAtIndex:row]];
		cell.imageView.image = [UIImage imageWithData:profileData];
	}
	
	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//go to that player profile
	NSUInteger row = [indexPath row];
	Fan *coachTeam = [self.fans objectAtIndex:row];
	coachTeam.headUserRole = self.userRole;
	[self.navigationController pushViewController:coachTeam animated:YES];
	
	
}

- (void)getPicsFans {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	//Create the new player
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	for (int i = 0; i < [self.fans count]; i++) {
		
		
		Player *controller = [self.fans objectAtIndex:i];
		
		NSDictionary *response = [ServerAPI getMemberInfo:self.teamId :controller.memberId :mainDelegate.token :@""];
		
		
		NSString *status = [response valueForKey:@"status"];
		
		
		
		if ([status isEqualToString:@"100"]){
			
			NSDictionary *memberInfo = [response valueForKey:@"memberInfo"];
			
			NSString *profile = [memberInfo valueForKey:@"thumbNail"];
			
			if ((profile == nil)  || ([profile isEqualToString:@""])){
				
				
			}else {
				
				[self.fanPics replaceObjectAtIndex:i withObject:profile];
				
				
			}
			
			
			[self performSelectorOnMainThread:
			 @selector(didFinishFans)
								   withObject:nil
								waitUntilDone:NO
			 ];
			
		}else{
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.error = @"*Error connecting to server";
					break;
				default:
					//should never get here
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		
	}
    [pool drain];
}

- (void)didFinishFans{
	
		[self.fanTable reloadData];
	
}


- (void)viewDidUnload {
	//fans = nil;
	//teamName = nil;
	//teamId = nil;
	//userRole = nil;
	currentIcon = nil;
	currentMemberId = nil;
	error = nil;
	fanTable = nil;
	fanActivity = nil;
	fanActivityLabel = nil;
	barActivity = nil;
	fanPics = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[fans release];
	[teamName release];
	[teamId release];
	[userRole release];
	[currentIcon release];
	[currentMemberId release];
	[error release];
	[fanActivity release];
	[fanTable release];
	[fanActivityLabel release];
	[barActivity release];
	[fanPics release];
	[super dealloc];
}


@end

