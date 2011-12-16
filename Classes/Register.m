//
//  CoachRegister.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Register.h"
#import "ServerAPI.h"
#import "CoachTeamHome.h"
#import "JSON/JSON.h"
#import "rTeamAppDelegate.h"
#import "RegisterNewUser.h"
#import "ResetPassword.h"
#import "Home.h"
#import "SettingsTabs.h"
#import "Login.h"
#import "QuartzCore/QuartzCore.h"
#import "TraceSession.h"


@implementation Register
@synthesize email, password, error, registering, submitButton, createSuccess, invalidEmail, isMember, serverError, success, numMemberTeams, helpScreen,
isHelpOpen, barItem, memberLogin, confirmEmail, closeButton, firstName, lastName, watchVideoButton, errorString, loginButton, middleView, theEmail, thePassword;


-(void)viewWillAppear:(BOOL)animated{

	
	[self.submitButton setEnabled:YES];
	[self.memberLogin setEnabled:YES];
	[self.navigationItem setHidesBackButton:YES];
	[self.email setEnabled:YES];
	[self.password setEnabled:YES];
	[self.confirmEmail setEnabled:YES];
	
	//self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1];
	
}
- (void)viewDidLoad {
	self.title = @"Register";
	
	self.firstName = @"";
	self.lastName = @"";
	[self.helpScreen setHidden:YES];
	self.isHelpOpen = false;
	
	[self.navigationItem setHidesBackButton:YES];
	
	//self.navigationController.navigationBar.tintColor = [UIColor grayColor]; 
	
	self.barItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
	[self.navigationItem setRightBarButtonItem:self.barItem];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.closeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.loginButton setBackgroundImage:stretch forState:UIControlStateNormal];


	
	self.helpScreen.layer.masksToBounds = YES;
	self.helpScreen.layer.cornerRadius = 15.0;
	self.middleView.layer.masksToBounds = YES;
	self.middleView.layer.cornerRadius = 15.0;
	
}

-(void)memberLoginAction{
    [TraceSession addEventToSession:@"Register Page - Log In Here Button Clicked"];
	Login *tmp = [[Login alloc] init];
	[self.navigationController pushViewController:tmp animated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 1) {
		Login *tmp = [[Login alloc] init];
		tmp.startEmail = self.email.text;
		[self.navigationController pushViewController:tmp animated:NO];
	}
	
	
}

-(void)about{
	
	[TraceSession addEventToSession:@"Register Page - Help Button Clicked"];
    
	if ([self.barItem.title isEqualToString:@"Help"]) {
		self.barItem.title = @"Done";
		[self.helpScreen setHidden:NO];
        [self.email resignFirstResponder];
        [self.confirmEmail resignFirstResponder];
        [self.password resignFirstResponder];
	}else {
		self.barItem.title = @"Help";
		[self.helpScreen setHidden:YES];
	}

	//TestAddrBook *nextController = [[TestAddrBook alloc] init];
	//[self.navigationController pushViewController:nextController animated:YES];
}

-(void)closeHelp{
	
	self.barItem.title = @"Help";
	[self.helpScreen setHidden:YES];
}


-(void)endText {
	
	
	
}

-(void)submit{
	
    [TraceSession addEventToSession:@"Register Page - Register Button Clicked"];

    
    self.success.text = @"";
	self.error.text = @"";
	//Validate all fields are entered:
	if (([email.text  isEqualToString:@""]) ||
		([password.text  isEqualToString:@""])){
	   error.text = @"*You must enter a value for each field";	
	}else if (![email.text isEqualToString:confirmEmail.text]){
		error.text = @"*Email and Confirm Email must match";
	}else{
		
		[registering startAnimating];

		//Disable the UI buttons and textfields while registering
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.email setEnabled:NO];
		[self.password setEnabled:NO];
		[self.confirmEmail setEnabled:NO];
		[self.memberLogin setEnabled:NO];
		
		
		//Register the User in a background thread

        self.theEmail = [NSString stringWithString:self.email.text];
        
		[self performSelectorInBackground:@selector(runMemberRequest) withObject:nil];
	
		
	
	}
}


- (void)runMemberRequest {
	
	@autoreleasepool {
        NSDictionary *response = [ServerAPI getMembershipStatus:self.theEmail];
        
        NSString *status = [response valueForKey:@"status"];
        self.isMember = false;
		
        if ([status isEqualToString:@"100"]){
            
            self.numMemberTeams = [[response valueForKey:@"numberOfTeams"] intValue];
            
            if (self.numMemberTeams > 0) {
                self.isMember = true;
            }
            
            if ([response valueForKey:@"firstName"] != nil) {
                self.firstName = [response valueForKey:@"firstName"];
            }
            
            if ([response valueForKey:@"lastName"] != nil) {
                self.lastName = [response valueForKey:@"lastName"];
            }
        }else{
            
            self.isMember = false;
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
                    //
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:
         @selector(didFinishMember)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

- (void)didFinishMember{
	
	//When background thread is done, return to main thread
	[registering stopAnimating];
	
	if (self.isMember){
		
		//Create a user (other info is on Web App), store Token
		
		if ([self.firstName isEqualToString:@""] || [self.lastName isEqualToString:@""]) {
			
			RegisterNewUser *tmp = [[RegisterNewUser alloc] init];
			tmp.email = email.text;
			tmp.password = password.text;
			tmp.firstString = self.firstName;
			tmp.lastString = self.lastName;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else {
			
			[registering startAnimating];
			
			//Disable the UI buttons and textfields while registering
			[submitButton setEnabled:NO];
			[self.navigationItem setHidesBackButton:YES];
			[self.email setEnabled:NO];
			[self.password setEnabled:NO];
			[self.watchVideoButton setEnabled:NO];
			
			
			//Register the User in a background thread
			
            self.theEmail = [NSString stringWithString:self.email.text];
            self.thePassword = [NSString stringWithString:self.password.text];
            
			[self performSelectorInBackground:@selector(runRegister) withObject:nil];
			
		}

		
		
	}else {
		self.error.text = self.errorString;
		self.error.text = @"";
		RegisterNewUser *tmp = [[RegisterNewUser alloc] init];
		tmp.email = email.text;
		tmp.password = password.text;
		[self.navigationController pushViewController:tmp animated:YES];
		
		
	}
	
}


- (void)runRegister {

	@autoreleasepool {
        NSDictionary *response = [ServerAPI createUser:self.firstName
                                                      :self.lastName
                                                      :self.theEmail
                                                      :self.thePassword
                                                      :@"true" :@"" :@"" :@"" :@"" :@""];
        
        
        NSString *status = [response valueForKey:@"status"];
		
        if ([status isEqualToString:@"100"]){
            
            NSString *token = [response valueForKey:@"token"];
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            mainDelegate.token = token;
            mainDelegate.quickLinkOne = @"create";
            mainDelegate.quickLinkTwo = @"";
            mainDelegate.quickLinkOneName = @"";
            mainDelegate.quickLinkTwoName = @"";
            mainDelegate.quickLinkOneImage = @"";
            mainDelegate.quickLinkTwoImage = @"";
            
            [mainDelegate saveUserInfo];
            
            self.createSuccess = true;
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            self.createSuccess = false;
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 201:
                    //email address already in use
                    self.errorString = @"*Email address is already in use.";
                    break;
                case 300:
                    //first and last names required
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 303:
                    //email address and password required
                    self.errorString = @"*Email address and password required.";
                    break;
                case 518:
                    //invalid already member parameter
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 542:
                    //invalid already member parameter
                    self.errorString = @"*Invalid phone number.";
                    break;
                default:
                    //should never get here
                    self.errorString = @"*Error connecting to server.";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:
         @selector(didFinishRunRegister)
                               withObject:nil
                            waitUntilDone:NO
         ];

        
    }
		
}

- (void)didFinishRunRegister{
	
	//When background thread is done, return to main thread
	[registering stopAnimating];
	
	if (self.createSuccess){
		//Then go to the coaches home
		SettingsTabs *nextController = [[SettingsTabs alloc] init];
		nextController.fromRegisterFlow = @"true";
		nextController.didRegister = @"true";
		nextController.numMemberTeams = self.numMemberTeams;
		[self.navigationController  pushViewController:nextController animated:NO];
	}else {
		//if it failed, re-enable all fields so user can make changes
		if ([self.errorString isEqualToString:@"*Email address is already in use"]) {
			NSString *message1 = @"The email address you entered is already being used by a registered rTeam User.  If you are already a User, please use the Login Page access your account.";
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Email Not Valid" message:message1 delegate:self cancelButtonTitle:nil otherButtonTitles:@"Try Again", @"Login Page", nil];
			[alert1 show];
		}else {
			self.error.text = self.errorString;

		}

		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:YES];
		[self.email setEnabled:YES];
		[self.password setEnabled:YES];
		[self.confirmEmail setEnabled:YES];
		[self.memberLogin setEnabled:YES];
		[self.watchVideoButton setEnabled:YES];
		
	}
	
}


-(void)watchVideo{
	
    [TraceSession addEventToSession:@"Register Page - Watch Video Button Clicked"];

    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"rTeamWelcomeFinal" ofType:@"m4v"];      
	if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.2)
	{
		MPMoviePlayerViewController *tmpMoviePlayViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
		if (tmpMoviePlayViewController) {
			[self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
			[tmpMoviePlayViewController.moviePlayer play];
		}
		//[tmpMoviePlayViewController release];
	}
	else{
		MPMoviePlayerController *theMovie=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
		[theMovie play];
	}
	
	
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{      
	MPMoviePlayerController* theMovie=[aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];

    [[UIApplication sharedApplication]
						 setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
}

- (void)viewDidUnload {
	email = nil;
	password = nil;
	error = nil;
	registering = nil;
	submitButton = nil;
	success = nil;
	helpScreen = nil;
	barItem = nil;
	memberLogin  = nil;
	confirmEmail = nil;
	loginButton = nil;
	middleView = nil;
	closeButton = nil;
	watchVideoButton = nil;
	[super viewDidUnload];
}



@end
