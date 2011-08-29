//
//  Search.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Search.h"
#import "Team.h"
#import "Player.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "TeamNavigation.h"
#import "Fan.h"
#import "Home.h"
#import "FastActionSheet.h"
#import "TeamHome.h"
#import "TeamActivity.h"
#import "EventList.h"
#import "Players.h"
#import "TeamMessages.h"
#import "CurrentTeamTabs.h"

@implementation Search
@synthesize searchBar, searchCriteria, searchTableView, potentialMatches, allMatches, teamsOnly, error, potentialMatchesTeamName, 
allMatchesTeamName, bannerIsVisible, errorLabel, searchActivity;

-(void)viewDidAppear:(BOOL)animated{
	
	//[self becomeFirstResponder];
	
}
-(void)viewDidLoad{
	self.errorLabel.text = @"";
	self.potentialMatchesTeamName = [NSMutableArray array]; //Actually holds the entire team object
	self.title = @"Search";
	self.searchBar.placeholder = @"Search rTeam";
	[self.searchBar becomeFirstResponder];
	
	self.potentialMatches = [NSMutableArray array];
	
	self.searchTableView.delegate = self;
	self.searchTableView.dataSource = self;
	self.searchTableView.backgroundColor = [UIColor clearColor];
	self.searchBar.delegate = self;
	
	[self.searchActivity startAnimating];
	[self performSelectorInBackground:@selector(getListOfTeams) withObject:nil];
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	[homeButton release];
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}


-(void)getListOfTeams{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	NSString *token = @"";
	NSArray *teamArray = [NSArray array];
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	//If there is a token, do a DB lookup to find the teams associated with this coach:
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfTeams:token];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			teamArray = [response valueForKey:@"teams"];
			
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
					//should never get here
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
	}

	self.potentialMatches = [NSMutableArray arrayWithArray:teamArray];
	for (int i = 0; i < [self.potentialMatches count]; i++) {
		Team *tmpTeam = [self.potentialMatches objectAtIndex:i];
		
		[self.potentialMatchesTeamName addObject:tmpTeam];
	}
	self.teamsOnly = [NSMutableArray arrayWithArray:teamArray];
	
	[self performSelectorOnMainThread:@selector(doneTeams) withObject:nil waitUntilDone:NO];
	
	[pool drain];
	
}


-(void)doneTeams{
	
	[self.searchActivity stopAnimating];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];

	
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	self.errorLabel.text = @"";
	self.allMatches = [NSMutableArray array];
	self.allMatchesTeamName = [NSMutableArray array];

	NSString *currentText = searchText;
	int length = currentText.length;
	
	if (length > 0) {
		
		for (int i = 0; i < [self.potentialMatches count]; i++) {
						
			if ([[self.potentialMatches objectAtIndex:i] class] == [Team class]) {
				//Its a Team
				Team *tmpTeam = [self.potentialMatches objectAtIndex:i];
				NSString *currentResult = tmpTeam.name;
				
				if (currentResult.length > length) {
					
					NSString *substring = [currentResult substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						[self.allMatches addObject:tmpTeam];
						[self.allMatchesTeamName addObject:tmpTeam];
					}
					
				}
				
			}else if ([[self.potentialMatches objectAtIndex:i] class] == [Player class]){
				//Its a Player
				
				Player *tmpPlayer = [self.potentialMatches objectAtIndex:i];
				
				NSString *wholeName = @"";
				NSString *currentResult = @"";
				
		
				if (tmpPlayer.firstName != nil) {
					wholeName = tmpPlayer.firstName;
					if (tmpPlayer.lastName != nil) {
						wholeName = [[tmpPlayer.firstName stringByAppendingFormat:@" "] stringByAppendingString:tmpPlayer.lastName];

					}
				}
				currentResult = tmpPlayer.firstName;
					
			
				
				bool didAdd = false;
				
				if (currentResult.length > length - 1) {
					
					NSString *substring = [currentResult substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						[self.allMatches addObject:tmpPlayer];
						[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];

						didAdd = true;
					}
					
				}
				
				NSString *currentLast = tmpPlayer.lastName;
				
				if (currentLast.length > length - 1) {
					
					NSString *substring = [currentLast substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];

							didAdd = true;
						}
					}
					
				}
				
				if (wholeName.length > length - 1) {
					
					NSString *substring = [wholeName substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];

							didAdd = true;
						}
						
					}
					
				}
				
				NSString *currentEmail = tmpPlayer.email;
				
				if (currentEmail.length > length - 1) {
					
					NSString *substring = [currentEmail substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];
							
							didAdd = true;
						}
						
					}
					
				}
				
			}else {
				//Fan
				Fan *tmpPlayer = [self.potentialMatches objectAtIndex:i];
				NSString *wholeName = @"";
				
				if (tmpPlayer.firstName != nil) {
					wholeName = tmpPlayer.firstName;
					if (tmpPlayer.lastName != nil) {
						wholeName = [[tmpPlayer.firstName stringByAppendingFormat:@" "] stringByAppendingString:tmpPlayer.lastName];
						
					}
				}
				
				NSString *currentResult = tmpPlayer.firstName;
				bool didAdd = false;
				
				if (currentResult.length > length - 1) {
					
					NSString *substring = [currentResult substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						[self.allMatches addObject:tmpPlayer];
						[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];

						didAdd = true;
					}
					
				}
				
				NSString *currentLast = tmpPlayer.lastName;
				
				if (currentLast.length > length - 1) {
					
					NSString *substring = [currentLast substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];

							didAdd = true;
						}
					}
					
				}
				
				if (wholeName.length > length - 1) {
					
					NSString *substring = [wholeName substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:[self.potentialMatchesTeamName objectAtIndex:i]];
							didAdd = true;
						}
						
					}
					
				}

				
			}


		}
	}
	
	if ([self.allMatches count] > 0) {
		[self.searchTableView setHidden:NO];
		[self.searchTableView reloadData];
	}else {
		[self.searchTableView setHidden:YES];
	}
}


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	return [self.allMatches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	static NSInteger teamTag = 2;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 9;
		frame.size.height = 22;
		frame.size.width = 170;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];
		
		frame.origin.x = 180;
		frame.size.width = 103;
		UILabel *teamLabel = [[UILabel alloc] initWithFrame:frame];
		teamLabel.tag = teamTag;
		[cell.contentView addSubview:teamLabel];
		[teamLabel release];
	
		
	}
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];
	
	nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	nameLabel.textColor = [UIColor blackColor];
	
	teamLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	teamLabel.textColor = [UIColor grayColor];
	teamLabel.textAlignment = UITextAlignmentCenter;
	teamLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	
	NSUInteger row = [indexPath row];
	NSString *display = @"";
	NSString *teamDisplay = @"";

	
	if ([[self.allMatches objectAtIndex:row] class] == [Team class]) {
		Team *tmpTeam = [self.allMatches objectAtIndex:row];
		display = tmpTeam.name;
	}else {
		if ([[self.allMatches objectAtIndex:row] class] == [Player class]) {
			Player *tmpPlayer = [self.allMatches objectAtIndex:row];
			if (tmpPlayer.firstName != nil) {
				display = tmpPlayer.firstName;
				if (tmpPlayer.lastName != nil) {
					display = [[tmpPlayer.firstName stringByAppendingFormat:@" "] stringByAppendingString:tmpPlayer.lastName];
					
				}
			}
			
			Team *tmpTeam = [self.allMatchesTeamName objectAtIndex:row];
			teamDisplay = [NSString stringWithFormat:@"(%@)", tmpTeam.name];
		}
		
		if ([[self.allMatches objectAtIndex:row] class] == [Fan class]) {
			Fan *tmpPlayer = [self.allMatches objectAtIndex:row];
			
			if (tmpPlayer.firstName != nil) {
				display = tmpPlayer.firstName;
				if (tmpPlayer.lastName != nil) {
					display = [[tmpPlayer.firstName stringByAppendingFormat:@" "] stringByAppendingString:tmpPlayer.lastName];
					
				}
			}
			
			Team *tmpTeam = [self.allMatchesTeamName objectAtIndex:row];
			teamDisplay = [NSString stringWithFormat:@"(%@)", tmpTeam.name];

		}
	
	}

	nameLabel.text = display;
	if (![teamDisplay isEqualToString:@""]) {
		teamLabel.text = teamDisplay;
	}else {
		teamLabel.text = @"";
	}

	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	if ([[self.allMatches objectAtIndex:row] class] == [Team class]) {
		
		Team *coachTeam = [self.allMatches objectAtIndex:row];
		/*TeamNavigation *tmp = [[TeamNavigation alloc] init];
		tmp.teamId = coachTeam.teamId;
		tmp.teamName = coachTeam.name;
		tmp.userRole = coachTeam.userRole;
		tmp.sport = coachTeam.sport;
		[self.navigationController presentModalViewController:tmp animated:YES];
		*/
		
		CurrentTeamTabs *tmp = [[CurrentTeamTabs alloc] init];
		
		NSArray *viewControllers = tmp.viewControllers;
		
		tmp.teamId = coachTeam.teamId;
		tmp.teamName = coachTeam.name;
		tmp.userRole = coachTeam.userRole;
		tmp.title = coachTeam.name;
		tmp.sport = coachTeam.sport;
		
		TeamHome *home = [viewControllers objectAtIndex:0];
		home.teamId = coachTeam.teamId;
		home.userRole = coachTeam.userRole;
		home.teamSport = coachTeam.sport;
		home.teamName = coachTeam.name;
		home.teamUrl = coachTeam.teamUrl;
		
		TeamActivity *activity = [viewControllers objectAtIndex:1];
		activity.teamId = coachTeam.teamId;
		activity.userRole = coachTeam.userRole;
		
		Players *people = [viewControllers objectAtIndex:2];
		people.teamId = coachTeam.teamId;
		people.userRole = coachTeam.userRole;
		people.teamName = coachTeam.name;
		
		EventList *events = [viewControllers objectAtIndex:3];
		events.teamId = coachTeam.teamId;
		events.userRole = coachTeam.userRole;
		events.sport = coachTeam.sport;
		events.teamName = coachTeam.name;
		
		//TeamMessages *message = [viewControllers objectAtIndex:4];
		//message.teamId = coachTeam.teamId;
		//message.userRole = coachTeam.userRole;

		[self.navigationController pushViewController:tmp animated:YES];

		
	}else {
		if ([[self.allMatches objectAtIndex:row] class] == [Player class]) {
			Player *coachTeam = [self.allMatches objectAtIndex:row];
			Team *tmpTeam = [self.allMatchesTeamName objectAtIndex:row];
			coachTeam.headUserRole = tmpTeam.userRole;
			coachTeam.fromSearch = true;
			[self.navigationController pushViewController:coachTeam animated:YES];
		}
		if ([[self.allMatches objectAtIndex:row] class] == [Fan class]) {
			Fan *coachTeam = [self.allMatches objectAtIndex:row];
			Team *tmpTeam = [self.allMatchesTeamName objectAtIndex:row];
			coachTeam.headUserRole = tmpTeam.userRole;
			coachTeam.fromSearch = true;
			[self.navigationController pushViewController:coachTeam animated:YES];
		}
		
	}
	
	
}

- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	for (int i = 0; i < [self.teamsOnly count]; i++) {
		
		Team *tmpTeam = [self.teamsOnly objectAtIndex:i];
		
		NSArray *tmp = [NSArray array];
		
		NSDictionary *response = [ServerAPI getListOfTeamMembers:tmpTeam.teamId :mainDelegate.token :@"all" :@""];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			tmp = [response valueForKey:@"members"];
			
			
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
		
		
		for (int j = 0; j < [tmp count]; j++) {
			
			
			
			if ([[tmp objectAtIndex:j] class] == [Player class]) {
				Player *tmpPlayer = [tmp objectAtIndex:j];
				
				if ((tmpPlayer.firstName != nil) && ![tmpPlayer.firstName isEqualToString:@""]) {
					NSString *fullName = tmpPlayer.firstName;
					
					NSArray *names = [fullName componentsSeparatedByString:@" "];
					tmpPlayer.firstName = [names objectAtIndex:0];
					
					tmpPlayer.lastName = @"";
					bool oneBefore = false;
					for (int i = 1; i < [names count]; i++) {
						
						if (oneBefore) {
							tmpPlayer.lastName = [tmpPlayer.lastName stringByAppendingFormat:@" %@", [names objectAtIndex:i]];
						}else {
							tmpPlayer.lastName = [tmpPlayer.lastName stringByAppendingString:[names objectAtIndex:i]];
						}
						oneBefore = true;

					}
				}

				
				[self.potentialMatches addObject:tmpPlayer];
				[self.potentialMatchesTeamName addObject:tmpTeam];
			}
			
			if ([[tmp objectAtIndex:j] class] == [Fan class]) {
				Fan *tmpPlayer = [tmp objectAtIndex:j];
			
				NSString *fullName = tmpPlayer.firstName;
				
				
				NSArray *names = [fullName componentsSeparatedByString:@" "];
				tmpPlayer.firstName = [names objectAtIndex:0];
				

				@try {
					tmpPlayer.lastName = [names objectAtIndex:1];
				}
				@catch (NSException * e) {
					tmpPlayer.lastName = @"";
				}
			
			
								
				[self.potentialMatches addObject:tmpPlayer];
				[self.potentialMatchesTeamName addObject:tmpTeam];

			}
			 
		}
		
		
		
	}
    [pool drain];
}

- (void)didFinish{
	
	
	
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	
	[self.searchBar resignFirstResponder];
	[self becomeFirstResponder];
	if ([self.allMatches count] == 0) {
		self.errorLabel.text = @"No Results Found...";
	}
}




//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
	
	if (!self.bannerIsVisible) {
		self.bannerIsVisible = YES;
		myAd.hidden = NO;
		
		self.searchBar.frame = CGRectMake(0, 50, 320, 44);
		self.searchTableView.frame = CGRectMake(8, 94, 304, 386);
		self.searchActivity.frame = CGRectMake(264, 62, 20, 20);

        [self.view bringSubviewToFront:myAd];
        myAd.frame = CGRectMake(0.0, 0.0, myAd.frame.size.width, myAd.frame.size.height);
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		self.searchBar.frame = CGRectMake(0, 0, 320, 44);
		self.searchTableView.frame = CGRectMake(8, 44, 304, 372);
		self.searchActivity.frame = CGRectMake(264, 12, 20, 20);
	}
	
	
}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
		[actionSheet release];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)viewDidUnload{
	searchBar = nil;
	searchCriteria = nil;
	searchTableView = nil;
	//potentialMatches = nil;
	//allMatches = nil;
	//teamsOnly = nil;
	//potentialMatchesTeamName = nil;
	myAd = nil;
	errorLabel = nil;
	//allMatchesTeamName = nil;
	//error = nil;
	searchActivity = nil;
	[super viewDidUnload];
	
}

-(void)dealloc{
	[searchActivity release];
	[searchBar release];
	[searchCriteria release];
	[searchTableView release];
	[potentialMatches release];
	[allMatches release];
	[teamsOnly release];
	[error release];
	[potentialMatchesTeamName release];
	[allMatchesTeamName release];
	[errorLabel release];
    myAd.delegate = nil;
	[myAd release];
	[super dealloc];
	
}

@end
