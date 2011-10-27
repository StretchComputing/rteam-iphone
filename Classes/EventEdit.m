//
//  EventEdit.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventEdit.h"
#import "EventEditDate.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "EventTabs.h"
#import "EventNotes.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "AllEventCalList.h"
#import "AllEventsCalendar.h"
#import "CurrentTeamTabs.h"

@implementation EventEdit
@synthesize activity, saveChanges, practiceOpponent, practiceDate, practiceDescription, opponent, stringDate, description, teamId, eventId, 
practiceChangeDate, notifyTeam, fromDateChange, practiceDateObject, createSuccess, errorMessage, eventName, nameString, errorString, deleteButton,
deleteActionSheet;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.practiceChangeDate setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.saveChanges setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.practiceDescription.layer.masksToBounds = YES;
	self.practiceDescription.layer.cornerRadius = 7.0;
	
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteButton setBackgroundImage:stretch1 forState:UIControlStateNormal];

	
}

-(void)viewWillAppear:(BOOL)animated{
	
	self.title = @"Edit Event Info";
	self.practiceOpponent.text = self.opponent;
	
	self.eventName.text = self.nameString;
	self.practiceDescription.text = self.description;
	self.practiceDescription.delegate = self;
	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
	if (self.fromDateChange != YES){
		self.fromDateChange = NO;
		self.practiceDateObject = [dateFormat dateFromString:self.stringDate];
	}
	
	[dateFormat setDateFormat:@"MMM dd, hh:mm aa"];
	
	self.practiceDate.text = [@"Date: " stringByAppendingString:[dateFormat stringFromDate:self.practiceDateObject]];
	
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		[self becomeFirstResponder];

        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}




-(void)submit{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Team Alert" message:@"Notify your team of this update?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		self.notifyTeam = false;
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		
		self.notifyTeam = true;
		
		
	}
	
	[activity startAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[self.saveChanges setEnabled:NO];
	[self.practiceChangeDate setEnabled:NO];
	[self.navigationItem.leftBarButtonItem setEnabled:NO];
	[self.practiceOpponent setEnabled:NO];
	[self.practiceDescription setEditable:NO];
	
	//Create the team in a background thread
	
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}

-(void)changeDate{
	
	EventEditDate *tmp = [[EventEditDate alloc] init];
	tmp.practiceDate = self.practiceDateObject;
	[self.navigationController pushViewController:tmp animated:YES];
	
}



- (void)runRequest {
	

	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
	NSString *startDate = [dateFormat stringFromDate:self.practiceDateObject];
	
    
	NSDictionary *response = [NSDictionary dictionary];
	
	if (![token isEqualToString:@""]){	
		
		NSString *notify = @"";
		if (self.notifyTeam) {
			notify = @"true";
		}else {
			notify = @"false";
		}
		
		response = [ServerAPI updateEvent:token :self.teamId :self.eventId :startDate :@"" :[[NSTimeZone systemTimeZone] name] 
										 :self.practiceDescription.text :@"" :@"" :self.practiceOpponent.text :notify :self.eventName.text :@"" :@""];
		
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.createSuccess = true;
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			self.createSuccess = false;
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
					//log status code?
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
	
	if (self.createSuccess){
		//team, sent, inbox, game or pracitce
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num - 2;
		
		EventTabs *cont = [temp objectAtIndex:num];
		cont.selectedIndex = 0;
		
		
		NSArray *tmp = cont.viewControllers;
		EventNotes *notes = [tmp objectAtIndex:0];
		notes.fromNextUpdate = true;
		
		[self.navigationController popToViewController:cont animated:YES];
		
		
	}else{
		self.errorMessage.text = self.errorString;
		
		[self.saveChanges setEnabled:YES];
		[self.practiceChangeDate setEnabled:YES];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
		[self.practiceOpponent setEnabled:YES];
		[self.practiceDescription setEditable:YES];
	}
}

-(void)endText{
	[self becomeFirstResponder];

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet == self.deleteActionSheet) {
		
		if (buttonIndex == 0) {
			//Remove
			[self.activity startAnimating];
			self.deleteButton.enabled = NO;
			self.saveChanges.enabled = NO;
			[self performSelectorInBackground:@selector(removeEvent) withObject:nil];
		}else if (buttonIndex == 1) {
			//Cancel
			[self.activity startAnimating];
			self.deleteButton.enabled = NO;
			self.saveChanges.enabled = NO;
			[self performSelectorInBackground:@selector(cancelEvent) withObject:nil];
		}else{
			
		}
		
		
	}else {
		[FastActionSheet doAction:self :buttonIndex];
		
	}	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)deleteEvent{
	
	self.deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"'Delete' removes event from schedule. 'Cancel' marks event as cancelled." delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Delete Event" otherButtonTitles:@"Cancel Event", nil];
    self.deleteActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.deleteActionSheet showInView:self.view];
	
}


-(void)removeEvent{
	isCancel = false;

	
	//Delete Event
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	if (![token isEqualToString:@""]){
		NSDictionary *response = [ServerAPI deleteEvent:token :self.teamId :self.eventId];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.errorString  = @"";
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.errorString  = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.errorString  = @"*Error connecting to server";
					break;
				default:
					//log status code
					self.errorString  = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	
	
	[self performSelectorOnMainThread:@selector(doneCancelDelete) withObject:nil waitUntilDone:NO];
}

-(void)cancelEvent{
	
	isCancel = true;

	
	//Cancel Event
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		NSDictionary *response = [ServerAPI updateEvent:token :self.teamId :self.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];
		
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
					self.errorString  = @"*Error connecting to server";
					break;
				default:
					//log status code
					self.errorString  = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	[self performSelectorOnMainThread:@selector(doneCancelDelete) withObject:nil waitUntilDone:NO];
	
}


-(void)doneCancelDelete{
	
	[self.activity stopAnimating];
	self.deleteButton.enabled = YES;
	self.saveChanges.enabled = YES;
	
	
	if ([self.errorString isEqualToString:@""]) {
		NSArray *viewControllers = [self.navigationController viewControllers];
		
		if ([viewControllers count] > 2) {
			
			int num = [viewControllers count];
			
			if ([AllEventCalList class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				AllEventCalList *tmp = [viewControllers objectAtIndex:num - 3];
				AllEventsCalendar *tmp1 = [viewControllers objectAtIndex:num - 4];
				tmp1.createdEvent = true;
				
				tmp.eventIdCanceled = self.eventId;
				tmp.isCancel = isCancel;
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([AllEventsCalendar class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				AllEventsCalendar *tmp = [viewControllers objectAtIndex:num - 3];
				tmp.createdEvent = true;
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([CurrentTeamTabs class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				CurrentTeamTabs *tmp = [viewControllers objectAtIndex:num - 3];
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else {
				[self.navigationController dismissModalViewControllerAnimated:YES];
				
			}
			
			
		}else {
			//from Home
			
			[self.navigationController dismissModalViewControllerAnimated:YES];
		}
		
		
	}else {
		self.errorMessage.text = self.errorString;
	}
	
	
	
	
}

-(void)viewDidUnload{
	
	activity = nil;
	saveChanges = nil;
	practiceOpponent = nil;
	practiceDate = nil;
	practiceDescription = nil;
	//opponent = nil;
	//stringDate = nil;
	//description = nil;
	//teamId = nil;
	//eventId = nil;
	practiceChangeDate = nil;
	practiceDateObject = nil;
	errorMessage = nil;
	eventName = nil;

	[super viewDidUnload];
	
}

@end
