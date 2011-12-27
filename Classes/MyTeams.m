//
//  MyTeams.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyTeams.h"
#import "CreateTeam.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CoachHome.h"
#import "CurrentTeamTabs.h"
#import "TeamNavigation.h"
#import "TeamEdit.h"
#import <iAd/iAd.h>
#import "NewMemberObject.h"
#import "Players.h"
#import "Fans.h"
#import "EventList.h"
#import "TeamHome.h"
#import "FastActionSheet.h"
#import "TraceSession.h"

@implementation MyTeams
@synthesize teams, header, footer, didRegister, deleteRow, teamsStored, numMemberTeams, fanTeams, memberTeams, noFanTeams,
deleteMember, deleteFan, noMemberTeams, error, haveTeamList, homeTeamList, bannerIsVisible, createTeamButton, joinTeamButton, quickCreate,
myTableView, viewLine, myAlertView, phoneOnlyArray, loadingLabel, loadingActivity, gettingTeams, newlyCreatedTeam, allTeamsArray, displayNa, displayError,
fromHome, myAd, alertOne, alertTwo, isDelete;
	
-(void)viewDidAppear:(BOOL)animated{
	
    
    if (self.quickCreate) {
        self.quickCreate = false;
        
        CreateTeam *tmp = [[CreateTeam alloc] init];
        tmp.fromHome = true;
        [self.navigationController pushViewController:tmp animated:NO];
    }else{
        if (([self.fanTeams count] == 0) && ([self.memberTeams count] == 0) && !(self.quickCreate)) {
            
            if (!self.gettingTeams) {
                NSString *tmp = @"If you believe you are on a team, but you do not see it, please make sure you have confirmed your email address by clicking the link in the email we sent you.";
                self.myAlertView = [[UIAlertView alloc] initWithTitle:@"No Teams Found." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                //[self.myAlertView show];
                
            }
            
        }
        
        
        
        [self becomeFirstResponder];
        

    }

}

-(void)viewDidLoad{
	
	//iAds
	myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
	//myAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
	
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setLeftBarButtonItem:homeButton];
    
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(create)];
	[self.navigationItem setRightBarButtonItem:createButton];
	
	
}

-(void)home{
	
    [TraceSession addEventToSession:@"MyTeams Page - Home Button Clicked"];

    
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}


-(void)viewWillAppear:(BOOL)animated{
		
    if (myAd.bannerLoaded) {
        myAd.hidden = NO;
        bannerIsVisible = YES;
        
        self.myTableView.frame = CGRectMake(0, 50, 320, 366);

    }else{
        myAd.hidden = YES;
        bannerIsVisible = NO;
        
        self.myTableView.frame = CGRectMake(0, 0, 320, 416);

    }
    
	[super setEditing:NO animated:NO];
	[self.myTableView setEditing:NO animated:NO];
	
	self.title = @"Teams";
	self.error = @"";
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noLogoNoCrowd.png"]];
    self.myTableView.backgroundView = imageView;
	

	
	self.memberTeams = [NSMutableArray array];
	self.fanTeams = [NSMutableArray array];
	self.allTeamsArray = [NSMutableArray array];
	
	self.haveTeamList = false;
	if (self.haveTeamList) {
		for (int i = 0; i < [self.homeTeamList count]; i++) {
			
			Team *tmpTeam = [self.homeTeamList objectAtIndex:i];
			
			if ([tmpTeam.userRole isEqualToString:@"fan"]) {
				[self.fanTeams addObject:tmpTeam];
			}else {
				[self.memberTeams addObject:tmpTeam];
			}
			
		}
		[self.myTableView reloadData];
		self.haveTeamList = false;
		self.myTableView.hidden =  NO;

	}else {
		self.myTableView.hidden = YES;
		self.gettingTeams = true;
		[self.loadingActivity startAnimating];
		[self performSelectorInBackground:@selector(getAllTeams) withObject:nil];
	}
	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.createTeamButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	self.myTableView.tableHeaderView = nil;
	
	if ([self.phoneOnlyArray count] > 0) {
		bool canText = false;
		
		NSString *ios = [[UIDevice currentDevice] systemVersion];
		
		
		if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
			
			if ([MFMessageComposeViewController canSendText]) {
				
				canText = true;
				
			}
		}else { 
			if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]){
				canText = true;
			}
		}
		
		if (canText) {
			NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Would you like to send them a text right now with information on how to sign up?";
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
			[alert1 show];
		}else {
			NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Please notify them that they must send the text 'yes' to 'join@rteam.com' to sign up.";
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert1 show];
		}
		
		
	}
    
    if (self.displayNa){
        self.displayNa = false;
        NSString *tmp = @"Only User's with confirmed email addresses can add new team members.  To confirm your email, please click on the activation link in the email we sent you.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }else if (self.displayError){
        self.displayError = false;
        NSString *tmp = @"Your team was created, but an error was encountered that prevented one or more of the members you entered from being added to this team.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Member Add Failed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        
    }
	

}




-(void)getAllTeams{

    @autoreleasepool {
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
                
                NSArray *allteams = [response valueForKey:@"teams"];
                
                self.allTeamsArray = [NSMutableArray arrayWithArray:allteams];
                
                for (int i = 0; i < [allteams count]; i++) {
                    
                    Team *tmpTeam = [allteams objectAtIndex:i];
                    
                    if ([tmpTeam.userRole isEqualToString:@"fan"]) {
                        [self.fanTeams addObject:tmpTeam];
                    }else {
                        [self.memberTeams addObject:tmpTeam];
                    }
                    
                }
                
            }else{
                
                self.memberTeams = [NSMutableArray array];
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
            
            
            //get fan teams as well, then order them
            
        }
        
        [self performSelectorOnMainThread:@selector(doneTeams) withObject:nil waitUntilDone:NO];

    }
	
		
}

-(void)doneTeams{
	
	[self.loadingActivity stopAnimating];
	self.loadingLabel.hidden = YES;
	self.myTableView.hidden = NO;
	
	if (([self.fanTeams count] == 0) && ([self.memberTeams count] == 0) && !(self.quickCreate)) {
		
		if (self.gettingTeams) {
			NSString *tmp = @"If you believe you are on a team, but you do not see it, please make sure you have confirmed your email address by clicking the link in the email we sent you.";
			self.myAlertView = [[UIAlertView alloc] initWithTitle:@"No Teams Found." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[self.myAlertView show];
			
		}
		
	}
	
    gettingTeams = false;

	int numTeams = [self.fanTeams count] + [self.memberTeams count];
	if (numTeams > 0) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
		[self.tabBarController.navigationItem setLeftBarButtonItem:addButton];
	}
	
	[self.myTableView reloadData];
}



- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //Code to delete the team goes here
	
	
	self.deleteRow = [indexPath row];
	NSUInteger sec = [indexPath section];
	
	if (sec == 0) {
		self.deleteMember = true;
		self.deleteFan = false;
	}else if (sec == 1) {
		self.deleteFan = true;
		self.deleteMember = false;
	}
	
	[self deleteActionSheet];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (alertView == self.myAlertView) {
		
	}else{
		
		if (buttonIndex == 0) {
			
		}else{
			
			//Text
			@try{
				
				NSMutableArray *numbersToCall = [NSMutableArray array];
				bool call = false;
				
				for (int i = 0; i < [self.phoneOnlyArray count]; i++) {
					
					NSString *numberToCall = @"";
					
					NSString *tmpPhone = [self.phoneOnlyArray objectAtIndex:i];
					
					if ([tmpPhone length] == 16) {
						call = true;
						
						NSRange first3 = NSMakeRange(3, 3);
						NSRange sec3 = NSMakeRange(8, 3);
						NSRange end4 = NSMakeRange(12, 4);
						numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
										[tmpPhone substringWithRange:end4]];
						
					}else if ([tmpPhone length] == 14) {
						call = true;
						
						NSRange first3 = NSMakeRange(1, 3);
						NSRange sec3 = NSMakeRange(6, 3);
						NSRange end4 = NSMakeRange(10, 4);
						numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
										[tmpPhone substringWithRange:end4]];
						
					}else if (([tmpPhone length] == 10) || ([tmpPhone length] == 11)) {
						call = true;
						numberToCall = tmpPhone;
					}
					
					[numbersToCall addObject:numberToCall];
				}
				
				if (call) {
					
					NSString *ios = [[UIDevice currentDevice] systemVersion];
					
					if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
						
						if ([MFMessageComposeViewController canSendText]) {
							
							MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
							messageViewController.messageComposeDelegate = self;
							[messageViewController setRecipients:numbersToCall];
							
							rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

							NSString *addition = @"";
							
							if (![mainDelegate.displayName isEqualToString:@""]) {
								addition = [NSString stringWithFormat:@" by %@", mainDelegate.displayName];
							}
							
                            NSString *teamNameShort = self.newlyCreatedTeam;
                            int strLength = [self.newlyCreatedTeam length];
                            
                            if (strLength > 13){
                                teamNameShort = [[self.newlyCreatedTeam substringToIndex:10] stringByAppendingString:@".."];
                            }
                            
                            NSString *bodyMessage = [NSString stringWithFormat:@"Hi, you have been added via rTeam to the team '%@'. To sign up for our free texting service, send a text to 'join@rteam.com' with the message 'yes'.", teamNameShort];
                            
							[messageViewController setBody:bodyMessage];
							[self presentModalViewController:messageViewController animated:YES];
							
						}
					}else {
						
						NSString *url = [@"sms://" stringByAppendingString:[numbersToCall objectAtIndex:0]];
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
					}
					
					
				}
				
			}@catch (NSException *e) {
				
			}
			
			
		}
		
		self.phoneOnlyArray = [NSMutableArray array];

		
	}
	
	
}



- (void) EditTable:(id)sender{
	
	if(self.editing){
		[super setEditing:NO animated:NO];
		[self.myTableView setEditing:NO animated:NO];
		[self.myTableView reloadData];
		[self.tabBarController.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.tabBarController.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
		
	}else{
		
		[super setEditing:YES animated:YES];
		[self.myTableView setEditing:YES animated:YES];
		[self.myTableView reloadData];
		[self.tabBarController.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.tabBarController.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
		
	}	
}



-(void)create{
	
    [TraceSession addEventToSession:@"MyTeams Page - New Team Button Clicked"];

    
	CreateTeam *nextController = [[CreateTeam alloc] init];
    nextController.fromHome = false;
	[self.navigationController pushViewController:nextController animated:YES];	
	
}

-(void)findTeam{

	
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
	NSUInteger section = [indexPath section];
	
	if (section == 0) {
		if ([self.memberTeams count] == 0) {
			cell.textLabel.text = @"You are not a member of any teams...";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.imageView.image = nil;
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
		}else {
			cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			Team *team = [self.memberTeams objectAtIndex:row];
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
			cell.textLabel.text = team.name;
			
			NSString *theSport = [team.sport lowercaseString];
			
			if ([theSport isEqualToString:@"basketball"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellBasketball.png"];
			}else if ([theSport isEqualToString:@"baseball"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellBaseball.png"];
			}else if ([theSport isEqualToString:@"soccer"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellSoccer.png"];
			}else if ([theSport isEqualToString:@"football"] || [team.sport isEqualToString:@"flag football"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellFootball.png"];
			}else if ([theSport isEqualToString:@"hockey"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellHockey.png"];
			}else if ([theSport isEqualToString:@"lacrosse"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellLacrosse.png"];
			}else if ([theSport isEqualToString:@"tennis"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellTennis.png"];
			}else if ([theSport isEqualToString:@"volleyball"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellVolleyball.png"];
			}else {
				cell.imageView.image = [UIImage imageNamed:@"cellOther.png"];
			}
			
		}
		
		
	}else {
		if ([self.fanTeams count] == 0) {
			cell.textLabel.text = @"You are not a fan of any teams...";
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			cell.imageView.image = nil;
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
		}else {
			cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			Team *team = [self.fanTeams objectAtIndex:row];
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
			cell.textLabel.text = team.name;
			
			
			if ([team.sport isEqualToString:@"Basketball"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellBasketball.png"];
			}else if ([team.sport isEqualToString:@"Baseball"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellBaseball.png"];
			}else if ([team.sport isEqualToString:@"Soccer"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellSoccer.png"];
			}else if ([team.sport isEqualToString:@"Football"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellFootball.png"];
			}else if ([team.sport isEqualToString:@"Hockey"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellHockey.png"];
			}else if ([team.sport isEqualToString:@"Lacrosse"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellLacrosse.png"];
			}else if ([team.sport isEqualToString:@"Tennis"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellTennis.png"];
			}else if ([team.sport isEqualToString:@"Volleyball"]) {
				cell.imageView.image = [UIImage imageNamed:@"cellVolleyball.png"];
			}else if ([team.sport isEqualToString:@"Development"]) {
				cell.imageView.image = [UIImage imageNamed:@"computerCell.png"];
			}else {
				cell.imageView.image = [UIImage imageNamed:@"cellOther.png"];
			}
			
			
		}
	}
	
	
	
	return cell;
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSException *test = [NSException exceptionWithName:@"Test Crash" reason:@"Testing Crash Detect" userInfo:nil];
    @throw test;
    
	//Get the Team from the array, and forward action to the Teams home page
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	if (section == 0) {
        
        [TraceSession addEventToSession:@"MyTeams Page - Member Team Clicked"];

        
		if ([self.memberTeams count] > 0) {
			
			
			Team *coachTeam = [self.memberTeams objectAtIndex:row];
			
			/*
			TeamNavigation *tmp = [[TeamNavigation alloc] init];
			tmp.teamId = coachTeam.teamId;
			tmp.teamName = coachTeam.name;
			tmp.userRole = coachTeam.userRole;
			tmp.sport = coachTeam.sport;
			tmp.teamUrl = coachTeam.teamUrl;

			
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
			
			//TeamActivity *activity = [viewControllers objectAtIndex:1];
			//activity.teamId = coachTeam.teamId;
			//activity.userRole = coachTeam.userRole;
			
			Players *people = [viewControllers objectAtIndex:1];
			people.teamId = coachTeam.teamId;
			people.userRole = coachTeam.userRole;
			people.teamName = coachTeam.name;
			
			EventList *events = [viewControllers objectAtIndex:2];
			events.teamId = coachTeam.teamId;
			events.userRole = coachTeam.userRole;
			events.sport = coachTeam.sport;
			events.teamName = coachTeam.name;
			
			//TeamMessages *message = [viewControllers objectAtIndex:4];
			//message.teamId = coachTeam.teamId;
			//message.userRole = coachTeam.userRole;
			
			
			[self.navigationController pushViewController:tmp animated:YES];
			
			
		}
		
	}else {
        
        [TraceSession addEventToSession:@"MyTeams Page - Fan Team Clicked"];

        
		if ([self.fanTeams count] > 0) {
			
			
			Team *coachTeam = [self.fanTeams objectAtIndex:row];
			
			/*
			TeamNavigation *tmp = [[TeamNavigation alloc] init];
			tmp.teamId = coachTeam.teamId;
			tmp.teamName = coachTeam.name;
			tmp.userRole = coachTeam.userRole;
			tmp.sport = coachTeam.sport;
			tmp.teamUrl = coachTeam.teamUrl;

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
			
			//TeamActivity *activity = [viewControllers objectAtIndex:1];
			///activity.teamId = coachTeam.teamId;
			//activity.userRole = coachTeam.userRole;
			
			Players *people = [viewControllers objectAtIndex:1];
			people.teamId = coachTeam.teamId;
			people.userRole = coachTeam.userRole;
			people.teamName = coachTeam.name;
			
			EventList *events = [viewControllers objectAtIndex:2];
			events.teamId = coachTeam.teamId;
			events.userRole = coachTeam.userRole;
			events.sport = coachTeam.sport;
			events.teamName = coachTeam.name;
			
			//TeamMessages *message = [viewControllers objectAtIndex:4];
			//message.teamId = coachTeam.teamId;
			//message.userRole = coachTeam.userRole;
			
			
			[self.navigationController pushViewController:tmp animated:YES];
			
		}
		
	}
	
	
	
}





- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	
	//go to that game profil
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	
	if (section == 0) {
		Team *tmpTeam = [self.memberTeams objectAtIndex:row];
		
		TeamEdit *tmp = [[TeamEdit alloc] init];
		tmp.teamId = tmpTeam.teamId;
		[self.navigationController pushViewController:tmp animated:YES];
		
	}else {
		
	}
	
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (section == 0) {
		if ([self.memberTeams count] == 0) {
			self.noMemberTeams = true;
			return 1;
		}
		return [self.memberTeams count];
	}else {
		if ([self.fanTeams count] == 0) {
			self.noFanTeams = true;
			return 1;
		}
		return [self.fanTeams count];
	}
	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSUInteger section = [indexPath section];
	
	if (section == 0) {
		if ([self.memberTeams count] == 0) {
			
			return UITableViewCellEditingStyleNone;
			
		}
		
	}else {
		if ([self.fanTeams count] == 0) {
			return UITableViewCellEditingStyleNone;
			
		}
	}
	
	return UITableViewCellEditingStyleDelete;
	
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSUInteger section = [indexPath section];
	
	if (section == 0) {
		if ([self.memberTeams count] == 0) {
			
			return NO;
			
		}
		
	}else {
		if ([self.fanTeams count] == 0) {
			return NO;
			
		}
	}
	
	return YES;
	
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	if (section == 0) {
		return @"Member Of:";
	}else {
		return @"Fan Of:";
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

		self.myTableView.frame = CGRectMake(0, 50, 320, 366);

        [self.view bringSubviewToFront:myAd];
		
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {
		
		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
		
		self.myTableView.frame = CGRectMake(0, 0, 320, 416);
	
		
	}
	
	
}


-(void)deleteActionSheet{
	
    isDelete = true;
	UIActionSheet *deleteNow = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Team" otherButtonTitles:nil];
    deleteNow.actionSheetStyle = UIActionSheetStyleDefault;
    [deleteNow showInView:self.view];
	
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (!self.isDelete){
        [FastActionSheet doAction:self :buttonIndex];

    }else{
        self.isDelete = false;
        
        //"Delete"
        if (buttonIndex == 0) {
            
            NSString *deleteTeamId = @"";
            
            if (self.deleteMember) {
                Team *tmp = [self.memberTeams objectAtIndex:self.deleteRow];
                deleteTeamId = tmp.teamId;
            }else if (self.deleteFan) {
                Team *tmp = [self.fanTeams objectAtIndex:self.deleteRow];;
                deleteTeamId = tmp.teamId;
            }
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *token = @"";
            if (mainDelegate.token != nil){
                token = mainDelegate.token;
            }
            
            if (![token isEqualToString:@""]){
                
                NSDictionary *response = [ServerAPI deleteTeam:deleteTeamId :token];
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
                    if ([mainDelegate.quickLinkOne isEqualToString:deleteTeamId]) {
                        //if this first quick link team was just deleted
                        
                        mainDelegate.quickLinkOne = @"create";
                        mainDelegate.quickLinkOneName = @"";
                        
                        [mainDelegate saveUserInfo];
                    }
                    
                    if ([mainDelegate.quickLinkTwo isEqualToString:deleteTeamId]) {
                        //if the second quick link team was just deleted
                        if ([mainDelegate.quickLinkOne isEqualToString:@"create"]) {
                            mainDelegate.quickLinkTwo = @"";
                            mainDelegate.quickLinkTwoName = @"";
                        }else {
                            //quick 1 is a team, do you
                            mainDelegate.quickLinkTwo = mainDelegate.quickLinkOne;
                            mainDelegate.quickLinkTwoName = mainDelegate.quickLinkOneName;
                            
                            mainDelegate.quickLinkOne = @"create";
                            mainDelegate.quickLinkOneName = @"";
                        }
                        //[self performSelectorInBackground:@selector(updateUserIcons) withObject:nil];
                        [mainDelegate saveUserInfo];
                    }
                    
                    if (self.deleteMember) {
                        for (int i = 0; i < [self.memberTeams count]; i++) {
                            Team *tmp = [self.memberTeams objectAtIndex:i];
                            
                            if ([tmp.teamId isEqualToString:deleteTeamId]) {
                                [self.memberTeams removeObjectAtIndex:i];
                                break;
                            }
                        }
                    }
                    
                    if (self.deleteFan) {
                        for (int i = 0; i < [self.fanTeams count]; i++) {
                            Team *tmp = [self.fanTeams objectAtIndex:i];
                            
                            if ([tmp.teamId isEqualToString:deleteTeamId]) {
                                [self.fanTeams removeObjectAtIndex:i];
                                break;
                            }
                        }
                    }
                    
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    int statusCode = [status intValue];
                    self.memberTeams = [NSMutableArray array];
                    self.fanTeams = [NSMutableArray array];
                    [self performSelectorInBackground:@selector(getAllTeams) withObject:nil];
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            self.error = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            self.error = @"*Error connecting to server";
                            break;
                        case 204:
                            //user not member of specified team
                            self.error = @"*Email address is already in use";
                            break;
                        case 305:
                            //team id required
                            self.error = @"*Error connecting to server";
                            break;
                        case 602:
                            //team not found
                            self.error = @"*Email address and password required";
                            break;
                        default:
                            //should never get here
                            self.error = @"*Error connecting to server";
                            break;
                    }
                }
                
                
            }
            
        }
        [super setEditing:NO animated:NO];
        [self.myTableView setEditing:NO animated:NO];
        [self.tabBarController.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.tabBarController.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.myTableView reloadData];

    }

	
}

-(void)updateUserIcons{

	
	//Retrieve teams from DB
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	//If there is a token, do a DB lookup to find the teams associated with this coach:
	if (![token isEqualToString:@""]){
		
		
		NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :@"" :@"" :mainDelegate.quickLinkOne 
													  :mainDelegate.quickLinkOneName :mainDelegate.quickLinkTwo :mainDelegate.quickLinkTwoName
													  :mainDelegate.quickLinkOneImage :mainDelegate.quickLinkTwoImage :@"" :[NSData data] :@"" :@""
                                  :@"" :@"" :@"" :@""];
		
		NSString *status = [response valueForKey:@"status"];
				
		if ([status isEqualToString:@"100"]){
			
			
		}else{
			
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
		
		
		
		
	}

	
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	NSString *displayString = @"";
	BOOL success = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			displayString = @"";
			break;
		case MessageComposeResultSent:
			displayString = @"Text sent successfully!";
			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString = @"Text send failed.";
			break;
		default:
			displayString = @"Text send failed.";
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	
	
	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}



-(void)viewDidUnload{
	
	header = nil;
	footer = nil;

	alertOne = nil;
	alertTwo = nil;
	createTeamButton = nil;
	joinTeamButton = nil;
    myAd.delegate = nil;
	myAd = nil;
	myTableView = nil;
	viewLine = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	[super viewDidUnload];
	
}
	
@end
