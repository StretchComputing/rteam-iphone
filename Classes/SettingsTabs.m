//
//  SettingsTabs.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsTabs.h"
#import "Feedback.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"

#import "ChangePassword.h"
#import "PasswordResetQuestion.h"
#import "AddChangeProfilePic.h"
#import "DeleteMessageFrequency.h"
#import "Game.h"
#import "Practice.h"
#import "Event.h"
#import <EventKit/EventKit.h>
#import "HelpAbout.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation SettingsTabs
@synthesize numMemberTeams, fromRegisterFlow, didRegister, displaySuccess, passwordReset, passwordResetQuestion, haveUserInfo, myTableView, loadingLabel, 
loadingActivity, bannerIsVisible, largeActivity, doneGames, doneEvents, allGames, allEvents, gamesAndEvents, didSynch, synchSuccess, myAd;

-(void)viewWillAppear:(BOOL)animated{
	
    [self.navigationItem setHidesBackButton:YES];
    
    
	if ([self.fromRegisterFlow isEqualToString:@"true"]) {
		
		rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		if (mainDelegate.pushToken != nil) {
			
			NSString *deviceTokenStr = [[[mainDelegate.pushToken description]
										 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] 
										stringByReplacingOccurrencesOfString:@" " 
										withString:@""];
			
			deviceTokenStr = [deviceTokenStr uppercaseString];
			NSDictionary *updateResponse = [ServerAPI updateUser:mainDelegate.token :@"" :@"" :@"" :deviceTokenStr :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :[NSData data] :@"" :@"" :@"" :@"" :@"" :@""];
			NSString *updateStatus = [updateResponse valueForKey:@"status"];
			
			if ([updateStatus isEqualToString:@"100"]) {
				//Log succes
			}else {
				//Failure - Log this as a PUSH TOKEN update failure.
			}
		}
		
		self.fromRegisterFlow = @"false";
		Home *tmp = [[Home alloc] init];
		tmp.didRegister = self.didRegister;
		tmp.numMemberTeams = self.numMemberTeams;
        
        if ((self.numMemberTeams == 0) && ([self.didRegister isEqualToString:@"true"])) {
            //[self performSelectorInBackground:@selector(firstTeam) withObject:nil];
            [self performSelector:@selector(firstTeam)];
        }
        
		UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:nil action:nil];
		self.navigationItem.backBarButtonItem = temp;
		[self.navigationController pushViewController:tmp animated:YES];
		
	}else{
        
        if ([self.myTableView indexPathForSelectedRow]) {        
            [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
        }
        
        if (myAd.bannerLoaded) {
            bannerIsVisible = YES;
            myAd.hidden = NO;
            
            self.myTableView.frame = CGRectMake(0, 50, 320, 366);

        }else{
            bannerIsVisible = NO;
            myAd.hidden = YES;
            self.myTableView.frame = CGRectMake(0, 0, 320, 416);

        }
        
    }
	
	if (self.displaySuccess) {
		//Alert
		self.displaySuccess = false;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Request completed successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}



- (void)viewDidLoad {

    self.title = @"Settings";
    
    //iAds
    myAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
    myAd.delegate = self;
    myAd.hidden = YES;
    [self.view addSubview:myAd];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.myTableView.hidden = YES;
    [self.loadingActivity startAnimating];
    self.loadingLabel.hidden = NO;
    [self performSelectorInBackground:@selector(getUserInfo) withObject:nil];
    
    UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noLogoNoCrowd.png"]];
    
    NSString *ios = [[UIDevice currentDevice] systemVersion];
    if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
        
        self.myTableView.backgroundView = tmp;
        
    }
        
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.navigationItem.rightBarButtonItem = homeButton;
	
}

-(void)home{
	
	Home *tmp = [[Home alloc] init];
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	[self.navigationController pushViewController:tmp animated:YES];
	
}




-(void)getUserInfo{
	
    @autoreleasepool {
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getUserInfo:token :@"false"];
            
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSDictionary *info = [response valueForKey:@"userInfo"];
                
                if ([info valueForKey:@"passwordResetQuestion"] != nil) {
                    self.passwordReset = true;
                    self.passwordResetQuestion = [info valueForKey:@"passwordResetQuestion"];
                }
                
            }else{
                
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
                        //log status code
                        //self.error = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        [self performSelectorOnMainThread:@selector(doneUserInfo) withObject:nil waitUntilDone:NO];

    }
		
}

-(void)doneUserInfo{
	
	self.haveUserInfo = true;
	self.myTableView.hidden = NO;
	[self.myTableView reloadData];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger cellTag = 1;
	static NSInteger segTag = 2;
	static NSInteger feedbackTag = 3;
    
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 22;
		frame.size.width = 250;
		
		
		UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
		cellLabel.tag = cellTag;
		[cell.contentView addSubview:cellLabel];
		
		frame.origin.x = 125;
		frame.size.width = 150;
		UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:frame];
		feedbackLabel.tag = feedbackTag;
		[cell.contentView addSubview:feedbackLabel];
		
		
		frame.size.height = 30;
		frame.origin.y = 9;
		frame.origin.x = 200;
		frame.size.width = 90;
		UISwitch *switchControl = [[UISwitch alloc] initWithFrame:frame];
		switchControl.tag = segTag;
		[cell.contentView addSubview:switchControl];
		
		
	}
	
	UILabel *cellLabel = (UILabel *)[cell.contentView viewWithTag:cellTag];
	UISwitch *switchControl = (UISwitch *)[cell.contentView viewWithTag:segTag];
	
	UILabel *feedbackLabel = (UILabel *)[cell.contentView viewWithTag:feedbackTag];
	
	cellLabel.frame = CGRectMake(10, 10, 275, 22);
    
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	feedbackLabel.hidden = YES;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	switchControl.hidden = YES;
	
	cellLabel.textAlignment = UITextAlignmentLeft;
    
    cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
	if (section == 0) {
		
		
		if (row == 0) {
			
			cellLabel.text = @"Add/Change Profile Picture";
            
		}else if (row == 1) {
			
			cellLabel.text = @"Change Password";
            
			
		}else if (row == 2) {
			
			cellLabel.frame = CGRectMake(10, 10, 275, 22);
			if (self.passwordReset) {
				cellLabel.text = @"Change Password Reset Question";
				
			}else {
				cellLabel.text = @"Add Password Reset Question";
			}
			
		}else if (row == 3) {
			
			cellLabel.text = @"Log Out";
			cell.accessoryType = UITableViewCellAccessoryNone;
			cellLabel.textAlignment = UITextAlignmentCenter;
            
            
		}
        
	}else if (section == 3) {
		if (row == 0) {
			
			cellLabel.text = @"Message Delete Frequency";
		}
        
	}else if (section == 2) {
		if (row == 1) {
			cellLabel.text = @"Auto Sync Events:";
			switchControl.hidden = NO;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}else{
            
            cellLabel.text = @"Sync Events Now";
            
        }
	}else if (section == 1){
        
        if (row == 0) {
            cellLabel.text = @"Feedback";

        }else if (row == 1){
            cellLabel.text = @"Help";

        }else if (row == 2){
            cellLabel.text = @"Rate rTeam!";
        }
    }
	
    cellLabel.backgroundColor = [UIColor clearColor];
	return cell;
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	if (section == 0) {
		
		if (row == 0) {
			
            [TraceSession addEventToSession:@"Settings Page - Add/Change Profile Pic Button Clicked"];

            
			AddChangeProfilePic *tmp = [[AddChangeProfilePic alloc] init];
			[self.navigationController pushViewController:tmp animated:NO];
			
		}else if (row == 1) {
			
            [TraceSession addEventToSession:@"Settings Page - Change Password Button Clicked"];

			ChangePassword *tmp = [[ChangePassword alloc] init];
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 2) {
			
            [TraceSession addEventToSession:@"Settings Page - Password Reset Question Button Clicked"];

			PasswordResetQuestion *tmp = [[PasswordResetQuestion alloc] init];
			tmp.question = self.passwordResetQuestion;
			
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 3) {
			
            [TraceSession addEventToSession:@"Settings Page - Logout Button Clicked"];

            
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Logout"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
            
			//Log Out
			//rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
			mainDelegate.token = @"logout";
			mainDelegate.quickLinkOne = @"";
			mainDelegate.quickLinkTwo = @"";
			mainDelegate.quickLinkOneName = @"";
			mainDelegate.quickLinkTwoName = @"";
			mainDelegate.quickLinkOneImage = @"";
			mainDelegate.quickLinkTwoImage = @"";
			
			[mainDelegate saveUserInfo];
			[self.navigationController popToRootViewControllerAnimated:NO];
		}
		
		
	}else if (section == 3){
        
		if (row == 0) {
			
			DeleteMessageFrequency *tmp = [[DeleteMessageFrequency alloc] init];
			[self.navigationController pushViewController:tmp animated:YES];
            
			
		}else if (row == 1)	{
			
            
            
		}
        
        
	}else if (section == 2){
    
        if (row == 1) {
			
            
            
			
		}else if (row == 0)	{
			
            [TraceSession addEventToSession:@"Settings Page - Sync Events Button Clicked"];

            
            UIActionSheet *synch = [[UIActionSheet alloc] initWithTitle:@"Do you want to sync your rTeam Events to your iPhone Calendar?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
            synch.actionSheetStyle = UIActionSheetStyleDefault;
            [synch showInView:self.view];
            
		}

    
    }else{
        
        if (row == 0) {
            //Feedback
            
            [TraceSession addEventToSession:@"Settings Page - Feedback Button Clicked"];

            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Feedback Selected"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
            
            if ([MFMailComposeViewController canSendMail]) {
                
                MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                mailViewController.mailComposeDelegate = self;
                [mailViewController setToRecipients:[NSArray arrayWithObject:@"feedback@rteam.com"]];
                [mailViewController setSubject:@"rTeam FeedBack"];
                
                [self presentModalViewController:mailViewController animated:YES];
                
            }else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:@"Your device cannot currently send email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }

        }else if (row == 1){
            //Help
            
            [TraceSession addEventToSession:@"Settings Page - Help Button Clicked"];

            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Go to Help Page - From Settings"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
            HelpAbout *tmp = [[HelpAbout alloc] init];
            //NEW HOME
            //[self.navigationController pushViewController:tmp animated:YES];
            
            tmp.fromSettings = true;
            UINavigationController *tmpController = [[UINavigationController alloc] init];
            
            [tmpController pushViewController:tmp animated:NO];
            
            [self.navigationController pushViewController:tmp animated:YES];
        }else{
            //rate
            [TraceSession addEventToSession:@"Settings Page - Rate rTeam Button Clicked"];

            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Rate rTeam"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
            NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
            str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str]; 
            str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
            
            // Here is the app id from itunesconnect
            str = [NSString stringWithFormat:@"%@407424453", str]; 
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
           
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	BOOL success = NO;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//self.displayLabel.text = @"";
			break;
		case MFMailComposeResultSent:
			//self.displayLabel.text = @"Feedback sent successfully!";
			//self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
			success = YES;
			break;
		case MFMailComposeResultFailed:
			//self.displayLabel.text = @"Message Send Failed.";
			//self.displayLabel.textColor = [UIColor redColor];
            
			break;
			
		case MFMailComposeResultSaved:
			//self.displayLabel.text = @"Message Saved.";
			//self.displayLabel.textColor =  [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
			success = YES;
			break;
		default:
			//self.displayLabel.text = @"";
			
			break;
	}
	
	
	[self dismissModalViewControllerAnimated:YES];
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (section == 0) {
		return 4;
	}else if (section == 1){
        return 3;
    }else if (section == 2) {
		return 1;
	}else{
        return 1;
    }
	
}




- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return NO;
	
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	if (section == 0) {
		return @"Account:";
	}else if (section == 1){
        return @"Support:";
    }else if (section == 2) {
		return @"iPhone Calendar Sync:";
	}else {
		return @"Messages:";
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
    
    if (buttonIndex == 0) {
        //Yes
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Synch Events With Calendar"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
        [self.largeActivity startAnimating];
        [self performSelectorInBackground:@selector(getGames) withObject:nil];
        [self performSelectorInBackground:@selector(getEvents) withObject:nil];
    }else if (buttonIndex == 1) {
        
        
        
    }
	
	
	
}

-(void)getGames{
	
	@autoreleasepool {
        NSArray *games = [NSArray array];
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfGames:@"" :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                games = [response valueForKey:@"games"];
                
            }else{
                
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
                        //log status code
                        //self.error = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        self.doneGames = true;
        self.allGames = [NSMutableArray arrayWithArray:games];
        [self performSelectorOnMainThread:@selector(doneCall) withObject:nil waitUntilDone:NO];

    }
	    
	
}



- (void)getEvents {

	@autoreleasepool {
        NSArray *practices = [NSArray array];
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfEvents:@"" :token :@"all"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                practices = [response valueForKey:@"events"];
            }else{
                
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
                        //log response
                        //self.error = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        self.doneEvents = true;
        
        self.allEvents = [NSMutableArray arrayWithArray:practices];	
        
        [self performSelectorOnMainThread:@selector(doneCall) withObject:nil waitUntilDone:NO];

    }
	
}


-(void)doneCall{
    
    if (self.doneGames && self.doneEvents){
        
        self.doneGames = false;
        self.doneEvents = false;
        
        self.gamesAndEvents = [NSMutableArray arrayWithArray:self.allEvents];
        
        for (int i= 0; i < [self.allGames count]; i++) {
            
            Game *tmpGame = [self.allGames objectAtIndex:i];
            
            [self.gamesAndEvents addObject:tmpGame];
        }
        
        if ([self.gamesAndEvents count] > 0){
            [self performSelectorInBackground:@selector(synchEvents) withObject:nil];
        }else{
            
            [self.largeActivity stopAnimating];
            NSString *message = @"You have no current rTeam events to push to your iPhone calendar.";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"No New Events" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert1 show];
        }
        
        
    }
    
}

-(void)synchEvents{
 
    @autoreleasepool {
        
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        [self.gamesAndEvents sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
        NSString *startingDate;
        NSString *endingDate;
        
        //Get the date of first event
        if ([Game class] == [[self.gamesAndEvents objectAtIndex:0] class]) {
            Game *firstEvent = [self.gamesAndEvents objectAtIndex:0];
            startingDate = firstEvent.startDate;
            
        }else if ([Practice class] == [[self.gamesAndEvents objectAtIndex:0] class]){
            
            Practice *firstEvent = [self.gamesAndEvents objectAtIndex:0];
            startingDate = firstEvent.startDate;
            
        }else{
            
            Event *firstEvent = [self.gamesAndEvents objectAtIndex:0];
            startingDate = firstEvent.startDate;
        }
        
        //Get the date of last event
        int count = [self.gamesAndEvents count];
        count--;
        
        if ([Game class] == [[self.gamesAndEvents objectAtIndex:count] class]) {
            Game *firstEvent = [self.gamesAndEvents objectAtIndex:count];
            endingDate = firstEvent.startDate;
            
        }else if ([Practice class] == [[self.gamesAndEvents objectAtIndex:count] class]){
            
            Practice *firstEvent = [self.gamesAndEvents objectAtIndex:count];
            endingDate = firstEvent.startDate;
            
        }else{
            
            Event *firstEvent = [self.gamesAndEvents objectAtIndex:count];
            endingDate = firstEvent.startDate;
        }
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        
        EKCalendar *defaultCalendar = [eventStore defaultCalendarForNewEvents];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
        NSDate *searchStartDate = [dateFormat dateFromString:startingDate];
        NSDate *searchEndDate = [dateFormat dateFromString:endingDate];
        
        searchStartDate = [searchStartDate dateByAddingTimeInterval:-86400];
        searchEndDate = [searchEndDate dateByAddingTimeInterval:86400];
        
        NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:searchStartDate endDate:searchEndDate calendars:calendarArray];
        
        NSArray *eventsFromCalendar = [eventStore eventsMatchingPredicate:predicate];
        
        self.didSynch = false;
        self.synchSuccess = false;
        
        for (int i = 0; i < [self.gamesAndEvents count]; i++) {
            
            if ([Game class] == [[self.gamesAndEvents objectAtIndex:i] class]) {
                Game *firstEvent = [self.gamesAndEvents objectAtIndex:i];
                
                NSString *titleString = [NSString stringWithFormat:@"%@ Game", firstEvent.teamName];
                
                //If this event is already in the calendar, dont add it agian
                bool shouldAdd = true;
                for (int  j= 0; j < [eventsFromCalendar count]; j++) {
                    
                    EKEvent *tmpEKEvent = [eventsFromCalendar objectAtIndex:j];
                    if ([tmpEKEvent.title isEqualToString:titleString]) {
                        
                        NSDate *newDate = [dateFormat dateFromString:firstEvent.startDate];
                        
                        if ([tmpEKEvent.startDate isEqualToDate:newDate]) {
                            shouldAdd = false;
                        }
                    }
                }
                
                if (shouldAdd){
                    
                    self.didSynch = true;
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = titleString;
                    
                    NSDate *tmpStart = [dateFormat dateFromString:firstEvent.startDate];
                    event.startDate = tmpStart;
                    
                    NSString *notesString = @"";
                    if ((firstEvent.opponent != nil) && ![firstEvent.opponent isEqualToString:@""]){
                        notesString = [NSString stringWithFormat:@"Opponent: %@", firstEvent.opponent];
                    }
                    
                    if ((firstEvent.description != nil) && ![firstEvent.description isEqualToString:@""]) {
                        notesString = [notesString stringByAppendingFormat:@"; Description: %@", firstEvent.description];
                    }
                    event.notes = notesString;
                    event.endDate   = [[NSDate alloc] initWithTimeInterval:9000 sinceDate:event.startDate];
                    
                    [event setCalendar:defaultCalendar];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 
                    
                    if (err == nil){
                        self.synchSuccess = true;
                    }
                    
                }
                
                
            }else if ([Practice class] == [[self.gamesAndEvents objectAtIndex:i] class]){
                
                Practice *firstEvent = [self.gamesAndEvents objectAtIndex:i];
                NSString *titleString = [NSString stringWithFormat:@"%@ Practice", firstEvent.teamName];
                
                //If this event is already in the calendar, dont add it agian
                bool shouldAdd = true;
                
                for (int  j= 0; j < [eventsFromCalendar count]; j++) {
                    
                    EKEvent *tmpEKEvent = [eventsFromCalendar objectAtIndex:j];
                    if ([tmpEKEvent.title isEqualToString:titleString]) {
                        
                        NSDate *newDate = [dateFormat dateFromString:firstEvent.startDate];
                        
                        if ([tmpEKEvent.startDate isEqualToDate:newDate]) {
                            shouldAdd = false;
                        }
                    }
                }
                
                if (shouldAdd){
                    
                    self.didSynch = true;
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = titleString;
                    
                    NSDate *tmpStart = [dateFormat dateFromString:firstEvent.startDate];
                    event.startDate = tmpStart;
                    
                    NSString *notesString = @"";
                    if ((firstEvent.location != nil) && ![firstEvent.location isEqualToString:@""]){
                        notesString = [NSString stringWithFormat:@"Location: %@", firstEvent.location];
                    }
                    
                    if ((firstEvent.description != nil) && ![firstEvent.description isEqualToString:@""]) {
                        notesString = [notesString stringByAppendingFormat:@"; Description: %@", firstEvent.description];
                    }
                    event.notes = notesString;
                    event.endDate   = [[NSDate alloc] initWithTimeInterval:9000 sinceDate:event.startDate];
                    
                    [event setCalendar:defaultCalendar];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 
                    
                    if (err == nil){
                        self.synchSuccess = true;
                    }
                    
                }
                
                
            }else{
                
                Event *firstEvent = [self.gamesAndEvents objectAtIndex:i];
                NSString *titleString = [NSString stringWithFormat:@"%@", firstEvent.eventName];
                
                //If this event is already in the calendar, dont add it agian
                bool shouldAdd = true;
                
                for (int  j= 0; j < [eventsFromCalendar count]; j++) {
                    
                    EKEvent *tmpEKEvent = [eventsFromCalendar objectAtIndex:j];
                    if ([tmpEKEvent.title isEqualToString:titleString]) {
                        
                        NSDate *newDate = [dateFormat dateFromString:firstEvent.startDate];
                        
                        if ([tmpEKEvent.startDate isEqualToDate:newDate]) {
                            shouldAdd = false;
                        }
                    }
                }
                
                if (shouldAdd){
                    
                    self.didSynch = true;
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = titleString;
                    
                    NSDate *tmpStart = [dateFormat dateFromString:firstEvent.startDate];
                    event.startDate = tmpStart;
                    
                    NSString *notesString = @"";
                    if ((firstEvent.teamName != nil) && ![firstEvent.teamName isEqualToString:@""]){
                        notesString = [NSString stringWithFormat:@"Team Name: %@", firstEvent.teamName];
                    }
                    
                    if ((firstEvent.location != nil) && ![firstEvent.location isEqualToString:@""]) {
                        notesString = [notesString stringByAppendingFormat:@"; Location: %@", firstEvent.location];
                    }
                    
                    if ((firstEvent.description != nil) && ![firstEvent.description isEqualToString:@""]) {
                        notesString = [notesString stringByAppendingFormat:@"; Description: %@", firstEvent.description];
                    }
                    event.notes = notesString;
                    event.endDate   = [[NSDate alloc] initWithTimeInterval:9000 sinceDate:event.startDate];
                    
                    [event setCalendar:defaultCalendar];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 
                    if (err == nil){
                        self.synchSuccess = true;
                    }
                    
                }
                
            }
            
        }
        
        
        [self performSelectorOnMainThread:@selector(doneSynch) withObject:nil waitUntilDone:NO];

        
    }
    
}

-(void)doneSynch{
    
    [self.largeActivity stopAnimating];
    
    if(!self.didSynch){
        
        NSString *message = @"Your iPhone calendar is currently up to date with all of your rTeam events.";
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"No New Events" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert1 show];
        
    }else{
        
        if (self.synchSuccess) {
            
            NSString *message = @"Your rTeam events were successfully added to your iPhone calendar.";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert1 show];
        }else{
            
            NSString *message = @"An error occurred while trying to add your rTeam events to your iPhone calendar.";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Sync Failed" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert1 show];
            
        }
    }
    
    
}


- (void)firstTeam{
	


        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *useTwitter = @"";
        
        
        
        NSDictionary *results = [ServerAPI createTeam:@"Team 1" :@"" :@"No description entered..." :useTwitter
                                                     :mainDelegate.token :@"No Sport"];
        
        NSString *status = [results valueForKey:@"status"];
	    
        if ([status isEqualToString:@"100"]){
            
            
            if ([mainDelegate.quickLinkOne isEqualToString:@"create"]) {
                
                mainDelegate.quickLinkOne = [results valueForKey:@"teamId"];
                
                
                mainDelegate.quickLinkOneName = @"Team 1";
                mainDelegate.quickLinkOneImage = [@"Basketball" lowercaseString];
                
                [mainDelegate saveUserInfo];
            }
            
        }else{
            
        }
        

    
	
}

-(void)viewDidUnload{
	
    myAd.delegate = nil;
    myAd = nil;
    myTableView = nil;
	loadingActivity = nil;
	loadingLabel = nil;
    largeActivity = nil;
	[super viewDidUnload];
}




@end
