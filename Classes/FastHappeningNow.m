//
//  FastHappeningNow.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastHappeningNow.h"
#import "Player.h"
#import "NewPlayer.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "Game.h"
#import "Gameday.h"
#import "GameTabs.h"
#import "GameAttendance.h"
#import "GameMessages.h"
#import "GameEdit.h"
#import "Practice.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "PracticeEdit.h"
#import "PracticeMessages.h"
#import "GameTabsNoCoord.h"
#import "NewGamePractice.h"
#import "MapLocation.h"
#import "Event.h"
#import "EventTabs.h"
#import "EventNotes.h"
#import "EventMessages.h"
#import "EventAttendance.h"
#import "EventEdit.h"
#import "TeamActivity.h"
#import "Fans.h"
#import "CurrentEvent.h"
#import "Vote.h"
#import "GameChatter.h"
#import "PracticeChatter.h"

@implementation FastHappeningNow
@synthesize events, error, eventActivity, eventActivityLabel, eventsTableView, errorString, loadingActivity, actionRow, largeActivity;


- (void)viewDidLoad {
    self.loadingActivity.hidden = YES;
	self.eventsTableView.dataSource = self;
	self.eventsTableView.delegate = self;
	
	self.eventsTableView.hidden = YES;
	
	[self.eventActivity startAnimating];
	self.eventActivityLabel.hidden = NO;

	self.title = @"Happening Now";
}

-(void)viewWillAppear:(BOOL)animated{
	
	[self.largeActivity startAnimating];
	[self performSelectorInBackground:@selector(getAllEvents) withObject:nil];
	
	
	
}





-(void)getAllEvents{
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	NSString *token = @"";
	NSMutableArray *eventArray = [NSMutableArray array];
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfEventsNow:token];
	
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			NSArray *eventsToday = [response valueForKey:@"eventsToday"];
			NSArray *eventsTomorrow = [response valueForKey:@"eventsTomorrow"];
			
			
			for (int i = 0; i < [eventsToday count]; i++) {
				[eventArray addObject:[eventsToday objectAtIndex:i]];
			}
			
			for (int i = 0; i < [eventsTomorrow count]; i++) {
				[eventArray addObject:[eventsTomorrow objectAtIndex:i]];
			}
			
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
					//Game retrieval failed, log error code?
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	
	
	NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"eventDate" ascending:YES];
	[eventArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	[lastNameSorter release];
	
	self.events = eventArray;
	
	
	[self performSelectorOnMainThread:@selector(finishedEvents) withObject:nil waitUntilDone:NO];
    [pool drain];

}


-(void)finishedEvents{
	
	[self.largeActivity stopAnimating];
	self.eventActivityLabel.hidden = YES;
	self.eventsTableView.hidden = NO;
	[self.eventsTableView reloadData];
	
	
}




- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if ([self.events count] == 0) {
		return 1;
	}
	return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	bool mapIt = false;
	
	CurrentEvent *tmpEvent;
	if ([self.events count] > 0) {
		tmpEvent = [self.events objectAtIndex:row];
		
		
		if (tmpEvent.latitude != nil) {
			mapIt = true;
		}
        
        if (tmpEvent.isCanceled) {
            mapIt = false;
        }
	}
    
    
	
	
	static NSString *noMapCell=@"noMapCell";
	static NSString *mapCell = @"mapCell";
	
	static NSInteger dateTag = 100000;
	static NSInteger oppTag = 200000;
	static NSInteger descTag = 300000;
	static NSInteger typeTag = 400000;
	//static NSInteger mapTag = 5;
	static NSInteger scoreTag = 600000;
	static NSInteger noEventsTag = 800000;
    static NSInteger canceledTag = 900000;

	
	UITableViewCell *cell;
	if (mapIt) {
		cell = [tableView dequeueReusableCellWithIdentifier:mapCell];
	}else {
		cell = [tableView dequeueReusableCellWithIdentifier:noMapCell];
		
	}
	
	
	if (cell == nil){
		
		if (mapIt) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:mapCell] autorelease];
			
		}else {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:noMapCell] autorelease];
			
		}
		
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 300;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		[dateLabel release];
		
		frame.size.height = 17;
		frame.origin.y += 23;
		UILabel *oppLabel = [[UILabel alloc] initWithFrame:frame];
		oppLabel.tag = oppTag;
		[cell.contentView addSubview:oppLabel];
		[oppLabel release];
		
		frame.size.height = 15;
		frame.origin.y += 18;
		UILabel *descLabel = [[UILabel alloc] initWithFrame:frame];
		descLabel.tag = descTag;
		[cell.contentView addSubview:descLabel];
		[descLabel release];
		
		frame.size.height = 15;
		frame.origin.y = 5;
		frame.origin.x = 200;
		frame.size.width = 75;
		UILabel *typeLabel = [[UILabel alloc] initWithFrame:frame];
		typeLabel.tag = typeTag;
		[cell.contentView addSubview:typeLabel];
		[typeLabel release];
		
		
		//[cell.contentView bringSubviewToFront:mapButton];
		
		frame.origin.x = 10;
		frame.origin.y = 65;
		frame.size.height = 15;
		frame.size.width = 100;	
		UILabel *scoreLabel = [[UILabel alloc] initWithFrame:frame];
		scoreLabel.tag = scoreTag;
		[cell.contentView addSubview:scoreLabel];
		[scoreLabel release];
		
		
		frame.origin.x = 10;
		frame.origin.y = 30;
		frame.size.height = 20;
		frame.size.width = 300;	
		UILabel *noEventsLabel = [[UILabel alloc] initWithFrame:frame];
		noEventsLabel.tag = noEventsTag;
		[cell.contentView addSubview:noEventsLabel];
		[noEventsLabel release];
        
        frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 80;
		frame.size.width = 320;	
		UILabel *canceledLabel = [[UILabel alloc] initWithFrame:frame];
		canceledLabel.tag = canceledTag;
		[cell.contentView addSubview:canceledLabel];
		[canceledLabel release];
		
		
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	dateLabel.backgroundColor = [UIColor clearColor];
	UILabel *oppLabel = (UILabel *)[cell.contentView viewWithTag:oppTag];
	oppLabel.backgroundColor = [UIColor clearColor];
	UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:descTag];
	descLabel.backgroundColor = [UIColor clearColor];
	UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
	typeLabel.backgroundColor = [UIColor clearColor];
	UILabel *scoreLabel = (UILabel *)[cell.contentView viewWithTag:scoreTag];
	scoreLabel.backgroundColor = [UIColor clearColor];
	UIButton *mapButton;
	
	UILabel *noEventsLabel = (UILabel *)[cell.contentView viewWithTag:noEventsTag];
	noEventsLabel.hidden = YES;
	noEventsLabel.textColor = [UIColor blackColor];
	noEventsLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
	noEventsLabel.text = @"No Upcoming Events...";
	noEventsLabel.textAlignment = UITextAlignmentCenter;
	noEventsLabel.backgroundColor = [UIColor clearColor];
	
    UILabel *canceledLabel = (UILabel *)[cell.contentView viewWithTag:canceledTag];
	
	
	canceledLabel.text = @"CANCELED";
	canceledLabel.textColor = [UIColor colorWithRed:190.0/255.0 green:0.0 blue:0.0 alpha:.90];
	canceledLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:40];
	canceledLabel.textAlignment = UITextAlignmentCenter;
	canceledLabel.backgroundColor = [UIColor clearColor];
	canceledLabel.hidden = YES;
    
	if (mapIt) {
		mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		mapButton.frame = CGRectMake(210, 30, 80, 30);
		mapButton.tag = row;
		[mapButton setTitle:@"View Map" forState:UIControlStateNormal];
		[mapButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
		[mapButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:mapButton];
	}
	
	
	
	
	scoreLabel.textColor = [UIColor greenColor];
	scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	oppLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	descLabel.textColor = [UIColor darkGrayColor];
	descLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	typeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	typeLabel.textColor = [UIColor blueColor];
	typeLabel.textAlignment = UITextAlignmentCenter;
	
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    
	if ([self.events count] == 0) {
		
		noEventsLabel.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
	}else {
		//Configure the cell
		if ([tmpEvent.eventType isEqualToString:@"game"]) {
			
			typeLabel.text = @"Game";
			
			//format the start date (coming back as YYYY-MM-DD hh:mm)
			NSString *date = tmpEvent.eventDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];	
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"MMM dd, hh:mm aa"];
			
			NSString *startDateString = [format stringFromDate:formatedDate];
			
			
			dateLabel.text = startDateString;
			[dateFormat release];
			[format release];
			//retrieve the opponent
			
			oppLabel.text = [@"vs. " stringByAppendingString:tmpEvent.opponent];
			//oppLabel.text = @"";
			
			//set description
			
			descLabel.text = tmpEvent.eventDescription;
			
			//Map info
			if(mapIt){
				mapButton.tag = row;
			}
			
			//Scoring info
			if (tmpEvent.gameInterval != nil && !tmpEvent.isCanceled) {
				
				if (![tmpEvent.gameInterval isEqualToString:@"0"]) {
					
					
					if ([tmpEvent.gameInterval isEqualToString:@"-1"]) {
						//Game over
						int scoreUs = [tmpEvent.scoreUs intValue];
						int scoreThem = [tmpEvent.scoreThem intValue];
						//int scoreUs = 0;
						//int scoreThem = 0;
						
						NSString *result = @"";
						
						if (scoreUs > scoreThem) {
							result = @"W";
							scoreLabel.textColor = [UIColor colorWithRed:.34 green:.55 blue:.34 alpha:1.0];
							scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
							
						}else if (scoreUs < scoreThem) {
							result = @"L";
							scoreLabel.textColor = [UIColor redColor];
						}else {
							result = @"T";
							scoreLabel.textColor = [UIColor colorWithRed:.34 green:.55 blue:.34 alpha:1.0];
							scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
						}
						
						scoreLabel.text = [NSString stringWithFormat:@"%@ %@-%@", result, tmpEvent.scoreUs, tmpEvent.scoreThem];
						scoreLabel.text = @"";
					}else {
						//Game in progress
						//scoreLabel.textColor = [UIColor colorWithRed:.412 green:.412 blue:.412 alpha:1.0];
						scoreLabel.textColor = [UIColor blueColor];
						
						NSString *time = @"";
						int interval = [tmpEvent.gameInterval intValue];
						
						if (interval == 1) {
							time = @"1st";
						}
						
						if (interval == 2) {
							time = @"2nd";
						}
						
						if (interval == 3) {
							time = @"3rd";
						}
						
						if (interval >= 4) {
							time = [NSString stringWithFormat:@"%@th", tmpEvent.gameInterval];
						}
						
						if (interval == -2) {
							time = @"OT";
						}
						
						
						if (interval == -3) {
							time = @"";
						}
						
						
						scoreLabel.text = [NSString stringWithFormat:@"%@-%@ %@", tmpEvent.scoreUs, tmpEvent.scoreThem, time];
						scoreLabel.text = @"";
					}
					
				}
			}
            
            if (tmpEvent.isCanceled) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			
			
		}else if ([tmpEvent.eventType isEqualToString:@"practice"]) {
			
            if (tmpEvent.isCanceled) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
            
			[scoreLabel setHidden:YES];
			typeLabel.text = @"Practice";
			
			//format the start date (coming back as YYYY-MM-DD hh:mm)
			NSString *date = tmpEvent.eventDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];
			
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"MMM dd, hh:mm aa"];
			
			NSString *startDateString = [format stringFromDate:formatedDate];
			
			if(mapIt){
				mapButton.tag = row;
			}
			
			dateLabel.text = startDateString;
			[dateFormat release];
			[format release];
			//retrieve the opponent
			
			oppLabel.text = [@"at " stringByAppendingString:tmpEvent.opponent];
			//oppLabel.text = @"at Location";
			
			//set description
			
			descLabel.text = tmpEvent.eventDescription;
			
			
		}else if ([tmpEvent.eventType isEqualToString:@"generic"]) {
			
            if (tmpEvent.isCanceled) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
            
			[scoreLabel setHidden:YES];
			typeLabel.text = @"Event";
			
			//format the start date (coming back as YYYY-MM-DD hh:mm)
			NSString *date = tmpEvent.eventDate;
			
			if(mapIt){
				mapButton.tag = row;
			}
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];
			
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"MMM dd, hh:mm aa"];
			
			NSString *startDateString = [format stringFromDate:formatedDate];
			
			
			dateLabel.text = startDateString;
			[dateFormat release];
			[format release];
			
			
			oppLabel.text = tmpEvent.eventName;
			descLabel.text = [@"at " stringByAppendingString:tmpEvent.opponent];
			//descLabel.text = @"at Location";
			
			
		}
		
	}

		
	if (row % 2 != 0) {
		cell.contentView.backgroundColor = [UIColor whiteColor];
		cell.accessoryView.backgroundColor = [UIColor whiteColor];
		cell.backgroundView = [[[UIView alloc] init] autorelease]; 
		cell.backgroundView.backgroundColor = [UIColor whiteColor];
		
	}else {
		UIColor *tmpColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
		cell.contentView.backgroundColor = tmpColor;
		cell.accessoryView.backgroundColor = tmpColor;
		
		cell.backgroundView = [[[UIView alloc] init] autorelease]; 
		cell.backgroundView.backgroundColor = tmpColor;
	}
	
	
	return cell;
}

-(void)viewMap:(id)sender{
	
	UIButton *tmp = (UIButton *)sender;
	
	int row = tmp.tag;
	
	CurrentEvent *tmpEvent = [self.events objectAtIndex:row];
	
	MapLocation *next = [[MapLocation alloc] init];
	next.eventLatCoord = [tmpEvent.latitude doubleValue];
	next.eventLongCoord = [tmpEvent.longitude doubleValue];
	[self.navigationController pushViewController:next animated:YES];
}







//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//go to that game profile
	
	NSUInteger row = [indexPath row];
	
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Events" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	
	CurrentEvent *tmpEvent = [self.events objectAtIndex:row];
	NSString *teamId = tmpEvent.teamId;
	NSString *eventId = tmpEvent.eventId;
	NSString *teamName = tmpEvent.teamName;
	NSString *userRole = tmpEvent.participantRole;
	NSString *eventDate = tmpEvent.eventDate;
	NSString *sport = tmpEvent.sport;
	NSString *description = tmpEvent.eventDescription;
	
    if (!tmpEvent.isCanceled){
        
        if ([tmpEvent.eventType isEqualToString:@"game"]) {
            
            
            if ([userRole isEqualToString:@"creator"] || [userRole isEqualToString:@"coordinator"]) {
                GameTabs *currentGameTab = [[GameTabs alloc] init];
                NSArray *viewControllers = currentGameTab.viewControllers;
                currentGameTab.teamId = teamId;
                currentGameTab.gameId = eventId;
                currentGameTab.userRole = userRole;
                currentGameTab.teamName = teamName;
                
                Gameday *currentNotes = [viewControllers objectAtIndex:0];
                currentNotes.gameId = eventId;
                currentNotes.teamId = teamId;
                currentNotes.userRole = userRole;
                currentNotes.sport = sport;
                currentNotes.description = description;
                currentNotes.startDate = eventDate;
                currentNotes.opponentString = @"";
                
                
                GameAttendance *currentAttendance = [viewControllers objectAtIndex:2];
                currentAttendance.gameId = eventId;
                currentAttendance.teamId = teamId;
                currentAttendance.startDate = eventDate;
                
                GameChatter *messages = [viewControllers objectAtIndex:1];
                messages.gameId = eventId;
                messages.teamId = teamId;
                messages.userRole = userRole;
                messages.startDate = eventDate;
                
                
                Vote *fans = [viewControllers objectAtIndex:3];
                fans.teamId = teamId;
                fans.userRole = userRole;
                fans.gameId = eventId;
                
                
                [self.navigationController pushViewController:currentGameTab animated:YES];
                
            }else {
                
                GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
                NSArray *viewControllers = currentGameTab.viewControllers;
                currentGameTab.teamId = teamId;
                currentGameTab.gameId = eventId;
                currentGameTab.userRole = userRole;
                currentGameTab.teamName = teamName;
                
                
                Gameday *currentNotes = [viewControllers objectAtIndex:0];
                currentNotes.gameId = eventId;
                currentNotes.teamId = teamId;
                currentNotes.userRole = userRole;
                currentNotes.sport = sport;
                currentNotes.description = description;
                currentNotes.startDate = eventDate;
                currentNotes.opponentString = @"";
                
                
                GameChatter *messages = [viewControllers objectAtIndex:1];
                messages.gameId = eventId;
                messages.teamId = teamId;
                messages.userRole = userRole;
                messages.startDate = eventDate;
                
                Vote *fans = [viewControllers objectAtIndex:2];
                fans.teamId = tmpEvent.teamId;
                fans.userRole = tmpEvent.participantRole;
                fans.gameId = tmpEvent.eventId;
                
                
                [self.navigationController pushViewController:currentGameTab animated:YES];
                
            }
            
            
        }else if ([tmpEvent.eventType isEqualToString:@"practice"]) {
            
            PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
            
            NSArray *viewControllers = currentPracticeTab.viewControllers;
            currentPracticeTab.teamId = teamId;
            currentPracticeTab.practiceId = eventId;
            currentPracticeTab.userRole = userRole;
            
            PracticeNotes *currentNotes = [viewControllers objectAtIndex:0];
            currentNotes.practiceId = eventId;
            currentNotes.teamId = teamId;
            currentNotes.userRole = userRole;
            
            PracticeAttendance *currentAttendance = [viewControllers objectAtIndex:1];
            currentAttendance.practiceId = eventId;
            currentAttendance.teamId = teamId;
            currentAttendance.startDate = eventDate;
            currentAttendance.userRole = userRole;
            
            PracticeChatter *messages = [viewControllers objectAtIndex:2];
            messages.teamId = teamId;
            messages.practiceId = eventId;
            messages.userRole = userRole;
            messages.startDate = eventDate;
            
            
            [self.navigationController pushViewController:currentPracticeTab animated:YES];
        }else if ([tmpEvent.eventType isEqualToString:@"generic"]) {
            
            EventTabs *currentPracticeTab = [[EventTabs alloc] init];
            
            NSArray *viewControllers = currentPracticeTab.viewControllers;
            currentPracticeTab.teamId = teamId;
            currentPracticeTab.eventId = eventId;
            currentPracticeTab.userRole = userRole;
            
            EventNotes *currentNotes = [viewControllers objectAtIndex:0];
            currentNotes.eventId = eventId;
            currentNotes.teamId = teamId;
            currentNotes.userRole = userRole;
            
            
            EventAttendance *currentAttendance = [viewControllers objectAtIndex:1];
            currentAttendance.eventId = eventId;
            currentAttendance.teamId = teamId;
            currentAttendance.startDate = eventDate;
            currentAttendance.userRole = userRole;
            
            [self.navigationController pushViewController:currentPracticeTab animated:YES];
        }

    
    }else{
        
        if ([tmpEvent.participantRole isEqualToString:@"coordinator"] || [tmpEvent.participantRole isEqualToString:@"creator"]) {
            
            self.actionRow = row;
            
            UIActionSheet *tmpAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
            tmpAction.actionSheetStyle = UIActionSheetStyleDefault;
            [tmpAction showInView:self.view];
            [tmpAction release];
            
            
        }
        
        
    }
		
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	
		
		if (buttonIndex == 1) {
			//Undo cancel
			
			[self.largeActivity startAnimating];
			[self performSelectorInBackground:@selector(activateEvent) withObject:nil];			
			
		}else if (buttonIndex == 0) {
			[self.largeActivity startAnimating];
            
			[self performSelectorInBackground:@selector(deleteEvent) withObject:nil];
			
		}else {
			
		}
        
	
	
	
	
}


-(void)deleteEvent{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	//Delete Event
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
    CurrentEvent *tmpEvent = [self.events objectAtIndex:self.actionRow];
    
	if ([tmpEvent.eventType isEqualToString:@"game"]) {
		
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI deleteGame:token :tmpEvent.teamId :tmpEvent.eventId];
			
			NSString *status = [response valueForKey:@"status"];
            
			if ([status isEqualToString:@"100"]){
				
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						//null parameter
						//self.error.text = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						//self.error.text = @"*Error connecting to server";
						break;
					default:
						//log status code
						//self.error.text = @"*Error connecting to server";
						break;
				}
			}
			
			
		}
		
	}else{
		
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI deleteEvent:token :tmpEvent.teamId :tmpEvent.eventId];
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						//null parameter
						//self.error.text = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						//self.error.text = @"*Error connecting to server";
						break;
					default:
						//log status code
						//self.error.text = @"*Error connecting to server";
						break;
				}
			}
		}
	}
    
	
	
	[self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];
	[pool drain];
}



-(void)activateEvent{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
    CurrentEvent *tmpEvent = [self.events objectAtIndex:self.actionRow];
    
	if ([tmpEvent.eventType isEqualToString:@"game"]) {
		
		if (![token isEqualToString:@""]){
            
			NSDictionary *response = [ServerAPI updateGame:token :tmpEvent.teamId :tmpEvent.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"0" :@"" :@"" :@""];
			
			
			NSString *status = [response valueForKey:@"status"];
			
			
			if ([status isEqualToString:@"100"]){
				
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						//null parameter
						//self.error.text = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						//self.error.text = @"*Error connecting to server";
						break;
					default:
						//log status code
						//self.error.text = @"*Error connecting to server";
						break;
				}
			}
			
			
		}
		
	}else{
		
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI updateEvent:token :tmpEvent.teamId :tmpEvent.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						//null parameter
						//self.error.text = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						///self.error.text = @"*Error connecting to server";
						break;
					default:
						//log status code
						//self.error.text = @"*Error connecting to server";
						break;
				}
			}
		}
	}
	
	[self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];
	[pool drain];
	
}

-(void)doneEventEdit{
	
	[self performSelectorInBackground:@selector(getAllEvents) withObject:nil];
	
}

- (void)viewDidUnload {
	//events = nil;
	//errorString = nil;
	error = nil;
	eventActivity = nil;
	eventActivityLabel = nil;
	loadingActivity = nil;
    largeActivity = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[events release];
	[errorString release];
	[error release];
	[eventActivity release];
	[eventActivityLabel release];
	[loadingActivity release];
    [largeActivity release];
	[super dealloc];
}

@end