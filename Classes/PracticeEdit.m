//
//  PracticeEdit.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PracticeEdit.h"
#import "PracticeEditDate.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "AllEventCalList.h"
#import "AllEventsCalendar.h"
#import "CurrentTeamTabs.h"
#import "FastHappeningNow.h"

@implementation PracticeEdit
@synthesize activity, saveChanges, practiceOpponent, practiceDate, practiceDescription, opponent, stringDate, description, teamId, practiceId, 
practiceChangeDate, notifyTeam, fromDateChange, practiceDateObject, createSuccess, errorMessage, errorString, deleteButton, deleteActionSheet;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewDidLoad{
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.saveChanges setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.practiceChangeDate setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.practiceOpponent.text = self.opponent;
	
	self.practiceDescription.layer.masksToBounds = YES;
	self.practiceDescription.layer.cornerRadius = 7.0;
	
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	self.title = @"Edit Practice Info";
	//self.practiceOpponent.text = self.opponent;
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
	
	[dateFormat release];
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
    [alert release];
	
	
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
	
	PracticeEditDate *tmp = [[PracticeEditDate alloc] init];
	tmp.practiceDate = self.practiceDateObject;
	[self.navigationController pushViewController:tmp animated:YES];
	
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
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
	NSString *startDate = [dateFormat stringFromDate:self.practiceDateObject];
	
	NSDictionary *response = [NSDictionary dictionary];
	
    [dateFormat release];
    
	if (![token isEqualToString:@""]){	
		
		NSString *notify = @"";
		if (self.notifyTeam) {
			notify = @"true";
		}else {
			notify = @"false";
		}
		
		response = [ServerAPI updateEvent:token :self.teamId :self.practiceId :startDate :@"" :[[NSTimeZone systemTimeZone] name] 
										 :self.practiceDescription.text :@"" :@"" :self.practiceOpponent.text :notify :@"" :@"" :@""];
		
	
	
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
	
    [pool drain];
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[activity stopAnimating];
	
	if (self.createSuccess){
		//team, sent, inbox, game or pracitce
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num - 2;
		
		PracticeTabs *cont = [temp objectAtIndex:num];
		cont.selectedIndex = 0;
		
		NSArray *tmp = cont.viewControllers;
		PracticeNotes *notes = [tmp objectAtIndex:0];
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
		[actionSheet release];
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


-(void)deletePractice{
	
	self.deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"'Delete' removes practice from schedule. 'Cancel' marks practice as cancelled." delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Delete Practice" otherButtonTitles:@"Cancel Practice", nil];
    self.deleteActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.deleteActionSheet showInView:self.view];
    [self.deleteActionSheet release];
	
}


-(void)removeEvent{
	isCancel = false;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	//Delete Event
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	if (![token isEqualToString:@""]){
		NSDictionary *response = [ServerAPI deleteEvent:token :self.teamId :self.practiceId];
		
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
	[pool drain];
}

-(void)cancelEvent{
	isCancel = true;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	//Cancel Event
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *token = @"";
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	if (![token isEqualToString:@""]){
		NSDictionary *response = [ServerAPI updateEvent:token :self.teamId :self.practiceId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];
		
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
	[pool drain];
	
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
				
				tmp.practiceIdCanceled = self.practiceId;
				tmp.isCancel = isCancel;
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([AllEventsCalendar class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				AllEventsCalendar *tmp = [viewControllers objectAtIndex:num - 3];
				tmp.createdEvent = true;
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([CurrentTeamTabs class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				CurrentTeamTabs *tmp = [viewControllers objectAtIndex:num - 3];
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([FastHappeningNow class] == [[viewControllers objectAtIndex:num - 3] class]){
                
                FastHappeningNow *tmp = [viewControllers objectAtIndex:num - 3];
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
	//practiceId = nil;
	practiceChangeDate = nil;
	practiceDateObject = nil;
	errorMessage = nil;
	//errorString = nil;
	[super viewDidUnload];

	
	
}

-(void)dealloc{
	
	[activity release];
	[saveChanges release];
	[practiceOpponent release];
	[practiceDate release];
	[practiceDescription release];
	[opponent release];
	[stringDate release];
	[description release];
	[teamId release];
	[practiceId release];
	[practiceChangeDate release];
	[practiceDateObject release];
	[errorMessage release];
	[errorString release];
	[super dealloc];
}
@end