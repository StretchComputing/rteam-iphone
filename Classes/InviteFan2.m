//
//  InviteFan2.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InviteFan2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CurrentTeamTabs.h"
#import "FastActionSheet.h"

@implementation InviteFan2
@synthesize firstName, lastName, email, teamId, submitButton, serverProcess, error, createSuccess, userRole, addDone, errorString, hideHomeButton,
multipleEmailArray, multipleEmailAlert;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}
- (void)viewDidLoad {
	
	self.title=@"Invite Fan";

	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];

	
//	if (self.addDone) {
//		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
//		[self.navigationItem setRightBarButtonItem:addButton];
//		[addButton release];
//	}
	

	
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	if (!self.hideHomeButton) {
		UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
		[self.navigationItem setRightBarButtonItem:homeButton];
		[homeButton release];
	}
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)done{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}




-(void)create {
	
	error.text = @"";
	
	if (self.email.text == nil) {
		self.email.text = @"";
	}
	//Validate all fields are entered:
	if ([email.text  isEqualToString:@""]){
		error.text = @"*You must enter a value for 'email'.";	
	}else{
		
		[serverProcess startAnimating];
		
		//Disable the UI buttons and textfields while registering
		
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.firstName setEnabled:NO];
		[self.lastName setEnabled:NO];
		[self.email setEnabled:NO];
		
		
		
		
		//Create the player in a background thread
		
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
	}
	
	
	
	
}

- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	//Create the new player
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpRoles = [[NSMutableArray alloc] init];
	
	NSString *role = @"player";
	
	[tmpRoles addObject:role];
	
	NSArray *rRoles = tmpRoles;
	NSArray *rEmails = [NSArray array];
	
	NSString *theRole = @"fan";

	NSDictionary *response = [ServerAPI createMember:self.firstName.text :self.lastName.text :self.email.text
													:@"" :rRoles :rEmails :self.teamId :mainDelegate.token :theRole :@""];
	
	
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
			case 208:
				self.errorString = @"NA";
				break;

			case 209:
				self.errorString = @"*Fan email address already in use";
				break;
			default:
				//Log the status code?
				self.errorString = @"*Error connecting to server";
				break;
		}
	}
	
	
	[tmpRoles release];
	[self performSelectorOnMainThread:
	 @selector(didFinish)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[serverProcess stopAnimating];
	
	if (self.createSuccess){
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num-=2;
		
		if (num >= 0) {
			
			if ([CurrentTeamTabs class] == [[temp objectAtIndex:num] class]) {
				//go back to CurrentTeamTabs
				CurrentTeamTabs *tmpTab = [temp objectAtIndex:num];
				tmpTab.selectedIndex = 2;
				[self.navigationController popToViewController:tmpTab animated:YES];
				
				
			}else {
				self.error.text = @"Fan Invite Successfull!";
				self.error.textColor = [UIColor colorWithRed:0.0 green:0.445 blue:0.0 alpha:1.0];
			}
			
		}else {
			self.error.text = @"Fan Invite Successfull!";
			self.error.textColor = [UIColor colorWithRed:0.0 green:0.445 blue:0.0 alpha:1.0];
		}

		

		
	}else{
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can invite fans.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
			self.error.text = self.errorString;
			self.error.textColor = [UIColor redColor];
		}

		
		
		
	}
	[submitButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.firstName setEnabled:YES];
	[self.lastName setEnabled:YES];
	[self.email setEnabled:YES];
	
	
}

-(void)endText {
	[self becomeFirstResponder];

}

- (void)showPicker:(id)sender {
    self.multipleEmailArray = [NSMutableArray array];
    ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
    NSString* name = (NSString *)ABRecordCopyValue(person,
												   kABPersonFirstNameProperty);
	
	ABMultiValueRef emails = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
	
	NSArray *emailArray = (NSArray *)ABMultiValueCopyArrayOfAllValues(emails);
	NSString *emailAddress = @"";
	if ([emailArray count] > 0) {
		emailAddress = [emailArray objectAtIndex:0];
        self.multipleEmailArray = [NSMutableArray arrayWithArray:emailArray];
	}
    
    [emailArray release];
	
    self.firstName.text = name;
    [name release];
	
    name = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    self.lastName.text = name;
    [name release];
	
	//self.email.text = emailAddress;
    
    if ([self.multipleEmailArray count] > 1){
        
        self.multipleEmailAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Emails Found" message:@"Please pick which email address you would like to use." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        for (int i = 0; i < [self.multipleEmailArray count]; i++) {
            
            [self.multipleEmailAlert addButtonWithTitle:[self.multipleEmailArray objectAtIndex:i]];
        }
        [self.multipleEmailAlert show];
        
    }else{
        self.email.text = emailAddress;
        
    }
	
    [self dismissModalViewControllerAnimated:YES];
	
    return NO;
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
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
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == self.multipleEmailAlert) {
        
        if (buttonIndex != 0){
            
            // self.tmpEmail = [self.multipleEmailArray objectAtIndex:buttonIndex - 1];
            
            self.email.text = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
            //self.phoneText.text = self.tmpPhone;
        }
        
    }
    
}


-(void)viewDidUnload{
	firstName = nil;
	email = nil;
	lastName = nil;
	//teamId = nil;
	//userRole = nil;
	submitButton = nil;
	serverProcess = nil;
	error = nil;
	//errorString = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	[firstName release];
	[lastName release];
	[email release];

	[teamId release];
	[submitButton release];
	[serverProcess release];
	[error release];
	[userRole release];
	[errorString release];
    [multipleEmailArray release];
    [multipleEmailAlert release];
	[super dealloc];
	
}

@end