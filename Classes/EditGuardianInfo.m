//
//  EditGuardianInfo.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditGuardianInfo.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "FastActionSheet.h"
#import "Player.h"

@implementation EditGuardianInfo
@synthesize guardianArray, oneFirstName, oneLastName, oneEmail, twoFirstName, twoLastName, twoEmail, saveChangesButton, removeGuardiansButton,
activity, errorLabel, teamId, memberId, errorString, onePhone, twoPhone, oneKey, twoKey, guard1Na, guard2Na, phoneOnlyArray,
confirmedLabel, initGuard1Phone, initGuard2Phone, teamName, guard1SmsConfirmed, guard2SmsConfirmed, guard2isUser, guard1EmailConfirmed, guard2EmailConfirmed, guard1isUser;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
	
}

-(void)viewDidLoad{
    self.phoneOnlyArray = [NSMutableArray array];
	self.title = @"Edit Guardian Info";
	[self.errorLabel setHidden:NO];
    self.errorLabel.text = @"";
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.saveChangesButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.removeGuardiansButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
	
    self.initGuard1Phone = @"";
    self.initGuard2Phone = @"";
	
	if ([self.guardianArray count] > 0) {
				
		NSDictionary *guardOneInfo = [self.guardianArray objectAtIndex:0];
        
        self.oneFirstName.text = [guardOneInfo valueForKey:@"firstName"];
        self.oneLastName.text = [guardOneInfo valueForKey:@"lastName"];
        self.oneEmail.text = [guardOneInfo valueForKey:@"emailAddress"];
        self.onePhone.text = [guardOneInfo valueForKey:@"phoneNumber"];
        
        if ([guardOneInfo valueForKey:@"phoneNumber"] != nil) {
            self.initGuard1Phone = [guardOneInfo valueForKey:@"phoneNumber"];
        }
        self.oneKey = [guardOneInfo valueForKey:@"key"];

        
        self.removeGuardiansButton.hidden = NO;
		
	}else{
        self.removeGuardiansButton.hidden = YES;
    }
    
	if ([self.guardianArray count] > 1) {
		
		NSDictionary *guardTwoInfo = [self.guardianArray objectAtIndex:1];
		
		self.twoFirstName.text = [guardTwoInfo valueForKey:@"firstName"];
		self.twoLastName.text = [guardTwoInfo valueForKey:@"lastName"];
		self.twoEmail.text = [guardTwoInfo valueForKey:@"emailAddress"];
        self.twoPhone.text = [guardTwoInfo valueForKey:@"phoneNumber"];
        if ([guardTwoInfo valueForKey:@"phoneNumber"] != nil) {
            self.initGuard2Phone = [guardTwoInfo valueForKey:@"phoneNumber"];
        }
        self.twoKey = [guardTwoInfo valueForKey:@"key"];

		
	}

    myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];

    myTextFieldSemaphore = 0;
	[self.onePhone addTarget:self
                         action:@selector(autoFormatTextField:)
               forControlEvents:UIControlEventEditingChanged
	 ];
    [self.twoPhone addTarget:self
                      action:@selector(autoFormatTextField1:)
            forControlEvents:UIControlEventEditingChanged
	 ];


    self.confirmedLabel.hidden = YES;
   
    
    if (self.guard1isUser) {
        
        if (self.guard1EmailConfirmed) {
            self.oneEmail.enabled = NO;
            self.confirmedLabel.hidden = NO;
            self.confirmedLabel.textColor = [UIColor blueColor];
            self.oneEmail.textColor = [UIColor blueColor];
        }
        
        if (self.guard1SmsConfirmed) {
            self.onePhone.enabled = NO;
            self.confirmedLabel.hidden = NO;
            self.confirmedLabel.textColor = [UIColor blueColor];
            self.onePhone.textColor = [UIColor blueColor];
        }
    }else{
        
       
        
    }
    
   
    
    if (self.guard2isUser) {
        
        if (self.guard2EmailConfirmed) {
            self.twoEmail.enabled = NO;
            self.confirmedLabel.hidden = NO;
            self.confirmedLabel.textColor = [UIColor blueColor];
            self.twoEmail.textColor = [UIColor blueColor];
        }
        
        if (self.guard2SmsConfirmed) {
            self.twoPhone.enabled = NO;
            self.confirmedLabel.hidden = NO;
            self.confirmedLabel.textColor = [UIColor blueColor];
            self.twoPhone.textColor = [UIColor blueColor];
        }
    }else{
        
        
        
    }
    
   
}

-(void)removeGuardians{
	
    [activity startAnimating];
    
    //Disable the UI buttons and textfields while registering
    
    [self.saveChangesButton setEnabled:NO];
    [self.removeGuardiansButton setEnabled:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.oneFirstName setEnabled:NO];
    [self.oneLastName setEnabled:NO];
    [self.oneEmail setEnabled:NO];
    [self.twoFirstName setEnabled:NO];
    [self.twoLastName setEnabled:NO];
    [self.twoEmail setEnabled:NO];
    [self.onePhone setEnabled:NO];
    [self.twoPhone setEnabled:NO];
    
    
    
    //Create the player in a background thread
    
    [self performSelectorInBackground:@selector(runRemove) withObject:nil];

    
}

-(void)saveChanges{
	
	self.errorLabel.text = @"";
	self.phoneOnlyArray = [NSMutableArray array];
    
	if ([self.oneLastName.text isEqualToString:@""] || [self.oneFirstName.text isEqualToString:@""]) {
        self.errorLabel.text = @"*Please fill out the entire name for Guardian 1.";
    }else if ([self.onePhone.text isEqualToString:@""] && [self.oneEmail.text isEqualToString:@""]){
        self.errorLabel.text = @"*Email Address or Phone Number required for Guardian 1.";
    }else if (![self.twoFirstName.text isEqualToString:@""] || ![self.twoLastName.text isEqualToString:@""] ||
              ![self.twoEmail.text isEqualToString:@""] || ![self.twoFirstName.text isEqualToString:@""]){
        
        if ([self.twoLastName.text isEqualToString:@""] || [self.twoFirstName.text isEqualToString:@""]) {
            self.errorLabel.text = @"*Please fill out the entire name for Guardian 2.";
        }else if ([self.twoPhone.text isEqualToString:@""] && [self.twoEmail.text isEqualToString:@""]){
            self.errorLabel.text = @"*Email Address or Phone Number required for Guardian 2.";
        }else{
            
            [activity startAnimating];
            
            //Disable the UI buttons and textfields while registering
            
            [self.saveChangesButton setEnabled:NO];
            [self.removeGuardiansButton setEnabled:NO];
            [self.navigationItem setHidesBackButton:YES];
            [self.oneFirstName setEnabled:NO];
            [self.oneLastName setEnabled:NO];
            [self.oneEmail setEnabled:NO];
            [self.twoFirstName setEnabled:NO];
            [self.twoLastName setEnabled:NO];
            [self.twoEmail setEnabled:NO];
            [self.onePhone setEnabled:NO];
            [self.twoPhone setEnabled:NO];
            
            
            
            
            //Create the player in a background thread
            
            [self performSelectorInBackground:@selector(runRequest) withObject:nil];
            
            
        }
        
        
        
    }else {

		
		[activity startAnimating];
		
		//Disable the UI buttons and textfields while registering
		
		[self.saveChangesButton setEnabled:NO];
		[self.removeGuardiansButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.oneFirstName setEnabled:NO];
		[self.oneLastName setEnabled:NO];
		[self.oneEmail setEnabled:NO];
		[self.twoFirstName setEnabled:NO];
		[self.twoLastName setEnabled:NO];
		[self.twoEmail setEnabled:NO];
        [self.onePhone setEnabled:NO];
        [self.twoPhone setEnabled:NO];
		
		
		
		//Create the player in a background thread
		
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
	}
}


- (void)runRequest {
	self.errorString = @"";
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGuardians = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *guardianOne = [NSMutableDictionary dictionary];
	NSMutableDictionary *guardianTwo = [NSMutableDictionary dictionary];
    
    if (self.oneEmail.text == nil) {
        self.oneEmail.text = @"";
    }
    if (self.onePhone.text == nil) {
        self.onePhone.text = @"";
    }
    
    if (self.twoEmail.text == nil) {
        self.twoEmail.text = @"";
    }if (self.twoPhone.text == nil) {
        self.twoPhone.text = @"";
    }
	
	if (![self.oneFirstName.text isEqualToString:@""]) {
		
		NSDictionary *tmpDictionary = [NSDictionary dictionary];
		[guardianOne setObject:self.oneFirstName.text forKey:@"firstName"];
		[guardianOne setObject:self.oneLastName.text forKey:@"lastName"];
		[guardianOne setObject:self.oneEmail.text forKey:@"emailAddress"];
        [guardianOne setObject:self.onePhone.text forKey:@"phoneNumber"];
        if (self.oneKey != nil) {
            [guardianOne setObject:self.oneKey forKey:@"key"];

        }
		
		tmpDictionary = guardianOne;
		[tmpGuardians addObject:tmpDictionary];
	}
	
	if (![self.twoFirstName.text isEqualToString:@""]) {
		
		NSDictionary *tmpDictionary = [NSDictionary dictionary];
		[guardianTwo setObject:self.twoFirstName.text forKey:@"firstName"];
		[guardianTwo setObject:self.twoLastName.text forKey:@"lastName"];
		[guardianTwo setObject:self.twoEmail.text forKey:@"emailAddress"];
        [guardianTwo setObject:self.twoPhone.text forKey:@"phoneNumber"];
        
        if (self.twoKey != nil) {
            [guardianTwo setObject:self.twoKey forKey:@"key"];
        }
		
		tmpDictionary = guardianTwo;
		[tmpGuardians addObject:tmpDictionary];
	}
	NSArray *guardians = tmpGuardians;
    
    if (![self.onePhone.text isEqualToString:@""]) {
        
        if (![self.onePhone.text isEqualToString:self.initGuard1Phone] && !self.guard1EmailConfirmed) {
            [self.phoneOnlyArray addObject:self.onePhone.text];
        }
    }
    
    if (![self.twoPhone.text isEqualToString:@""]) {
        
        if (![self.twoPhone.text isEqualToString:self.initGuard2Phone] && !self.guard2EmailConfirmed) {
            [self.phoneOnlyArray addObject:self.twoPhone.text];
        }
    }
	
		
	NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@"" :@"" :[NSArray array] :guardians :mainDelegate.token :[NSData data] :@"" :@"" :@"" :@""];
	
	[tmpGuardians release];
	
	NSString *status = [response valueForKey:@"status"];
	
	if ([status isEqualToString:@"100"]){
		
		self.errorString = @"";
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status intValue];
		
		[self.errorLabel setHidden:NO];
		switch (statusCode) {
			case 0:
				//null parameter
				self.errorString = @"*Error connecting to server";
				break;
			case 1:
				//error connecting to server
				self.errorString = @"*Error connecting to server";
				break;
            case 219:
				//error connecting to server
				self.errorString = @"*Email addresses must be unique.";
				break;
			default:
				//Log the status code?
				self.errorString = @"*Error connecting to server";
				break;
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
	
    if ([self.errorString isEqualToString:@""]){
        
        NSArray *views = [self.navigationController viewControllers];
        int num = [views count] - 2;
        
     
        self.initGuard1Phone = self.onePhone.text;
        self.initGuard2Phone = self.twoPhone.text;
        
        Player *tmpController = [views objectAtIndex:num];
        tmpController.guard1Phone = self.initGuard1Phone;
        tmpController.guard2Phone = self.initGuard2Phone;
        
        self.errorLabel.text = @"Update Successful!";
        self.errorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        
        if ([self.phoneOnlyArray count] > 0) {
            bool canText = false;
            
            NSString *ios = [[UIDevice currentDevice] systemVersion];
            
            
            if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                
                if ([MFMessageComposeViewController canSendText]) {
                    
                    canText = true;
                    
                }
            }else { 
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]){
                    canText = true;
                }
            }
            
            if (canText) {
                NSString *message1 = @"You have added or changed at least one guardian with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Would you like to send them a text right now with information on how to sign up?";
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
                [alert1 show];
                [alert1 release];
            }else {
                NSString *message1 = @"You have added or changed at least one guardian with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Please notify them that they must send the text 'yes' to 'join@rteam.com' to sign up.";
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert1 show];
                [alert1 release];
            }
            
            
        }

    }else{
        self.errorLabel.text = self.errorString;
        self.errorLabel.textColor = [UIColor redColor];

    }
    self.errorLabel.hidden = NO;
	[activity stopAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[self.saveChangesButton setEnabled:YES];
	[self.removeGuardiansButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.oneFirstName setEnabled:YES];
	[self.oneLastName setEnabled:YES];
	[self.oneEmail setEnabled:YES];
	[self.twoFirstName setEnabled:YES];
	[self.twoLastName setEnabled:YES];
	[self.twoEmail setEnabled:YES];
    [self.onePhone setEnabled:YES];
    [self.twoPhone setEnabled:YES];
	

}



- (void)runRemove {
	self.errorString = @"";
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpGuardians = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *guardianOne = [NSMutableDictionary dictionary];
	NSMutableDictionary *guardianTwo = [NSMutableDictionary dictionary];
    
  
	
	if (![self.oneKey isEqualToString:@""] && (self.oneKey != nil)) {
		
		NSDictionary *tmpDictionary = [NSDictionary dictionary];
		[guardianOne setObject:@"" forKey:@"firstName"];
		[guardianOne setObject:@"" forKey:@"lastName"];
		[guardianOne setObject:@"" forKey:@"emailAddress"];
        [guardianOne setObject:@"" forKey:@"phoneNumber"];
        if (self.oneKey != nil) {
            [guardianOne setObject:self.oneKey forKey:@"key"];
            
        }
		
		tmpDictionary = guardianOne;
		[tmpGuardians addObject:tmpDictionary];
	}
	
	if (![self.twoKey isEqualToString:@""] && (self.twoKey != nil)) {
		
		NSDictionary *tmpDictionary = [NSDictionary dictionary];
		[guardianTwo setObject:@"" forKey:@"firstName"];
		[guardianTwo setObject:@"" forKey:@"lastName"];
		[guardianTwo setObject:@"" forKey:@"emailAddress"];
        [guardianTwo setObject:@"" forKey:@"phoneNumber"];
        
        if (self.twoKey != nil) {
            [guardianTwo setObject:self.twoKey forKey:@"key"];
        }
		
		tmpDictionary = guardianTwo;
		[tmpGuardians addObject:tmpDictionary];
	}
	NSArray *guardians = tmpGuardians;
	
    
	NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@"" :@"" :[NSArray array] :guardians :mainDelegate.token :[NSData data] :@"" :@"" :@"" :@""];
	
	[tmpGuardians release];
	
	NSString *status = [response valueForKey:@"status"];
	        
	if ([status isEqualToString:@"100"]){
		
		self.errorString = @"";
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status intValue];
		
		[self.errorLabel setHidden:NO];
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
				//Log the status code?
				self.errorString = @"*Error connecting to server";
				break;
		}
	}
	
	
    
	
	[self performSelectorOnMainThread:
	 @selector(didFinishRemove)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
    [pool drain];
}

- (void)didFinishRemove{
	
    if ([self.errorString isEqualToString:@""]){
        
        self.errorLabel.text = @"Remove Successful!";
        self.errorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        
        self.oneFirstName.text = @"";
        self.oneLastName.text = @"";
        self.oneEmail.text = @"";
        self.onePhone.text = @"";
        
        self.twoFirstName.text = @"";
        self.twoLastName.text = @"";
        self.twoEmail.text = @"";
        self.twoPhone.text = @"";
        
        self.confirmedLabel.hidden = YES;
        self.oneEmail.textColor = [UIColor blackColor];
        self.twoEmail.textColor = [UIColor blackColor];
        
        
    }else{
        self.errorLabel.text = self.errorString;
        self.errorLabel.textColor = [UIColor clearColor];
    }
    self.errorLabel.hidden = NO;
	[activity stopAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[self.saveChangesButton setEnabled:YES];
	[self.removeGuardiansButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.oneFirstName setEnabled:YES];
	[self.oneLastName setEnabled:YES];
	[self.oneEmail setEnabled:YES];
	[self.twoFirstName setEnabled:YES];
	[self.twoLastName setEnabled:YES];
	[self.twoEmail setEnabled:YES];
    [self.onePhone setEnabled:YES];
    [self.twoPhone setEnabled:YES];
	
    
}



-(void)endText{
	
    [self becomeFirstResponder];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (buttonIndex == 0) {
        
    }else{
        
        //Text
        @try{
            
            NSMutableArray *numbersToCall = [NSMutableArray array];
            bool call = false;
            
            for (int i = 0; i < [self.phoneOnlyArray count]; i++) {
                
                NSString *numberToCall = @"";
                
                NSString *tmpPhone = [self.phoneOnlyArray objectAtIndex:i];
                
                if ([tmpPhone length] == 16) {
                    call = true;
                    
                    NSRange first3 = NSMakeRange(3, 3);
                    NSRange sec3 = NSMakeRange(8, 3);
                    NSRange end4 = NSMakeRange(12, 4);
                    numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
                                    [tmpPhone substringWithRange:end4]];
                    
                }else if ([tmpPhone length] == 14) {
                    call = true;
                    
                    NSRange first3 = NSMakeRange(1, 3);
                    NSRange sec3 = NSMakeRange(6, 3);
                    NSRange end4 = NSMakeRange(10, 4);
                    numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
                                    [tmpPhone substringWithRange:end4]];
                    
                }else if (([tmpPhone length] == 10) || ([tmpPhone length] == 11)) {
                    call = true;
                    numberToCall = tmpPhone;
                }
                
                [numbersToCall addObject:numberToCall];
            }
            
            if (call) {
                
                NSString *ios = [[UIDevice currentDevice] systemVersion];
                
                if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                    
                    if ([MFMessageComposeViewController canSendText]) {
                        
                        MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
                        messageViewController.messageComposeDelegate = self;
                        [messageViewController setRecipients:numbersToCall];
                        
                        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                        
                        NSString *addition = @"";
                        
                        if (![mainDelegate.displayName isEqualToString:@""]) {
                            addition = [NSString stringWithFormat:@" by %@", mainDelegate.displayName];
                        }
                        
                        NSString *teamNameShort = self.teamName;
                        int strLength = [self.teamName length];
                        
                        if (strLength > 13){
                            teamNameShort = [[self.teamName substringToIndex:10] stringByAppendingString:@".."];
                        }
                        
                        NSString *bodyMessage = [NSString stringWithFormat:@"Hi, you have been added via rTeam to the team '%@'. To sign up for our free texting service, send a text to 'join@rteam.com' with the message 'yes'.", teamNameShort];
                        
                        [messageViewController setBody:bodyMessage];
                        [self presentModalViewController:messageViewController animated:YES];
                        [messageViewController release];
                        
                    }
                }else {
                    
                    NSString *url = [@"sms://" stringByAppendingString:[numbersToCall objectAtIndex:0]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
                
                
            }
            
        }@catch (NSException *e) {
            
        }
        
        
    }
    
    self.phoneOnlyArray = [NSMutableArray array];
    
    
    
    
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)autoFormatTextField:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.onePhone.text = [myPhoneNumberFormatter format:self.onePhone.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)autoFormatTextField1:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.twoPhone.text = [myPhoneNumberFormatter format:self.twoPhone.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.onePhone resignFirstResponder];
    [self.twoPhone resignFirstResponder];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	NSString *displayString = @"";
	BOOL success = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			displayString = @"";
			break;
		case MessageComposeResultSent:
			displayString = @"Text sent successfully!";
            self.errorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];

			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString = @"Text send failed.";
            self.errorLabel.textColor = [UIColor redColor];

			break;
		default:
			displayString = @"Text send failed.";
            self.errorLabel.textColor = [UIColor redColor];

			break;
	}
	
    self.errorLabel.text = displayString;
	[self dismissModalViewControllerAnimated:YES];
	
	
	
	
}

-(void)viewDidUnload{
	oneEmail = nil;
	oneFirstName = nil;
	oneLastName = nil;
	twoEmail = nil;
	twoFirstName = nil;
	twoLastName = nil;
	activity = nil;
	errorLabel = nil;
	saveChangesButton = nil;
	removeGuardiansButton = nil;
	guardianArray = nil;
    onePhone = nil;
    twoPhone = nil;
	//teamId = nil;
	//memberId = nil;
	//errorString = nil;
    confirmedLabel = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	[oneFirstName release];
	[oneEmail release];
	[oneLastName release];
	[twoEmail release];
	[twoFirstName release];
	[twoLastName release];
	[activity release];
	[errorLabel release];
	[saveChangesButton release];
	[removeGuardiansButton release];
	[guardianArray release];
	[teamId release];
	[memberId release];
	[errorString release];
    [onePhone release];
    [twoPhone release];
    [oneKey release];
    [twoKey release];
    [confirmedLabel release];
    [phoneOnlyArray release];
    [initGuard1Phone release];
    [initGuard2Phone release];
    [teamName release];
    [super dealloc];

}
@end
