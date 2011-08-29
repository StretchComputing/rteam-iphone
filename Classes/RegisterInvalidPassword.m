//
//  RegisterInvalidPassword.m
//  iCoach
//
//  Created by Nick Wroblewski on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterInvalidPassword.h"
#import "ServerAPI.h"
#import "CoachTeamHome.h"
#import "JSON/JSON.h"
#import "iCoachAppDelegate.h"
#import "About.h"
#import "RegisterInvalidPassword.h"
#import "RegisterNewUser.h"
#import "Register.h"
#import "Home.h"
#import "SettingsTabs.h"

@implementation RegisterInvalidPassword
@synthesize email, password, error, registering, submitButton, createSuccess, invalidEmail, resetButton, sameEmail, serverError, isMember;


- (void)viewDidLoad {
	self.title = @"Register";
	
	self.email.text = self.sameEmail;
	
	[self.navigationItem setHidesBackButton:YES];
	
	UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
	[self.navigationItem setRightBarButtonItem:about];
	[about release];
	
}

-(void)reset{
	
	if ([self.email.text isEqualToString:@""]) {
		self.error.text = @"To reset your password, first enter your email address";
	}else {
		NSString *display = [@"Reset Password for '" stringByAppendingString:self.email.text];
		display = [display stringByAppendingFormat:@"'?"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:display message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
		[alert show];
	}

	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		
		NSString *response = [ServerAPI resetUserPassword:self.email.text];
		
		if ([response isEqualToString:@"Success"]) {
			//do something
			
			NSArray *temp = [self.navigationController viewControllers];
			int num = [temp count];
			num = num - 2;
			
			Register *cont = [temp objectAtIndex:num];
			cont.success.text = @"Success!  You will recieve your new password via email.";
			cont.password.text = @"";
			[cont.submitButton setEnabled:YES];
			[cont.email setEnabled:YES];
			[cont.password setEnabled:YES];
			[self.navigationController popToViewController:cont animated:YES];
			
			
		}else if ([response isEqualToString:@"Email Address is not valid"]){
			self.error.text = @"Please enter a valid email address.";
 		}else {
			self.error.text = @"Error connecting to server.";
		}


	}

}


-(IBAction)about{
	
	About *nextController = [[About alloc] init];
	[self.navigationController pushViewController:nextController animated:YES];
}

-(IBAction)endText {
	
	
	
}

-(IBAction)submit{
	
	
	error.text = @"";
	//Validate all fields are entered:
	if (([email.text  isEqualToString:@""]) ||
		([password.text  isEqualToString:@""])){
		error.text = @"*You must enter a value for each field";	
	}else{
		
		[registering startAnimating];
		
		//Disable the UI buttons and textfields while registering
		[submitButton setEnabled:NO];
		[resetButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.email setEnabled:NO];
		[self.password setEnabled:NO];
		
		
		//Register the User in a background thread
		
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		
	}
}


- (void)runRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *response = [ServerAPI getUserToken:self.email.text :self.password.text];
	
	//Pull out the token from the JSON response...
	SBJSON *jsonParser = [SBJSON new];
	
	NSDictionary *feed = (NSDictionary *) [jsonParser objectWithString:response error:NULL];
	
	NSString *message = [feed valueForKey:@"message"];
	
	if ([message isEqualToString:@"Success"]){
		
		NSString *token = [feed valueForKey:@"token"];
		
		iCoachAppDelegate *mainDelegate = (iCoachAppDelegate *)[[UIApplication sharedApplication] delegate];
		mainDelegate.token = token;
		
		if (mainDelegate.pushToken != nil) {
			NSString *tmp = [[NSString alloc] initWithData:mainDelegate.pushToken encoding:NSUTF8StringEncoding];
			[ServerAPI updateUser:token :@"" :@"" :@"" :tmp];
			[tmp release];
		}
		
		self.createSuccess = true;
		self.serverError = false;
	}else if([message isEqualToString:@"Invalid email address"]){
		
		self.createSuccess = false;
		self.invalidEmail = true;
		self.serverError = false;
		
	}else if([message isEqualToString:@"Invalid password"]){
		
		self.createSuccess = false;
		self.invalidEmail = false;
		self.serverError = false;
		
		
	}else{
		self.createSuccess = false;
		self.serverError = true;
		error.text = @"*Error connecting to server.";					  
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
	[registering stopAnimating];
	
	if (self.createSuccess){
		//Then go to the coaches home
		SettingsTabs *nextController = [[SettingsTabs alloc] init];
		nextController.fromRegisterFlow = @"true";
		nextController.didRegister = @"false";
		[self.navigationController  pushViewController:nextController animated:NO];
	}else {
		//if it failed, re-enable all fields so user can make changes
		
		if (serverError) {
			[submitButton setEnabled:YES];
			[resetButton setEnabled:YES];
			[self.navigationItem setHidesBackButton:NO];
			[self.email setEnabled:YES];
			[self.password setEnabled:YES];
		}else {
			
			if (self.invalidEmail) {
				//Do a Member check
				
				
				[registering startAnimating];
				
				//Disable the UI buttons and textfields while registering
				[submitButton setEnabled:NO];
				[resetButton setEnabled:NO];
				[self.navigationItem setHidesBackButton:YES];
				[self.email setEnabled:NO];
				[self.password setEnabled:NO];
				
				
				//Register the User in a background thread
				
				[self performSelectorInBackground:@selector(runMemberRequest) withObject:nil];
				
			}else {
				
				[submitButton setEnabled:YES];
				[resetButton setEnabled:YES];
				[self.navigationItem setHidesBackButton:NO];
				[self.email setEnabled:YES];
				[self.password setEnabled:YES];
				
				self.error.text = @"*Password does not match";
			}
		}

	}
	
}

- (void)runMemberRequest {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *response = [ServerAPI getMembershipStatus:self.email.text];
	
	//Pull out the token from the JSON response...
	SBJSON *jsonParser = [SBJSON new];
	
	NSDictionary *feed = (NSDictionary *) [jsonParser objectWithString:response error:NULL];
	 
	NSString *message = [feed valueForKey:@"numberOfTeams"];
	
	int numTeams = [message intValue];
	
	if (numTeams > 0) {
		self.isMember = true;
	}else {
		self.isMember = false;
	}

	
	[self performSelectorOnMainThread:
	 @selector(didFinishMember)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinishMember{
	
	//When background thread is done, return to main thread
	[registering stopAnimating];
	
	if (self.isMember){
		
		//Create a user (other info is on Web App), store Token
		
		[registering startAnimating];
		
		//Disable the UI buttons and textfields while registering
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.email setEnabled:NO];
		[self.password setEnabled:NO];
		
		
		//Register the User in a background thread
		
		[self performSelectorInBackground:@selector(runRegister) withObject:nil];
	}else {
		
		RegisterNewUser *nextController = [[RegisterNewUser alloc] init];
		nextController.email = self.email.text;
		nextController.password = self.password.text;
		[self.navigationController  pushViewController:nextController animated:YES];
		
		
	}
	
}

- (void)runRegister {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	NSString *response = [ServerAPI createUser:@""
											  :@""
											  :self.email.text
											  :self.password.text
											  :@"true"];
	
	//Pull out the token from the JSON response...
	SBJSON *jsonParser = [SBJSON new];
	
	NSDictionary *feed = (NSDictionary *) [jsonParser objectWithString:response error:NULL];
	
	NSString *message = [feed valueForKey:@"message"];
	
	if ([message isEqualToString:@"User created"]){
		
		NSString *token = [feed valueForKey:@"token"];
		
		iCoachAppDelegate *mainDelegate = (iCoachAppDelegate *)[[UIApplication sharedApplication] delegate];
		mainDelegate.token = token;
		
		if (mainDelegate.pushToken != nil) {
			NSString *tmp = [[NSString alloc] initWithData:mainDelegate.pushToken encoding:NSUTF8StringEncoding];
			[ServerAPI updateUser:token :@"" :@"" :@"" :tmp];
			[tmp release];
		}
		
		self.createSuccess = true;
	}else{
		self.createSuccess = false;
		error.text = [@"*" stringByAppendingString:message];
	}
	
	[self performSelectorOnMainThread:
	 @selector(didFinishRunRegister)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinishRunRegister{
	
	//When background thread is done, return to main thread
	[registering stopAnimating];
	
	if (self.createSuccess){
		//Then go to the coaches home
		SettingsTabs *nextController = [[SettingsTabs alloc] init];
		nextController.fromRegisterFlow = @"true";
		nextController.didRegister = @"true";
		[self.navigationController  pushViewController:nextController animated:NO];
	}else {
		//if it failed, re-enable all fields so user can make changes
		
		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.email setEnabled:YES];
		[self.password setEnabled:YES];
		
	}
	
}


- (void)viewDidUnload {
	email = nil;
	password = nil;
	error = nil;
	registering = nil;
	submitButton = nil;
	resetButton = nil;
	sameEmail = nil;
	
	[super viewDidUnload];
}

- (void)dealloc {
	[email release];
	[password release];
	[error release];
	[registering release];
	[submitButton release];
	[resetButton release];
	[sameEmail release];
	
	[super dealloc];
}


@end
