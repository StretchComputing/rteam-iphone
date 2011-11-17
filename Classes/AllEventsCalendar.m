//
//  CalendarTestViewController.m
//  CalendarTest
//
//  Created by Ved Surtani on 10/03/09.
//  Copyright Pramati Technologies 2009. All rights reserved.
//

#import "AllEventsCalendar.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Game.h"
#import "Practice.h"
#import "KLDate.h"
#import "GameAttendance.h"
#import "Gameday.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "Practice.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "CreateNewEvent.h"
#import "AllEventCalList.h"
#import "Event.h"
#import "EventTabs.h"
#import "EventNotes.h"
#import "EventAttendance.h"
#import "Home.h"
#import "Fans.h"
#import "FastActionSheet.h"
#import "Vote.h"
#import "GANTracker.h"

@implementation AllEventsCalendar
@synthesize allGames, allPractices, allEvents, eventType, dateSelected, gamesToday, practicesToday, eventsToday, bottomBar, segmentedControl, 
createdEvent, error, allGenericEvents, loadingActivity, activityLabel, deleteActivity, deleteAction, deleteEventType, deleteEventId,
deleteEventTeamId, deleteCell, emptyGames, emptyPractices, emptyEvents, gDelete, pDelete, eDelete, gotGames, gotPractices, gotEvents, canceledAction, errorString;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated{


	if (self.createdEvent) {
		self.createdEvent = false;
		[self performSelectorInBackground:@selector(getAllGames) withObject:nil];
		//[calendarView refreshViewWithPushDirection:nil];
        [calendarView performSelector:@selector(refreshViewWithPushDirection:) withObject:nil];

		[myTableView reloadData];
	}
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setLeftBarButtonItem:homeButton];

}


-(void)home{
	
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}




- (void)loadView {
	self.title = @"Events Calendar";
	
	self.eventType = @"game";
	[super loadView];
	
	
	self.allGames = [NSMutableArray array];
	self.allPractices = [NSMutableArray array];
	self.allEvents = [NSMutableArray array];
	self.dateSelected = [NSDate date];
	
	self.loadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 165, 20, 20)];
	self.loadingActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	self.loadingActivity.hidesWhenStopped = YES;
	[self.loadingActivity startAnimating];
	
	self.activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 320, 20)];
	self.activityLabel.textAlignment = UITextAlignmentCenter;
	self.activityLabel.textColor = [UIColor darkGrayColor];
	self.activityLabel.text = @"Loading Calendar Events...";
	
	[self.view addSubview:self.activityLabel];
	[self.view addSubview:self.loadingActivity];
	[self performSelectorInBackground:@selector(getAllGames) withObject:nil];
	
	
	
	
	
}


-(void)finishSetup{
	
	self.emptyGames = false;
	self.emptyPractices = false;
	self.emptyEvents = false;
	
	self.eDelete = false;
	self.pDelete = false;
	self.gDelete = false;
	
	self.gotGames = false;
	self.gotPractices = false;
	self.gotEvents = false;
	
	calendarView = [[KLCalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,  320.0f, 360) delegate:self];
	
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,242,320,135) style:UITableViewStylePlain];
	
	myTableView.dataSource = self;
	myTableView.delegate = self;
	UIView *myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,myTableView.frame.size.width , 5)];
	myHeaderView.backgroundColor = [UIColor grayColor];
	[myTableView setTableHeaderView:myHeaderView];
	
	self.bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 377, 320, 40)];
	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	NSArray *segments = [NSArray arrayWithObjects:@"Games", @"Practices", @"All", nil];
	
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
	self.segmentedControl.frame = CGRectMake(25, 3, 250, 30);
	self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.segmentedControl.selectedSegmentIndex = 0;
	[self.segmentedControl addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
    UIBarButtonItem *tmp = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
	
	
	
	NSArray *items1 = [NSArray arrayWithObjects:flexibleSpace, tmp, flexibleSpace, nil];
	self.bottomBar.items = items1;

	
	[self.view addSubview:myTableView];
	[self.view addSubview:calendarView];
	[self.view bringSubviewToFront:myTableView];
	
	[self.view addSubview:self.bottomBar];
	[self.view bringSubviewToFront:self.bottomBar];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:self action:@selector(listView)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	self.deleteActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(141, 295, 37, 37)];
	self.deleteActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	self.deleteActivity.hidesWhenStopped = YES;
	[self.view addSubview:self.deleteActivity];
	[self.view bringSubviewToFront:self.deleteActivity];
	
}


-(void)getAllGames{

	@autoreleasepool {
        //Start 2 background threads for practices and all events here?
        [self performSelectorInBackground:@selector(getAllPractices) withObject:nil];
        [self performSelectorInBackground:@selector(getAllEvents) withObject:nil];
        
        
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
        
        self.allGames = [NSMutableArray arrayWithArray:games];
        [self filterGames];
        [self performSelectorOnMainThread:@selector(finishedGames) withObject:nil waitUntilDone:NO];

    }
	
	
}

-(void)finishedGames{
	[self performSelectorInBackground:@selector(combineEvents) withObject:nil];

	self.activityLabel.hidden = YES;
	[self.loadingActivity stopAnimating];
	[self finishSetup];
}

- (void)getAllPractices {

    @autoreleasepool {
        NSArray *practices = [NSArray array];
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfEvents:@"" :token :@"practice"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                practices = [response valueForKey:@"events"];
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
                        //log response
                        self.error = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        self.gotPractices = true;
        
        self.allPractices = [NSMutableArray arrayWithArray:practices];	
        
        [self performSelectorOnMainThread:@selector(finishedPractices) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)finishedPractices{
	
	[self performSelectorInBackground:@selector(combineEvents) withObject:nil];

	
}

- (void)getAllEvents {
	

	@autoreleasepool {
        NSArray *practices = [NSArray array];
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfEvents:@"" :token :@"generic"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                practices = [response valueForKey:@"events"];
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
                        //log response
                        self.error = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        
        self.allGenericEvents = [NSMutableArray arrayWithArray:practices];	
        
        [self performSelectorOnMainThread:@selector(finishedEvents) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)finishedEvents{
	
	[self performSelectorInBackground:@selector(combineEvents) withObject:nil];

	
}


- (void)combineEvents {

	@autoreleasepool {
        self.allEvents = [NSMutableArray array];
        
        //NSArray *events = [NSArray array];
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            //events = [ServerAPI getListOfEvents:@"" :token];
            
        }
        
        
        for (int i = 0; i < [self.allGames count]; i++) {
            
            [self.allEvents addObject:[self.allGames objectAtIndex:i]];
        }
        
        for (int i = 0; i < [self.allPractices count]; i++) {
            
            [self.allEvents addObject:[self.allPractices objectAtIndex:i]];
        }
        
        for (int i = 0; i < [self.allGenericEvents count]; i++) {
            
            [self.allEvents addObject:[self.allGenericEvents objectAtIndex:i]];
        }
        
        NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        [self.allEvents sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
        
        [self performSelectorOnMainThread:
         @selector(didFinishEvents)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

-(void)didFinishEvents{
	[self filterAllEvents];
	[myTableView reloadData];
	[calendarView reloadInputViews];
}



#pragma mark tableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([self.eventType isEqualToString:@"game"]) {
						
		return [self.gamesToday count] + 1;
		
	}else if ([self.eventType isEqualToString:@"practice"]) {
		return [self.practicesToday count] + 1;
		
	}else{
		return [self.eventsToday count] + 1;	
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSInteger eventTag = 1;
	static NSInteger teamTag = 2;
	static NSInteger canceledTag = 3;
	NSInteger row = [indexPath row];
	bool addDelete = false;
	
	if (row != 0) {
	
		if ([self.eventType isEqualToString:@"game"]) {

			Game *tmpGame = [self.gamesToday objectAtIndex:row-1];
		
			if ([tmpGame.userRole isEqualToString:@"creator"] || [tmpGame.userRole isEqualToString:@"coordinator"]) {
				addDelete = true;
			}
		
		}else if ([self.eventType isEqualToString:@"practice"]) {

			Practice *tmpGame = [self.practicesToday objectAtIndex:row-1];
			
			if ([tmpGame.userRole isEqualToString:@"creator"] || [tmpGame.userRole isEqualToString:@"coordinator"]) {
				addDelete = true;
			}
	
		}else{
		
			if ([[self.eventsToday objectAtIndex:row-1] class] == [Game class]) {
			
				Game *tmpGame = [self.eventsToday objectAtIndex:row-1];
				
				if ([tmpGame.userRole isEqualToString:@"creator"] || [tmpGame.userRole isEqualToString:@"coordinator"]) {
					addDelete = true;
				}
					
			}else if ([[self.eventsToday objectAtIndex:row-1] class] == [Practice class]) {
			
				Practice *tmpGame = [self.eventsToday objectAtIndex:row-1];

				if ([tmpGame.userRole isEqualToString:@"creator"] || [tmpGame.userRole isEqualToString:@"coordinator"]) {
					addDelete = true;
				}
			
			}else if ([[self.eventsToday objectAtIndex:row-1] class] == [Event class]) {
			
				Event *tmpEvent = [self.eventsToday objectAtIndex:row-1];
			
				if ([tmpEvent.userRole isEqualToString:@"creator"] || [tmpEvent.userRole isEqualToString:@"coordinator"]) {
					addDelete = true;
				}
			
			}
		
		}

	}
	
	
	static NSString *noDeleteCell = @"noDeleteCell";
	static NSString *deleteCell1 = @"deleteCell";

	
	UITableViewCell *cell;
	if (addDelete) {
		cell = [tableView dequeueReusableCellWithIdentifier:deleteCell1];
	}else {
		cell = [tableView dequeueReusableCellWithIdentifier:noDeleteCell];
		
	}
	
	if (cell == nil){
		
		if (addDelete) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deleteCell1];
			
		}else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noDeleteCell];
			
		}
		
		CGRect frame;
		
		frame.origin.x = 10;
		frame.origin.y = 2;
		frame.size.height = 20;
		frame.size.width = 300;
		UILabel *eventLabel = [[UILabel alloc] initWithFrame:frame];
		eventLabel.tag = eventTag;
		[cell.contentView addSubview:eventLabel];
		
		frame.origin.x = 10;
		frame.origin.y = 24;
		frame.size.height = 13;
		frame.size.width = 300;
		UILabel *teamLabel = [[UILabel alloc] initWithFrame:frame];
		teamLabel.tag = teamTag;
		[cell.contentView addSubview:teamLabel];
		
		
		
		frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 40;
		frame.size.width = 320;	
		UILabel *canceledLabel = [[UILabel alloc] initWithFrame:frame];
		canceledLabel.tag = canceledTag;
		[cell.contentView addSubview:canceledLabel];
		
		
	}
	
	
	UILabel *canceledLabel = (UILabel *)[cell.contentView viewWithTag:canceledTag];
	
	
	canceledLabel.text = @"CANCELED";
	canceledLabel.textColor = [UIColor colorWithRed:190.0/255.0 green:0.0 blue:0.0 alpha:.90];
	canceledLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:20];
	canceledLabel.textAlignment = UITextAlignmentCenter;
	canceledLabel.backgroundColor = [UIColor clearColor];
	canceledLabel.hidden = YES;
	
	UILabel *eventLabel = (UILabel *)[cell.contentView viewWithTag:eventTag];
	UILabel *teamLabel = (UILabel *)[cell.contentView viewWithTag:teamTag];
	eventLabel.backgroundColor = [UIColor clearColor];
	eventLabel.textAlignment = UITextAlignmentCenter;
	eventLabel.textColor = [UIColor blackColor];
	eventLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	eventLabel.frame = CGRectMake(10, 2, 300, 20);
	
	teamLabel.backgroundColor = [UIColor clearColor];
	teamLabel.textAlignment = UITextAlignmentCenter;
	teamLabel.textColor = [UIColor blueColor];
	teamLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
	
	if (addDelete) {
		UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		deleteButton.frame = CGRectMake(7, 4, 32, 32);
		deleteButton.tag = row;
		[deleteButton setImage:[UIImage imageNamed:@"deleteIcon.png"] forState:UIControlStateNormal];
		[deleteButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:deleteButton];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if (row == 0) {
		eventLabel.text = @"*Create New Event*";
		eventLabel.textAlignment = UITextAlignmentCenter;
		eventLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		eventLabel.frame = CGRectMake(10, 10, 300, 20);


		teamLabel.text = @"";
	}else {
		if ([self.eventType isEqualToString:@"game"]) {
			//
	        Game *tmpGame = [self.gamesToday objectAtIndex:row-1];
			
			NSString *date = tmpGame.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *gameDate = [dateFormat dateFromString:date];
			
			[dateFormat setDateFormat:@"hh:mm aa"];
			
			NSString *hour = [dateFormat stringFromDate:gameDate];
			
			eventLabel.text = [@"Game at " stringByAppendingString:hour];
			eventLabel.textAlignment = UITextAlignmentCenter;
			teamLabel.text = tmpGame.teamName;
			if ([tmpGame.interval isEqualToString:@"-4"]) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
		}else if ([self.eventType isEqualToString:@"practice"]) {
			//
			Practice *tmpGame = [self.practicesToday objectAtIndex:row-1];
			NSString *date = tmpGame.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *gameDate = [dateFormat dateFromString:date];
			
			[dateFormat setDateFormat:@"hh:mm aa"];
			
			NSString *hour = [dateFormat stringFromDate:gameDate];
			eventLabel.text = [@"Practice at " stringByAppendingString:hour];
			eventLabel.textAlignment = UITextAlignmentCenter;
			teamLabel.text = tmpGame.teamName;

			if (tmpGame.isCanceled) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}else{
			//	
			
			if ([[self.eventsToday objectAtIndex:row-1] class] == [Game class]) {
				
				Game *tmpGame = [self.eventsToday objectAtIndex:row-1];
				
				NSString *date = tmpGame.startDate;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *gameDate = [dateFormat dateFromString:date];
				
				[dateFormat setDateFormat:@"hh:mm aa"];
				
				NSString *hour = [dateFormat stringFromDate:gameDate];
				
				eventLabel.text = [@"Game at " stringByAppendingString:hour];
				eventLabel.textAlignment = UITextAlignmentCenter;
				teamLabel.text = tmpGame.teamName;
                
				if ([tmpGame.interval isEqualToString:@"-4"]) {
					canceledLabel.hidden = NO;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}

				
			}else if ([[self.eventsToday objectAtIndex:row-1] class] == [Practice class]) {
				
				Practice *tmpGame = [self.eventsToday objectAtIndex:row-1];
				NSString *date = tmpGame.startDate;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *gameDate = [dateFormat dateFromString:date];
				
				[dateFormat setDateFormat:@"hh:mm aa"];
				
				NSString *hour = [dateFormat stringFromDate:gameDate];
				eventLabel.text = [@"Practice at " stringByAppendingString:hour];
				eventLabel.textAlignment = UITextAlignmentCenter;
				teamLabel.text = tmpGame.teamName;

				if (tmpGame.isCanceled) {
					canceledLabel.hidden = NO;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}
				
			}else if ([[self.eventsToday objectAtIndex:row-1] class] == [Event class]) {
				
				Event *tmpEvent = [self.eventsToday objectAtIndex:row-1];
				NSString *date = tmpEvent.startDate;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
				NSDate *eventDate = [dateFormat dateFromString:date];
				
				[dateFormat setDateFormat:@"hh:mm aa"];
				
				NSString *hour = [dateFormat stringFromDate:eventDate];
				eventLabel.text = [@"Event at " stringByAppendingString:hour];
				eventLabel.textAlignment = UITextAlignmentCenter;
				teamLabel.text = tmpEvent.teamName;

				if (tmpEvent.isCanceled) {
					canceledLabel.hidden = NO;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}
				
			}else {
				
			}

		}
	}
	
	return cell;
	
}

-(void)deleteEvent:(id)sender{
	
   
    
	UIButton *tmpbutton = (UIButton *)sender;
	
	int cell = tmpbutton.tag - 1;
	
	if ([self.eventType isEqualToString:@"game"]) {
		
		Game *tmpGame = [self.gamesToday objectAtIndex:cell];
		
		self.deleteEventType = @"game";
		self.deleteEventId = tmpGame.gameId;
		self.deleteEventTeamId = tmpGame.teamId;
		self.deleteCell = cell;
	
	}else if ([self.eventType isEqualToString:@"practice"]) {
		
		Practice *tmpGame = [self.practicesToday objectAtIndex:cell];
		
		self.deleteEventType = @"practice";
		self.deleteEventId = tmpGame.practiceId;
		self.deleteEventTeamId = tmpGame.ppteamId;
		self.deleteCell = cell;

		
	}else{
		
		if ([[self.eventsToday objectAtIndex:cell] class] == [Game class]) {
			
			Game *tmpGame = [self.eventsToday objectAtIndex:cell];
			
			self.deleteEventType = @"game";
			self.deleteEventId = tmpGame.gameId;
			self.deleteEventTeamId = tmpGame.teamId;
			self.deleteCell = cell;

			
		}else if ([[self.eventsToday objectAtIndex:cell] class] == [Practice class]) {
			
			Practice *tmpGame = [self.eventsToday objectAtIndex:cell];
		
			self.deleteEventType = @"practice";
			self.deleteEventId = tmpGame.practiceId;
			self.deleteEventTeamId = tmpGame.ppteamId;
			self.deleteCell = cell;

			
		}else if ([[self.eventsToday objectAtIndex:cell] class] == [Event class]) {
			
			Event *tmpEvent = [self.eventsToday objectAtIndex:cell];
			
			self.deleteEventType = @"generic";
			self.deleteEventId = tmpEvent.eventId;
			self.deleteEventTeamId = tmpEvent.teamId;
			self.deleteCell = cell;

			
		}
		
	}
	
	
	self.deleteAction = [[UIActionSheet alloc] initWithTitle:@"'Delete' removes event from schedule. 'Cancel' marks event as cancelled." delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Delete Event" otherButtonTitles:@"Cancel Event", nil];

	self.deleteAction.delegate = self;
	[self.deleteAction showInView:self.view];
	
}


/*----- Calendar Delegates -----> */

- (void)calendarView:(KLCalendarView *)calendarView tappedTile:(KLTile *)aTile{
	
	[aTile flash];
	
	if(tile == nil){
		tile = aTile;
	}
	else{
	    //[tile restoreBackgroundColor];
        [tile performSelector:@selector(restoreBackgroundColor)];
		tile = aTile;
	}
	
	KLDate *klDateSelected = [aTile date];
	
	NSInteger intYear = [klDateSelected yearOfCommonEra];
	NSInteger intMonth = [klDateSelected monthOfYear];
	NSInteger intDay = [klDateSelected dayOfMonth];
	
	NSString *year = [NSString stringWithFormat:@"%d", intYear];
	NSString *month = [NSString stringWithFormat:@"%d", intMonth];
	NSString *day = [NSString stringWithFormat:@"%d", intDay];
	
	if ([month length] == 1) {
		month = [@"0" stringByAppendingString:month];
	}
	
	if ([day length] == 1) {
		day = [@"0" stringByAppendingString:day];
	}
	
	NSString *stringDate = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd"]; 
	NSDate *formatedDate = [dateFormat dateFromString:stringDate];
	self.dateSelected = formatedDate;
	
	if ([self.eventType isEqualToString:@"game"]) {
		[self filterGames];
		
	}else if ([self.eventType isEqualToString:@"practice"]) {
		[self filterPractices];
		
	}else{
		[self filterAllEvents];	
	}
	
	[myTableView reloadData];
	
	
}

- (KLTile *)calendarView:(KLCalendarView *)calendarView1 createTileForDate:(KLDate *)date{
	
	
	CheckmarkTile *thisTile = [[CheckmarkTile alloc] init];
	
	NSInteger intYear = [date yearOfCommonEra];
	NSInteger intMonth = [date monthOfYear];
	NSInteger intDay = [date dayOfMonth];
	
	NSString *year = [NSString stringWithFormat:@"%d", intYear];
	NSString *month = [NSString stringWithFormat:@"%d", intMonth];
	NSString *day = [NSString stringWithFormat:@"%d", intDay];
	
	if ([month length] == 1) {
		month = [@"0" stringByAppendingString:month];
	}
	
	if ([day length] == 1) {
		day = [@"0" stringByAppendingString:day];
	}
	
	NSString *stringDate = [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
	
	bool check = false;
	
	if ([self.eventType isEqualToString:@"game"]) {
		
		for (int i = 0; i < [self.allGames count]; i++){
			
			Game *tmpGame = [self.allGames objectAtIndex:i];
			
			NSString *date = tmpGame.startDate;
			
			NSString *testDate = [date substringToIndex:10];
			
			if ([testDate isEqualToString:stringDate]) {
				check = true;
				break;
			}
		}
		
	}else if ([self.eventType isEqualToString:@"practice"]) {
		
		for (int i = 0; i < [self.allPractices count]; i++){
			
			Practice *tmpGame = [self.allPractices objectAtIndex:i];
			
			NSString *date = tmpGame.startDate;
			
			NSString *testDate = [date substringToIndex:10];
			
			if ([testDate isEqualToString:stringDate]) {
				check = true;
				break;
			}
			
		}
	}else {
		for (int i = 0; i < [self.allGames count]; i++){
			
			Game *tmpGame = [self.allGames objectAtIndex:i];
			
			NSString *date = tmpGame.startDate;
			
			NSString *testDate = [date substringToIndex:10];
			
			if ([testDate isEqualToString:stringDate]) {
				check = true;
				break;
			}
		}
		
		for (int i = 0; i < [self.allPractices count]; i++){
			
			Practice *tmpGame = [self.allPractices objectAtIndex:i];
			
			NSString *date = tmpGame.startDate;
			
			NSString *testDate = [date substringToIndex:10];
			
			if ([testDate isEqualToString:stringDate]) {
				check = true;
				break;
			}
			
		}
		for (int i = 0; i < [self.allGenericEvents count]; i++){
			
			Event *tmpEvent = [self.allGenericEvents objectAtIndex:i];
			
			NSString *date = tmpEvent.startDate;
			
			NSString *testDate = [date substringToIndex:10];
			
			if ([testDate isEqualToString:stringDate]) {
				check = true;
				break;
			}
			
		}
	}
	
	
	if (check) {
		thisTile.checkmarked = true;
	}else {
		thisTile.checkmarked = false;
	}
	
	
	return thisTile;
	
}

- (void)didChangeMonths{
	
    //UIView *clip = calendarView.superview;
    //if (!clip)
    ///    return;
    
    //CGRect f = clip.frame;
    NSInteger weeks = [calendarView selectedMonthNumberOfWeeks];
    CGFloat adjustment = 0.f;
    
    switch (weeks) {
        case 4:
            adjustment = (92/321)*360+30;
            break;
        case 5:
            adjustment = (46/321)*360;
            break;
        case 6:
            adjustment = -42.f;
            break;
        default:
            break;
    }
   // f.size.height = 360 - adjustment;
   // clip.frame = f;
	
	CGRect f2 = CGRectMake(0,242-adjustment,320,135+adjustment);
	myTableView.frame = f2;
	[self.view bringSubviewToFront:myTableView];
	
	[self.view bringSubviewToFront:self.bottomBar];
	tile = nil;
}


-(void)listView{
	
	AllEventCalList *tmp = [[AllEventCalList alloc] init];
	
	//Sort the games, practices, and all events
	NSMutableArray *tmpMutable = [NSMutableArray arrayWithArray:self.allGames];
	NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	[tmpMutable sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	self.allGames = tmpMutable;
	
	tmpMutable = [NSMutableArray arrayWithArray:self.allPractices];
	[tmpMutable sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	self.allPractices = tmpMutable;
	
	tmpMutable = [NSMutableArray arrayWithArray:self.allEvents];
	[tmpMutable sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
	self.allEvents = tmpMutable;
	
	
	tmp.allGames = [NSArray arrayWithArray:self.allGames];
	tmp.allPractices = [NSArray arrayWithArray:self.allPractices];
	tmp.allEvents = [NSArray arrayWithArray:self.allEvents];
	tmp.gameIdCanceled = @"";
	tmp.practiceIdCanceled = @"";
	tmp.eventIdCanceled = @"";

	if ([self.eventType isEqualToString:@"game"]) {
		tmp.events = [NSArray arrayWithArray:self.allGames];
		tmp.title = @"Game List";
		tmp.initialSegment = 0;
	}else if ([self.eventType isEqualToString:@"practice"]){
		tmp.events = [NSArray arrayWithArray:self.allPractices];
		tmp.title = @"Practice List";
		tmp.initialSegment = 1;
	}else{
		tmp.events = [NSArray arrayWithArray:self.allEvents];
		tmp.title = @"Event List";
		tmp.initialSegment = 2;
	}
	
	[self.navigationController pushViewController:tmp animated:NO];
														

    
}

-(void)segmentSelect:(id)sender{
	
	int selection = [self.segmentedControl selectedSegmentIndex];
	
	switch (selection) {
		case 0:
			self.eventType = @"game";
			self.segmentedControl.selectedSegmentIndex = 0;
			break;
		case 1:
			self.eventType = @"practice";
			self.segmentedControl.selectedSegmentIndex = 1;
			break;
		case 2:
			self.eventType = @"all";
			self.segmentedControl.selectedSegmentIndex = 2;
			break;
		default:
			break;
	}
	
	//[calendarView refreshViewWithPushDirection:nil];
    [calendarView performSelector:@selector(refreshViewWithPushDirection:) withObject:nil];
	[myTableView reloadData];
	
	
}

-(void)filterGames{
	
	self.gamesToday = [NSMutableArray array];
	
	for (int i = 0; i < [self.allGames count]; i++) {
		
		Game *tmpGame = [self.allGames objectAtIndex:i];
		
		NSString *date = tmpGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *gameDate = [dateFormat dateFromString:date];
		
		[dateFormat setDateFormat:@"yyyyMMdd"];
		
		NSString *dateOfGame = [dateFormat stringFromDate:gameDate];
		NSString *dateToday = [dateFormat stringFromDate:self.dateSelected];
		
		if ([dateOfGame isEqualToString:dateToday]) {
			[self.gamesToday addObject:tmpGame];
		}
		
	}

}

-(void)filterPractices{
	
	self.practicesToday = [NSMutableArray array];
	
	for (int i = 0; i < [self.allPractices count]; i++) {
		
		Practice *tmpGame = [self.allPractices objectAtIndex:i];
		
		NSString *date = tmpGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *gameDate = [dateFormat dateFromString:date];
		
		//Now convert gameDate and self.dateSelected to strings, and do a compare
		
		[dateFormat setDateFormat:@"yyyyMMdd"];
		
		NSString *dateOfGame = [dateFormat stringFromDate:gameDate];
		NSString *dateToday = [dateFormat stringFromDate:self.dateSelected];
		
		if ([dateOfGame isEqualToString:dateToday]) {
			[self.practicesToday addObject:tmpGame];
		}
		
	}
	
}

-(void)filterAllEvents{
	
	self.eventsToday = [NSMutableArray array];
		
	//int count1 = [self.allEvents count];
	
	for (int i = 0; i < [self.allEvents count]; i++) {
		
		if ([[self.allEvents objectAtIndex:i] class]==[Practice class]) {
			
			Practice *tmpGame = [self.allEvents objectAtIndex:i];
			
			NSString *date = tmpGame.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *gameDate = [dateFormat dateFromString:date];
			
			[dateFormat setDateFormat:@"yyyyMMdd"];
			
			NSString *dateOfGame = [dateFormat stringFromDate:gameDate];
			NSString *dateToday = [dateFormat stringFromDate:self.dateSelected];
			
			if ([dateOfGame isEqualToString:dateToday]) {
				[self.eventsToday addObject:tmpGame];
			}
			
			
		}else if ([[self.allEvents objectAtIndex:i] class]==[Game class]) {
			
			Game *tmpGame = [self.allEvents objectAtIndex:i];
			
			NSString *date = tmpGame.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *gameDate = [dateFormat dateFromString:date];
			
			[dateFormat setDateFormat:@"yyyyMMdd"];
			
			NSString *dateOfGame = [dateFormat stringFromDate:gameDate];
			NSString *dateToday = [dateFormat stringFromDate:self.dateSelected];
			
			if ([dateOfGame isEqualToString:dateToday]) {
				[self.eventsToday addObject:tmpGame];
			}
			
			
		}else if ([[self.allEvents objectAtIndex:i] class]==[Event class]) {
			
			Event *tmpEvent = [self.allEvents objectAtIndex:i];
			
			NSString *date = tmpEvent.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *eventDate = [dateFormat dateFromString:date];
			
			[dateFormat setDateFormat:@"yyyyMMdd"];
			
			NSString *dateOfEvent = [dateFormat stringFromDate:eventDate];
			NSString *dateToday = [dateFormat stringFromDate:self.dateSelected];
			
			if ([dateOfEvent isEqualToString:dateToday]) {
				[self.eventsToday addObject:tmpEvent];
			}
			
			
		}else {
			
			//Should never get here
		}
		
	}
	
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Set the back button to just say "Calendar"
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Calendar" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;

	NSUInteger row = [indexPath row];
	
	if (row == 0) {
		//Create new event
		CreateNewEvent *tmp = [[CreateNewEvent alloc] init];
		tmp.eventDate = self.dateSelected;
		[self.navigationController pushViewController:tmp animated:YES];
		
	}else if ([self.eventType isEqualToString:@"game"]) {
		
		Game *currentGame = [self.gamesToday objectAtIndex:row-1];
		
		NSString *userRole = @"";
		NSString *teamId = @"";
		
		teamId = currentGame.teamId;
		userRole = currentGame.userRole;

		
		if (![currentGame.interval isEqualToString:@"-4"]) {
			
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
				 GameMessages *messages = [viewControllers objectAtIndex:3];
				 messages.gameId = currentGame.gameId;
				 messages.teamId = teamId;
				 messages.userRole = userRole;
				 */
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
								
				self.deleteEventType = @"game";
				self.deleteEventTeamId = currentGame.teamId;
				self.deleteEventId = currentGame.gameId;
				
				self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
				self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
				[self.canceledAction showInView:self.view];
				
				
			}
		}


		
	}else if ([self.eventType isEqualToString:@"practice"]) {
		
		PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
		
		
		Practice *currentPractice = [self.practicesToday objectAtIndex:row-1];
		
		NSString *userRole = @"";
		NSString *teamId = @"";
		
		teamId = currentPractice.ppteamId;
		userRole = currentPractice.userRole;
		
		if (currentPractice.isCanceled) {
			
			if ([userRole isEqualToString:@"coordinator"] || [userRole isEqualToString:@"creator"]) {
				
				self.deleteEventType = @"practice";
				self.deleteEventTeamId = currentPractice.ppteamId;
				self.deleteEventId = currentPractice.practiceId;
				
				self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
				self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
				[self.canceledAction showInView:self.view];
				
				
			}
			
		}else {
			
			
			
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
		
	}else if ([self.eventType isEqualToString:@"all"]) {
		
		
		if ([[self.eventsToday objectAtIndex:row-1] class] == [Game class]) {
			
			Game *currentGame = [self.eventsToday objectAtIndex:row-1];
			
			NSString *userRole = @"";
			NSString *teamId = @"";
			
			teamId = currentGame.teamId;
			userRole = currentGame.userRole;
			
			if (![currentGame.interval isEqualToString:@"-4"]) {
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
					
					self.deleteEventType = @"game";
					self.deleteEventTeamId = currentGame.teamId;
					self.deleteEventId = currentGame.gameId;
					
					self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
					self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
					[self.canceledAction showInView:self.view];
					
					
				}
			}

			
			
			
		}else if ([[self.eventsToday objectAtIndex:row-1] class] == [Practice class]) {
			
			PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
			
			
			Practice *currentPractice = [self.eventsToday objectAtIndex:row-1];
			
			NSString *userRole = @"";
			NSString *teamId = @"";
			
			teamId = currentPractice.ppteamId;
			userRole = currentPractice.userRole;
			
			if (currentPractice.isCanceled) {
				
				if ([userRole isEqualToString:@"coordinator"] || [userRole isEqualToString:@"creator"]) {
					
					self.deleteEventType = @"practice";
					self.deleteEventTeamId = currentPractice.ppteamId;
					self.deleteEventId = currentPractice.practiceId;
					
					self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
					self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
					[self.canceledAction showInView:self.view];
					
					
				}
			}else {
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

			
			
		}else {
			EventTabs *currentEventTab = [[EventTabs alloc] init];
			
			
			Event *currentEvent = [self.eventsToday objectAtIndex:row-1];
			
			NSString *userRole = @"";
			NSString *teamId = @"";
			
			teamId = currentEvent.teamId;
			userRole = currentEvent.userRole;
			
			if (currentEvent.isCanceled) {
				if ([userRole isEqualToString:@"coordinator"] || [userRole isEqualToString:@"creator"]) {
					
					self.deleteEventType = @"event";
					self.deleteEventTeamId = currentEvent.teamId;
					self.deleteEventId = currentEvent.eventId;
					
					self.canceledAction = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
					self.canceledAction.actionSheetStyle = UIActionSheetStyleDefault;
					[self.canceledAction showInView:self.view];
					
					
				}
			}else {
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

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == self.deleteAction) {
		
		if (buttonIndex == 0) {
			
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Delete Event"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			//run the delete
			[self.deleteActivity startAnimating];
			[self performSelectorInBackground:@selector(runDelete) withObject:nil];
		}else if (buttonIndex == 1) {
			//Cancel
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Cancel Event"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			[self.deleteActivity startAnimating];
			[self performSelectorInBackground:@selector(cancelEvent) withObject:nil];
		}else {
			
		}


	}else if (actionSheet == self.canceledAction) {
		
		if (buttonIndex == 0) {
			
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Delete Event"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			//run the delete
			[self.deleteActivity startAnimating];
			[self performSelectorInBackground:@selector(runDelete) withObject:nil];
		}else if (buttonIndex == 1){
			//Cancel
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Activate Event"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
			[self.deleteActivity startAnimating];
			[self performSelectorInBackground:@selector(activateEvent) withObject:nil];
		}else {
			
		}

		
	}
	
	else {
		[FastActionSheet doAction:self :buttonIndex];

	}

	
	
	
}


-(void)runDelete{

	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([self.deleteEventType isEqualToString:@"game"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteGame:token :self.deleteEventTeamId :self.deleteEventId];
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    if ([self.eventType isEqualToString:@"game"]) {
                        
                        if ([self.gamesToday count] == 1) {
                            
                            self.emptyGames = true;
                            
                        }else {
                            [self.gamesToday removeObjectAtIndex:self.deleteCell];
                            
                        }
                        
                        
                    }else {
                        if ([self.eventsToday count] == 1) {
                            
                            self.emptyEvents = true;
                            
                        }else {
                            [self.eventsToday removeObjectAtIndex:self.deleteCell];
                            
                        }
                    }
                    
                    self.gDelete = true;
                    
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            //self.error.text = @"*Error connecting to server";
                            break;
                        case 205:
                            self.errorString = @"NA";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
                
                
            }
            
        }else if ([self.deleteEventType isEqualToString:@"practice"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteEvent:token :self.deleteEventTeamId :self.deleteEventId];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    self.pDelete = true;
                    
                    if ([self.eventType isEqualToString:@"practice"]) {
                        
                        if ([self.practicesToday count] == 1) {
                            
                            self.emptyPractices = true;
                            
                        }else {
                            [self.practicesToday removeObjectAtIndex:self.deleteCell];
                            
                        }
                    }else {
                        
                        if ([self.eventsToday count] == 1) {
                            
                            self.emptyEvents = true;
                            
                        }else {
                            [self.eventsToday removeObjectAtIndex:self.deleteCell];
                            
                        }
                    }
                    
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
                        case 205:
                            self.errorString = @"NA";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
        }else {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteEvent:token :self.deleteEventTeamId :self.deleteEventId];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    self.eDelete = true;
                    
                    
                    if ([self.eventsToday count] == 1) {
                        
                        self.emptyEvents = true;
                        
                    }else {
                        [self.eventsToday removeObjectAtIndex:self.deleteCell];
                        
                    }
                    
                    
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
                        case 205:
                            self.errorString = @"NA";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
            
            
        }
        
        
        [self performSelectorOnMainThread:@selector(doneDelete) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)doneDelete{
	
    if ([self.errorString isEqualToString:@"NA"]) {
        self.errorString = @"";
        NSString *tmp = @"You are not a coordinator, or you have not confirmed your email.  Only User's with confirmed email addresses can delete events.  To confirm your email, please click on the activation link in the email we sent you.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
	if (self.emptyGames) {
		self.emptyGames = false;
		[self.gamesToday removeObjectAtIndex:0];
	}
	
	if (self.emptyPractices) {
		[self.practicesToday removeObjectAtIndex:0];
		self.emptyPractices = false;
	}
	
	if (self.emptyEvents) {
		[self.eventsToday removeObjectAtIndex:0];
		self.emptyEvents = false;
	}
	
	
	if (self.gDelete) {
		self.gDelete = false;
		for (int i = 0; i < [self.allGames count]; i++) {
			Game *tmpGame = [self.allGames objectAtIndex:i];
			
			if ([tmpGame.gameId isEqualToString:self.deleteEventId]) {
				
				[self.allGames removeObjectAtIndex:i];
				break;
			}
		}
		
		
		for (int i = 0; i < [self.allEvents count]; i++) {
			
			if ([[self.allEvents objectAtIndex:i] class] == [Game class]) {
				Game *tmpGame = [self.allEvents objectAtIndex:i];
				
				if ([tmpGame.gameId isEqualToString:self.deleteEventId]) {
					
					[self.allEvents removeObjectAtIndex:i];
					break;
				}
			}
	
		}
		
	
	}
	
	if (self.pDelete) {
		self.pDelete = false;
		for (int i = 0; i < [self.allPractices count]; i++) {
			Practice *tmpGame = [self.allPractices objectAtIndex:i];
			
			if ([tmpGame.practiceId isEqualToString:self.deleteEventId]) {
				
				[self.allPractices removeObjectAtIndex:i];
				break;
			}
		}
		
		for (int i = 0; i < [self.allEvents count]; i++) {
			
			if ([[self.allEvents objectAtIndex:i] class] == [Practice class]) {
				Practice *tmpGame = [self.allEvents objectAtIndex:i];
				
				if ([tmpGame.practiceId isEqualToString:self.deleteEventId]) {
					[self.allEvents removeObjectAtIndex:i];
					break;
				}
			}
		
		}
		
	}
	
	if (self.eDelete) {
		self.eDelete = false;
		for (int i = 0; i < [self.allGenericEvents count]; i++) {
			Event *tmpGame = [self.allGenericEvents objectAtIndex:i];
			
			if ([tmpGame.eventId isEqualToString:self.deleteEventId]) {
				
				[self.allGenericEvents removeObjectAtIndex:i];
				break;
			}
		}
		
		for (int i = 0; i < [self.allEvents count]; i++) {
		
			if ([[self.allEvents objectAtIndex:i] class] == [Event class]) {
				Event *tmpGame = [self.allEvents objectAtIndex:i];
				
				if ([tmpGame.eventId isEqualToString:self.deleteEventId]) {
					[self.allEvents removeObjectAtIndex:i];
					break;
				}
			}
		}

		
	}
	
	

	[self.deleteActivity stopAnimating];

	//[calendarView refreshViewWithPushDirection:nil];
    [calendarView performSelector:@selector(refreshViewWithPushDirection:) withObject:nil];

	[myTableView reloadData];
}



-(void)cancelEvent{

    @autoreleasepool {
        //Cancel Event
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([self.deleteEventType isEqualToString:@"game"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateGame:token :self.deleteEventTeamId :self.deleteEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"-4" :@"" :@"" :@""];
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    if ([self.eventType isEqualToString:@"game"]) {
                        Game *tmpEvent = [self.gamesToday objectAtIndex:self.deleteCell];
                        tmpEvent.interval = @"-4";
                        
                        [self.gamesToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }else {
                        Game *tmpEvent = [self.eventsToday objectAtIndex:self.deleteCell];
                        tmpEvent.interval = @"-4";
                        
                        [self.eventsToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }
                    
                    
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
            
        }else if ([self.deleteEventType isEqualToString:@"practice"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.deleteEventTeamId :self.deleteEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    if ([self.eventType isEqualToString:@"practice"]) {
                        Practice *tmpEvent = [self.practicesToday objectAtIndex:self.deleteCell];
                        tmpEvent.isCanceled = false;
                        
                        [self.practicesToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }else {
                        Practice *tmpEvent = [self.eventsToday objectAtIndex:self.deleteCell];
                        tmpEvent.isCanceled = false;
                        
                        [self.eventsToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }
                    
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
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.deleteEventTeamId :self.deleteEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    Event *tmpEvent = [self.eventsToday objectAtIndex:self.deleteCell];
                    tmpEvent.isCanceled = true;
                    
                    [self.eventsToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    
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

    }
		
}

-(void)activateEvent{
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([self.deleteEventType isEqualToString:@"game"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateGame:token :self.deleteEventTeamId :self.deleteEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"0" :@"" :@"" :@""];
                
                
                NSString *status = [response valueForKey:@"status"];
                
                
                if ([status isEqualToString:@"100"]){
                    
                    if ([self.eventType isEqualToString:@"game"]) {
                        Game *tmpEvent = [self.gamesToday objectAtIndex:self.deleteCell];
                        tmpEvent.interval = @"0";
                        
                        [self.gamesToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }else {
                        Game *tmpEvent = [self.eventsToday objectAtIndex:self.deleteCell];
                        tmpEvent.interval = @"0";
                        
                        [self.eventsToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }
                    
                    
                    
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
            
        }else if ([self.deleteEventType isEqualToString:@"practice"]) {
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.deleteEventTeamId :self.deleteEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
                NSString *status = [response valueForKey:@"status"];
                
                
                if ([status isEqualToString:@"100"]){
                    
                    if ([self.eventType isEqualToString:@"practice"]) {
                        Practice *tmpEvent = [self.practicesToday objectAtIndex:self.deleteCell];
                        tmpEvent.isCanceled = false;
                        
                        [self.practicesToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }else {
                        Practice *tmpEvent = [self.eventsToday objectAtIndex:self.deleteCell];
                        tmpEvent.isCanceled = false;
                        
                        [self.eventsToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    }
                    
                    
                    
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
            
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.deleteEventTeamId :self.deleteEventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    Event *tmpEvent = [self.eventsToday objectAtIndex:self.deleteCell];
                    tmpEvent.isCanceled = false;
                    
                    [self.eventsToday replaceObjectAtIndex:self.deleteCell withObject:tmpEvent];
                    
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

    }
		
}


-(void)doneEventEdit{
	
	[self.deleteActivity stopAnimating];
	[myTableView reloadData];
	
}


- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)viewDidUnload{
	
	/*
	allGames =nil;
	gamesToday =nil;
	allPractices =nil;
	practicesToday =nil;
	allEvents =nil;
	eventsToday =nil;
	eventType =nil;
	dateSelected =nil;
	error =nil;
	allGenericEvents =nil;
	deleteEventId = nil;
	deleteEventType = nil;
	deleteEventTeamId = nil;
	*/
	
	
	deleteAction = nil;
	deleteActivity = nil;
	myTableView =nil;
	tile =nil;
	loadingActivity = nil;
	activityLabel = nil;
	calendarView =nil;
	currentTile =nil;
	bottomBar =nil;
	segmentedControl =nil;
	myTableView = nil;

	[super viewDidUnload];
}


@end
