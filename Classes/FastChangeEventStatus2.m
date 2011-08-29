//
//  FastChangeEventStatus2.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastChangeEventStatus2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"

@implementation FastChangeEventStatus2
@synthesize eventLabel, messageLabel, messageString, toLabel, sendButton, cancelButton, selectedEvent, recipArray, currentRecipIndex,
errorMessage, errorString, activity, sendSuccess, messageIntro, status, finalScoreLabel, finalUs, finalThem, newDateTime, newDateTimeLabel,
newLocationLabel, newLocation, setCurrentLocationButton, eventTypeString, timeString, todayTomorrowString, delay, doneMessage, doneSecondary,
newCurrentLocationLabel, latitude, longitude, locationManager;


-(void)viewDidLoad{
	self.doneMessage = false;
    self.doneSecondary = false;
	self.recipArray = [NSArray arrayWithObjects:@"Team Coordinators", @"Everyone", nil];
	self.currentRecipIndex = 0;
	
	self.title = @"My Status";
	self.messageLabel.text = self.messageString;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.sendButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.cancelButton setBackgroundImage:stretch forState:UIControlStateNormal];

	NSDate *minDate = [NSDate date];
	self.newDateTime.minimumDate = minDate;
	minDate = [minDate dateByAddingTimeInterval:300];
	[self.newDateTime setDate:minDate];
	
	
	
	NSString *eventTypeLabel = @"";
	NSString *timeLabel;
	if ([self.selectedEvent.eventType isEqualToString:@"game"]) {
		eventTypeLabel = @"Game";
	}else if ([self.selectedEvent.eventType isEqualToString:@"practice"]) {
		eventTypeLabel = @"Practice";
	}else {
		eventTypeLabel = @"Event";
	}
	
	
	NSString *date = self.selectedEvent.eventDate;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	NSDate *eventDate = [dateFormat dateFromString:date];
	NSDate *todaysDate = [NSDate date];
	
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	NSString *eventDateString = [dateFormat stringFromDate:eventDate];
	NSString *todayDateString = [dateFormat stringFromDate:todaysDate];
	bool today = false;
	if ([eventDateString isEqualToString:todayDateString]) {
		//time format
		today = true;
	}
	
	[dateFormat setDateFormat:@"hh:mm"];
	timeLabel = [dateFormat stringFromDate:eventDate];
	
	[dateFormat setDateFormat:@"a"];
	NSString *ampm = [dateFormat stringFromDate:eventDate];
	ampm = [ampm lowercaseString];
	ampm = [ampm substringToIndex:1];
	timeLabel = [timeLabel stringByAppendingString:ampm];
	
	NSString *todayTomorrow = @"";
	if (today) {
		todayTomorrow = @"Today";
	}else {
		todayTomorrow = @"Tomorrow";
	}
	
    [dateFormat release];
	self.eventLabel.text = [NSString stringWithFormat:@"%@ %@, %@", eventTypeLabel, todayTomorrow, timeLabel];
	self.eventTypeString = eventTypeLabel;
	self.todayTomorrowString = todayTomorrow;
	self.timeString = timeLabel;
	
	if (self.status == 0) {
		//Game cancelled or delayed
		self.finalScoreLabel.hidden = YES;
		self.finalUs.hidden = YES;
		self.finalThem.hidden = YES;
		self.newDateTime.hidden = YES;
		self.newDateTimeLabel.hidden = YES;
		self.newLocationLabel.hidden = YES;
		self.setCurrentLocationButton.hidden = YES;
		self.newLocation.hidden = YES;
		self.newCurrentLocationLabel.hidden = YES;
		self.sendButton.frame = CGRectMake(20, 200, 97, 37);
		self.cancelButton.frame = CGRectMake(203, 200, 97, 37);
		self.activity.frame = CGRectMake(150, 209, 20, 20);
		self.errorMessage.frame = CGRectMake(20, 180, 280, 21);

		
	}else if (self.status == 1){
		//rescheduled
		self.finalScoreLabel.hidden = YES;
		self.finalUs.hidden = YES;
		self.finalThem.hidden = YES;
		self.newDateTime.hidden = NO;
		self.newDateTimeLabel.hidden = NO;
		self.newLocationLabel.hidden = YES;
		self.newCurrentLocationLabel.hidden = YES;
		self.setCurrentLocationButton.hidden = YES;
		self.newLocation.hidden = YES;
		
	}else if (self.status == 2) {
		
		self.finalScoreLabel.hidden = YES;
		self.finalUs.hidden = YES;
		self.finalThem.hidden = YES;
		self.newDateTime.hidden = YES;
		self.newDateTimeLabel.hidden = YES;
		self.newLocationLabel.hidden = NO;
		self.setCurrentLocationButton.hidden = NO;
		self.newLocation.hidden = NO;
		self.newCurrentLocationLabel.hidden = NO;
		
	}else if (self.status == 3) {
		self.finalScoreLabel.hidden = NO;
		self.finalUs.hidden = NO;
		self.finalThem.hidden = NO;
		self.newDateTime.hidden = YES;
		self.newDateTimeLabel.hidden = YES;
		self.newLocationLabel.hidden = YES;
		self.setCurrentLocationButton.hidden = YES;
		self.newLocation.hidden = YES;
		self.newCurrentLocationLabel.hidden = YES;
	}
	
}

-(void)rightRecip{
	
	if (self.currentRecipIndex > 0) {
		self.currentRecipIndex--;
	}else {
        self.currentRecipIndex = [self.recipArray count] - 1;
	}
	
	
	self.toLabel.text = [self.recipArray objectAtIndex:self.currentRecipIndex];
}

-(void)leftRecip{
	
	if (self.currentRecipIndex < ([self.recipArray count] - 1)) {
		self.currentRecipIndex++;
	}else {
        self.currentRecipIndex = 0;
	}
	
	
	self.toLabel.text = [self.recipArray objectAtIndex:self.currentRecipIndex];
	
	
}


-(void)send{
	[activity startAnimating];
	self.cancelButton.enabled = NO;
	self.sendButton.enabled = NO;
	
	if (self.status == 0) {
		
		if ([self.messageLabel.text isEqualToString:@"• Cancel Event."]) {
			self.messageIntro = [NSString stringWithFormat:@"The %@ scheduled for %@ at %@ has been cancelled.", self.eventTypeString,
								 self.todayTomorrowString, self.timeString];
			
			UIActionSheet *deleteNow = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Cancel Event" otherButtonTitles:nil];
			deleteNow.actionSheetStyle = UIActionSheetStyleDefault;
			[deleteNow showInView:self.view];
			[deleteNow release];
			
		}else {
			self.messageIntro = [NSString stringWithFormat:@"The %@ scheduled for %@ at %@ has been delayed by %d minutes.", self.eventTypeString,
								 self.todayTomorrowString, self.timeString, self.delay];
			self.doneSecondary = true;
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];


		}
		
	}else if (status == 1) {
		//Reschedule
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MM/dd/YY hh:mma"];
		NSString *startDateString = [format stringFromDate:self.newDateTime.date];
		self.messageIntro = [NSString stringWithFormat:@"The %@ scheduled for %@ at %@ has been rescheduled, and will now occurr on %@.", 
							 self.eventTypeString, self.todayTomorrowString, self.timeString, startDateString];
		[format release];
		
		[self performSelectorInBackground:@selector(reschedule) withObject:nil];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];

		
	}else if (status == 2) {
		//New location
		self.errorMessage.text = @"";
		if ([self.newLocation.text isEqualToString:@""]) {
			self.errorMessage.text = @"*You must enter a new location in the text box.";
		}
		
		self.messageIntro = [NSString stringWithFormat:@"The %@ schedulded for %@ at %@ has changed locations.  The new location is %@.",
							 self.eventTypeString, self.todayTomorrowString, self.timeString, self.newLocation.text];
		if (self.setCurrentLocationButton.selectedSegmentIndex == 0) {
			//use current coordinates
		
			self.locationManager = [[[CLLocationManager alloc] init] autorelease];
			self.locationManager.delegate = self; // Tells the location manager to send updates to this object
			[locationManager startUpdatingLocation];
		}else {
			self.latitude = @"";
			self.longitude = @"";
			[self performSelectorInBackground:@selector(updateLocation) withObject:nil];
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		}

	}else if (status == 3) {
		//Game over
		self.errorMessage.text = @"";

		int x = [self.finalUs.text intValue];
		int y = [self.finalThem.text intValue];
		
		NSString *intUsString = [NSString stringWithFormat:@"%d", x];
		NSString *intThemString = [NSString stringWithFormat:@"%d", y];
		bool runReq = false;
		
		if (([self.finalUs.text isEqualToString:@""]) && ([self.finalThem.text isEqualToString:@""])) {
			runReq = true;
		}else if ((![intUsString isEqualToString:self.finalUs.text]) || (![intThemString isEqualToString:self.finalThem.text])){
			self.errorMessage.text = @"*Please enter a valid number for each score.";
		}else {
			runReq = true;
		}
		
		self.messageIntro = [NSString stringWithFormat:@"The Game scheduled for %@ at %@ has ended.  The final score was Us: %@, Them: %@.", 
							 self.todayTomorrowString, self.timeString, self.finalUs.text, self.finalThem.text];
		
		[self performSelectorInBackground:@selector(gameOver) withObject:nil];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}
	
}


- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	NSArray *recipients = [NSArray array];
	
	NSString *coordsOnly = @"";
	if (self.currentRecipIndex == 0) {
		coordsOnly = @"true";
	}
	
	NSString *message = self.messageIntro;
	
	if (![token isEqualToString:@""]){	
		
		NSString *type = @"";
		if ([self.eventTypeString isEqualToString:@"Game"]) {
			type = @"game";
		}else if ([self.eventTypeString isEqualToString:@"Practice"]) {
			type = @"practice";
		}else {
			type = @"generic";
		}
		
		NSDictionary *response = [ServerAPI createMessageThread:token :self.selectedEvent.teamId :@"Event Status" :message :@"plain" 
															   :self.selectedEvent.eventId :type :@"true" 
															   :[NSArray array] :recipients :@"" :@"false" :coordsOnly];	
		
		NSString *status1 = [response valueForKey:@"status"];
		
		
		if ([status1 isEqualToString:@"100"]){
			
			self.sendSuccess = true;
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			self.sendSuccess = false;
			int statusCode = [status1 intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.errorString = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.errorString = @"*Error connecting to server";
					break;
				case 208:
					self.errorString = @"NA";
					break;
					
				default:
					//should never get here
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
	self.doneMessage = true;
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinish{
	
	if (self.doneMessage && self.doneSecondary) {
		
	//When background thread is done, return to main thread
	[activity stopAnimating];
	
	if (self.sendSuccess){
		
		self.errorMessage.text = @"Message Sent!";
		self.errorMessage.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0f blue:0.00 alpha:1.0];
		[self performSelector:@selector(cancel) withObject:nil afterDelay:1];
		
	}else{
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send messages.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
			
			self.errorMessage.text = self.errorString;
			self.errorMessage.textColor = [UIColor redColor];
		}
		
		self.cancelButton.enabled = YES;
		self.sendButton.enabled = YES;
		
	}
		
	}
}



-(void)cancel{
	
	NSArray *temp = [self.navigationController viewControllers];
	
	UIViewController *tmp1 = [temp objectAtIndex:[temp count] - 3];
	
	[self.navigationController popToViewController:tmp1 animated:NO];
	
}

-(void)setCurrentLocation{
	
	
}

- (void)reschedule {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 

	
	NSDictionary *response = [NSDictionary dictionary];
	if (![token isEqualToString:@""]){	
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"YYYY-MM-dd HH:mm"];
		
		NSString *startDateString = [format stringFromDate:self.newDateTime.date];
		[format release];
		
		if ([self.eventTypeString isEqualToString:@"Game"]) {
			
			response = [ServerAPI updateGame:token :self.selectedEvent.teamId :self.selectedEvent.eventId :startDateString :@"" 
											:[[NSTimeZone systemTimeZone] name] :@"" :@"" :@"" :@"" :@"" :@"" :@"" 
											:@"" :@"false" :@"" :@""];
		}else{
			
			response = [ServerAPI updateEvent:token :self.selectedEvent.teamId :self.selectedEvent.eventId :startDateString :@"" 
											 :[[NSTimeZone systemTimeZone] name] :@"" :@"" :@"" :@"" :@"false" :@"" :@"" :@""];
		}

		
		NSString *status1 = [response valueForKey:@"status"];
		
		
		if ([status1 isEqualToString:@"100"]){
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status1 intValue];
			
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
					//log status code?
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
	}
	
	self.doneSecondary = true;
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}


-(void)runDelete{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	NSDictionary *response = [NSDictionary dictionary];

	if ([self.eventTypeString isEqualToString:@"Game"]) {
		
		//response = [ServerAPI deleteGame:token :self.selectedEvent.teamId :self.selectedEvent.eventId];
		response = [ServerAPI updateGame:token :self.selectedEvent.teamId :self.selectedEvent.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"-4" :@"false" :@"" :@""];
		
	}else {
		//response = [ServerAPI deletePractice:token :self.selectedEvent.teamId :self.selectedEvent.eventId];
		response = [ServerAPI updateEvent:token :self.selectedEvent.teamId :self.selectedEvent.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];

		
	}
	
	NSString *status1 = [response valueForKey:@"status"];
	
	
	if ([status1 isEqualToString:@"100"]){
		
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status1 intValue];
		
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

	
	self.doneSecondary = true;
	[self performSelectorOnMainThread:@selector(didFinish) withObject:nil waitUntilDone:NO];
	[pool drain];
	
	
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (buttonIndex == 0) {
		
		[self performSelectorInBackground:@selector(runDelete) withObject:nil];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];

	}
			
}


-(void)endText{
	
	
}

- (void)gameOver {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
	
		
	NSDictionary *response = [ServerAPI updateGame:token :self.selectedEvent.teamId :self.selectedEvent.eventId :@"" :@"" :@"" :@"" :@"" :@"" 
												  :@"" :@"" :self.finalUs.text :self.finalThem.text :@"-1" :@"" :@"" :@""];
	
	NSString *status1 = [response valueForKey:@"status"];
	
	if ([status1 isEqualToString:@"100"]){
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status1 intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				//self.error.text = @"*Error connecting to server";
				break;
			case 1:
				///error connecting to server
				//self.error.text = @"*Error connecting to server";
				break;
				
			default:
				//should never get here
				//self.error.text = @"*Error connecting to server";
				break;
		}
	}
	
	self.doneSecondary = true;
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}



- (void)updateLocation {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	

	
	NSDictionary *response = [NSDictionary dictionary];
	
	if (![token isEqualToString:@""]){	
		
		if ([self.eventTypeString isEqualToString:@"Game"]) {
			
			response = [ServerAPI updateGame:token :self.selectedEvent.teamId :self.selectedEvent.eventId :@"" :@"" :[[NSTimeZone systemTimeZone] name]
											:@"" :self.latitude :self.longitude :@"" :self.newLocation.text :@"" :@"" :@"" :@"false" :@"" :@""];
		}else {
			response = [ServerAPI updateEvent:token :self.selectedEvent.teamId :self.selectedEvent.eventId :@"" :@"" :[[NSTimeZone systemTimeZone] name]
											 :@"" :self.longitude :self.latitude :self.newLocation.text :@"false" :@"" :@"" :@""];
		}

		
		
		
		
		NSString *status1 = [response valueForKey:@"status"];
		
		if ([status1 isEqualToString:@"100"]){
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status1 intValue];
			
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
					//log status code?
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
	self.doneSecondary = true;
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}


- (void)locationManager: (CLLocationManager *)manager
	didUpdateToLocation: (CLLocation *)newLocation1
		   fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	
	double degrees = newLocation1.coordinate.latitude;
	self.latitude = [NSString stringWithFormat:@"%f", degrees];
	
	degrees = newLocation1.coordinate.longitude;
	self.longitude = [NSString stringWithFormat:@"%f", degrees];

	
	[self performSelectorInBackground:@selector(updateLocation) withObject:nil];
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];


}
- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error
{
}



-(void)viewDidUnload{
	
	eventLabel = nil;
	//messageString = nil;
	messageLabel = nil;
	toLabel = nil;
	sendButton = nil;
	cancelButton = nil;
	selectedEvent = nil;
	//recipArray = nil;
	//errorString = nil;
	errorMessage = nil;
	activity = nil;
	//messageIntro = nil;
	finalScoreLabel = nil;
	finalUs = nil;
	finalThem = nil;
	newDateTime = nil;
	newDateTimeLabel = nil;
	newLocationLabel = nil;
	newLocation = nil;
	setCurrentLocationButton = nil;
	//eventTypeString = nil;
	//todayTomorrowString = nil;
	//timeString = nil;
	//latitude = nil;
	//longitude = nil;
	locationManager = nil;
	[super viewDidUnload];
	

}

-(void)dealloc{
	[eventLabel release];
	[messageString release];
	[messageLabel release];
	[toLabel release];
	[sendButton release];
	[cancelButton release];
	[selectedEvent release];
	[recipArray release];
	[errorString release];
	[errorMessage release];
	[activity release];
	[messageIntro release];
	[finalScoreLabel release];
	[finalUs release];
	[finalThem release];
	[newDateTime release];
	[newDateTimeLabel release];
	[newLocationLabel release];
	[newLocation release];
	[setCurrentLocationButton release];
	[eventTypeString release];
	[timeString release];
	[todayTomorrowString release];
	[latitude release];
	[longitude release];
	[locationManager release];
	[super dealloc];
}


@end
