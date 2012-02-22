//
//  ResetPasswordWithQuestion.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordWithQuestion.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Login.h"
#import <QuartzCore/QuartzCore.h>
#import "GANTracker.h"

@implementation ResetPasswordWithQuestion
@synthesize question, answerField, questionField, errorLabel, activity, submitButton, success, email, errorString, theAnswerField;

-(void)viewDidLoad{
	
	self.title = @"Reset Password";
	self.questionField.text = self.question;
	self.answerField.delegate = self;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    self.answerField.layer.masksToBounds = YES;
	self.answerField.layer.cornerRadius = 7.0;
}

-(void)submit{
	
	self.errorLabel.text = @"";
	
	//Validate all fields are entered:
	if ([self.answerField.text  isEqualToString:@""]){
		self.errorLabel.text = @"*You must enter an answer.";	
	}else{
		
		[activity startAnimating];
		
		//Disable the UI buttons and textfields while registering
		[self.submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.answerField setEditable:NO];
		
		
		//Register the User in a background thread
		
        self.theAnswerField = [NSString stringWithString:self.answerField.text];
        
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Reset Password With Question"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		
	}
}


- (void)runRequest {

	@autoreleasepool {
        NSDictionary *response = [ServerAPI resetUserPassword:self.email :self.theAnswerField];
        
        
        NSString *status = [response valueForKey:@"status"];
		
        if ([status isEqualToString:@"100"]){
            
            self.success = true;
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            self.success = false;
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
                case 215:
                    //error connecting to server
                    self.errorString = @"*Invalid reset question/answer.";
                    break;
                case 600:
                    //error connecting to server
                    self.errorString = @"*Invalid reset question/answer.";
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
	
	if (self.success){
		
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num - 3;
		
		Login *cont = [temp objectAtIndex:num];
		cont.success.text = @"Success!  You will recieve your new password via email.";
		cont.error.text = @"";
		cont.password.text = @"";
		[cont.submitButton setEnabled:YES];
		[cont.email setEnabled:YES];
		[cont.password setEnabled:YES];
		[self.navigationController popToViewController:cont animated:YES];
	
	}else {
		//if it failed, re-enable all fields so user can make changes
		
		self.errorLabel.text = self.errorString;
		
		[self.submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.answerField setEditable:YES];
		
	}
	
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

-(void)viewDidUnload{
	
	//question = nil;
	answerField = nil;
	questionField = nil;
	errorLabel = nil;
	activity = nil;
	submitButton = nil;
	//errorString = nil;
	//email = nil;
	[super viewDidUnload];
}

@end
