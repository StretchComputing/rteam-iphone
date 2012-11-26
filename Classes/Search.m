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
#import "EventList.h"
#import "Players.h"
#import "CurrentTeamTabs.h"
#import "GANTracker.h"
#import "TraceSession.h"
#import "GoogleAppEngine.h"

@implementation Search
@synthesize searchBar, searchCriteria, searchTableView, potentialMatches, allMatches, teamsOnly, error, potentialMatchesTeamName, 
allMatchesTeamName, bannerIsVisible, errorLabel, searchActivity, myAd;


-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"Search - View Will Appear"];

    if (myAd.bannerLoaded) {
        myAd.hidden = NO;
        bannerIsVisible = YES;
        
        self.searchBar.frame = CGRectMake(0, 50, 320, 44);
		self.searchTableView.frame = CGRectMake(8, 94, 304, 386);
		self.searchActivity.frame = CGRectMake(264, 62, 20, 20);
        
    }else{
        myAd.hidden = YES;
        bannerIsVisible = NO;
        
        self.searchBar.frame = CGRectMake(0, 0, 320, 44);
		self.searchTableView.frame = CGRectMake(8, 44, 304, 372);
		self.searchActivity.frame = CGRectMake(264, 12, 20, 20);
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
	
	//[self becomeFirstResponder];
    [self.searchBar becomeFirstResponder];

	
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
	myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setLeftBarButtonItem:homeButton];
	
}

-(void)home{
	
    [TraceSession addEventToSession:@"Search Page - Home Button Clicked"];

    
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}


-(void)getListOfTeams{

	@autoreleasepool {
        NSString *token = @"";
        NSArray *teamArray = @[];
        
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
            Team *tmpTeam = (self.potentialMatches)[i];
            
            [self.potentialMatchesTeamName addObject:tmpTeam];
        }
        self.teamsOnly = [NSMutableArray arrayWithArray:teamArray];
        
        [self performSelectorOnMainThread:@selector(doneTeams) withObject:nil waitUntilDone:NO];
    }
	
	
	
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
						
			if ([(self.potentialMatches)[i] class] == [Team class]) {
				//Its a Team
				Team *tmpTeam = (self.potentialMatches)[i];
				NSString *currentResult = tmpTeam.name;
				
				if (currentResult.length > length) {
					
					NSString *substring = [currentResult substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						[self.allMatches addObject:tmpTeam];
						[self.allMatchesTeamName addObject:tmpTeam];
					}
					
				}
				
			}else if ([(self.potentialMatches)[i] class] == [Player class]){
				//Its a Player
				
				Player *tmpPlayer = (self.potentialMatches)[i];
				
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
						[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];

						didAdd = true;
					}
					
				}
				
				NSString *currentLast = tmpPlayer.lastName;
				
				if (currentLast.length > length - 1) {
					
					NSString *substring = [currentLast substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];

							didAdd = true;
						}
					}
					
				}
				
				if (wholeName.length > length - 1) {
					
					NSString *substring = [wholeName substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];

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
							[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];
							
							didAdd = true;
						}
						
					}
					
				}
				
			}else {
				//Fan
				Fan *tmpPlayer = (self.potentialMatches)[i];
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
						[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];

						didAdd = true;
					}
					
				}
				
				NSString *currentLast = tmpPlayer.lastName;
				
				if (currentLast.length > length - 1) {
					
					NSString *substring = [currentLast substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];

							didAdd = true;
						}
					}
					
				}
				
				if (wholeName.length > length - 1) {
					
					NSString *substring = [wholeName substringToIndex:length];
					
					if ([currentText localizedCaseInsensitiveCompare:substring] == 0) {
						if (!didAdd) {
							[self.allMatches addObject:tmpPlayer];
							[self.allMatchesTeamName addObject:(self.potentialMatchesTeamName)[i]];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 9;
		frame.size.height = 22;
		frame.size.width = 170;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		
		frame.origin.x = 180;
		frame.size.width = 103;
		UILabel *teamLabel = [[UILabel alloc] initWithFrame:frame];
		teamLabel.tag = teamTag;
		[cell.contentView addSubview:teamLabel];
	
		
	}
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];
	
	nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
	
	teamLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	teamLabel.textColor = [UIColor grayColor];
	teamLabel.textAlignment = UITextAlignmentCenter;
	teamLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    teamLabel.backgroundColor = [UIColor clearColor];
	
	NSUInteger row = [indexPath row];
	NSString *display = @"";
	NSString *teamDisplay = @"";

	
	if ([(self.allMatches)[row] class] == [Team class]) {
		Team *tmpTeam = (self.allMatches)[row];
		display = tmpTeam.name;
	}else {
		if ([(self.allMatches)[row] class] == [Player class]) {
			Player *tmpPlayer = (self.allMatches)[row];
			if (tmpPlayer.firstName != nil) {
				display = tmpPlayer.firstName;
				if (tmpPlayer.lastName != nil) {
					display = [[tmpPlayer.firstName stringByAppendingFormat:@" "] stringByAppendingString:tmpPlayer.lastName];
					
				}
			}
			
			Team *tmpTeam = (self.allMatchesTeamName)[row];
			teamDisplay = [NSString stringWithFormat:@"(%@)", tmpTeam.name];
		}
		
		if ([(self.allMatches)[row] class] == [Fan class]) {
			Fan *tmpPlayer = (self.allMatches)[row];
			
			if (tmpPlayer.firstName != nil) {
				display = tmpPlayer.firstName;
				if (tmpPlayer.lastName != nil) {
					display = [[tmpPlayer.firstName stringByAppendingFormat:@" "] stringByAppendingString:tmpPlayer.lastName];
					
				}
			}
			
			Team *tmpTeam = (self.allMatchesTeamName)[row];
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
	
    
    @try {
        [TraceSession addEventToSession:@"Search Page - Search Result Clicked"];
        
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Search Result Selected"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        NSUInteger row = [indexPath row];
        if ([(self.allMatches)[row] class] == [Team class]) {
            
            Team *coachTeam = (self.allMatches)[row];
            
            CurrentTeamTabs *tmp = [[CurrentTeamTabs alloc] init];
            
            NSArray *viewControllers = tmp.viewControllers;
            
            tmp.teamId = coachTeam.teamId;
            tmp.teamName = coachTeam.name;
            tmp.userRole = coachTeam.userRole;
            tmp.title = coachTeam.name;
            tmp.sport = coachTeam.sport;
            
            TeamHome *home = viewControllers[0];
            home.teamId = coachTeam.teamId;
            home.userRole = coachTeam.userRole;
            home.teamSport = coachTeam.sport;
            home.teamName = coachTeam.name;
            home.teamUrl = coachTeam.teamUrl;
            
            
            Players *people = viewControllers[1];
            people.teamId = coachTeam.teamId;
            people.userRole = coachTeam.userRole;
            people.teamName = coachTeam.name;
            
            EventList *events = viewControllers[2];
            events.teamId = coachTeam.teamId;
            events.userRole = coachTeam.userRole;
            events.sport = coachTeam.sport;
            events.teamName = coachTeam.name;
            
            
            [self.navigationController pushViewController:tmp animated:YES];
            
            
        }else {
            if ([(self.allMatches)[row] class] == [Player class]) {
                Player *coachTeam = (self.allMatches)[row];
                Team *tmpTeam = (self.allMatchesTeamName)[row];
                coachTeam.headUserRole = tmpTeam.userRole;
                coachTeam.fromSearch = true;
                [self.navigationController pushViewController:coachTeam animated:YES];
            }
            if ([(self.allMatches)[row] class] == [Fan class]) {
                Fan *coachTeam = (self.allMatches)[row];
                Team *tmpTeam = (self.allMatchesTeamName)[row];
                coachTeam.headUserRole = tmpTeam.userRole;
                coachTeam.fromSearch = true;
                [self.navigationController pushViewController:coachTeam animated:YES];
            }
            
        }

    }
    @catch (NSException *exception) {
        [GoogleAppEngine sendClientLog:@"Search.m - didSelectRowAtIndexPath()" logMessage:[exception reason] logLevel:@"exception" exception:exception];
    }
 	
	
}

- (void)runRequest {
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [self.teamsOnly count]; i++) {
            
            Team *tmpTeam = (self.teamsOnly)[i];
            
            NSArray *tmp = @[];
            
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
                
                
                
                if ([tmp[j] class] == [Player class]) {
                    Player *tmpPlayer = tmp[j];
                    
                    if ((tmpPlayer.firstName != nil) && ![tmpPlayer.firstName isEqualToString:@""]) {
                        NSString *fullName = tmpPlayer.firstName;
                        
                        NSArray *names = [fullName componentsSeparatedByString:@" "];
                        tmpPlayer.firstName = names[0];
                        
                        tmpPlayer.lastName = @"";
                        bool oneBefore = false;
                        for (int i = 1; i < [names count]; i++) {
                            
                            if (oneBefore) {
                                tmpPlayer.lastName = [tmpPlayer.lastName stringByAppendingFormat:@" %@", names[i]];
                            }else {
                                tmpPlayer.lastName = [tmpPlayer.lastName stringByAppendingString:names[i]];
                            }
                            oneBefore = true;
                            
                        }
                    }
                    
                    
                    [self.potentialMatches addObject:tmpPlayer];
                    [self.potentialMatchesTeamName addObject:tmpTeam];
                }
                
                if ([tmp[j] class] == [Fan class]) {
                    Fan *tmpPlayer = tmp[j];
                    
                    NSString *fullName = tmpPlayer.firstName;
                    
                    
                    NSArray *names = [fullName componentsSeparatedByString:@" "];
                    tmpPlayer.firstName = names[0];
                    
                    
                    @try {
                        tmpPlayer.lastName = names[1];
                    }
                    @catch (NSException * e) {
                        tmpPlayer.lastName = @"";
                    }
                    
                    
                    
                    [self.potentialMatches addObject:tmpPlayer];
                    [self.potentialMatchesTeamName addObject:tmpTeam];
                    
                }
                
            }
            
            
            
        }

    }
	
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
    myAd.delegate = nil;
	myAd = nil;
	errorLabel = nil;
	searchActivity = nil;
	[super viewDidUnload];
	
}

-(void)dealloc{
    myAd.delegate = nil;
    myAd = nil;
}

@end
