//
//  CoachTeamHome.m
//  iCoach
//
//  Created by Nick Wroblewski on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CoachTeamHome.h"
#import "TabController.h"
#import "CreateTeam.h"
#import "Team.h"
#import "iCoachAppDelegate.h"
#import "ServerAPI.h"
#import "CoachHome.h"
#import "JoinTeam.h"


@implementation CoachTeamHome
@synthesize teams, header, footer, didLoad, didRegister, deleteRow, teamsStored, numMemberTeams;


- (void)viewDidAppear:(BOOL)animated{
	
	if (![self.didLoad isEqualToString:@"true"]) {
		[self viewDidLoad];
	}
}



- (void)viewDidLoad {
	self.title = @"My Teams";
	self.didLoad = @"true";
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor clearColor];

	
	if (self.numMemberTeams > 0) {
	
		NSString *num = [NSString stringWithFormat:@"%d", self.numMemberTeams];
		
		NSString *display = [[@"We have found that you are already a member of " stringByAppendingString:num] stringByAppendingString:@" team(s)."];
		alertOne = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:display delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertOne show];
		
		self.numMemberTeams = 0;
	}
	
	//Retrieve teams from DB
	NSString *token = @"";
	NSArray *teamArray = [NSArray array];
	
	iCoachAppDelegate *mainDelegate = (iCoachAppDelegate *)[[UIApplication sharedApplication] delegate];
	

	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	
	//If the team array was already set, dont do the lookup
	
	if (self.teamsStored <= 0){
	   //If there is a token, do a DB lookup to find the teams associated with this coach:
	   if (![token isEqualToString:@""]){
		
		
		 teamArray = [ServerAPI getListOfTeams:token];
		 self.teams = teamArray;
		
	}
	}
	self.teamsStored = 0;
	
	
	[self.tableView reloadData];
    //Header to be displayed if there are no teams
	UIView *headerView =
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 50)]
	 autorelease];
	UILabel *headerLabel =
	[[[UILabel alloc]
	  initWithFrame:CGRectMake(10, 10, 300, 40)]
	 autorelease];
    headerLabel.text = NSLocalizedString(@"You are not currently part of any teams.", @"");
	headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
	
	//Footer to be displayed, allows option to create new team
	UIView *footerView = 
	[[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 320, 200)]
	 autorelease];
	
	if ([self.didRegister isEqualToString:@"true"]){
		self.didRegister = @"false";
		UILabel *footerLabel =
		[[[UILabel alloc]
		  initWithFrame:CGRectMake(60, 10, 500, 40)]
		 autorelease];
		footerLabel.text = NSLocalizedString(@"Registration Successful!", @"");
		footerLabel.textColor = [UIColor colorWithRed:.1333 green:.545 blue:.1333 alpha:1];
		footerLabel.font = [UIFont boldSystemFontOfSize:16];
		footerLabel.backgroundColor = [UIColor clearColor];
		[footerView addSubview:footerLabel];
	}
	
	UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	b.frame = CGRectMake(50, 47, 200, 30);
	[b setTitle:@"Create New Team" forState:UIControlStateNormal];
	[b setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[b addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
	
	 [footerView addSubview:b];
	
	UIButton *c = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	c.frame = CGRectMake(55, 85, 190, 30);
	[c setTitle:@"Join A Team" forState:UIControlStateNormal];
	[c setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[c addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
	
	[footerView addSubview:c];
	
	UIButton *d = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	d.frame = CGRectMake(55, 120, 190, 30);
	[d setTitle:@"Become a Fan" forState:UIControlStateNormal];
	[d setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[d addTarget:self action:@selector(fan) forControlEvents:UIControlEventTouchUpInside];
	
	[footerView addSubview:d];
	
	
	CGRect myImageRect = CGRectMake(50.0f, 155.0f, 188.0f, 169.0f);
	UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
	[myImage setImage:[UIImage imageNamed:@"sports.png"]];
	 myImage.opaque = YES; // explicitly opaque for performance
	[footerView addSubview:myImage];
	[myImage release];
	
	headerView.backgroundColor = [UIColor whiteColor];
	footerView.backgroundColor = [UIColor whiteColor];
   
	//Only display header if there are no teams
	NSInteger numTeams = [teams count];
	if (numTeams == 0) {
		self.tableView.tableHeaderView = headerView;
	}else{
		self.tableView.tableHeaderView = nil;
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
		[self.navigationItem setRightBarButtonItem:addButton];
		[addButton release];
	}
	
	
    [self.navigationItem setHidesBackButton:YES];
	
	self.tableView.tableFooterView = footerView;

}


-(IBAction)home{
	
	//About *nextController = [[About alloc] init];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {

    //Code to delete the team goes here
	
	alertTwo = [[UIAlertView alloc] initWithTitle:@"Delete this Team?" message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alertTwo show];
	
	self.deleteRow = [indexPath row];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (alertView == alertOne) {
       
	}else{
	//"No"
	if(buttonIndex == 0) {	
		
		
	
    //"Yes"
	}else if (buttonIndex == 1) {
		
		Team *coachTeam = [self.teams objectAtIndex:self.deleteRow];
		
		iCoachAppDelegate *mainDelegate = (iCoachAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSString *token = @"";
		if (mainDelegate.token != nil){
			token = mainDelegate.token;
		}
		
		if (![token isEqualToString:@""]){
			NSString *response = [ServerAPI deleteTeam:coachTeam.teamId :token];
			NSLog(@"%@", response);
		}
		
	}
	self.didLoad = @"false";
	[super setEditing:NO animated:NO];
	[self.tableView setEditing:NO animated:NO];
	[self.tableView reloadData];
	[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
	[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	[self viewDidAppear:YES];
		
	}
}



- (IBAction) EditTable:(id)sender{
	
	if(self.editing){
		[super setEditing:NO animated:NO];
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	
	}else{
		
		[super setEditing:YES animated:YES];
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
		
	}	
}

- (void)viewDidUnload {
	self.teams = nil;
	self.header = nil;
	self.footer = nil;
	[super viewDidUnload];
}

-(IBAction)create{
	
	self.didLoad = @"false";
	CreateTeam *nextController = [[CreateTeam alloc] init];
	[self.navigationController pushViewController:nextController animated:YES];		
	
}

-(IBAction)join{
	
	self.didLoad = @"false";
	JoinTeam *nextController = [[JoinTeam alloc] init];
	[self.navigationController pushViewController:nextController animated:YES];		
	
}

-(void)fan{
	
		
	
}

- (void)dealloc {
	[header release];
	[footer release];
	[teams release];
	[didLoad release];
	[didRegister release];

	[super dealloc];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.teams count];
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
	Team *team = [self.teams objectAtIndex:row];
	cell.textLabel.text = team.name;
	cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	

	UIImage *rowBackground;
	cell.backgroundView = [[[UIImageView alloc] init] autorelease];
	NSInteger sectionRows = [tableView numberOfRowsInSection:[indexPath section]];
	
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
	
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	
	
	return cell;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

	//Get the Team from the array, and forward action to the Teams home page
//	NSUInteger row = [indexPath row];

//	Team *coachTeam = [self.teams objectAtIndex:row];
	
//	[self.navigationController pushViewController:coachTeam animated:YES];
	
	
}

@end
