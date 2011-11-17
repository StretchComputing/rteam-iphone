//
//  ChangePassword.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChangePassword.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "SettingsTabs.h"
#import "GANTracker.h"

@implementation ChangePassword
@synthesize submitButton, error, password, confirmPassword, activity, changeSuccess, errorString, thePassword;

-(void)viewDidLoad{
	
	self.title = @"Change Password";
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
}

-(void)submit{
	
	self.error.text = @"";
	//Validate all fields are entered:
	if (([self.password.text  isEqualToString:@""]) ||
		([self.confirmPassword.text  isEqualToString:@""])){
		self.error.text = @"*You must enter a value for each field";	
	}else if (![self.password.text isEqualToString:self.confirmPassword.text]) {
		self.error.text = @"*Your passwords do not match";
	}else{
		
		[activity startAnimating];
		
		//Disable the UI buttons and textfields while registering
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.confirmPassword setEnabled:NO];
		[self.password setEnabled:NO];
		
		
		//Register the User in a background thread
		
        self.thePassword = [NSString stringWithString:self.password.text];
        
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Change Password"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		
	}
}


- (void)runRequest {

	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response = [ServerAPI updateUser:mainDelegate.token :@"" :@"" :self.thePassword :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :[NSData data] :@"" :@"" :@"" :@"" :@"" :@""];
        
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            self.changeSuccess = true;
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            self.changeSuccess = false;
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
                case 500:
                    //email address already in use
                    self.errorString = @"*Error connecting to server";
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
	[activity stopAnimating];
	
	if (self.changeSuccess){
		
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num - 2;
		
		SettingsTabs *tmp = [temp objectAtIndex:num];
		tmp.displaySuccess = true;
		[self.navigationController popToViewController:tmp animated:YES];
	}else {
				
		self.error.text = self.errorString;
		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.confirmPassword setEnabled:YES];
		[self.password setEnabled:YES];
		
	}
	
}

-(void)viewDidUnload{
	submitButton = nil;
	error = nil;
	password = nil;
	confirmPassword = nil;
	activity = nil;
	errorString = nil;
	[super viewDidUnload];
}


-(void)endText{
	
}


@end
