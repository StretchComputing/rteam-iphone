//
//  SendPollOptions.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SendPollOptions.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "GameTabs.h"
#import "PracticeTabs.h"
#import "CurrentTeamTabs.h"
#import "FastActionSheet.h"
#import "Fan.h"
#import "Player.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation SendPollOptions
@synthesize action, question, errorMessage, option1, option2, option3, option4, option5, submitButton, questionText, teamId, createSuccess, 
eventId, eventType, pollSubject, origLoc, userRole, recipients, toTeam, displayResults, errorString, theOption1, theOption2, theOption3, theOption4, theOption5;

-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"SendPollOptions - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.question.text = self.questionText;
	self.title = @"Send Poll";
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.submitButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
}

-(void)submit{
    
    [TraceSession addEventToSession:@"Send Poll Options Page - Submit Button Clicked"];

    
	self.errorMessage.text = @"";
	if ([self.option1.text isEqualToString:@""] || [self.option2.text isEqualToString:@""]) {
		self.errorMessage.text = @"*You must have options #1 and #2 filled out";
	}else {
		
		[action startAnimating];
		
		//Disable the UI buttons and textfields while registering
		
		[submitButton setEnabled:NO];
		[self.navigationItem.leftBarButtonItem setEnabled:NO];
		[self.option1 setEnabled:NO];
		[self.option2 setEnabled:NO];
		[self.option3 setEnabled:NO];
		[self.option4 setEnabled:NO];
		[self.option5 setEnabled:NO];
		
		//Create the team in a background thread
		
        self.theOption1 = [NSString stringWithString:self.option1.text];
        self.theOption2 = [NSString stringWithString:self.option2.text];
        self.theOption3 = [NSString stringWithString:self.option3.text];
        self.theOption4 = [NSString stringWithString:self.option4.text];
        self.theOption5 = [NSString stringWithString:self.option5.text];
        
        
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	}

}




- (void)runRequest {

	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        NSArray *choices = [NSArray arrayWithObjects:self.theOption1, self.theOption2, nil];
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:choices];
        
        if (![self.theOption3 isEqualToString:@""]) {
            [tmpArray addObject:self.theOption3];
        }
        if (![self.theOption4 isEqualToString:@""]) {
            [tmpArray addObject:self.theOption4];
        }
        if (![self.theOption5 isEqualToString:@""]) {
            [tmpArray addObject:self.theOption5];
        }
        
        choices = tmpArray;
        
        if (self.eventType == nil){
            self.eventType = @"";
        } 
        if (self.eventId == nil){
            self.eventId = @"";
        }
        
        NSMutableArray *recipIds = [NSMutableArray array];
        for (int i = 0; i < [self.recipients count]; i++) {
            
            if ([[self.recipients objectAtIndex:i] class] == [Fan class]) {
                Fan *tmpFan = [self.recipients objectAtIndex:i];
                [recipIds addObject:tmpFan.memberId];
            }else if ([[self.recipients objectAtIndex:i] class] == [Player class]) {
                Player *tmpPlayer = [self.recipients objectAtIndex:i];
                [recipIds addObject:tmpPlayer.memberId];
            }
        }
        
        NSArray *recip = [NSArray arrayWithArray:recipIds];
        
        NSDictionary *response = [NSDictionary dictionary];
        if (![token isEqualToString:@""]){	
      
            
             response = [ServerAPI createMessageThread:token teamId:self.teamId subject:self.pollSubject body:self.questionText type:@"poll" eventId:@"" eventType:@"" isAlert:@"false" pollChoices:choices recipients:recip displayResults:self.displayResults includeFans:@"true" coordinatorsOnly:@""];
            
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
                    case 207:
                        //error connecting to server
                        self.errorString = @"*Fans cannot send polls.";
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
		
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[action stopAnimating];
	
	if (self.createSuccess){
		
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Send Poll - Options"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
		[self.navigationController dismissModalViewControllerAnimated:YES];		
	}else{
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send polls.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
			self.errorMessage.text = self.errorString;
			self.errorMessage.textColor = [UIColor redColor];
		}
		
		[submitButton setEnabled:YES];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
		[self.option1 setEnabled:YES];
		[self.option2 setEnabled:YES];
		[self.option3 setEnabled:YES];
		[self.option4 setEnabled:YES];
		[self.option5 setEnabled:YES];
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
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)viewDidUnload{
	
	action = nil;
	question = nil;
	errorMessage = nil;
	option1 = nil;
	option2 = nil;
	option3 = nil;
	option4 = nil;
	option5 = nil;
	submitButton = nil;
	//questionText = nil;
	//origLoc = nil;
	//teamId = nil;
	//eventId = nil;
	//eventType = nil;
	//userRole = nil;
	//recipients = nil;
	//displayResults = nil;
	//errorString = nil;
	//pollSubject = nil;
	[super viewDidUnload];
	

	
	
}

@end
