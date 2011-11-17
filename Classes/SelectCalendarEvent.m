//
//  SelectCalendarEvent.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "SelectCalendarEvent.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Game.h"
#import "Practice.h"
#import "KLDate.h"
#import "Event.h"
#import "FastActionSheet.h"
#import "CalendarEventObject.h"
#import "CurrentTeamTabs.h"
#import "AllEventsCalendar.h"
#import "rTeamAppDelegate.h"
#import "GANTracker.h"

@implementation SelectCalendarEvent
@synthesize shouldPushAnotherView, allEvents, eventType, dateSelected, error, eventLabel, eventTimeField, removeEventButton, errorLabel, activity,
timePicker, cancelTimeButton, okTimeButton, explainPickerView, explainPickerLabel, isEventToday, addEventButton, errorString, teamId, createButton;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)create{
	
	[self.activity startAnimating];
	
	self.createButton.enabled = NO;
	self.eventTimeField.enabled = NO;
	self.removeEventButton.enabled = NO;
	self.addEventButton.enabled = NO;
	
	self.timePicker.hidden = YES;
	self.explainPickerView.hidden = YES;
	self.explainPickerLabel.hidden = YES;
	self.okTimeButton.hidden = YES;
	self.cancelTimeButton.hidden = YES;
	
	if ([self.eventType isEqualToString:@"game"]) {
		
		[self performSelectorInBackground:@selector(createGames) withObject:nil];

		
	}else if ([self.eventType isEqualToString:@"practice"]) {
		
		[self performSelectorInBackground:@selector(createPractices) withObject:nil];

		
	}else {
		
		[self performSelectorInBackground:@selector(createEvents) withObject:nil];

	}

	
}

-(void)viewDidLoad{
	
	if ([self.eventType isEqualToString:@"game"]) {
		self.title = @"Add Game(s)";
	}else if ([self.eventType isEqualToString:@"practice"]) {
		self.title = @"Add Practice(s)";
	}else {
		self.title = @"Add Event(s)";

	}

	NSDateFormatter *tmp = [[NSDateFormatter alloc] init];
	[tmp setDateFormat:@"hh:mm aa"];
	NSString *tmpDate = @"10:00 AM";
	NSDate *theDate = [tmp dateFromString:tmpDate];
	self.timePicker.date = theDate;

	NSString *message = @"To add an Event, click a date on the calendar, then enter the Event time.  When you are done, click 'Create' in the upper right corner to create the Events.";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Creating Events" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	self.createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleBordered target:self action:@selector(create)];
	[self.navigationItem setRightBarButtonItem:self.createButton];
	
	self.allEvents = [NSMutableArray array];
	self.dateSelected = [NSDate date];
	
	
	calendarView = [[KLCalendarView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,  320.0f, 280) delegate:self];
	
	[self.view addSubview:calendarView];
	[self.view sendSubviewToBack:calendarView];
		
	self.eventLabel.hidden = YES;
	self.eventTimeField.hidden = YES;
	self.removeEventButton.hidden = YES;
	self.timePicker.hidden = YES;
	self.okTimeButton.hidden = YES;
	self.cancelTimeButton.hidden = YES;
	self.explainPickerView.hidden = YES;
	self.explainPickerLabel.hidden = YES;
	self.addEventButton.hidden = YES;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.removeEventButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.okTimeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.cancelTimeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addEventButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
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
	
	NSDate *todaysDate = [NSDate date];
    NSString *tempDateToday = [dateFormat stringFromDate:todaysDate];

    
	if ([todaysDate isEqualToDate:[todaysDate earlierDate:self.dateSelected]] || [tempDateToday isEqualToString:stringDate]) {
		
		self.dateSelected = formatedDate;

		//Check to see if there is already an Event on this date
		
		self.isEventToday = false;
		
		NSString *timeEventToday = @"";
		for (int i = 0; i < [self.allEvents count]; i++){
			
			CalendarEventObject *tmp = [self.allEvents objectAtIndex:i];
			
			if ([tmp.eventDate isEqualToDate:formatedDate]){
				//There is an event today
				self.isEventToday = true;
				
				NSDate *tmpTime = tmp.eventTime;
				NSDateFormatter *tmpFormat = [[NSDateFormatter alloc] init];
				[tmpFormat setDateFormat:@"hh:mm aa"];
				timeEventToday = [tmpFormat stringFromDate:tmpTime];
				
				break;
			}
		}
		
		if (self.isEventToday) {
			
			self.eventLabel.hidden = NO;
			self.eventLabel.text = [NSString stringWithFormat:@"Time for Event on %@/%@", month, day];
			self.addEventButton.hidden = YES;
			self.removeEventButton.hidden = NO;
			self.eventTimeField.text = timeEventToday;
			self.eventTimeField.hidden = NO;
			
		}else {
			
			self.timePicker.hidden = NO;
			self.cancelTimeButton.hidden = NO;
			self.okTimeButton.hidden = NO;
			self.explainPickerView.hidden = NO;
			self.explainPickerLabel.hidden = NO;
			self.explainPickerLabel.text = [NSString stringWithFormat:@"Select the time for the Event on %@/%@", month, day];
			
			self.eventLabel.hidden = NO;
			self.eventLabel.text = [NSString stringWithFormat:@"No Event currently on %@/%@", month, day];
			self.eventTimeField.hidden = YES;
			
		}

		

	}
	
	
}

-(void)addEvent{
	
	self.timePicker.hidden = NO;
	self.cancelTimeButton.hidden = NO;
	self.okTimeButton.hidden = NO;
	self.explainPickerView.hidden = NO;
	self.explainPickerLabel.hidden = NO;
	
	self.eventLabel.hidden = NO;
	self.eventLabel.text = @"No Event on this date.";
	self.eventTimeField.hidden = NO;
	
}

-(IBAction)timeEditStart{
	
	[self.eventTimeField resignFirstResponder];
	self.timePicker.hidden = NO;
	self.okTimeButton.hidden = NO;
	self.cancelTimeButton.hidden = NO;
	self.explainPickerView.hidden = NO;
	self.explainPickerLabel.hidden = NO;
}

-(IBAction)okTime{
	
	NSString *timeEventToday = @"";
	NSDate *tmpTime = self.timePicker.date;
	NSDateFormatter *tmpFormat = [[NSDateFormatter alloc] init];
	[tmpFormat setDateFormat:@"hh:mm aa"];
	timeEventToday = [tmpFormat stringFromDate:tmpTime];
	
	NSString *dateTodayString = @"";
	[tmpFormat setDateFormat:@"MM/dd"];
	dateTodayString = [tmpFormat stringFromDate:self.dateSelected];
	
	if (self.isEventToday) {
		//Replace the Time of the Event that is today with the new time;
		int eventIndex;
		NSDate *tmpDate = [NSDate date];
		
		for (int i = 0; i < [self.allEvents count]; i++){
			
			CalendarEventObject *tmp = [self.allEvents objectAtIndex:i];
			
			if ([tmp.eventDate isEqualToDate:self.dateSelected]){
				//found the event today
				eventIndex = i;
				tmpDate = tmp.eventDate;
				break;
			}
		}
		
		CalendarEventObject *newObject = [[CalendarEventObject alloc] init];
		newObject.eventDate = tmpDate;
		newObject.eventTime = tmpTime;
		[self.allEvents replaceObjectAtIndex:eventIndex withObject:newObject];
		
	}else {
	
		CalendarEventObject *tmp = [[CalendarEventObject alloc] init];
		
		tmp.eventDate = [self.dateSelected copy];
		tmp.eventTime = tmpTime;
		
		[self.allEvents addObject:tmp];
		
		
		//[calendarView refreshViewWithPushDirection:nil];
        [calendarView performSelector:@selector(refreshViewWithPushDirection:) withObject:nil];
		
	}

	
	self.eventTimeField.text = timeEventToday;
	self.eventTimeField.hidden = NO;
	self.eventLabel.text = [NSString stringWithFormat:@"Time for Event on %@", dateTodayString];
	self.removeEventButton.hidden = NO;
	self.addEventButton.hidden = YES;
	self.explainPickerView.hidden = YES;
	self.explainPickerLabel.hidden = YES;
	self.okTimeButton.hidden = YES;
	self.cancelTimeButton.hidden = YES;
	self.timePicker.hidden = YES;
	
}


-(IBAction)cancelTime{
	
	if (!self.isEventToday) {
		self.addEventButton.hidden = NO;
		self.eventTimeField.hidden = YES;
		self.removeEventButton.hidden = YES;
	}else {
		self.addEventButton.hidden = YES;
		self.removeEventButton.hidden = NO;
	}

	
	self.explainPickerView.hidden = YES;
	self.explainPickerLabel.hidden = YES;
	self.okTimeButton.hidden = YES;
	self.cancelTimeButton.hidden = YES;
	self.timePicker.hidden = YES;
}


-(IBAction)removeEvent{
	
	int eventIndex;
	NSString *todayTimeString = @"";
	
	for (int i = 0; i < [self.allEvents count]; i++){
		
		CalendarEventObject *tmp = [self.allEvents objectAtIndex:i];
		
		if ([tmp.eventDate isEqualToDate:self.dateSelected]){
			//found the event today
			eventIndex = i;			
			NSDateFormatter *tmp = [[NSDateFormatter alloc] init];
			[tmp setDateFormat:@"MM/dd"];
			todayTimeString = [tmp stringFromDate:self.dateSelected];
			break;
		}
	}
	
	[self.allEvents removeObjectAtIndex:eventIndex];
	
	self.eventTimeField.hidden = YES;
	self.removeEventButton.hidden = YES;
	self.addEventButton.hidden = NO;
	self.eventLabel.text = [NSString stringWithFormat:@"No Event currently on %@", todayTimeString];
	
	//[calendarView refreshViewWithPushDirection:nil];
    [calendarView performSelector:@selector(refreshViewWithPushDirection:) withObject:nil];

	
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
	
		
		for (int i = 0; i < [self.allEvents count]; i++){
			
			CalendarEventObject *tmpEvent = [self.allEvents objectAtIndex:i];
				
			NSDate *tmpEventDate = tmpEvent.eventDate;
				
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"yyyy-MM-dd"];
			
			NSString *testDate = [format stringFromDate:tmpEventDate];
			
	
			
			if ([testDate isEqualToString:stringDate]) {
				
				check = true;
				break;
				
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
    
	CGRect newFrame;
    switch (weeks) {
        case 4:
            adjustment = (92/321)*360+30;
            break;
        case 5:
            newFrame = CGRectMake(0.0, 0.0, 320.0, 280.0 - 46.0);
            break;
        case 6:
            newFrame = CGRectMake(0.0, 0.0, 320.0, 280);
            break;
        default:
            break;
    }
	
	
	calendarView.frame = newFrame;
	
	tile = nil;
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



-(void)createGames{

	
	//Create the new game
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGameArray = [NSMutableArray array];
	NSArray *gameArray = [NSArray array];
	
	//Not using lat/long right now
	NSString *theDescription = @"No description entered...";
	NSString *theOpponent = @"Opponent TBD";
	
	
	for(int i = 0; i < [self.allEvents count]; i++){
		
		NSString *dateString = @"";
		NSString *timeString = @"";
		
		NSString *startDateString = @"";
		
		CalendarEventObject *tmpGameObject = [self.allEvents objectAtIndex:i];
		
		NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
		
		[tmpGame setObject:theDescription forKey:@"description"];
		[tmpGame setObject:theOpponent forKey:@"opponent"];
		
		
		NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
		
		[tmpFormatter setDateFormat:@"yyyy-MM-dd"];
		dateString = [tmpFormatter stringFromDate:tmpGameObject.eventDate];
		
		[tmpFormatter setDateFormat:@"HH:mm"];
		timeString = [tmpFormatter stringFromDate:tmpGameObject.eventTime];
		
		startDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
				
		[tmpGame setObject:startDateString forKey:@"startDate"];
		
		NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
		
		[tmpGameArray addObject:tmpGame1];
		

	}

	gameArray = tmpGameArray;
    
    NSError *errors;
    //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Create Games - Multiple (Calendar)"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	
	NSDictionary *response = [ServerAPI createMultipleGames:mainDelegate.token :self.teamId :@"plain" :gameArray];
	
	NSString *status = [response valueForKey:@"status"];
	
	
	if ([status isEqualToString:@"100"]){
		
		self.errorString = @"";
		
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
            case 205:
				//error connecting to server
				self.errorString = @"*You must be a coordinator to add events.";
				break;
			default:
				//Log the status code?
				self.errorString = @"*Error connecting to server";
				break;
		}
	}
	
	
	[self performSelectorOnMainThread:
	 @selector(doneCreate)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
	
	
	
}


-(void)doneCreate{
	
	[self.activity stopAnimating];
	self.createButton.enabled = YES;
	self.eventTimeField.enabled = YES;
	self.removeEventButton.enabled = YES;
	self.addEventButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
		NSArray *views = [self.navigationController viewControllers];
		
		if ([[views objectAtIndex:[views count] - 4] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *tmp = [views objectAtIndex:[views count] - 4];
			tmp.selectedIndex = 3;
			
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 4] class] == [AllEventsCalendar class]) {
			AllEventsCalendar *tmp = [views objectAtIndex:[views count] - 4];
			tmp.createdEvent = true;
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 5] class] == [AllEventsCalendar class]) {
			AllEventsCalendar *tmp = [views objectAtIndex:[views count] - 5];
			tmp.createdEvent = true;
			[self.navigationController popToViewController:tmp animated:NO];
		}
		
	}else {
		
		NSString *message = @"Error creating events.  Please make sure you have a valid internet conneciton.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
	}

	
}


-(void)createPractices{

	
	//Create the new game
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGameArray = [NSMutableArray array];
	NSArray *gameArray = [NSArray array];
	
	//Not using lat/long right now
	NSString *theDescription = @"No description entered...";
	NSString *theLocation = @"Location TBD";
	
	
	for(int i = 0; i < [self.allEvents count]; i++){
		
		NSString *dateString = @"";
		NSString *timeString = @"";
		
		NSString *startDateString = @"";
		
		CalendarEventObject *tmpGameObject = [self.allEvents objectAtIndex:i];
		
		NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
		
		[tmpGame setObject:theDescription forKey:@"description"];
		[tmpGame setObject:theLocation forKey:@"opponent"];
		[tmpGame setObject:@"practice" forKey:@"eventType"];

		
		
		NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
		
		[tmpFormatter setDateFormat:@"yyyy-MM-dd"];
		dateString = [tmpFormatter stringFromDate:tmpGameObject.eventDate];
		
		[tmpFormatter setDateFormat:@"HH:mm"];
		timeString = [tmpFormatter stringFromDate:tmpGameObject.eventTime];
		
		startDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
		
		[tmpGame setObject:startDateString forKey:@"startDate"];
		
		NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];		
		[tmpGameArray addObject:tmpGame1];
		
		
	}
	
	gameArray = tmpGameArray;
	
    NSError *errors;
    //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Create Practice - Multiple (Calendar)"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	NSDictionary *response = [ServerAPI createMultipleEvents:mainDelegate.token :self.teamId :@"plain" :gameArray];
	
	NSString *status = [response valueForKey:@"status"];
	
	
	if ([status isEqualToString:@"100"]){
		
		self.errorString = @"";
		
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
            case 205:
				//error connecting to server
				self.errorString = @"*You must be a coordinator to add events.";
				break;
			default:
				//Log the status code?
				self.errorString = @"*Error connecting to server";
				break;
		}
	}
	
	
	[self performSelectorOnMainThread:
	 @selector(donePractices)
						   withObject:nil
						waitUntilDone:NO
	 ];

}


-(void)donePractices{
	
	[self.activity stopAnimating];
	self.createButton.enabled = YES;
	self.eventTimeField.enabled = YES;
	self.removeEventButton.enabled = YES;
	self.addEventButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
		NSArray *views = [self.navigationController viewControllers];
		
		if ([[views objectAtIndex:[views count] - 4] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *tmp = [views objectAtIndex:[views count] - 4];
			
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 4] class] == [AllEventsCalendar class]) {
			AllEventsCalendar *tmp = [views objectAtIndex:[views count] - 4];
			tmp.createdEvent = true;
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 5] class] == [AllEventsCalendar class]) {
			AllEventsCalendar *tmp = [views objectAtIndex:[views count] - 5];
            tmp.createdEvent = true;

			[self.navigationController popToViewController:tmp animated:NO];
		}
		
	}else {
		
		NSString *message = @"Error creating events.  Please make sure you have a valid internet conneciton.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
	}
	
}




-(void)createEvents{
	
	
	//Create the new game
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGameArray = [NSMutableArray array];
	NSArray *gameArray = [NSArray array];
	
	//Not using lat/long right now
	NSString *theDescription = @"No description entered...";
	NSString *theLocation = @"Location TBD";
	
	
	for(int i = 0; i < [self.allEvents count]; i++){
		
		NSString *dateString = @"";
		NSString *timeString = @"";
		
		NSString *startDateString = @"";
		
		CalendarEventObject *tmpGameObject = [self.allEvents objectAtIndex:i];
		
		NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
		
		[tmpGame setObject:theDescription forKey:@"description"];
		[tmpGame setObject:theLocation forKey:@"opponent"];
		[tmpGame setObject:@"generic" forKey:@"eventType"];
		[tmpGame setObject:@"No Event Name" forKey:@"eventName"];

		
		
		NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
		
		[tmpFormatter setDateFormat:@"yyyy-MM-dd"];
		dateString = [tmpFormatter stringFromDate:tmpGameObject.eventDate];
		
		[tmpFormatter setDateFormat:@"HH:mm"];
		timeString = [tmpFormatter stringFromDate:tmpGameObject.eventTime];
		
		startDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
		
		[tmpGame setObject:startDateString forKey:@"startDate"];
		
		NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
		
		[tmpGameArray addObject:tmpGame1];
		
		
	}
	
	gameArray = tmpGameArray;
    
    NSError *errors;
    //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Create Event - Multiple (Calendar)"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	
	NSDictionary *response = [ServerAPI createMultipleEvents:mainDelegate.token :self.teamId :@"plain" :gameArray];
	
	NSString *status = [response valueForKey:@"status"];
	
	
	if ([status isEqualToString:@"100"]){
		
		self.errorString = @"";
		
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
            case 205:
				//error connecting to server
				self.errorString = @"*You must be a coordinator to add events.";
				break;
			default:
				//Log the status code?
				self.errorString = @"*Error connecting to server";
				break;
		}
	}
	
	
	[self performSelectorOnMainThread:
	 @selector(doneEvents)
						   withObject:nil
						waitUntilDone:NO
	 ];
    
	
	
}


-(void)doneEvents{
	
	[self.activity stopAnimating];
	self.createButton.enabled = YES;
	self.eventTimeField.enabled = YES;
	self.removeEventButton.enabled = YES;
	self.addEventButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
		NSArray *views = [self.navigationController viewControllers];
		
		if ([[views objectAtIndex:[views count] - 4] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *tmp = [views objectAtIndex:[views count] - 4];
			tmp.selectedIndex = 3;
			
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 4] class] == [AllEventsCalendar class]) {
			AllEventsCalendar *tmp = [views objectAtIndex:[views count] - 4];
            tmp.createdEvent = true;

			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 5] class] == [AllEventsCalendar class]) {
			AllEventsCalendar *tmp = [views objectAtIndex:[views count] - 5];
            tmp.createdEvent = true;

			[self.navigationController popToViewController:tmp animated:NO];
		}

		
		
	}else {
		
		NSString *message = @"Error creating events.  Please make sure you have a valid internet conneciton.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	
}


-(void)viewDidUnload{
	
	eventLabel = nil;
	calendarView =nil;
	eventTimeField = nil;
	removeEventButton = nil;
	timePicker = nil;
	cancelTimeButton = nil;
	okTimeButton = nil;
	explainPickerView = nil;
	explainPickerLabel = nil;
	errorLabel = nil;
	activity = nil;
	[super viewDidUnload];
}



@end

