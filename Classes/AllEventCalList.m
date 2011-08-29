//
//  AllEventCalList.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AllEventCalList.h"
#import "Game.h"
#import "Practice.h"
#import "GameAttendance.h"
#import "Fans.h"
#import "Gameday.h"
#import "GameMessages.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "PracticeMessages.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "AllEventsCalendar.h"
#import "Event.h"
#import "EventTabs.h"
#import "EventNotes.h"
#import "EventMessages.h"
#import "EventAttendance.h"
#import "TeamActivity.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"
#import "Vote.h"
#import "GameChatter.h"
#import "PracticeChatter.h"
#import "ServerAPI.h"
#import <EventKit/EventKit.h>

@implementation AllEventCalList
@synthesize events, allGames, allPractices, allEvents, bottomBar, segmentedControl, initialSegment, dateArray, calendarList, scrolledOnce,
canceledAction, cancelRow, deleteActivity, cancelSection, gameIdCanceled, practiceIdCanceled, eventIdCanceled, isCancel;

-(void)viewDidAppear:(BOOL)animated{
	
	if (!self.scrolledOnce) {
		[self scrollToCurrent];
		self.scrolledOnce = true;
	}
	[self becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{

	self.calendarList.delegate = self;
	self.calendarList.dataSource = self;
	[self.navigationController.view addSubview:self.bottomBar];
	
	[self buildDateArray];


	
	
	//Hand a Game that was just canceled
	if (![self.gameIdCanceled isEqualToString:@""]) {
		
		NSMutableArray *gamesMutable = [NSMutableArray arrayWithArray:self.allGames];
		for (int i = 0; i < [gamesMutable count]; i++) {
			
			Game *tmpGame = [gamesMutable objectAtIndex:i];
			if ([tmpGame.gameId isEqualToString:self.gameIdCanceled]) {
				
				if (self.isCancel) {
					tmpGame.interval = @"-4";
					
					[gamesMutable replaceObjectAtIndex:i withObject:tmpGame];
				}else {
					[gamesMutable removeObjectAtIndex:i];
				}

				
			}
		}
		self.allGames = [NSArray arrayWithArray:gamesMutable];
		
		NSMutableArray *eventsMutable = [NSMutableArray arrayWithArray:self.allEvents];
		for (int i = 0; i < [eventsMutable count]; i++) {
			
			if ([Game class] == [[eventsMutable objectAtIndex:i] class]) {
				
				Game *tmpGame = [eventsMutable objectAtIndex:i];
				if ([tmpGame.gameId isEqualToString:self.gameIdCanceled]) {
					
					if (self.isCancel) {
						tmpGame.interval = @"-4";
						
						[eventsMutable replaceObjectAtIndex:i withObject:tmpGame];
					}else {
						[eventsMutable removeObjectAtIndex:i];
					}

					
				}
			}
			
		}
		self.allEvents = [NSArray arrayWithArray:eventsMutable];
		
		
		if (self.segmentedControl.selectedSegmentIndex == 0) {
			//Games
			self.events = self.allGames;
		}else {
			//Events
			self.events = self.allEvents;
		}

		self.gameIdCanceled = @"";
		[self buildDateArray];
		[self.calendarList reloadData];
		[self scrollToCurrent];
	}
	
	
	//Handle a practice that was just canceled
	if (![self.practiceIdCanceled isEqualToString:@""]) {
		
		NSMutableArray *practicesMutable = [NSMutableArray arrayWithArray:self.allPractices];
		for (int i = 0; i < [practicesMutable count]; i++) {
			
			Practice *tmpPractice = [practicesMutable objectAtIndex:i];
			if ([tmpPractice.practiceId isEqualToString:self.practiceIdCanceled]) {
				
				if (self.isCancel) {
					tmpPractice.isCanceled = true;
					
					[practicesMutable replaceObjectAtIndex:i withObject:tmpPractice];
				}else {
					[practicesMutable removeObjectAtIndex:i];
				}
				
				
			}
		}
		self.allPractices = [NSArray arrayWithArray:practicesMutable];
		
		NSMutableArray *eventsMutable = [NSMutableArray arrayWithArray:self.allEvents];
		for (int i = 0; i < [eventsMutable count]; i++) {
			
			if ([Practice class] == [[eventsMutable objectAtIndex:i] class]) {
				
				Practice *tmpPractice = [eventsMutable objectAtIndex:i];
				if ([tmpPractice.practiceId isEqualToString:self.practiceIdCanceled]) {
					
					if (self.isCancel) {
						tmpPractice.isCanceled = true;
						
						[eventsMutable replaceObjectAtIndex:i withObject:tmpPractice];
					}else {
						[eventsMutable removeObjectAtIndex:i];
					}
					
					
				}
			}
			
		}
		self.allEvents = [NSArray arrayWithArray:eventsMutable];
		
		
		if (self.segmentedControl.selectedSegmentIndex == 1) {
			//Games
			self.events = self.allPractices;
		}else {
			//Events
			self.events = self.allEvents;
		}
		
		self.practiceIdCanceled = @"";
		[self buildDateArray];
		[self.calendarList reloadData];
		[self scrollToCurrent];
	}
	
	
	if (![self.eventIdCanceled isEqualToString:@""]) {
		
		
		NSMutableArray *eventsMutable = [NSMutableArray arrayWithArray:self.allEvents];
		for (int i = 0; i < [eventsMutable count]; i++) {
			
			if ([Event class] == [[eventsMutable objectAtIndex:i] class]) {
				
				Event *tmpEvent = [eventsMutable objectAtIndex:i];
				if ([tmpEvent.eventId isEqualToString:self.eventIdCanceled]) {
					
					if (self.isCancel) {
						tmpEvent.isCanceled = true;
						
						[eventsMutable replaceObjectAtIndex:i withObject:tmpEvent];
					}else {
						[eventsMutable removeObjectAtIndex:i];
					}
					
					
				}
			}
			
		}
		self.allEvents = [NSArray arrayWithArray:eventsMutable];
		
		
	
		self.events = self.allEvents;
		
		
		self.eventIdCanceled = @"";
		[self buildDateArray];
		[self.calendarList reloadData];
		[self scrollToCurrent];
	}
	
	
}

-(void)goHome{
	
	//Then go to the coaches home
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 3;
	[self.bottomBar removeFromSuperview];

	Home *cont = [temp objectAtIndex:num];
	[self.navigationController popToViewController:cont animated:YES];
	
	
}



-(void)home{
	
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
   // EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    /*
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = @"rTeam Event";
    
    event.startDate = [NSDate date];
    event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err]; 
    
	NSLog(@"Event Identifier: %@", event.eventIdentifier);
     */
    
    //EKEvent *tmpEvent = [eventStore eventWithIdentifier:@"BFA21712-76D6-4A31-8327-6i7657657865678291:AC1A1A6F-AB9C-4233-B494-DB33DA34C7C4"];
    
        
}


-(void)viewDidLoad{
	
	//self.title = @"Events Calendar";
	
	[self.navigationItem setHidesBackButton:YES];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Month" style:UIBarButtonItemStyleBordered target:self action:@selector(month)];
	[self.navigationItem setLeftBarButtonItem:addButton];
	[addButton release];
	
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	[homeButton release];
	
	self.bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 440, 320, 40)];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	NSArray *segments = [NSArray arrayWithObjects:@"Games", @"Practices", @"All", nil];
	
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
	self.segmentedControl.frame = CGRectMake(25, 3, 250, 30);
	self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.segmentedControl.selectedSegmentIndex = self.initialSegment;
	[self.segmentedControl addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
    UIBarButtonItem *tmp = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
	
	
	
	NSArray *items1 = [NSArray arrayWithObjects:flexibleSpace, tmp, flexibleSpace, nil];
	self.bottomBar.items = items1;
	[tmp release];
	
	[self.navigationController.view addSubview:self.bottomBar];
	//[self.superview bringSubviewToFront:self.bottomBar];
	

}

-(void)segmentSelect:(id)sender{
	
	int selection = [self.segmentedControl selectedSegmentIndex];
	
	switch (selection) {
		case 0:
			self.title = @"Game List";
			self.events = self.allGames;
			self.segmentedControl.selectedSegmentIndex = 0;
			break;
		case 1:
			self.title = @"Practice List";
			self.events = self.allPractices;
			self.segmentedControl.selectedSegmentIndex = 1;
			break;
		case 2:
			self.title = @"Event List";
			self.events = self.allEvents;
			self.segmentedControl.selectedSegmentIndex = 2;
			break;
		default:
			break;
	}
	
	[self buildDateArray];
	[self.calendarList reloadData];
	
	[self scrollToCurrent];

}

-(void)scrollToCurrent{
	
	/*
	 If all dates are in the past
	 - 
	 
	 If both past and present
	 - scroll to "today", or next day in the future
	 
	 If all dates are in the future
	 - dont scroll, stay at top
	 
	 */
	
	bool pastDates = false;
	bool futureDates = false;
	bool todayDates = false;
	
	int todaySection;
	int scrollSection;
	
	
	for (int i = 0; i < [self.dateArray count]; i++) {
		
		NSArray *tmpArray = [self.dateArray objectAtIndex:i];
		
		NSString *cellDate = @"";

		
		if ([[tmpArray objectAtIndex:0] class] == [Game class]) {
			Game *tmpGame = [tmpArray objectAtIndex:0];
			cellDate = tmpGame.startDate;
		}else if ([[tmpArray objectAtIndex:0] class] == [Practice class]) {
			Practice *tmpGame = [tmpArray objectAtIndex:0];
			cellDate = tmpGame.startDate;
		}else if ([[tmpArray objectAtIndex:0] class] == [Event class]) {
			Event *tmpGame = [tmpArray objectAtIndex:0];
			cellDate = tmpGame.startDate;
		}
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *eventDate = [dateFormat dateFromString:cellDate];
		NSDate *todaysDate = [NSDate date];
		
		[dateFormat setDateFormat:@"yyyyMMdd"];
		
		NSString *stringEvent = [dateFormat stringFromDate:eventDate];
		NSString *stringToday = [dateFormat stringFromDate:todaysDate];
		

		
		NSDate *realEvent = [dateFormat dateFromString:stringEvent];
		NSDate *realToday = [dateFormat dateFromString:stringToday];
		
        [dateFormat release];

		if ([stringToday isEqualToString:stringEvent]) {
			//Dates are equal, scroll to this section
			todayDates = true;
			todaySection = i;
			break;
		}else if ([realEvent isEqualToDate:[realToday earlierDate:realEvent]]) {
			//Event is in the past
			pastDates = true;
		}else {
			//event is in the future
			if (!futureDates) {
				//If futureDates is false, then this is the first future date
				scrollSection = i;
			}
			futureDates = true;
		}
		
	}
	
	if (todayDates) {
		//Scroll to today
		
		NSIndexPath *scrollPath = [NSIndexPath indexPathForRow:0 inSection:todaySection]; 
		
		[self.calendarList scrollToRowAtIndexPath:scrollPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}else if (pastDates && !futureDates) {
		//All past dates, scroll to the last section
		scrollSection = [self.dateArray count] - 1;
		
		NSIndexPath *scrollPath = [NSIndexPath indexPathForRow:0 inSection:scrollSection]; 
		[self.calendarList scrollToRowAtIndexPath:scrollPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
		
	}else if (futureDates && !pastDates) {
		//All future dates
		//do nothing	
		
	}else {
		//Mix of past and future dates, scroll to first future date
		NSIndexPath *scrollPath = [NSIndexPath indexPathForRow:0 inSection:scrollSection]; 
		[self.calendarList scrollToRowAtIndexPath:scrollPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	
}
-(void)month{
	
	[self.bottomBar removeFromSuperview];
	[self.navigationController popViewControllerAnimated:NO];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	static NSInteger gameTag = 1;
	static NSInteger timeTag = 2;
	static NSInteger vsTag = 3;
	static NSInteger descTag = 4;
	static NSInteger scoreTag = 5;
	static NSInteger teamTag = 6;
	static NSInteger canceledTag = 7;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
		CGRect frame;
		
		frame.origin.x = 10;
		frame.origin.y = 12;
		frame.size.height = 22;
		frame.size.width = 75;
		UILabel *gameLabel = [[UILabel alloc] initWithFrame:frame];
		gameLabel.tag = gameTag;
		[cell.contentView addSubview:gameLabel];
		[gameLabel release];
		
		frame.origin.x = 80;
		frame.origin.y = 12;
		frame.size.height = 22;
		frame.size.width = 100;
		UILabel *timeLabel = [[UILabel alloc] initWithFrame:frame];
		timeLabel.tag = timeTag;
		[cell.contentView addSubview:timeLabel];
		[timeLabel release];
		
		
		
		frame.origin.x = 180;
		frame.origin.y = 4;
		frame.size.height = 15;
		frame.size.width = 120;
		UILabel *teamLabel = [[UILabel alloc] initWithFrame:frame];
		teamLabel.tag = teamTag;
		[cell.contentView addSubview:teamLabel];
		[teamLabel release];
		
		
		frame.origin.x = 180;
		frame.origin.y = 19;
		frame.size.height = 18;
		frame.size.width = 120;
		UILabel *vsLabel = [[UILabel alloc] initWithFrame:frame];
		vsLabel.tag = vsTag;
		[cell.contentView addSubview:vsLabel];
		[vsLabel release];
		
		frame.origin.x = 180;
		frame.origin.y = 37;
		frame.size.height = 15;
		frame.size.width = 120;
		UILabel *descLabel = [[UILabel alloc] initWithFrame:frame];
		descLabel.tag = descTag;
		[cell.contentView addSubview:descLabel];
		[descLabel release];
		
		frame.origin.x = 10;
		frame.origin.y = 30;
		frame.size.height = 20;
		frame.size.width = 100;
		UILabel *scoreLabel = [[UILabel alloc] initWithFrame:frame];
		scoreLabel.tag = scoreTag;
		[cell.contentView addSubview:scoreLabel];
		[scoreLabel release];
	
		frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 55;
		frame.size.width = 320;	
		UILabel *canceledLabel = [[UILabel alloc] initWithFrame:frame];
		canceledLabel.tag = canceledTag;
		[cell.contentView addSubview:canceledLabel];
		[canceledLabel release];
		
		
	}
	
	
	UILabel *canceledLabel = (UILabel *)[cell.contentView viewWithTag:canceledTag];
	
	
	canceledLabel.text = @"CANCELED";
	canceledLabel.textColor = [UIColor colorWithRed:190.0/255.0 green:0.0 blue:0.0 alpha:.90];
	canceledLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:25];
	canceledLabel.textAlignment = UITextAlignmentCenter;
	canceledLabel.backgroundColor = [UIColor clearColor];
	canceledLabel.hidden = YES;
	
	UILabel *gameLabel = (UILabel *)[cell.contentView viewWithTag:gameTag];
	UILabel *timelabel = (UILabel *)[cell.contentView viewWithTag:timeTag];
	UILabel *vsLabel = (UILabel *)[cell.contentView viewWithTag:vsTag];
	UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:descTag];
	UILabel *scoreLabel = (UILabel *)[cell.contentView viewWithTag:scoreTag];
	UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];

		
	descLabel.backgroundColor = [UIColor clearColor];
	vsLabel.backgroundColor = [UIColor clearColor];
	
	scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	scoreLabel.textColor = [UIColor greenColor];
	
	gameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
	gameLabel.textColor = [UIColor blueColor];
	
	
	timelabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	teamLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	teamLabel.textColor = [UIColor blueColor];
	
	vsLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	descLabel.textColor = [UIColor grayColor];
	descLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
	
	
	//Configure the cell
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
		
	NSMutableArray *cellArray = [self.dateArray objectAtIndex:section];
	
	teamLabel.text = @"";
	
	if ([[cellArray objectAtIndex:row] class] == [Game class]) {
		
		gameLabel.text = @"Game";
		Game *theGame = [cellArray objectAtIndex:row];
		
		//team label
		teamLabel.text = theGame.teamName;

		
		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = theGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"hh:mm aa"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		
		
		timelabel.text = startDateString;
		[dateFormat release];
		[format release];
		//retrieve the opponent
		
		vsLabel.text = [@"vs. " stringByAppendingString:theGame.opponent];
		
		//set description
		
		descLabel.text = theGame.description;
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		scoreLabel.hidden = YES;
		//Scoring info
		if (theGame.interval != nil) {
			
			if (![theGame.interval isEqualToString:@"0"]) {
				
				
				if ([theGame.interval isEqualToString:@"-1"]) {
					//Game over
					int scoreUs = [theGame.scoreUs intValue];
					int scoreThem = [theGame.scoreThem intValue];
					
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
					
					scoreLabel.hidden = NO;
					scoreLabel.text = [NSString stringWithFormat:@"%@ %@-%@", result, theGame.scoreUs, theGame.scoreThem];
				}else if ([theGame.interval isEqualToString:@"-4"]){
					
					canceledLabel.hidden = NO;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					
				}else {
					//Game in progress
					scoreLabel.textColor = [UIColor colorWithRed:.412 green:.412 blue:.412 alpha:1.0];
					NSString *time = @"";
					int interval = [theGame.interval intValue];
					
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
						time = [NSString stringWithFormat:@"%@th", theGame.interval];
					}
					
					if (interval == -2) {
						time = @"OT";
					}
					
					if (interval == -3) {
						time = @"";
					}
					
					scoreLabel.hidden = NO;
					scoreLabel.text = [NSString stringWithFormat:@"%@-%@ %@", theGame.scoreUs, theGame.scoreThem, time];
				}
				
			}else {
				[scoreLabel setHidden:YES];
			}

		}
		
		
	}else if ([[cellArray objectAtIndex:row] class] == [Practice class]){
		
		[scoreLabel setHidden:YES];
		gameLabel.text = @"Practice";
		Practice *theGame = [cellArray objectAtIndex:row];
		
		teamLabel.text = theGame.teamName;

		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = theGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"hh:mm aa"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		
		
		timelabel.text = startDateString;
		[dateFormat release];
		[format release];
		//retrieve the opponent
		
		vsLabel.text = [@"at " stringByAppendingString:theGame.location];
		
		//set description
		
		descLabel.text = theGame.description;	
		
		if (theGame.isCanceled) {
			canceledLabel.hidden = NO;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
	}else if ([[cellArray objectAtIndex:row] class] == [Event class]){
		
		[scoreLabel setHidden:YES];
		gameLabel.text = @"Event";
		Event *theGame = [cellArray objectAtIndex:row];
		
		teamLabel.text = theGame.teamName;

		
		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = theGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"hh:mm aa"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		
		
		timelabel.text = startDateString;
		[dateFormat release];
		[format release];
		
		//set the eventName (using the 'vsLabel')
		//vsLabel.text = theGame.event
		vsLabel.text = theGame.eventName;
		
		//set locations (with description label)
		descLabel.text = [@"at " stringByAppendingString:theGame.location];	
		
		if (theGame.isCanceled) {
			canceledLabel.hidden = NO;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

		}
	}
	
	
		
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
	
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.gameIdCanceled = @"";
	self.practiceIdCanceled = @"";
	self.eventIdCanceled = @"";
	//Set the back button to just say "Calendar"
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	
	NSMutableArray *cellArray = [self.dateArray objectAtIndex:section];
	
	if ([[cellArray objectAtIndex:row] class] == [Game class]) {
		
		Game *currentGame = [cellArray objectAtIndex:row];
		
		NSString *userRole = @"";
		NSString *teamId = @"";
		
		teamId = currentGame.teamId;
		userRole = currentGame.userRole;
		
		
		if (![currentGame.interval isEqualToString:@"-4"]) {
			[self.bottomBar removeFromSuperview];

			if ([userRole isEqualToString:@"creator"] || [userRole isEqualToString:@"coordinator"]) {
				GameTabs *currentGameTab = [[GameTabs alloc] init];
				NSArray *viewControllers = currentGameTab.viewControllers;
				currentGameTab.teamId = teamId;
				currentGameTab.gameId = currentGame.gameId;
				currentGameTab.userRole = userRole;
				currentGameTab.teamName = currentGame.teamName;
				
				Gameday *currentNotes = [viewControllers objectAtIndex:0];
				currentNotes.gameId = currentGame.gameId;
				currentNotes.teamId = teamId;
				currentNotes.userRole = userRole;
				currentNotes.sport = currentGame.sport;
				currentNotes.description = currentGame.description;
				currentNotes.startDate = currentGame.startDate;
				currentNotes.opponentString = currentGame.opponent;
				
				/*"Activity" at 1
				 TeamActivity *activity = [viewControllers objectAtIndex:1];
				 activity.teamId = teamId;
				 activity.userRole = userRole;
				 */
				
				GameAttendance *currentAttendance = [viewControllers objectAtIndex:1];
				currentAttendance.gameId = currentGame.gameId;
				currentAttendance.teamId = teamId;
				currentAttendance.startDate = currentGame.startDate;
				
                /*
				GameChatter *messages = [viewControllers objectAtIndex:1];
				messages.gameId = currentGame.gameId;
				messages.teamId = teamId;
				messages.userRole = userRole;
				messages.startDate = currentGame.startDate;
				*/
				
				Vote *fans = [viewControllers objectAtIndex:2];
				fans.teamId = teamId;
				fans.userRole = userRole;
				fans.gameId = currentGame.gameId;
				[self.navigationController pushViewController:currentGameTab animated:YES];
				
			}else {
				
				GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
				NSArray *viewControllers = currentGameTab.viewControllers;
				currentGameTab.teamId = teamId;
				currentGameTab.gameId = currentGame.gameId;
				currentGameTab.userRole = userRole;
				currentGameTab.teamName = currentGame.teamName;
				
				
				/*Feeds is at 1
				 TeamActivity *activity = [viewControllers objectAtIndex:1];
				 activity.teamId = teamId;
				 activity.userRole = userRole;
				 */
				
				Gameday *currentNotes = [viewControllers objectAtIndex:0];
				currentNotes.gameId = currentGame.gameId;
				currentNotes.teamId = teamId;
				currentNotes.userRole = userRole;
				currentNotes.sport = currentGame.sport;
				
				/*
				GameChatter *messages = [viewControllers objectAtIndex:1];
				messages.gameId = currentGame.gameId;
				messages.teamId = teamId;
				messages.userRole = userRole;
				messages.startDate = currentGame.startDate;
				*/
                
				Vote *fans = [viewControllers objectAtIndex:1];
				fans.teamId = teamId;
				fans.userRole = userRole;
				fans.gameId = currentGame.gameId;
				
				[self.navigationController pushViewController:currentGameTab animated:YES];
			}
			
			
		}else {
			if ([userRole isEqualToString:@"coordinator"] || [userRole isEqualToString:@"creator"]) {
				
				self.cancelRow = row;
				self.cancelSection = section;
				
				
				self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
				//self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
				self.canceledAction.delegate = self;
				[self.canceledAction showInView:self.view];
				[self.canceledAction release];
				
		
				
				
			}
		}

		
				
	}else if ([[cellArray objectAtIndex:row] class] == [Practice class]){
		
		PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
		
		
		Practice *currentPractice = [cellArray objectAtIndex:row];
		
		NSString *userRole = @"";
		NSString *teamId = @"";
		
		teamId = currentPractice.ppteamId;
		userRole = currentPractice.userRole;
		
		if (currentPractice.isCanceled) {
			if ([userRole isEqualToString:@"coordinator"] || [userRole isEqualToString:@"creator"]) {
				
				self.cancelRow = row;
				self.cancelSection = section;
				
				self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
				self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
				[self.canceledAction showInView:self.view];
				[self.canceledAction release];
				
				
			}
		}else {
			[self.bottomBar removeFromSuperview];

			NSArray *viewControllers = currentPracticeTab.viewControllers;
			currentPracticeTab.teamId = teamId;
			currentPracticeTab.practiceId = currentPractice.practiceId;
			currentPracticeTab.userRole = userRole;
			
			PracticeNotes *currentNotes = [viewControllers objectAtIndex:0];
			currentNotes.practiceId = currentPractice.practiceId;
			currentNotes.teamId = teamId;
			currentNotes.userRole = userRole;
			
			PracticeAttendance *currentAttendance = [viewControllers objectAtIndex:1];
			currentAttendance.practiceId = currentPractice.practiceId;
			currentAttendance.teamId = teamId;
			currentAttendance.userRole = userRole;
			
			currentAttendance.startDate = currentPractice.startDate;
			
            /*
			PracticeChatter *messages = [viewControllers objectAtIndex:2];
			messages.teamId = teamId;
			messages.practiceId = currentPractice.practiceId;
			messages.userRole = userRole;
			messages.startDate = currentPractice.startDate;
			*/
			
			/*
			 PracticeMessages *messages = [viewControllers objectAtIndex:1];
			 messages.teamId = teamId;
			 messages.practiceId = currentPractice.practiceId;
			 messages.userRole = userRole;
			 */
			
			[self.navigationController pushViewController:currentPracticeTab animated:YES];
		}

		
		
		
	
	}else if ([[cellArray objectAtIndex:row] class] == [Event class]){
				
		EventTabs *currentEventTab = [[EventTabs alloc] init];
		
		
		Event *currentEvent =  [cellArray objectAtIndex:row];
		
		NSString *userRole = @"";
		NSString *teamId = @"";
		
		teamId = currentEvent.teamId;
		userRole = currentEvent.userRole;
		
		if (currentEvent.isCanceled) {
			if ([userRole isEqualToString:@"coordinator"] || [userRole isEqualToString:@"creator"]) {
				
				self.cancelRow = row;
				self.cancelSection = section;
				
				
				self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
				self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
				[self.canceledAction showInView:self.view];
				[self.canceledAction release];
				

				
			}
		}else {
			[self.bottomBar removeFromSuperview];

			NSArray *viewControllers = currentEventTab.viewControllers;
			currentEventTab.teamId = teamId;
			currentEventTab.eventId = currentEvent.eventId;
			currentEventTab.userRole = userRole;
			
			EventNotes *currentNotes = [viewControllers objectAtIndex:0];
			currentNotes.eventId = currentEvent.eventId;
			currentNotes.teamId = teamId;
			currentNotes.userRole = userRole;
			
			
			EventAttendance *currentAttendance = [viewControllers objectAtIndex:1];
			currentAttendance.eventId = currentEvent.eventId;
			currentAttendance.teamId = teamId;
			currentAttendance.userRole = userRole;
			
			currentAttendance.startDate = currentEvent.startDate;
			
			/*
			 EventMessages *messages = [viewControllers objectAtIndex:1];
			 messages.teamId = teamId;
			 messages.eventId = currentEvent.eventId;
			 messages.userRole = userRole;
			 
			 */
			[self.navigationController pushViewController:currentEventTab animated:YES];
			
			
		}

		
	}
	

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

	NSMutableArray *tmpMutable = (NSMutableArray *)[self.dateArray objectAtIndex:section];
	return [tmpMutable count];
	
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	NSMutableArray *cellArray = [self.dateArray objectAtIndex:section];
		
	if ([[cellArray objectAtIndex:0] class] == [Game class]) {

	  Game *theGame = [cellArray objectAtIndex:0];
	
	  //format the start date (coming back as YYYY-MM-DD hh:mm)
	  NSString *date = theGame.startDate;
	
	  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
      [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
      NSDate *formatedDate = [dateFormat dateFromString:date];
	
        [dateFormat release];
	
	  NSDateFormatter *format = [[NSDateFormatter alloc] init];
	  [format setDateFormat:@" eee      MMM dd yyyy"];
	
	  NSString *startDateString = [format stringFromDate:formatedDate];
	
        [format release];
	  return startDateString;
	}else if ([[cellArray objectAtIndex:0] class] == [Practice class]){
			
		Practice *theGame = [cellArray objectAtIndex:0];
		
		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = theGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		
		[dateFormat release];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@" eee      MMM dd yyyy"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		[format release];
		return startDateString;
	}else if ([[cellArray objectAtIndex:0] class] == [Event class]){
		
		Event *theEvent = [cellArray objectAtIndex:0];
		
		//format the start date (coming back as YYYY-MM-DD hh:mm)
		NSString *date = theEvent.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		[dateFormat release];
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@" eee      MMM dd yyyy"];
		
		NSString *startDateString = [format stringFromDate:formatedDate];
		[format release];
		return startDateString;
	}
	
	return @"";
}


-(void)buildDateArray{

	//Build the date array from the events array
	self.dateArray = [NSMutableArray array];
	
	for (int i = 0; i < [self.events count]; i++) {
		
		NSMutableArray *tmpCellArray = [NSMutableArray array];
		
		if (i == 0) {
			[tmpCellArray addObject:[self.events objectAtIndex:i]];
			[self.dateArray addObject:tmpCellArray];
		}else {
			//Get the date of object at "i" and "i-1" and compare
			
			NSString *currentCellDate = [self getDateForObject:[self.events objectAtIndex:i]];
			NSString *prevCellDate = [self getDateForObject:[self.events objectAtIndex:i-1]];
			
			
			if ([currentCellDate isEqualToString:prevCellDate]) {
				//If they are equal, add this event to the previous cells array in dateArray
				int currentCell = [self.dateArray count] - 1;
				
				NSMutableArray *prevArray = (NSMutableArray *)[self.dateArray objectAtIndex:currentCell];
				[prevArray addObject:[self.events objectAtIndex:i]];
				[self.dateArray replaceObjectAtIndex:currentCell withObject:prevArray];
				
			}else {
				
				[tmpCellArray addObject:[self.events objectAtIndex:i]];
				[self.dateArray addObject:tmpCellArray];
			}

			
			
		}
		
		
	}
	
	
}

-(NSString *)getDateForObject:(id)event{
	
	NSString *returnDate = @"";
	
	
	if ([event class] == [Practice class]) {
		Practice *tmpPractice = (Practice *)event;
		return [tmpPractice.startDate substringToIndex:10];
	}else if ([event class] == [Game class]) {
		Game *tmpGame = (Game *)event;
		return [tmpGame.startDate substringToIndex:10];
	}else if ([event class] == [Event class]) {
		Event *tmpEvent = (Event *)event;
		return [tmpEvent.startDate substringToIndex:10];
	}
	
	
	return returnDate;
	
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
	
	if (actionSheet == self.canceledAction) {
		
		if (buttonIndex == 0) {
			
			//run the delete
			[self.deleteActivity startAnimating];
			[self performSelectorInBackground:@selector(runDelete) withObject:nil];
		}else if (buttonIndex == 1) {
			//Cancel
			[self.deleteActivity startAnimating];
			[self performSelectorInBackground:@selector(activateEvent) withObject:nil];
		}else {


		}
		
	}else {
		[FastActionSheet doAction:self :buttonIndex];

	}

	
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)runDelete{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	//Cancel Event
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	NSMutableArray *cellArray = [self.dateArray objectAtIndex:self.cancelSection];

	
	if ([[cellArray objectAtIndex:self.cancelRow] class] == [Game class]) {
		
		Game *gameToDelete = [cellArray objectAtIndex:self.cancelRow];
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI deleteGame:token :gameToDelete.teamId :gameToDelete.gameId];
			
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				[cellArray removeObjectAtIndex:self.cancelRow];
				[self.dateArray replaceObjectAtIndex:self.cancelSection withObject:cellArray];
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
						//	self.error.text = @"*Error connecting to server";
						break;
					default:
						//log status code
						//self.error.text = @"*Error connecting to server";
						break;
				}
			}
			
			
		}
		
	}else if ([[cellArray objectAtIndex:self.cancelRow] class] == [Practice class]) {
		
		Practice *practiceToDelete = [cellArray objectAtIndex:self.cancelRow];
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI deleteEvent:token :practiceToDelete.ppteamId :practiceToDelete.practiceId];
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				[cellArray removeObjectAtIndex:self.cancelRow];
				[self.dateArray replaceObjectAtIndex:self.cancelSection withObject:cellArray];
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						////null parameter
						//	self.error.text = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						//	self.error.text = @"*Error connecting to server";
						break;
					default:
						//log status code
						//	self.error.text = @"*Error connecting to server";
						break;
				}
			}
		}
	}else {
		
		Event *practiceToDelete = [cellArray objectAtIndex:self.cancelRow];
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI deleteEvent:token :practiceToDelete.teamId :practiceToDelete.eventId];
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				[cellArray removeObjectAtIndex:self.cancelRow];
				[self.dateArray replaceObjectAtIndex:self.cancelSection withObject:cellArray];
				
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
	
	NSMutableArray *cellArray = [self.dateArray objectAtIndex:self.cancelSection];
	
	if ([[cellArray objectAtIndex:self.cancelRow] class] == [Game class]) {
		
		Game *gameToDelete = [cellArray objectAtIndex:self.cancelRow];
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI updateGame:token :gameToDelete.teamId :gameToDelete.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"0" :@"" :@"" :@""];
			
			
			NSString *status = [response valueForKey:@"status"];
			
			
			if ([status isEqualToString:@"100"]){
				
				gameToDelete.interval = @"0";
				[cellArray replaceObjectAtIndex:self.cancelRow withObject:gameToDelete];
				[self.dateArray replaceObjectAtIndex:self.cancelSection withObject:cellArray];
				
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
		
	}else if ([[cellArray objectAtIndex:self.cancelRow] class] == [Practice class]) {
		
		Practice *practiceToDelete = [cellArray objectAtIndex:self.cancelRow];
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI updateEvent:token :practiceToDelete.ppteamId :practiceToDelete.practiceId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				
				practiceToDelete.isCanceled = false;
				[cellArray replaceObjectAtIndex:self.cancelRow withObject:practiceToDelete];
				[self.dateArray replaceObjectAtIndex:self.cancelSection withObject:cellArray];
				
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
	}else {
		
		Event *practiceToDelete = [cellArray objectAtIndex:self.cancelRow];
		if (![token isEqualToString:@""]){
			NSDictionary *response = [ServerAPI updateEvent:token :practiceToDelete.teamId :practiceToDelete.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
			NSString *status = [response valueForKey:@"status"];
			
			if ([status isEqualToString:@"100"]){
				
				
				practiceToDelete.isCanceled = false;
				[cellArray replaceObjectAtIndex:self.cancelRow withObject:practiceToDelete];
				[self.dateArray replaceObjectAtIndex:self.cancelSection withObject:cellArray];
				
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				
				switch (statusCode) {
					case 0:
						///null parameter
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

-(void)doneEventEdit{
	
	[self.deleteActivity stopAnimating];
	[calendarList reloadData];
	
	[self.view bringSubviewToFront:self.bottomBar];

	
}


-(void)viewDidUnload{
	
	//events = nil;
	//allGames = nil;
	//allPractices = nil;
	//allEvents = nil;
	//dateArray = nil;
	bottomBar = nil;
	segmentedControl = nil;
	calendarList = nil;
	deleteActivity= nil;
	[super viewDidUnload];
	
}


-(void)dealloc{
	
	[events release];
	[allGames release];
	[allPractices release];
	[allEvents release];
	[dateArray release];
	[bottomBar release];
	[segmentedControl release];
	[calendarList release];
	[deleteActivity release];
	[canceledAction release];
	[gameIdCanceled release];
	[practiceIdCanceled release];
	[eventIdCanceled release];
	
	[super dealloc];
	
}

@end

