//
//  InviteFan.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InviteFan.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "InviteFan2.h"
#import "InviteFanFinal.h"
#import "FastActionSheet.h"

@implementation InviteFan
@synthesize listOfTeams, teamArray, noRightButton, error, errorString, loadingActivity, loadingLabel, teamArrayTemp;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.teamArray = [NSMutableArray array];
	
}

-(void)goHome{
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	self.title = @"Invite A Fan";
	self.listOfTeams.delegate = self;
	self.listOfTeams.dataSource = self;
	self.listOfTeams.backgroundColor = [UIColor clearColor];
	//self.listOfTeams.style = UITableViewStyleGrouped;
	
	[self.loadingActivity startAnimating];
	[self.loadingLabel setHidden:NO];
	
	[self performSelectorInBackground:@selector(getListOfTeams) withObject:nil];
	
	
	
}


-(void)getListOfTeams{
    
	@autoreleasepool {
        
		self.teamArrayTemp = [NSMutableArray array];	
		
		
		//Retrieve teams from DB
		NSString *token = @"";
		
		rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		if (mainDelegate.token != nil){
			token = mainDelegate.token;
		}
		
		
		//If there is a token, do a DB lookup to find the teams associated with this coach:
		if (![token isEqualToString:@""]){
			
			NSDictionary *response = [ServerAPI getListOfTeams:token];
			
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				self.teamArrayTemp = [response valueForKey:@"teams"];
				self.errorString = @"";
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						//null parameter
						self.errorString = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						self.errorString = @"*Error connecting to server";
						break;
					default:
						//should never get here
						self.errorString = @"*Error connecting to server";
						break;
				}
			}

			
		}
        
		
		
		[self performSelectorOnMainThread:@selector(doneTeams) withObject:nil waitUntilDone:NO];
	}
}

-(void)doneTeams{
	
	[self.loadingActivity stopAnimating];
	[self.loadingLabel setHidden:YES];
	
	
	if (![self.errorString isEqualToString:@""]) {
		self.error.text = self.errorString;
		[self.error setHidden:NO];
	}else {
		self.teamArray = self.teamArrayTemp;
		self.listOfTeams.hidden = NO;
		[self.listOfTeams reloadData];
	}
    
	if ([self.teamArray count] == 0) {
		self.error.text = @"You must create or join at least 1 team to invite a fan.";
	}
	
	if (self.noRightButton) {
		[self.tabBarController.navigationItem setLeftBarButtonItem:nil];
	}else {
		UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
		[self.navigationItem setRightBarButtonItem:homeButton];
		
	}
    
}


-(void)home{
	
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: FirstLevelCell];
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
	
	
	//Get the Team from the array, and forward action to the Teams home page
	
	NSUInteger row = [indexPath row];
    
	Team *coachTeam = [self.teamArray objectAtIndex:row];
	InviteFanFinal *tmp = [[InviteFanFinal alloc] init];
	tmp.teamId = coachTeam.teamId;
	tmp.userRole = coachTeam.userRole;
	tmp.teamName = coachTeam.name;
    
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	
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


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)viewDidUnload{
	
	listOfTeams = nil;
	error = nil;
	loadingActivity = nil;
	loadingLabel = nil;
	[super viewDidUnload];
}

@end
