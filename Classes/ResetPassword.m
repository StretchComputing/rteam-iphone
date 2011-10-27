//
//  ResetPassword.m
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResetPassword.h"
#import "ServerAPI.h"
#import "Register.h"
#import "Login.h"
#import "ResetPasswordWithQuestion.h"

@implementation ResetPassword
@synthesize email, activity, error, hasQuestion, resetButton, success, question, errorString;

-(void)viewDidLoad{
	
	self.title = @"Reset Password";
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.resetButton setBackgroundImage:stretch forState:UIControlStateNormal];
}

-(void)reset{
	self.error.text = @"";
	if ([self.email.text isEqualToString:@""]) {
		self.error.text = @"To reset your password, first enter your email address";
	}else {
		
		[activity startAnimating];
		[self.resetButton setEnabled:NO];
		[self.email setEnabled:NO];
		
		[self performSelectorInBackground:@selector(getResetPasswordQuestion) withObject:nil];
		
	}
	
	
}

- (void)getResetPasswordQuestion {

	NSDictionary *response = [ServerAPI getUserPasswordResetQuestion:self.email.text];
	
	
	NSString *status = [response valueForKey:@"status"];
			
	if ([status isEqualToString:@"100"]){
		
		self.success = true;
		self.question = [response valueForKey:@"passwordResetQuestion"];
		
		if ([self.question isEqualToString:@""]) {
			self.hasQuestion = false;
		}else {
			self.hasQuestion = true;
		}

		
	}else{
		
		self.success = false;
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
			case 600:
				//invalid user credentials
				self.errorString = @"*Email address does not match any users";
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

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[activity stopAnimating];
	
	if (self.success) {
		
		[self.error setHidden:YES];
		
		if (self.hasQuestion){
		
			ResetPasswordWithQuestion *tmp = [[ResetPasswordWithQuestion alloc] init];
			tmp.question = self.question;
			tmp.email = self.email.text;
			UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
			self.navigationItem.backBarButtonItem = temp;
			[self.navigationController pushViewController:tmp animated:YES];
		
		}else {
			//if it failed, re-enable all fields so user can make changes
	
			self.error.text = self.errorString;
			NSString *display = [@"Reset Password for '" stringByAppendingString:self.email.text];
			display = [display stringByAppendingFormat:@"'?"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:display message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
			[alert show];
		
		}
	}else {
		self.error.text = self.errorString;
		[self.resetButton setEnabled:YES];
		[self.email setEnabled:YES];
		[self.error setHidden:NO];
	}

	
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		[self.resetButton setEnabled:YES];
		[self.email setEnabled:YES];
		
		//"Yes"
	}else if (buttonIndex == 1) {
		
		NSDictionary *response = [ServerAPI resetUserPassword:self.email.text :@""];
		
			NSString *status = [response valueForKey:@"status"];
			
		
			if ([status isEqualToString:@"100"]){
				NSArray *temp = [self.navigationController viewControllers];
				int num = [temp count];
				num = num - 2;
				
				Login *cont = [temp objectAtIndex:num];
				cont.success.text = @"Success!  You will recieve your new password via email.";
				cont.error.text = @"";
				cont.password.text = @"";
				[cont.submitButton setEnabled:YES];
				[cont.email setEnabled:YES];
				[cont.password setEnabled:YES];
				[self.navigationController popToViewController:cont animated:YES];
				
			
				
			}else{
				
				//Server hit failed...get status code out and display error accordingly
				int statusCode = [status intValue];
				[self.resetButton setEnabled:YES];
				[self.email setEnabled:YES];
				switch (statusCode) {
					case 0:
						//null parameter
						self.error.text = @"*Error connecting to server";
						break;
					case 1:
						//error connecting to server
						self.error.text = @"*Error connecting to server";
						break;
					case 215:
						//password not reset
						self.error.text = @"*Error connecting to server";
						break;
					case 600:
						//User not found
						self.error.text = @"*Email address doesn't match any users";
						break;
					default:
						//should never get here
						self.error.text = @"*Error connecting to server";
						break;
				}
			}
			
		
		
	}
	
}

-(void)endText{
	
}

-(void)viewDidUnload{
	email = nil;
	activity = nil;
	error = nil;
	resetButton = nil;
	activity = nil;
	[super viewDidUnload];
}

@end
