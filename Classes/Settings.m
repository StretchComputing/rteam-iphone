//
//  Settings.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "ChangePassword.h"
#import "Home.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "PasswordResetQuestion.h"
#import "AddChangeProfilePic.h"
#import "DeleteMessageFrequency.h"
#import "Game.h"
#import "Practice.h"
#import "Event.h"
#import <EventKit/EventKit.h>
@implementation Settings
@synthesize passwordReset, passwordResetQuestion, haveUserInfo, myTableView, loadingLabel, loadingActivity, bannerIsVisible, largeActivity,
doneGames, doneEvents, allGames, allEvents, gamesAndEvents, didSynch, synchSuccess;


-(void)viewWillAppear:(BOOL)animated{
        
    if ([self.myTableView indexPathForSelectedRow]) {        
        [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
    } 

}
-(void)viewDidLoad{
  
  
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
}


-(void)getUserInfo{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
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
	[pool drain];
	
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
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 22;
		frame.size.width = 250;
		
		
		UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
		cellLabel.tag = cellTag;
		[cell.contentView addSubview:cellLabel];
		[cellLabel release];
		
		frame.origin.x = 125;
		frame.size.width = 150;
		UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:frame];
		feedbackLabel.tag = feedbackTag;
		[cell.contentView addSubview:feedbackLabel];
		[feedbackLabel release];
		
		
		frame.size.height = 30;
		frame.origin.y = 9;
		frame.origin.x = 200;
		frame.size.width = 90;
		UISwitch *switchControl = [[UISwitch alloc] initWithFrame:frame];
		switchControl.tag = segTag;
		[cell.contentView addSubview:switchControl];
		[switchControl release];
		
		
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

	}else if (section == 2) {
		if (row == 0) {
			
			cellLabel.text = @"Message Delete Frequency";
		}

	}else if (section == 1) {
		if (row == 1) {
			cellLabel.text = @"Auto Sync Events:";
			switchControl.hidden = NO;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}else{
            
            cellLabel.text = @"Sync Events Now";
		
        }
	}
	
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
			
			AddChangeProfilePic *tmp = [[AddChangeProfilePic alloc] init];
			[self.navigationController pushViewController:tmp animated:NO];
			
		}else if (row == 1) {
			
			ChangePassword *tmp = [[ChangePassword alloc] init];
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 2) {
			
			PasswordResetQuestion *tmp = [[PasswordResetQuestion alloc] init];
			tmp.question = self.passwordResetQuestion;
			
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 3) {
			
			//Log Out
			rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
			mainDelegate.token = @"logout";
			mainDelegate.quickLinkOne = @"";
			mainDelegate.quickLinkTwo = @"";
			mainDelegate.quickLinkOneName = @"";
			mainDelegate.quickLinkTwoName = @"";
			mainDelegate.quickLinkOneImage = @"";
			mainDelegate.quickLinkTwoImage = @"";
			
			[mainDelegate saveUserInfo];
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
		
		
	}else if (section == 2){
	
		if (row == 0) {
			
			DeleteMessageFrequency *tmp = [[DeleteMessageFrequency alloc] init];
			[self.navigationController pushViewController:tmp animated:YES];

			
		}else if (row == 1)	{
			
		
						
		}

	
	}else{
        
        if (row == 1) {
			
		
            
			
		}else if (row == 0)	{
			
            UIActionSheet *synch = [[UIActionSheet alloc] initWithTitle:@"Do you want to sync your rTeam Events to your iPhone Calendar?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
            synch.actionSheetStyle = UIActionSheetStyleDefault;
            [synch showInView:self.tabBarController.view];
            [synch release];
            
		}
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (section == 0) {
		return 4;
	}else if (section == 1) {
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
	}else if (section == 1) {
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
		
		self.myTableView.frame = CGRectMake(0, 50, 320, 327);
        
        [self.view bringSubviewToFront:myAd];
        myAd.frame = CGRectMake(0.0, 0.0, myAd.frame.size.width, myAd.frame.size.height);

		
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	
	if (self.bannerIsVisible) {

		myAd.hidden = YES;
		self.bannerIsVisible = NO;
		
		self.myTableView.frame = CGRectMake(0, 0, 320, 367);
		
		
	}
	
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
		
		if (buttonIndex == 0) {
			//Yes
			[self.largeActivity startAnimating];
            [self performSelectorInBackground:@selector(getGames) withObject:nil];
            [self performSelectorInBackground:@selector(getEvents) withObject:nil];
		}else if (buttonIndex == 1) {
			
            
			
		}
	
	
	
}

-(void)getGames{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
    
	
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



- (void)getEvents {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
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
    [pool drain];
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
            [alert1 release];
        }
        
        
    }
    
}

-(void)synchEvents{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);

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
    
    [eventStore release];
    [dateFormat release];
    
    [self performSelectorOnMainThread:@selector(doneSynch) withObject:nil waitUntilDone:NO];
    [pool drain];
}

-(void)doneSynch{
    
    [self.largeActivity stopAnimating];
    
    if(!self.didSynch){
  
        NSString *message = @"Your iPhone calendar is currently up to date with all of your rTeam events.";
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"No New Events" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert1 show];
        [alert1 release];
        
    }else{
        
        if (self.synchSuccess) {
            
            NSString *message = @"Your rTeam events were successfully added to your iPhone calendar.";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert1 show];
            [alert1 release];
        }else{
            
            NSString *message = @"An error occurred while trying to add your rTeam events to your iPhone calendar.";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Sync Failed" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert1 show];
            [alert1 release];
            
        }
    }
    
    
}
-(void)viewDidUnload{
	
	//passwordResetQuestion = nil;
	myTableView = nil;
	loadingActivity = nil;
	loadingLabel = nil;
    largeActivity = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	
	[passwordResetQuestion release];
	[myTableView release];
	[loadingActivity release];
	[loadingLabel release];
    [largeActivity release];
    [allGames release];
    [allEvents release];
	[super dealloc];
	
}
@end
