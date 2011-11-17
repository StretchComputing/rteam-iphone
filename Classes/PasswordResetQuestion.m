//
//  PasswordResetQuestion.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PasswordResetQuestion.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "SettingsTabs.h"
#import <QuartzCore/QuartzCore.h>
#import "GANTracker.h"

@implementation PasswordResetQuestion
@synthesize question, newQuestion, newAnswer, submitButton, errorLabel, activity, errorString, newQuestionString, newAnswerString;

-(void)viewDidLoad{
	self.title = @"Question";
    
	self.newQuestion.delegate = self;
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.newQuestion.layer.masksToBounds = YES;
	self.newQuestion.layer.cornerRadius = 7.0;
	
}

-(void)submit{
	
    self.errorLabel.text = @"";
    
    if ([self.newQuestion.text isEqualToString:@""] || [self.newAnswer.text isEqualToString:@""]) {
        self.errorLabel.text = @"*You must fill in both fields.";
    }else{
        
        self.submitButton.enabled = NO;
        self.newQuestion.editable = NO;
        self.newAnswer.enabled = NO;
        
        [self.activity startAnimating];
        
        self.newQuestionString = [NSString stringWithString:self.newQuestion.text];
        self.newAnswerString = [NSString stringWithString:self.newAnswer.text];
        
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Change Password Reset Question"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    }
		
}

-(void)runRequest{
 
    @autoreleasepool {
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :self.newQuestionString :self.newAnswerString :@"" :@"" :@"" :@"" :@"" :@"" :@"" :[NSData data] :@"" :@"" :@"" :@"" :@"" :@""]; 		
            
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
                        self.errorString = @"*Error connecting to server";
                        break;
                    default:
                        //log status code
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        [self performSelectorOnMainThread:@selector(doneRequest) withObject:nil waitUntilDone:NO];

    }
   
}

-(void)doneRequest{
    
    self.submitButton.enabled = YES;
    self.newQuestion.editable = YES;
    self.newAnswer.enabled = YES;
    [self.activity stopAnimating];
    
    if ([self.errorString isEqualToString:@""]) {
        NSArray *tempCont = [self.navigationController viewControllers];
        int tempNum = [tempCont count];
        tempNum = tempNum - 2;
        
        SettingsTabs *tmp = [tempCont objectAtIndex:tempNum];
        tmp.displaySuccess = true;
        [self.navigationController popToViewController:tmp animated:YES];
    }else{
        
        self.errorLabel.text = self.errorString;
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

-(void)endText{

	
}

- (void)viewDidUnload {
	//question = nil;
	newAnswer = nil;
	newQuestion = nil;
	errorLabel = nil;
	submitButton = nil;
    activity = nil;
    [super viewDidUnload];
 
}


@end
