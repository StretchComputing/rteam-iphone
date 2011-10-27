//
//  Scores.mf
//  rTeam
//
//  Created by Nick Wroblewski on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Scores.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Game.h"
#import "QuartzCore/QuartzCore.h"
#import "Team.h"
#import "Home.h"
#import "FastActionSheet.h"

@implementation Scores
@synthesize teamId, bottomBar, refreshButton, filterButton, table, games, error, teamTable, scroll, haveTeamList, teamList, sport, teamName,
bannerIsVisible, loadingActivity, loadingLabel, refreshActivity, cancelButton, insideView;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}


-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)viewDidLoad{
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];

	
	if (self.sport == nil) {
		self.sport = @"";
	}
	if (self.teamId == nil) {
		self.teamId = @"";
	}
	if (self.teamName == nil) {
		self.teamName = @"";
	}
	
	[self.scroll setHidden:YES];
	
	self.scroll.layer.masksToBounds = YES;
	self.scroll.layer.cornerRadius = 15.0;
	
	self.insideView.layer.masksToBounds = YES;
	self.insideView.layer.cornerRadius = 15.0;
	
	//UIColor *tmpColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
	self.scroll.backgroundColor = [UIColor blackColor];
	self.teamTable.backgroundColor = [UIColor clearColor];
	
	[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
	
	[self.loadingActivity startAnimating];
	self.table.hidden = YES;
	[self performSelectorInBackground:@selector(getGames) withObject:nil];
	
	self.title = @"Scores/Schedule";
	
	//Set refresh button
	self.refreshButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																	   target:self action:@selector(refresh)];
    
	self.refreshButton.style = UIBarButtonItemStyleBordered;
    
    
	
	

	self.table.dataSource = self;
	self.table.delegate = self;
	self.teamTable.dataSource = self;
	self.teamTable.delegate = self;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.cancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
}

-(void)getGames{

	
	NSArray *tmpGames = [NSArray array];
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfGames:self.teamId :token];
		
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			tmpGames = [response valueForKey:@"games"];
			
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
					//log status code
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
	NSMutableArray *tmpGamesSort = [NSMutableArray arrayWithArray:tmpGames];
	
	NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	[tmpGamesSort sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	self.games = tmpGamesSort;
	
	
	
	[self performSelectorOnMainThread:@selector(doneGames) withObject:nil waitUntilDone:NO];
}

-(void)doneGames{
	
	[self.refreshActivity stopAnimating];
	[self.loadingActivity stopAnimating];
	[self.loadingLabel setHidden:YES];
	self.table.hidden = NO;
	[self.table reloadData];
	
	
}


-(void)refresh{
	[self.refreshActivity startAnimating];
	[self performSelectorInBackground:@selector(getGames) withObject:nil];
}

-(void)filter{
	
	[self.scroll setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.table) {
		if ([self.games count] == 0) {
			return 1;
		}
		return [self.games count];
	}else {
		return [self.teamList count] + 1;
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.table) {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameUsTag = 1;
	static NSInteger nameThemTag = 2;
	static NSInteger dateTag = 3;
	static NSInteger scoreUsTag = 4;
	static NSInteger scoreThemTag = 5;
	static NSInteger intervalTag = 6;
		static NSInteger canceledTag = 7;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		
		frame.origin.x = 10;
		frame.origin.y = 8;
		frame.size.height = 20;
		frame.size.width = 175;
		UILabel *nameUsLabel = [[UILabel alloc] initWithFrame:frame];
		nameUsLabel.tag = nameUsTag;
		[cell.contentView addSubview:nameUsLabel];
		
		frame.origin.x = 10;
		frame.origin.y = 32;
		frame.size.height = 20;
		frame.size.width = 175;
		UILabel *nameThemLabel = [[UILabel alloc] initWithFrame:frame];
		nameThemLabel.tag = nameThemTag;
		[cell.contentView addSubview:nameThemLabel];
		
		frame.origin.x = 190;
		frame.origin.y = 18;
		frame.size.height = 20;
		frame.size.width = 130;
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		
		frame.origin.x = 34;
		frame.origin.y = 14;
		frame.size.height = 25;
		frame.size.width = 32;
		UILabel *scoreUsLabel = [[UILabel alloc] initWithFrame:frame];
		scoreUsLabel.tag = scoreUsTag;
		[cell.contentView addSubview:scoreUsLabel];
		
		
		frame.origin.x = 254;
		frame.origin.y = 14;
		frame.size.height = 25;
		frame.size.width = 32;
		UILabel *scoreThemLabel = [[UILabel alloc] initWithFrame:frame];
		scoreThemLabel.tag = scoreThemTag;
		[cell.contentView addSubview:scoreThemLabel];
		
		frame.origin.x = 100;
		frame.origin.y = 18;
		frame.size.height = 20;
		frame.size.width = 120;
		UILabel *intervalLabel = [[UILabel alloc] initWithFrame:frame];
		intervalLabel.tag = intervalTag;
		[cell.contentView addSubview:intervalLabel];
		
		frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 60;
		frame.size.width = 320;	
		UILabel *canceledLabel = [[UILabel alloc] initWithFrame:frame];
		canceledLabel.tag = canceledTag;
		[cell.contentView addSubview:canceledLabel];
		
		
	}
	
		UILabel *canceledLabel = (UILabel *)[cell.contentView viewWithTag:canceledTag];
		
		
		canceledLabel.text = @"CANCELED";
		canceledLabel.textColor = [UIColor colorWithRed:190.0/255.0 green:0.0 blue:0.0 alpha:.90];
		canceledLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:30];
		canceledLabel.textAlignment = UITextAlignmentCenter;
		canceledLabel.backgroundColor = [UIColor clearColor];
		canceledLabel.hidden = YES;


	UILabel *nameUsLabel = (UILabel *)[cell.contentView viewWithTag:nameUsTag];
	nameUsLabel.backgroundColor = [UIColor clearColor];
	
	UILabel *nameThemLabel = (UILabel *)[cell.contentView viewWithTag:nameThemTag];
	nameThemLabel.backgroundColor = [UIColor clearColor];
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	dateLabel.backgroundColor = [UIColor clearColor];
	
	UILabel *scoreUsLabel = (UILabel *)[cell.contentView viewWithTag:scoreUsTag];
	scoreUsLabel.backgroundColor = [UIColor clearColor];
	scoreUsLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
	
	UILabel *scoreThemLabel = (UILabel *)[cell.contentView viewWithTag:scoreThemTag];
	scoreThemLabel.backgroundColor = [UIColor clearColor];
	scoreThemLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];

	UILabel *intervalLabel = (UILabel *)[cell.contentView viewWithTag:intervalTag];
	intervalLabel.backgroundColor = [UIColor clearColor];
	intervalLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	
	if ([self.games count] == 0) {
			
			nameUsLabel.text = @"No games found...";
			nameUsLabel.frame = CGRectMake(100, 20, 220, 20);
			nameUsLabel.textColor = [UIColor blackColor];
			nameUsLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
			nameUsLabel.textAlignment = UITextAlignmentLeft;
			
			[nameThemLabel setHidden:YES];
			[scoreUsLabel setHidden:YES];
			[scoreThemLabel setHidden:YES];
			[intervalLabel setHidden:YES];
			[dateLabel setHidden:YES];
			
	}else {
		
		nameThemLabel.hidden = NO;
	NSUInteger row = [indexPath row];
	Game *tmpGame = [self.games objectAtIndex:row];
	
		
	NSString *date = tmpGame.startDate;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	NSDate *formatedDate = [dateFormat dateFromString:date];
	[dateFormat setDateFormat:@"MM/dd hh:mm aa"];
	
	NSString *dateText = [dateFormat stringFromDate:formatedDate];
	
	
	if ([tmpGame.interval isEqualToString:@"0"] || [tmpGame.interval isEqualToString:@"-4"]) {
		
		NSDate *todaysDate = [NSDate date];
		
		if ([tmpGame.interval isEqualToString:@"-4"]) {
			canceledLabel.hidden = NO;
		}
		
		if ([formatedDate isEqualToDate:[formatedDate earlierDate:todaysDate]] && ![tmpGame.interval isEqualToString:@"-4"]) {
			//
			
			[scoreUsLabel setHidden:NO];
			[scoreThemLabel setHidden:NO];
			[intervalLabel setHidden:NO];
			[nameUsLabel setHidden:NO];
			[nameThemLabel setHidden:NO];
			
			[dateFormat setDateFormat:@"MM/dd/YY"];
			dateText = [dateFormat stringFromDate:formatedDate];
			dateLabel.text = dateText;
			dateLabel.frame = CGRectMake(135, 45, 80, 15);
			dateLabel.textColor = [UIColor blueColor];
			dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
			
			scoreUsLabel.text = @"-";
			scoreUsLabel.textColor = [UIColor blackColor];
			scoreUsLabel.textAlignment = UITextAlignmentCenter;
			
			scoreThemLabel.text = @"-";
			scoreThemLabel.textColor = [UIColor blackColor];
			scoreThemLabel.textAlignment = UITextAlignmentCenter;
			
			intervalLabel.text = @"No score found";
			intervalLabel.textColor = [UIColor redColor];
			intervalLabel.textAlignment = UITextAlignmentCenter;
			
			if (![self.sport isEqualToString:@""]) {
				tmpGame.sport = self.sport;
			}
			
			if (![self.teamName isEqualToString:@""]) {
				tmpGame.teamName = self.teamName;
			}
			
			nameUsLabel.frame = CGRectMake(10, 35, 80, 25);
			nameUsLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
			nameUsLabel.textColor = [UIColor grayColor];
			nameUsLabel.textAlignment = UITextAlignmentCenter;
			nameUsLabel.text = tmpGame.teamName;
			
			nameThemLabel.frame = CGRectMake(230, 35, 80, 25);
			nameThemLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
			nameThemLabel.textColor = [UIColor grayColor];
			nameThemLabel.textAlignment = UITextAlignmentCenter;
			nameThemLabel.text = tmpGame.opponent;
			
			[nameUsLabel setHidden:NO];

			
		}else{
			
			if (![self.sport isEqualToString:@""]) {
				tmpGame.sport = self.sport;
			}
			
			if (![self.teamName isEqualToString:@""]) {
				tmpGame.teamName = self.teamName;
			}
			//Game hasnt started yet, show the time
			nameUsLabel.text = tmpGame.teamName;
			nameUsLabel.frame = CGRectMake(10, 8, 175, 20);
			nameUsLabel.textColor = [UIColor blackColor];
			nameUsLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
			nameUsLabel.textAlignment = UITextAlignmentLeft;
			
			nameThemLabel.text = tmpGame.opponent;
			nameThemLabel.frame = CGRectMake(10, 32, 175, 20);
			nameThemLabel.textColor = [UIColor blackColor];
			nameThemLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
			nameThemLabel.textAlignment = UITextAlignmentLeft;
			
			
			dateLabel.text = dateText;
			dateLabel.frame = CGRectMake(190, 18, 130, 20);
			dateLabel.textColor = [UIColor blackColor];
			dateLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
			
			
			[scoreUsLabel setHidden:YES];
			[scoreThemLabel setHidden:YES];
			[intervalLabel setHidden:YES];
			[dateLabel setHidden:NO];
			[nameUsLabel setHidden:NO];

			
		}
	}else {
		
		[scoreUsLabel setHidden:NO];
		[scoreThemLabel setHidden:NO];
		[intervalLabel setHidden:NO];
		[nameUsLabel setHidden:NO];

		[dateFormat setDateFormat:@"MM/dd/YY"];
		dateText = [dateFormat stringFromDate:formatedDate];
		dateLabel.text = dateText;
		dateLabel.frame = CGRectMake(135, 45, 80, 15);
		dateLabel.textColor = [UIColor blueColor];
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
		
        
		scoreUsLabel.text = tmpGame.scoreUs;
		scoreUsLabel.textColor = [UIColor greenColor];
		scoreUsLabel.textAlignment = UITextAlignmentCenter;
		scoreThemLabel.text = tmpGame.scoreThem;
		scoreThemLabel.textColor = [UIColor redColor];
		scoreThemLabel.textAlignment = UITextAlignmentCenter;
		
		NSString *intervalType = @"";
		
		if (![self.sport isEqualToString:@""]) {
			tmpGame.sport = self.sport;
		}
		
		if (![self.teamName isEqualToString:@""]) {
			tmpGame.teamName = self.teamName;
		}
		
		if ([tmpGame.sport isEqualToString:@"Baseball"] || [tmpGame.sport isEqualToString:@"Softball"]) {
			intervalType = @"inning";
		}else if ([tmpGame.sport isEqualToString:@"Football"] || [tmpGame.sport isEqualToString:@"Basketball"] ||
				  [tmpGame.sport isEqualToString:@"Flag Football"]) {
			intervalType = @"quarter";
		}else if ([tmpGame.sport isEqualToString:@"Hockey"] || [tmpGame.sport isEqualToString:@"Water Polo"]) {
			intervalType = @"period";
		}else if ([tmpGame.sport isEqualToString:@"Soccer"]) {
			intervalType = @"quarter (half)";
		}else if ([tmpGame.sport isEqualToString:@"Lacrosse"]) {
			intervalType = @"quarter (period)";
		}else {
			intervalType = @"";
		}

		
		if ([tmpGame.interval isEqualToString:@"-2"]) {
			intervalLabel.text = @"Overtime";
			intervalLabel.textColor = [UIColor blackColor];

		}else if ([tmpGame.interval isEqualToString:@"-1"]) {
			intervalLabel.text = @"Final";
			intervalLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];

			intervalLabel.textColor = [UIColor blackColor];

		}else if ([tmpGame.interval isEqualToString:@"-3"]) {
			intervalLabel.text = @"In progress";
			intervalLabel.textColor = [UIColor blackColor];

		}else {
			intervalLabel.textColor = [UIColor blackColor];

			if ([tmpGame.interval isEqualToString:@"1"]) {
				intervalLabel.text = [NSString stringWithFormat:@"1st %@", intervalType];

			}else if ([tmpGame.interval isEqualToString:@"2"]) {
				
				intervalLabel.text = [NSString stringWithFormat:@"2nd %@", intervalType];

			}else if ([tmpGame.interval isEqualToString:@"3"]) {
				
				intervalLabel.text = [NSString stringWithFormat:@"3rd %@", intervalType];

			}else {
				intervalLabel.text = [tmpGame.interval stringByAppendingFormat:@"th %@", intervalType];
			}

		}
		
		intervalLabel.textAlignment = UITextAlignmentCenter;
		
		nameUsLabel.frame = CGRectMake(10, 35, 80, 25);
		nameUsLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		nameUsLabel.textColor = [UIColor grayColor];
		nameUsLabel.textAlignment = UITextAlignmentCenter;
		nameUsLabel.text = tmpGame.teamName;
		
		nameThemLabel.frame = CGRectMake(230, 35, 80, 25);
		nameThemLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
		nameThemLabel.textColor = [UIColor grayColor];
		nameThemLabel.textAlignment = UITextAlignmentCenter;
		nameThemLabel.text = tmpGame.opponent;
	}

		if (row % 2 != 0) {
			cell.contentView.backgroundColor = [UIColor whiteColor];
		}else {
			UIColor *tmpColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
			cell.contentView.backgroundColor = tmpColor;
			cell.accessoryView.backgroundColor = tmpColor;
        
			cell.backgroundView = [[UIView alloc] init]; 
			cell.backgroundView.backgroundColor = tmpColor;
		}
	}
		
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		
	return cell;
	
		
	}else {
		static NSString *FirstLevelCell=@"FirstLevelCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc]
					 initWithStyle:UITableViewCellStyleDefault
					 reuseIdentifier: FirstLevelCell];
		}
		
		NSUInteger row = [indexPath row];
		
		if (row == 0) {
			cell.textLabel.text = @"All";
		}else {

			
			Team *tmpTeam = [self.teamList objectAtIndex:row-1];
			
			cell.textLabel.text = tmpTeam.name;
		}

		
		
		return cell;
	}

}

	



//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.table) {
		return 60;
	}
    return 30;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//go to that game profile
	
	NSUInteger row = [indexPath row];
	
	if (tableView == self.table) {
		
	}else {
		[self.scroll setHidden:YES];
		if (row == 0) {
			self.teamId = @"";
			self.sport = @"";
			self.teamName = @"";
			
			self.table.hidden = YES;
			[self.loadingActivity startAnimating];
			[self.loadingLabel setHidden:NO];
			[self performSelectorInBackground:@selector(getGames) withObject:nil];
		}else {
			Team *tmpTeam = [self.teamList objectAtIndex:row-1];
			self.teamId = tmpTeam.teamId;
			self.sport = tmpTeam.sport;
			self.teamName = tmpTeam.name;
			self.table.hidden = YES;
			[self.loadingActivity startAnimating];
			[self.loadingLabel setHidden:NO];
			[self performSelectorInBackground:@selector(getGames) withObject:nil];
		}

	}

}

-(void)getTeamList{

	
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
			
			self.teamList = [response valueForKey:@"teams"];
			
			
			self.haveTeamList = true;
	
			
		}else{
			
			self.haveTeamList = false;
			//self.memberTeams = [NSMutableArray array];
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.error = @"*Error connecting to server";
					break;
				default:
					//should never get here
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		
		[self performSelectorOnMainThread:
		 @selector(doneTeams)
							   withObject:nil
							waitUntilDone:NO
		 ];
		
				
	}
	
	
}

-(void)doneTeams{
	bool showFilter;
	if (self.haveTeamList) {
		
		if ([self.teamList count] > 1) {
			showFilter = true;
		}else {
			showFilter = false;
		}

	}else {
		showFilter = false;
	}

	
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Team Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filter)];
    self.filterButton.title = @"Team Filter";
    NSArray *items1 = [NSArray arrayWithObjects:self.filterButton, flexibleSpace, self.refreshButton, nil];
    NSArray *items2 = [NSArray arrayWithObjects:flexibleSpace, self.refreshButton, nil];
	if (showFilter) {
        self.bottomBar.items = items1;

	}else {
		self.bottomBar.items = items2;
	}
    
    [self.teamTable reloadData];

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



//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
	
	if (!self.bannerIsVisible) {
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
		
		self.table.frame = CGRectMake(0, 50, 320, 322);
	}
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
		self.table.frame = CGRectMake(0, 0, 320, 372);
		
		
	}
	
	
}

-(void)closeFilter{
	
	[self.scroll setHidden:YES];

}


-(void)viewDidUnload{
	
	//teamId = nil;
	bottomBar = nil;
	refreshButton = nil;
	filterButton = nil;
	table = nil;
	//error = nil;
	//games = nil;
	teamTable = nil;
	scroll = nil;
	//sport = nil;
	//teamName = nil;
	//teamList = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	refreshActivity = nil;
	cancelButton = nil;
	insideView = nil;
	[super viewDidUnload];
	
}



@end
