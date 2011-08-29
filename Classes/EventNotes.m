//
//  EventNotes.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventNotes.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "JSON/JSON.h"
#import "PracticeUpdateGPS.h"
#import "EventUpdateGPS.h"
#import "MapLocation.h"
#import "EventEdit.h"

@implementation EventNotes
@synthesize eventId, teamId, opponent, day, time, description, locationManager, updateSuccess, latitude, longitude, 
fromNextUpdate, errorLabel, updateLocationButton, viewMapButton, eventNameLabel, userRole, editDone, opponentString, descriptionString,
startDateString, loading, errorString, dayString, timeString, eventNameString;

-(void)viewDidLoad{
	
	self.tabBarController.navigationItem.title = @"Event Day";
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.viewMapButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.updateLocationButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
		
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
		
		
		[self.updateLocationButton setHidden:NO];
		
	}else {
		[self.updateLocationButton setHidden:YES];
	}
	
	
	
	[self.loading startAnimating];
	
	self.latitude = @"";
	self.longitude = @"";
	self.viewMapButton.hidden = YES;
}

-(void)editEvent{
	
	
	EventEdit *editEvent = [[EventEdit alloc] init];
	
	editEvent.nameString = self.eventNameLabel.text;
	editEvent.stringDate = self.startDateString;
	editEvent.opponent = self.opponentString;
	editEvent.description = self.descriptionString;
	editEvent.teamId = self.teamId;
	editEvent.eventId = self.eventId;
	
	
	[self.navigationController pushViewController:editEvent animated:YES];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	[self.loading startAnimating];
	[self performSelectorInBackground:@selector(getPracticeInfo) withObject:nil];
    
    if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		self.editDone = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editEvent)];
		[self.tabBarController.navigationItem setRightBarButtonItem:self.editDone];
	}
}

-(void)getPracticeInfo{
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
    NSDictionary *practiceInfo = [NSDictionary dictionary];
	//If there is a token, do a DB lookup to find the game info 
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getEventInfo:self.eventId :self.teamId :token];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			practiceInfo = [response valueForKey:@"eventInfo"];
			
			NSString *evName = [practiceInfo valueForKey:@"eventName"];
						
			self.eventNameString = evName;
			NSString *startDate = [practiceInfo valueForKey:@"startDate"];
			self.startDateString = startDate;
			NSString *desc = [practiceInfo valueForKey:@"description"];
			NSString *opp = [practiceInfo valueForKey:@"opponent"];
			
			if ([practiceInfo valueForKey:@"latitude"] != nil) {
				
				self.latitude = [[practiceInfo valueForKey:@"latitude"] stringValue];
				self.longitude = [[practiceInfo valueForKey:@"longitude"] stringValue];
			}else{
			}
	
			self.opponentString = opp;
			self.descriptionString = desc;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatStartDate = [dateFormat dateFromString:startDate];
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"EEE, MMM dd"];
			[timeFormat setDateFormat:@"hh:mm aa"];
			
			self.dayString = [format stringFromDate:formatStartDate];
			self.timeString = [timeFormat stringFromDate:formatStartDate];
			[timeFormat release];
			[format release];
			[dateFormat release];
			
			
			
			
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
					//log status code
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
		
	}
	

	[pool drain];
	[self performSelectorOnMainThread:@selector(finishedInfo) withObject:nil waitUntilDone:NO];
}

-(void)finishedInfo{
	
	self.opponent.text = self.opponentString;
	self.errorLabel.text = self.errorString;
	self.description.text = self.descriptionString;
	self.day.text = self.dayString;
	self.time.text = self.timeString;
	self.eventNameLabel.text = self.eventNameString;

	[self.loading stopAnimating];
	
	if (![self.latitude isEqualToString:@""]) {
		self.viewMapButton.hidden = NO;
	}else {
		self.viewMapButton.hidden = YES;
	}
	
}

-(void)updateLocationAction{
	
	EventUpdateGPS *tmp = [[EventUpdateGPS alloc] init];
	tmp.teamId = self.teamId;
	tmp.eventId = self.eventId;
	tmp.locationString = self.opponent.text;
	
	[self.navigationController pushViewController:tmp animated:YES];
	
}

-(void)viewMapAction{
	
	MapLocation *tmp = [[MapLocation alloc] init];
	tmp.eventLatCoord = [self.latitude doubleValue];
	tmp.eventLongCoord = [self.longitude doubleValue];
	[self.navigationController pushViewController:tmp animated:YES];
	
}


-(void)viewDidUnload{
	//eventId = nil;
	//teamId = nil;
	opponent = nil;
	day = nil;
	time = nil;
	description = nil;
	locationManager = nil;
	errorLabel = nil;
	updateLocationButton = nil;
	//latitude = nil;
	//longitude = nil;
	viewMapButton = nil;
	eventNameLabel = nil;
	//userRole = nil;
	//opponentString = nil;
	editDone = nil;
	//descriptionString = nil;
	//startDateString = nil;
	loading = nil;
	//dayString = nil;
	//timeString = nil;
	//errorString = nil;
	//eventNameString = nil;
	[super viewDidUnload];
	

	
}

-(void)dealloc{
	[eventId release];
	[teamId release];
	[opponent release];
	[day release];
	[time release];
	[description release];
	[locationManager release];
	[errorLabel release];
	[updateLocationButton release];
	[viewMapButton release];
	[eventNameLabel release];
	[userRole release];
	[editDone release];
	[opponentString release];
	[descriptionString release];
	[startDateString release];
	[latitude release];
	[longitude release];
	[loading release];
	[errorString release];
	[dayString release];
	[timeString release];
	[eventNameString release];
	[super dealloc];
}



@end