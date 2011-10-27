//
//  FastUpdateStatus2.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastUpdateStatus2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"

@implementation FastUpdateStatus2
@synthesize eventLabel, messageLabel, messageString, toLabel, sendButton, cancelButton, selectedEvent, recipArray, currentRecipIndex,
errorMessage, errorString, activity, sendSuccess, messageIntro, todayTomorrowString, eventTypeString, timeString;

-(void)viewDidLoad{
	
	self.recipArray = [NSArray arrayWithObjects:@"Team Coordinators", @"Everyone", nil];
	self.currentRecipIndex = 0;
	
	self.title = @"My Status";
	self.messageLabel.text = self.messageString;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.sendButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.cancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	
	
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
    

	self.eventLabel.text = [NSString stringWithFormat:@"%@ %@, %@", eventTypeLabel, todayTomorrow, timeLabel];
	
	self.messageIntro = [NSString stringWithFormat:@"In regard to the %@ %@ at %@: ", eventTypeLabel, todayTomorrow, timeLabel];
	
	self.todayTomorrowString = todayTomorrow;
	self.eventTypeString = eventTypeLabel;
	self.timeString = timeLabel;
	
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
	
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
}


- (void)runRequest {
	
	
	
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
	
	NSString *message = [self.messageIntro stringByAppendingString:[self.messageLabel.text substringFromIndex:2]];
	
	if (![token isEqualToString:@""]){	
		NSString *type = @"";
		if ([self.eventTypeString isEqualToString:@"Game"]) {
			type = @"game";
		}else if ([self.eventTypeString isEqualToString:@"Practice"]) {
			type = @"practice";
		}else {
			type = @"generic";
		}
		
		NSDictionary *response = [ServerAPI createMessageThread:token :self.selectedEvent.teamId :@"Member Status" :message :@"plain" 
												 :self.selectedEvent.eventId :type :@"true" 
															   :[NSArray array] :recipients :@"" :@"false" :coordsOnly];	
		
		NSString *status = [response valueForKey:@"status"];
		
		
		if ([status isEqualToString:@"100"]){
			
			self.sendSuccess = true;
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			self.sendSuccess = false;
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
	
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
}

- (void)didFinish{
	
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



-(void)cancel{
	
	NSArray *temp = [self.navigationController viewControllers];
	
	UIViewController *tmp1 = [temp objectAtIndex:[temp count] - 3];
	
	[self.navigationController popToViewController:tmp1 animated:NO];

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
	//todayTomorrowString = nil;
	//eventTypeString = nil;
	//timeString = nil;
	[super viewDidUnload];

}

@end
