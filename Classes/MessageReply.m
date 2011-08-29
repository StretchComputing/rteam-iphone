//
//  MessageReply.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageReply.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "ViewMessageReceived.h"
#import "FastActionSheet.h"

@implementation MessageReply
@synthesize teamId, subject, origMessage, replyToId, replyToName, userRole, errorString, toLabel, newMessageText, oldMessageText, errorLabel, activity,
sendButton, origMessageLabel, origMessageDate, replyAlert, keyboardToolbar;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

-(void)doneKeyboard{
    
    [self.newMessageText resignFirstResponder];
    [self becomeFirstResponder];

    
}
-(void)viewDidLoad{
	
	self.title = @"Reply";
	
	self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
    self.keyboardToolbar.barStyle = UIBarStyleBlack;
    self.keyboardToolbar.translucent = YES;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    
    UIBarButtonItem *doneKeyboard =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                            target:self action:@selector(doneKeyboard)];
    
    
	NSArray *items1 = [NSArray arrayWithObjects:flexibleSpace, doneKeyboard, nil];
	self.keyboardToolbar.items = items1;

    
    
    [self.view addSubview:self.keyboardToolbar];
    
	self.toLabel.text = [NSString stringWithFormat:@"To: %@", self.replyToName];
	self.errorLabel.textColor = [UIColor redColor];
	
	self.origMessageLabel.text = [NSString stringWithFormat:@"On %@, %@ wrote:", self.origMessageDate, self.replyToName];
	self.oldMessageText.text = self.origMessage;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.sendButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.newMessageText.delegate = self;
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    /*
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		[self becomeFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
     */
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.newMessageText.text isEqualToString:@"Enter your reply here..."]){
		self.newMessageText.text = @"";
	}
}


-(void)send{
	self.errorLabel.text = @"";
	if ([self.newMessageText.text isEqualToString:@""] || [self.newMessageText.text isEqualToString:@"Enter your reply here..."]) {
		self.errorLabel.text = @"*You must enter a reply.";
	}else {
		
		self.newMessageText.editable = NO;
		self.sendButton.enabled = NO;
		[self.activity startAnimating];
		
		[self performSelectorInBackground:@selector(sendTheMessage) withObject:nil];
	}

	
	
}

- (void)sendTheMessage {
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	
	NSDictionary *response = [NSDictionary dictionary];
	NSMutableArray *mutableMemberIds = [NSMutableArray array];
	NSArray *recipientMemberIds = [NSArray array];
	
	[mutableMemberIds addObject:self.replyToId];
	
	recipientMemberIds = mutableMemberIds;
	
		
	if (![token isEqualToString:@""]){	
		
        NSString *doAlert = @"false";
        
        if (self.replyAlert){
            
            doAlert = @"true";
            
        }
		response = [ServerAPI createMessageThread:token :self.teamId :self.subject :self.newMessageText.text :@"plain" :@"" 
												 :@"" :doAlert :[NSArray array] :recipientMemberIds :@"" :@"false" :@""];
        
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
					self.errorString = @"*Only members can send messages.";
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
	
    [pool drain];
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[self.activity stopAnimating];
	
	if ([self.errorString isEqualToString:@""]){
		
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 2;
		
		ViewMessageReceived *tmp = [tempCont objectAtIndex:tempNum];
		tmp.replySuccess = true;
		[self.navigationController popToViewController:tmp animated:YES];
			
				
	}else{
		
		if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can send messages.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            [alert release];
		}else {
			self.errorLabel.text = self.errorString;
		}
		
		[self.sendButton setEnabled:YES];		
		[self.newMessageText setEditable:YES];
	}
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

-(void)viewDidUnload{
	
	toLabel = nil;
	newMessageText = nil;
	oldMessageText = nil;
	errorLabel = nil;
	activity = nil;
	sendButton = nil;
	origMessageLabel = nil;
	
	[super viewDidUnload];
}

-(void)dealloc{
	[origMessageLabel release];
	[origMessageDate release];
	[teamId release];
	[subject release];
	[origMessage release];
	[replyToId release];
	[replyToName release];
	[userRole release];
	[errorString release];
	[toLabel release];
	[newMessageText release];
	[oldMessageText release];
	[errorLabel release];
	[activity release];
	[sendButton release];
	[super dealloc];
	
}
	
	

@end
