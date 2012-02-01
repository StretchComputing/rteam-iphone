//
//  DailyWeeklyEvent.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DailyWeeklyEvent.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CalendarEventObject.h"
#import "CurrentTeamTabs.h"
#import "FastActionSheet.h"
#import "AllEventsCalendar.h"
#import "GANTracker.h"
#import "rTeamAppDelegate.h"
#import "Home.h"

@implementation DailyWeeklyEvent
@synthesize frequency, dayPicker, timePicker, startDate, endDate, timeField, dayField, submitButton, okTimeButton, selectDateButton,
startEndPicker, isStart, currentDay, isTime, titleLabel, dayLabel, errorLabel, activity, allEventsArray, eventType, teamId, errorString, location;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewDidLoad{
		
	self.title = @"Recurring Event";
	self.errorLabel.text = @"";
	NSDate *today = [NSDate date];
	self.startEndPicker.minimumDate = today;
	[self.startEndPicker setDate:today];
	
	self.allEventsArray = [NSMutableArray array];
	
	NSDateFormatter *tmp = [[NSDateFormatter alloc] init];
	[tmp setDateFormat:@"hh:mm aa"];
	NSString *tmpDate = @"10:00 AM";
	NSDate *theDate = [tmp dateFromString:tmpDate];
	self.timePicker.date = theDate;
	
	self.dayPicker.delegate = self;
	self.dayPicker.dataSource = self;
	
	self.timePicker.hidden = YES;
	self.dayPicker.hidden = YES;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.okTimeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.selectDateButton setBackgroundImage:stretch forState:UIControlStateNormal];


	self.okTimeButton.hidden = YES;
	
	self.selectDateButton.hidden = YES;
	self.startEndPicker.hidden = YES;
	
	self.dayField.hidden = YES;
	self.dayLabel.hidden = YES;
	
	if ([self.frequency isEqualToString:@"daily"]) {
		
		
		self.titleLabel.text = @"Daily Event";
		
	}else if ([self.frequency isEqualToString:@"weekly"]) {
		
		self.titleLabel.text = @"Weekly Event";

	}else {
		
		self.titleLabel.text = @"Event Every Other Week";

	}


	
}

-(void)submit{
	
	self.errorLabel.text = @"";
	
	if ([self.timeField.text isEqualToString:@""] || [self.startDate.text isEqualToString:@""] ||
		[self.endDate.text isEqualToString:@""]) {
		
		self.errorLabel.text = @"*You must enter a value for each field.";
		
	}else {
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MM/dd/yyyy"];
		
		NSDate *start1 = [format dateFromString:self.startDate.text];
		NSDate *end1 = [format dateFromString:self.endDate.text];
				
		if ([end1 isEqualToDate:[end1 earlierDate:start1]]) {
			self.errorLabel.text = @"*'Start Date' can't be greater than 'End Date'";
		}else {
			
			if ([self.frequency isEqualToString:@"daily"]) {
				
				[self setUpDaily];
				
			}else if ([self.frequency isEqualToString:@"weekly"]) {
				
				[self setUpWeekly];
				
			}else {
				
				[self setUpBiWeekly];
				
			}
			
			if ([self.allEventsArray count] == 0) {
				self.errorLabel.text = @"*No events will be created with this date range.";
			}else if ([self.allEventsArray count] > 30) {
				self.errorLabel.text = @"*You cannot create more than 30 Events at one time.";
			}else {
				[self preCreateEvent];

			}

		}

	
	}

	
}

-(void)preCreateEvent{

	
	
	self.dayField.enabled = NO;
	self.timeField.enabled = NO;
	self.startDate.enabled = NO;
	self.endDate.enabled = NO;
	self.submitButton.enabled = NO;
	[self.activity startAnimating];
	
	if ([self.eventType isEqualToString:@"game"]) {
		
		[self performSelectorInBackground:@selector(createGames) withObject:nil];
		
		
	}else if ([self.eventType isEqualToString:@"practice"]) {
		
		[self performSelectorInBackground:@selector(createPractices) withObject:nil];
		
		
	}else {
		
		[self performSelectorInBackground:@selector(createEvents) withObject:nil];
		
	}
	
	
	
}




-(void)setUpDaily{
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy hh:mm aa"];
	
	NSDate *startNsDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@", self.startDate.text, self.timeField.text]];
	NSDate *endNsDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@", self.endDate.text, self.timeField.text]];
	endNsDate = [endNsDate dateByAddingTimeInterval:60];
	
	NSDate *tmpDate = [startNsDate copy];
	
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	while ([tmpDate isEqualToDate:[tmpDate earlierDate:endNsDate]]) {
		
		//Create an event corresponding to tmpDate, then add "1 day" worth of seconds to the date
		
		
		[format setDateFormat:@"YYYY-MM-dd HH:mm"];
		
		NSString *stringDate = [format stringFromDate:tmpDate];
		
		[tmpArray addObject:stringDate];
		
		tmpDate = [tmpDate dateByAddingTimeInterval:86400];
		
		
	}
	
    
	self.allEventsArray = tmpArray;
	

	
}

-(void)setUpWeekly{
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy hh:mm aa"];
	
	NSDate *startNsDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@", self.startDate.text, self.timeField.text]];
	NSDate *endNsDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@", self.endDate.text, self.timeField.text]];
	endNsDate = [endNsDate dateByAddingTimeInterval:60];
	
	NSDate *tmpDate = [startNsDate copy];
	
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	while ([tmpDate isEqualToDate:[tmpDate earlierDate:endNsDate]]) {
		
		//Create an event corresponding to tmpDate, then add "1 day" worth of seconds to the date
		
		
		[format setDateFormat:@"YYYY-MM-dd HH:mm"];
		
		NSString *stringDate = [format stringFromDate:tmpDate];
		
		[tmpArray addObject:stringDate];
		
		tmpDate = [tmpDate dateByAddingTimeInterval:604800];
		
		
	}
	
    
	self.allEventsArray = tmpArray;
	
	

	
}

-(void)setUpBiWeekly{
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy hh:mm aa"];
	
	NSDate *startNsDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@", self.startDate.text, self.timeField.text]];
	NSDate *endNsDate = [format dateFromString:[NSString stringWithFormat:@"%@ %@", self.endDate.text, self.timeField.text]];
	endNsDate = [endNsDate dateByAddingTimeInterval:60];
	
	NSDate *tmpDate = [startNsDate copy];
	
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	while ([tmpDate isEqualToDate:[tmpDate earlierDate:endNsDate]]) {
		
		//Create an event corresponding to tmpDate, then add "1 day" worth of seconds to the date
		
		
		[format setDateFormat:@"YYYY-MM-dd HH:mm"];
		
		NSString *stringDate = [format stringFromDate:tmpDate];
		
		[tmpArray addObject:stringDate];
		
		tmpDate = [tmpDate dateByAddingTimeInterval:1209600];
		
		
	}
	
	self.allEventsArray = tmpArray;
	
	
	
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
	
	return 7;
}


-(NSString *)pickerView:(UIPickerView *)pickerView
			titleForRow:(NSInteger)row
		   forComponent:(NSInteger)component 
{
	NSArray *tmpArray = [NSArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];

    return [tmpArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

	NSArray *tmpArray = [NSArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
	
	self.currentDay = [tmpArray objectAtIndex:row];

	
}



-(void)okTime{

	if (self.isTime) {
		NSDate *tmpDate = self.timePicker.date;
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"hh:mm aa"];
		
		NSString *tmpString = [format stringFromDate:tmpDate];
		
		self.timeField.text = tmpString;
		
		self.timePicker.hidden = YES;
		self.okTimeButton.hidden =YES;
		
		
	}else {
		self.dayField.text = self.currentDay;
		self.dayPicker.hidden = YES;
		self.okTimeButton.hidden =YES;
	}

	
	
	

	
	self.startDate.enabled = YES;
	self.endDate.enabled = YES;
	self.timeField.enabled = YES;
	self.dayField.enabled = YES;
	
}


-(void)selectDate{
	
	NSDate *tmpDate = self.startEndPicker.date;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MM/dd/yyyy"];
	
	NSString *tmpString = [format stringFromDate:tmpDate];
	
	if (self.isStart) {
		self.startDate.text = tmpString;
	}else {
		self.endDate.text = tmpString;

	}

	
	self.startEndPicker.hidden = YES;
	self.selectDateButton.hidden =YES;
	
	self.startDate.enabled = YES;
	self.endDate.enabled = YES;
	self.timeField.enabled = YES;
	self.dayField.enabled = YES;
	
	
}


-(void)startDateBegin{
	
	self.isStart = true;
	self.errorLabel.text = @"";
	
	self.startEndPicker.hidden = NO;
	self.selectDateButton.hidden = NO;
	[self.startDate resignFirstResponder];
	[self becomeFirstResponder];

	self.startDate.enabled = NO;
	self.endDate.enabled = NO;
	self.timeField.enabled = NO;
	self.dayField.enabled = NO;
	
}

-(void)endDateBegin{
	
	self.isStart = false;
	self.errorLabel.text = @"";
	
	self.startEndPicker.hidden = NO;
	self.selectDateButton.hidden = NO;
	[self.endDate resignFirstResponder];
	[self becomeFirstResponder];

	self.startDate.enabled = NO;
	self.endDate.enabled = NO;
	self.timeField.enabled = NO;
	self.dayField.enabled = NO;
	
}


-(void)timeBegin{
	
	self.isTime = true;
	self.errorLabel.text = @"";
	
	self.timePicker.hidden = NO;
	self.okTimeButton.hidden = NO;
	
	[self.timeField resignFirstResponder];
	[self becomeFirstResponder];

	self.startDate.enabled = NO;
	self.endDate.enabled = NO;
	self.timeField.enabled = NO;
	self.dayField.enabled = NO;
	
}

-(void)dayBegin{
	self.isTime = false;
	self.errorLabel.text = @"";
	
	self.dayPicker.hidden = NO;
	self.okTimeButton.hidden = NO;
	
	[self.dayField resignFirstResponder];
	[self becomeFirstResponder];

	self.startDate.enabled = NO;
	self.endDate.enabled = NO;
	self.timeField.enabled = NO;
	self.dayField.enabled = NO;
}


-(void)endText{
	
	[self becomeFirstResponder];
}



-(void)createGames{
	
	
	//Create the new game
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGameArray = [NSMutableArray array];
	NSArray *gameArray = [NSArray array];
	
	//Not using lat/long right now
	NSString *theDescription = @"No description entered...";
	NSString *theOpponent = @"Opponent TBD";
	
	
	for(int i = 0; i < [self.allEventsArray count]; i++){
		

		NSString *startDateString  = [self.allEventsArray objectAtIndex:i];
		
		NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
		//NSDictionary *tmpGame1 = [[NSDictionary alloc] init];
		
		[tmpGame setObject:theDescription forKey:@"description"];
		[tmpGame setObject:theOpponent forKey:@"opponent"];
		[tmpGame setObject:startDateString forKey:@"startDate"];
        
        if ((self.location.text != nil) && ![self.location.text isEqualToString:@""]){
            [tmpGame setObject:self.location.text forKey:@"location"];
        }
		
		NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
		
		[tmpGameArray addObject:tmpGame1];
		
		
	}
	
	gameArray = tmpGameArray;
	
    NSError *errors;
    //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Create Game - Multiple (Daily/Weekly)"
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
	self.startDate.enabled = YES;
	self.endDate.enabled = YES;
	self.timeField.enabled = YES;
	self.submitButton.enabled = YES;
	
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
		}else if ([[views objectAtIndex:[views count] - 5] class] == [Home class]) {
			Home *tmp = [views objectAtIndex:[views count] - 5];
            
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 4] class] == [Home class]) {
			Home *tmp = [views objectAtIndex:[views count] - 4];
            
			[self.navigationController popToViewController:tmp animated:NO];
		}
		
	}else {
		
		self.errorLabel.text = self.errorString;
		
	}
	
	
}


-(void)createPractices{
	

	
	//Create the new game
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGameArray = [NSMutableArray array];
	NSArray *gameArray = [NSArray array];
	
	//Not using lat/long right now
	NSString *theDescription = @"No description entered...";
    
    NSString *theLocation = @"";
    if ((self.location.text != nil) && ![self.location.text isEqualToString:@""]){
        theLocation = self.location.text;
    }else{
        theLocation = @"Location TBD";

    }
	
	
	for(int i = 0; i < [self.allEventsArray count]; i++){
		
		
		NSString *startDateString  = [self.allEventsArray objectAtIndex:i];
		
		NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
		//NSDictionary *tmpGame1 = [[NSDictionary alloc] init];
		
		[tmpGame setObject:theDescription forKey:@"description"];
		[tmpGame setObject:theLocation forKey:@"opponent"];
		[tmpGame setObject:startDateString forKey:@"startDate"];
		[tmpGame setObject:@"practice" forKey:@"eventType"];
		
		NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
		
		[tmpGameArray addObject:tmpGame1];
		
		
	}
	
	gameArray = tmpGameArray;
	
    NSError *errors;
    //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Create Practice - Multiple (Daily/Weekly)"
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
	self.startDate.enabled = YES;
	self.endDate.enabled = YES;
	self.timeField.enabled = YES;
	self.submitButton.enabled = YES;
	
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
		}else if ([[views objectAtIndex:[views count] - 5] class] == [Home class]) {
			Home *tmp = [views objectAtIndex:[views count] - 5];
            
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 4] class] == [Home class]) {
			Home *tmp = [views objectAtIndex:[views count] - 4];
            
			[self.navigationController popToViewController:tmp animated:NO];
		}
		
	}else {
		
		self.errorLabel.text = self.errorString;

		
	}
	
}



-(void)createEvents{
	

	//Create the new game
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGameArray = [NSMutableArray array];
	NSArray *gameArray = [NSArray array];
	
	//Not using lat/long right now
	NSString *theDescription = @"No description entered...";
    NSString *theLocation = @"";
    if ((self.location.text != nil) && ![self.location.text isEqualToString:@""]){
        theLocation = self.location.text;
    }else{
        theLocation = @"Location TBD";
        
    }
	
	
	for(int i = 0; i < [self.allEventsArray count]; i++){
		
		
		NSString *startDateString  = [self.allEventsArray objectAtIndex:i];
		
		NSMutableDictionary *tmpGame = [[NSMutableDictionary alloc] init];
		//NSDictionary *tmpGame1 = [[NSDictionary alloc] init];
		
		[tmpGame setObject:theDescription forKey:@"description"];
		[tmpGame setObject:theLocation forKey:@"opponent"];
		[tmpGame setObject:startDateString forKey:@"startDate"];
		[tmpGame setObject:@"generic" forKey:@"eventType"];
		
		NSDictionary *tmpGame1 = [NSDictionary dictionaryWithDictionary:tmpGame];
		
		[tmpGameArray addObject:tmpGame1];
		
		
	}	
	gameArray = tmpGameArray;
	
    NSError *errors;
    //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Create Event - Multiple (Daily/Weekly)"
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
	self.startDate.enabled = YES;
	self.endDate.enabled = YES;
	self.timeField.enabled = YES;
	self.submitButton.enabled = YES;
	
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
		}else if ([[views objectAtIndex:[views count] - 5] class] == [Home class]) {
			Home *tmp = [views objectAtIndex:[views count] - 5];
            
			[self.navigationController popToViewController:tmp animated:NO];
		}else if ([[views objectAtIndex:[views count] - 4] class] == [Home class]) {
			Home *tmp = [views objectAtIndex:[views count] - 4];
            
			[self.navigationController popToViewController:tmp animated:NO];
		}
		
	}else {
		
		self.errorLabel.text = self.errorString;

		
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
	
	dayPicker = nil;
	timePicker = nil;
	startDate = nil;
	endDate = nil;
	timeField = nil;
	dayField = nil;
	submitButton = nil;
	okTimeButton = nil;
	selectDateButton = nil;
	startEndPicker = nil;
	currentDay = nil;
	titleLabel = nil;
	dayLabel = nil;
	errorLabel = nil;
	activity = nil;
    location = nil;
	[super viewDidUnload];
	
}

@end
