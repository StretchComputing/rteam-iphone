//
//  Login.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


#import "Login.h"
#import "ServerAPI.h"
#import "CoachTeamHome.h"
#import "JSON/JSON.h"
#import "rTeamAppDelegate.h"
#import "RegisterInvalidPassword.h"
#import "RegisterNewUser.h"
#import "ResetPassword.h"
#import "Home.h"
#import "SettingsTabs.h"
#import "Login.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation Login
@synthesize email, password, error, registering, submitButton, createSuccess, invalidEmail, isMember, serverError, success, numMemberTeams, 
resetPasswordButton, errorString, startEmail, theEmail, thePassword;


-(void)viewWillAppear:(BOOL)animated{
	
	[self.submitButton setEnabled:YES];
	[self.resetPasswordButton setEnabled:YES];
	[self.email setEnabled:YES];
	[self.password setEnabled:YES];
	
}
- (void)viewDidLoad {
	self.title = @"Login";

	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.email.text = self.startEmail;
	
}

-(void)endText {
	
	
	
}

-(void)submit{
	
    [TraceSession addEventToSession:@"Login Page - Login Button Clicked"];
    
    self.success.text = @"";
	self.error.text = @"";
	
	//Validate all fields are entered:
	if (([email.text  isEqualToString:@""]) ||
		([password.text  isEqualToString:@""])){
		error.text = @"*You must enter a value for each field";	
	}else{
		
		[registering startAnimating];
		
		//Disable the UI buttons and textfields while registering
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.email setEnabled:NO];
		[self.password setEnabled:NO];
		[self.resetPasswordButton setEnabled:NO];
		
		
		//Register the User in a background thread
		
        self.theEmail = [NSString stringWithString:self.email.text];
        self.thePassword = [NSString stringWithString:self.password.text];
        
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		
	}
}


- (void)runRequest {

	@autoreleasepool {
        NSDictionary *response = [ServerAPI getUserToken:self.theEmail :self.thePassword];
        
		
        NSString *status = [response valueForKey:@"status"];
                
        if ([status isEqualToString:@"100"]){
            
            NSString *token = [response valueForKey:@"token"];
            
            NSString *userIconOneId = [response valueForKey:@"userIconOneId"];
            NSString *userIconOneAlias = [response valueForKey:@"userIconOneAlias"];
            NSString *userIconTwoId = [response valueForKey:@"userIconTwoId"];
            NSString *userIconTwoAlias = [response valueForKey:@"userIconTwoAlias"];
            
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            mainDelegate.token = token;
            
            if (userIconOneId == nil) {
                mainDelegate.quickLinkOne = @"create";
            }else {
                mainDelegate.quickLinkOne = userIconOneId;
                
            }
            
            if (userIconOneAlias == nil) {
                mainDelegate.quickLinkOneName = @"";
            }else {
                mainDelegate.quickLinkOneName = userIconOneAlias;
                
            }
            
            if (userIconTwoId == nil) {
                mainDelegate.quickLinkTwo = @"";
            }else {
                mainDelegate.quickLinkTwo = userIconTwoId;
                
            }
            
            if (userIconTwoAlias == nil) {
                mainDelegate.quickLinkTwoName = @"";
            }else {
                mainDelegate.quickLinkTwoName = userIconTwoAlias;			
            }
            
            if ([response valueForKey:@"userIconOneImage"] != nil) {
                NSString *imageOne = [response valueForKey:@"userIconOneImage"];
                mainDelegate.quickLinkOneImage = imageOne;
            }else {
                mainDelegate.quickLinkOneImage = @"";
            }
            
            if ([response valueForKey:@"userIconTwoImage"] != nil) {
                NSString *imageOne = [response valueForKey:@"userIconTwoImage"];
                mainDelegate.quickLinkTwoImage = imageOne;
            }else {
                mainDelegate.quickLinkTwoImage = @"";
            }
            
            [mainDelegate saveUserInfo];
            
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
                case 200:
                    //invalid user credentials
                    self.errorString = @"*Invalid username/password";
                    break;
                default:
                    //should never get here
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:
         @selector(didFinish)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[registering stopAnimating];
	
	if (self.createSuccess){
		
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"User Logged In"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
		//Then go to the coaches home
		SettingsTabs *nextController = [[SettingsTabs alloc] init];
		nextController.fromRegisterFlow = @"true";
		nextController.didRegister = @"false";
		[self.navigationController  pushViewController:nextController animated:NO];
	}else {
		//if it failed, re-enable all fields so user can make changes
		
		self.error.text = self.errorString;
		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.email setEnabled:YES];
		[self.password setEnabled:YES];
		[self.resetPasswordButton setEnabled:YES];
		
	}
	
}



-(void)resetPassword{
	
    [TraceSession addEventToSession:@"Login Page - Reset Password Button Clicked"];

    
	ResetPassword *tmp = [[ResetPassword alloc] init];
	[self.navigationController pushViewController:tmp animated:YES];
}

- (void)viewDidUnload {
	email = nil;
	password = nil;
	error = nil;
	registering = nil;
	submitButton = nil;
	success = nil;
	resetPasswordButton  = nil;
	[super viewDidUnload];
}

@end
