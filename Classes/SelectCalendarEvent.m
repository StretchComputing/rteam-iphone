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
#import "Home.h"
#import "GoogleAppEngine.h"
#import "SelectTeamCal.h"

@implementation SelectCalendarEvent
@synthesize shouldPushAnotherView, allEvents, eventType, dateSelected, error, eventLabel, eventTimeField, removeEventButton, errorLabel, activity,
timePicker, cancelTimeButton, okTimeButton, explainPickerView, explainPickerLabel, isEventToday, addEventButton, errorString, teamId, createButton, infoView, infoTextField, infoSegControl, allGames, allGenerics, allPractices, areGames, areEvents, arePractices, doneGames, doneEvents, donePractices, haveDate;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)create{
	
    
    if ([self.allEvents count] > 0) {
        [self.activity startAnimating];
        
        self.createButton.enabled = NO;
        self.eventTimeField.enabled = NO;
        self.removeEventButton.enabled = NO;
        self.addEventButton.enabled = NO;
        
        self.timePicker.hidden = YES;
        self.explainPickerView.hidden = YES;
        self.infoView.hidden = YES;
        
        self.explainPickerLabel.hidden = YES;
        self.okTimeButton.hidden = YES;
        self.cancelTimeButton.hidden = YES;
        
        
        for (int i = 0; i < [self.allEvents count]; i++) {
            
            CalendarEventObject *tmp = (self.allEvents)[i];
            
            if ([tmp.eventType isEqualToString:@"game"]){
                [self.allGames addObject:tmp];
            }else if ([tmp.eventType isEqualToString:@"practice"]){
                [self.allPractices addObject:tmp];
            }else{
                [self.allGenerics addObject:tmp];
            }
        }
        
        self.doneGames = false;
        self.donePractices = false;
        self.doneEvents = false;
        
        self.areGames = false;
        self.arePractices = false;
        self.areEvents = false;


        if ([self.allGames count] > 0) {
            self.areGames = true;
            
            [self performSelectorInBackground:@selector(createGames) withObject:nil];
        }
            
        if ([self.allPractices count] > 0) {
            self.arePractices = true;
            [self performSelectorInBackground:@selector(createPractices) withObject:nil];
        }
            
        if ([self.allGenerics count] > 0) {
            self.areEvents = true;
            [self performSelectorInBackground:@selector(createEvents) withObject:nil];

        }
            
            
        

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Events Added" message:@"You must add at least one event." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
	
	
}

-(void)viewDidLoad{
	
    self.infoSegControl.selectedSegmentIndex = 0;
    self.infoTextField.placeholder = @"Opponent (optional)";
   
   
	self.allGames = [NSMutableArray array];
    self.allPractices = [NSMutableArray array];
	self.allGenerics = [NSMutableArray array];

    self.title = @"Add Event(s)";

	

    
    @try {
        NSDateFormatter *tmp = [[NSDateFormatter alloc] init];
        [tmp setDateFormat:@"hh:mm aa"];
        NSString *tmpDate = @"10:00 AM";
        NSDate *theDate = [tmp dateFromString:tmpDate];
        self.timePicker.date = theDate;
    }
    @catch (NSException *exception) {

         [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - viewDidLoad" logMessage:[exception reason] logLevel:@"exception" exception:exception];
    }
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    if ([mainDelegate.showCreateAlert isEqualToString:@"true"]) {
        mainDelegate.showCreateAlert = @"false";
        
        [mainDelegate saveUserInfo];
        
        NSString *message = @"To add an Event, click a date on the calendar, then enter the Event info.  When you are done, click 'Create' in the upper right corner to create the Events.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Creating Events" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }else{

    }

	
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
    self.infoView.hidden = YES;

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
	
    @try {
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
        
        
        //if ([todaysDate isEqualToDate:[todaysDate earlierDate:self.dateSelected]] || [tempDateToday isEqualToString:stringDate]) {
            
            self.dateSelected = formatedDate;
            
            //Check to see if there is already an Event on this date
            
            self.isEventToday = false;
            
            NSString *timeEventToday = @"";
            for (int i = 0; i < [self.allEvents count]; i++){
                
                CalendarEventObject *tmp = (self.allEvents)[i];
                
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
                self.eventLabel.text = [NSString stringWithFormat:@"Info for Event on %@/%@", month, day];
                self.addEventButton.hidden = YES;
                self.removeEventButton.hidden = NO;
                self.eventTimeField.text = timeEventToday;
                self.eventTimeField.hidden = NO;
                
            }else {
                
                self.timePicker.hidden = NO;
                self.cancelTimeButton.hidden = NO;
                self.okTimeButton.hidden = NO;
                self.explainPickerView.hidden = NO;
                self.infoView.hidden = NO;

                self.explainPickerLabel.hidden = NO;
                self.explainPickerLabel.text = [NSString stringWithFormat:@"Enter info for the Event on %@/%@", month, day];
                
                self.eventLabel.hidden = NO;
                self.eventLabel.text = [NSString stringWithFormat:@"No Event currently on %@/%@", month, day];
                self.eventTimeField.hidden = YES;
                
            }
            
            
            
        //}

    }
    @catch (NSException *exception) {
        
        [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - tappedTile:()" logMessage:[exception reason] logLevel:@"exception" exception:exception];

    }
  
		
	
}

-(void)addEvent{
	
	self.timePicker.hidden = NO;
	self.cancelTimeButton.hidden = NO;
	self.okTimeButton.hidden = NO;
	self.explainPickerView.hidden = NO;
    self.infoView.hidden = NO;

	self.explainPickerLabel.hidden = NO;
	
	self.eventLabel.hidden = NO;
	self.eventLabel.text = @"No Event on this date.";
	self.eventTimeField.hidden = NO;
	
}

-(void)timeEditStart{
	
	[self.eventTimeField resignFirstResponder];
	self.timePicker.hidden = NO;
	self.okTimeButton.hidden = NO;
	self.cancelTimeButton.hidden = NO;
	self.explainPickerView.hidden = NO;
    self.infoView.hidden = NO;

	self.explainPickerLabel.hidden = NO;
}

-(void)okTime{
	
    @try {
        if (self.infoTextField.text == nil) {
            self.infoTextField.text = @"";
        }
        
        if ((self.infoSegControl.selectedSegmentIndex == 2) && [self.infoTextField.text isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name Required." message:@"If you are creating a generic event, you must enter a name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }else{
            
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
                    
                    CalendarEventObject *tmp = (self.allEvents)[i];
                    
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
                (self.allEvents)[eventIndex] = newObject;
                
            }else {
                
                
                
                CalendarEventObject *tmp = [[CalendarEventObject alloc] init];
                
                tmp.eventDate = [self.dateSelected copy];
                tmp.eventTime = tmpTime;
                tmp.infoText = self.infoTextField.text;

                if (infoSegControl.selectedSegmentIndex == 0) {
                    tmp.eventType = @"game";
                }else if (infoSegControl.selectedSegmentIndex == 1){
                    tmp.eventType = @"practice";

                }else{
                    tmp.eventType = @"generic";

                }
                
                [self.allEvents addObject:tmp];
                
                self.infoTextField.text = @"";
                //[calendarView refreshViewWithPushDirection:nil];
                [calendarView performSelector:@selector(refreshViewWithPushDirection:) withObject:nil];
                
            }
            
            
            self.eventTimeField.text = timeEventToday;
            self.eventTimeField.hidden = NO;
            self.eventLabel.text = [NSString stringWithFormat:@"Time for Event on %@", dateTodayString];
            self.removeEventButton.hidden = NO;
            self.addEventButton.hidden = YES;
            self.explainPickerView.hidden = YES;
            self.infoView.hidden = YES;
            
            self.explainPickerLabel.hidden = YES;
            self.okTimeButton.hidden = YES;
            self.cancelTimeButton.hidden = YES;
            self.timePicker.hidden = YES;

            
        }
    }
    @catch (NSException *exception) {
    
        [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - okTime:()" logMessage:[exception reason] logLevel:@"exception" exception:exception];
    }
  
		
}


-(void)cancelTime{
	
	if (!self.isEventToday) {
		self.addEventButton.hidden = NO;
		self.eventTimeField.hidden = YES;
		self.removeEventButton.hidden = YES;
	}else {
		self.addEventButton.hidden = YES;
		self.removeEventButton.hidden = NO;
	}

	
	self.explainPickerView.hidden = YES;
    self.infoView.hidden = YES;

	self.explainPickerLabel.hidden = YES;
	self.okTimeButton.hidden = YES;
	self.cancelTimeButton.hidden = YES;
	self.timePicker.hidden = YES;
}


-(void)removeEvent{
    
	@try {
        int eventIndex;
        NSString *todayTimeString = @"";
        
        for (int i = 0; i < [self.allEvents count]; i++){
            
            CalendarEventObject *tmp = (self.allEvents)[i];
            
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
    @catch (NSException *exception) {
      
        [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - removeEvent:()" logMessage:[exception reason] logLevel:@"exception" exception:exception];

    }
  
	
	
}







- (KLTile *)calendarView:(KLCalendarView *)calendarView1 createTileForDate:(KLDate *)date{
	
	@try {
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
			
			CalendarEventObject *tmpEvent = (self.allEvents)[i];
            
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
    @catch (NSException *exception) {
  
        [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - createTileForDate:()" logMessage:[exception reason] logLevel:@"exception" exception:exception];

    }
  
		
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
    
    @autoreleasepool {

	@try {
            //Create the new game
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSMutableArray *tmpGameArray = [NSMutableArray array];
            NSArray *gameArray = @[];
            
            //Not using lat/long right now
            NSString *theDescription = @"No description entered...";
            NSString *theOpponent = @"Opponent TBD";
            
            
            for(int i = 0; i < [self.allGames count]; i++){
                
                NSString *dateString = @"";
                NSString *timeString = @"";
                
                NSString *startDateString = @"";
                
                CalendarEventObject *tmpGameObject = (self.allGames)[i];
                
                NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
                
                if (![tmpGameObject.infoText isEqualToString:@""]) {
                    theOpponent = tmpGameObject.infoText;
                }
                
                tmpGame[@"description"] = theDescription;
                tmpGame[@"opponent"] = theOpponent;
                
                
                NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
                
                [tmpFormatter setDateFormat:@"yyyy-MM-dd"];
                dateString = [tmpFormatter stringFromDate:tmpGameObject.eventDate];
                
                [tmpFormatter setDateFormat:@"HH:mm"];
                timeString = [tmpFormatter stringFromDate:tmpGameObject.eventTime];
                
                startDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
                
                tmpGame[@"startDate"] = startDateString;
                
                NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
                
                [tmpGameArray addObject:tmpGame1];
                
                
            }
            
            gameArray = tmpGameArray;
            
            
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
             @selector(doneCreateGames)
                                   withObject:nil
                                waitUntilDone:NO
             ];
            
            
        }	

    
    @catch (NSException *exception) {
        
        [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - createGames" logMessage:[exception reason] logLevel:@"exception" exception:exception];

    }
        
    }
   
		
	
	
}


-(void)doneCreateGames{
	
    self.doneGames = true;
    
	[self.activity stopAnimating];
	self.createButton.enabled = YES;
	self.eventTimeField.enabled = YES;
	self.removeEventButton.enabled = YES;
	self.addEventButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
        bool runIt = true;
        
		if (self.arePractices) {
            if (self.donePractices) {
                runIt = true;
            }else{
                runIt = false;
            }
        }   
        
        if (self.areEvents) {
            if (self.doneEvents) {
                runIt = true;
            }else{
                runIt = false;
            }
        }
        
        if (runIt) {
            NSArray *views = [self.navigationController viewControllers];
                                    
            if ([views count] == 1) {
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Create Multiple Games - Gameday"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }else if (([views count] == 2) && ([views[0] class] == [SelectTeamCal class])){
            
                //From Gameday
                [self.navigationController dismissModalViewControllerAnimated:YES];

            
            }else{
                
                if ([views[[views count] - 2] class] == [CurrentTeamTabs class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Event List"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    CurrentTeamTabs *tmp = views[[views count] - 2];
                    tmp.selectedIndex = 3;
                    
                    [self.navigationController popToViewController:tmp animated:NO];
                    
                }else if ([views[[views count] - 2] class] == [AllEventsCalendar class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *tmp = views[[views count] - 2];
                    tmp.createdEvent = true;
                    [self.navigationController popToViewController:tmp animated:NO];
                }else if ([views[[views count] - 3] class] == [AllEventsCalendar class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *tmp = views[[views count] - 3];
                    tmp.createdEvent = true;
                    [self.navigationController popToViewController:tmp animated:NO];
                }
                
                
                
            }

        }
				
	}else {
		
		NSString *message = @"Error creating events.  Please make sure you have a valid internet conneciton.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
	}

	
}


-(void)createPractices{

	
	@autoreleasepool {
        
        @try {
            //Create the new game
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSMutableArray *tmpGameArray = [NSMutableArray array];
            NSArray *gameArray = @[];
            
            //Not using lat/long right now
            NSString *theDescription = @"No description entered...";
            NSString *theLocation = @"Location TBD";
            
            
            for(int i = 0; i < [self.allPractices count]; i++){
                
                NSString *dateString = @"";
                NSString *timeString = @"";
                
                NSString *startDateString = @"";
                
                CalendarEventObject *tmpGameObject = (self.allPractices)[i];
                
                if (![tmpGameObject.infoText isEqualToString:@""]) {
                    theLocation = tmpGameObject.infoText;
                }
                
                NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
                
                tmpGame[@"description"] = theDescription;
                tmpGame[@"opponent"] = theLocation;
                tmpGame[@"eventType"] = @"practice";
                
                
                
                NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
                
                [tmpFormatter setDateFormat:@"yyyy-MM-dd"];
                dateString = [tmpFormatter stringFromDate:tmpGameObject.eventDate];
                
                [tmpFormatter setDateFormat:@"HH:mm"];
                timeString = [tmpFormatter stringFromDate:tmpGameObject.eventTime];
                
                startDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
                
                tmpGame[@"startDate"] = startDateString;
                
                NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];		
                [tmpGameArray addObject:tmpGame1];
                
                
            }
            
            gameArray = tmpGameArray;
            
            
            
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
             @selector(doneCreatePractices)
                                   withObject:nil
                                waitUntilDone:NO
             ];

        }
        @catch (NSException *exception) {
            
             [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - createPractices" logMessage:[exception reason] logLevel:@"exception" exception:exception];
        }
       
       
        
    }
}


-(void)doneCreatePractices{
	
    self.donePractices = true;
    
	[self.activity stopAnimating];
	self.createButton.enabled = YES;
	self.eventTimeField.enabled = YES;
	self.removeEventButton.enabled = YES;
	self.addEventButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
        bool runIt = true;
        
		if (self.areGames) {
            if (self.doneGames) {
                runIt = true;
            }else{
                runIt = false;
            }
        }   
        
        if (self.areEvents) {
            if (self.doneEvents) {
                runIt = true;
            }else{
                runIt = false;
            }
        }
        
        if (runIt) {
            NSArray *views = [self.navigationController viewControllers];
            
            
            if ([views count] == 1) {
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Create Multiple Games - Gameday"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }else if (([views count] == 2) && ([views[0] class] == [SelectTeamCal class])){
                
                
                [self.navigationController dismissModalViewControllerAnimated:YES];
                
                
            }else{
                
                if ([views[[views count] - 2] class] == [CurrentTeamTabs class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Event List"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    CurrentTeamTabs *tmp = views[[views count] - 2];
                    tmp.selectedIndex = 3;
                    
                    [self.navigationController popToViewController:tmp animated:NO];
                    
                }else if ([views[[views count] - 2] class] == [AllEventsCalendar class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *tmp = views[[views count] - 2];
                    tmp.createdEvent = true;
                    [self.navigationController popToViewController:tmp animated:NO];
                }else if ([views[[views count] - 3] class] == [AllEventsCalendar class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *tmp = views[[views count] - 3];
                    tmp.createdEvent = true;
                    [self.navigationController popToViewController:tmp animated:NO];
                }
                
                
            }
            
        }
				
	}else {
		
		NSString *message = @"Error creating events.  Please make sure you have a valid internet conneciton.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
	}
	
}




-(void)createEvents{
	
	
	@autoreleasepool {
        
        @try {
            //Create the new game
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            NSMutableArray *tmpGameArray = [NSMutableArray array];
            NSArray *gameArray = @[];
            
            //Not using lat/long right now
            NSString *theDescription = @"No description entered...";
            NSString *theLocation = @"Location TBD";
            
            
            for(int i = 0; i < [self.allGenerics count]; i++){
                
                NSString *dateString = @"";
                NSString *timeString = @"";
                
                NSString *startDateString = @"";
                
                CalendarEventObject *tmpGameObject = (self.allGenerics)[i];
                
                NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
                
                tmpGame[@"description"] = theDescription;
                tmpGame[@"opponent"] = theLocation;
                tmpGame[@"eventType"] = @"generic";
                tmpGame[@"eventName"] = tmpGameObject.infoText;
                
                
                
                NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
                
                [tmpFormatter setDateFormat:@"yyyy-MM-dd"];
                dateString = [tmpFormatter stringFromDate:tmpGameObject.eventDate];
                
                [tmpFormatter setDateFormat:@"HH:mm"];
                timeString = [tmpFormatter stringFromDate:tmpGameObject.eventTime];
                
                startDateString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
                
                tmpGame[@"startDate"] = startDateString;
                
                NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
                
                [tmpGameArray addObject:tmpGame1];
                
                
            }
            
            gameArray = tmpGameArray;
            
            
            
            
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
             @selector(doneCreateEvents)
                                   withObject:nil
                                waitUntilDone:NO
             ];
            

        }
        @catch (NSException *exception) {
            [GoogleAppEngine sendClientLog:@"SelectCalendarEvent.m - createEvents" logMessage:[exception reason] logLevel:@"exception" exception:exception];
        }
      
                
    }    
	
	
}


-(void)doneCreateEvents{
	
    self.doneEvents = true;
    
	[self.activity stopAnimating];
	self.createButton.enabled = YES;
	self.eventTimeField.enabled = YES;
	self.removeEventButton.enabled = YES;
	self.addEventButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
        bool runIt = true;
        
		if (self.arePractices) {
            if (self.donePractices) {
                runIt = true;
            }else{
                runIt = false;
            }
        }   
        
        if (self.areGames) {
            if (self.doneGames) {
                runIt = true;
            }else{
                runIt = false;
            }
        }
        
        if (runIt) {
            NSArray *views = [self.navigationController viewControllers];
            
            
            if ([views count] == 1) {
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Create Multiple Games - Gameday"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }else{
                
                if ([views[[views count] - 2] class] == [CurrentTeamTabs class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Event List"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    CurrentTeamTabs *tmp = views[[views count] - 2];
                    tmp.selectedIndex = 3;
                    
                    [self.navigationController popToViewController:tmp animated:NO];
                    
                }else if (([views count] == 2) && ([views[0] class] == [SelectTeamCal class])){
                    
                    
                    [self.navigationController dismissModalViewControllerAnimated:YES];
                    
                    
                }else if ([views[[views count] - 2] class] == [AllEventsCalendar class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *tmp = views[[views count] - 2];
                    tmp.createdEvent = true;
                    [self.navigationController popToViewController:tmp animated:NO];
                }else if ([views[[views count] - 3] class] == [AllEventsCalendar class]) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Multiple Games - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *tmp = views[[views count] - 3];
                    tmp.createdEvent = true;
                    [self.navigationController popToViewController:tmp animated:NO];
                }
                
                
            }
            
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
    infoView = nil;
    infoSegControl = nil;
    infoTextField = nil;
	[super viewDidUnload];
}



-(void)segmentSelected{
    
    self.infoTextField.text = @"";
    
    if (self.infoSegControl.selectedSegmentIndex == 0) {
        self.infoTextField.placeholder = @"Opponent (optional)";

    }else if (self.infoSegControl.selectedSegmentIndex == 1){
        
        self.infoTextField.placeholder = @"Location (optional)";

    }else{
        self.infoTextField.placeholder = @"Event Name (required)";

    }
}

-(void)endText{

}

@end

