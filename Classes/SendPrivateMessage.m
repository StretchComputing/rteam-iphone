//
//  SendPrivateMessage.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SendPrivateMessage.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Team.h"
#import "Fan.h"
#import "Player.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation SendPrivateMessage
@synthesize keyboardIsUp, keyboardButton, recipients, cancelMessageButton, messageText, activity, recipLabel, recipientObjects, errorString, errorLabel, teamId, theMessageText, isReply, descripLabel, isConfirm;


-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"SendPrivateMessage - View Will Appear"];

    NSString *nameString = @"";
    self.recipients = [NSMutableArray array];
        
    for (int i = 0; i < [self.recipientObjects count]; i++) {
        
        NSString *theName = @"";
        
        if ([(self.recipientObjects)[i] class] == [Fan class]) {
            Fan *tmpFan = (self.recipientObjects)[i];
            theName = tmpFan.firstName;
            [self.recipients addObject:tmpFan.memberId];
        }else if ([(self.recipientObjects)[i] class] == [Player class]){
            Player *tmpPlayer = (self.recipientObjects)[i];
            theName = tmpPlayer.firstName;
            [self.recipients addObject:tmpPlayer.memberId];
        }
        
        if (i == [self.recipientObjects count] - 1) {
            nameString = [nameString stringByAppendingFormat:theName];
        }else{
            nameString = [nameString stringByAppendingFormat:@"%@, ", theName];
        }
    }
    
    self.recipLabel.text = [NSString stringWithFormat:@"Send To: %@", nameString];
}


- (void)viewDidLoad
{
    self.keyboardIsUp = false;
    
    if (self.isReply) {
        if (self.isConfirm) {
            self.title = @"Send Message";
        }else{
            self.title = @"Reply";
        }
    }else{
        self.title = @"Message";
    }
    
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
	[self.navigationItem setRightBarButtonItem:postButton];
    
    
    self.messageText.delegate = self;
    
    if (self.isReply) {
        self.descripLabel.hidden = YES;
    }else{
        self.descripLabel.hidden = NO;
    }
    [super viewDidLoad];
    
}

-(void)post{
    
    [TraceSession addEventToSession:@"Private Message Page - Send Button Clicked"];

    
    self.theMessageText = [NSString stringWithString:self.messageText.text];
    
    if ((self.messageText.text != nil) && ![self.messageText.text isEqualToString:@""]) {
        
        [self.activity startAnimating];
        [self.keyboardButton setEnabled:NO];
        [self.cancelMessageButton setEnabled:NO];
        
    
        
        [self performSelectorInBackground:@selector(createActivity) withObject:nil];
    }
    
}
-(void)cancel{
    [TraceSession addEventToSession:@"Private Message Page - Cancel Button Clicked"];

    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)createActivity{
    
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        NSDictionary *response = @{};
        
        if (![token isEqualToString:@""]){	
            
            response = [ServerAPI createMessageThread:token teamId:self.teamId subject:@"(no subject)" body:self.theMessageText type:@"confirm" eventId:@"" eventType:@"" isAlert:@"true" pollChoices:@[] recipients:self.recipients displayResults:@"" includeFans:@"true" coordinatorsOnly:@""];
            
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
                    case 207:
                        //error connecting to server
                        self.errorString = @"*Fans cannot send messages.";
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
        
        [self performSelectorOnMainThread:@selector(donePost) withObject:nil waitUntilDone:NO];
    }
    
}

-(void)donePost{
    
    [self.activity stopAnimating];
    [self.keyboardButton setEnabled:YES];
    [self.cancelMessageButton setEnabled:YES];
    
    if ([self.errorString isEqualToString:@""]) {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Send Private Message"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        [self.navigationController dismissModalViewControllerAnimated:YES];

    }else{
        
        if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send messages.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            
            [self.messageText resignFirstResponder];
		}else{
            self.errorLabel.text = self.errorString;
        }
        
    }

    
}




- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.keyboardIsUp = true;
    [self.keyboardButton setImage:[UIImage imageNamed:@"keyboarddown.png"] forState:UIControlStateNormal];
}

-(void)keyboard{
    
    if (self.keyboardIsUp) {
        self.keyboardIsUp = false;
        [self.messageText resignFirstResponder];
        [self.keyboardButton setImage:[UIImage imageNamed:@"keyboardup.png"] forState:UIControlStateNormal];
        
    }else{
        self.keyboardIsUp = true;
        [self.messageText becomeFirstResponder];
        [self.keyboardButton setImage:[UIImage imageNamed:@"keyboarddown.png"] forState:UIControlStateNormal];
        
    }
    
}

-(void)cancelMessage{
    
    if (self.isReply) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}
- (void)viewDidUnload
{
    messageText = nil;
    cancelMessageButton = nil;
    keyboardButton = nil;
    activity = nil;
    recipLabel = nil;
    errorLabel = nil;
    descripLabel = nil;
    [super viewDidUnload];
    
}

@end