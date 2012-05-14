//
//  ValidatePhoneCarrier.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ValidatePhoneCarrier.h"
#import "SettingsTabs.h"
#import "MobileCarrier.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "TraceSession.h"
#import "GANTracker.h"

@implementation ValidatePhoneCarrier
@synthesize  phoneNumber, carrierCode, carriers, verifyError, verifyButton, resendError, resendButton, finishButton, phoneNumberText, phoneCarrierText, carrierPicker, activity, selectCarrierButton, selectedCarrier, confirmCode, errorString, carrierCheatButton, sendingText, tryAgainText, carrierPicked, theConfirmCode, thePhoneNumber;


-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"ValidatePhoneCarrier - View Will Appear"];
    
}

-(void)viewDidLoad{
    
    self.title = @"Verify";
    
    //[self.navigationItem setHidesBackButton:YES];
    self.carrierPicker.hidden = YES;
    self.selectCarrierButton.hidden = YES;
    self.carrierPicker.delegate = self;
    
    self.phoneNumberText.text = self.phoneNumber;
    
    for (int i = 0; i < [self.carriers count]; i++) {
        MobileCarrier *tmp = [self.carriers objectAtIndex:i];
        
        if ([tmp.code isEqualToString:self.carrierCode]) {
            self.phoneCarrierText.text = tmp.name;
        }
    }
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.verifyButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.selectCarrierButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.resendButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.finishButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    
	myTextFieldSemaphore = 0;
	[self.phoneNumberText addTarget:self
                       action:@selector(autoFormatTextField:)
             forControlEvents:UIControlEventEditingChanged
	 ];
    
}


-(void)carrierBeginCheat{
    
    [self.phoneNumberText resignFirstResponder];
    [self.confirmCode resignFirstResponder];
    self.carrierPicker.hidden = NO;
    self.selectCarrierButton.hidden = NO;
}


-(void)verifiy{
    
    [TraceSession addEventToSession:@"Verify Phone Page - Verify Button Clicked"];

    
    self.verifyError.text = @"";
    self.resendError.text = @"";

    if (self.confirmCode.text == nil){
        self.confirmCode.text = @"";
    }
    
    if ([self.confirmCode.text isEqualToString:@""]){
        
        self.verifyError.text = @"You must enter a code to verify.";
    }else{
        
        
        [self.activity startAnimating];
        
        self.confirmCode.enabled = NO;
        self.verifyButton.enabled = NO;
        self.phoneNumberText.enabled = NO;
        self.carrierCheatButton.enabled = NO;
        self.resendButton.enabled = NO;
        self.finishButton.enabled = NO;
        
        self.theConfirmCode = [NSString stringWithString:self.confirmCode.text];
        
        [self performSelectorInBackground:@selector(runVerify) withObject:nil];
    }
    
}
-(void)resend{
    
    [TraceSession addEventToSession:@"Verify Phone Page - Resend Button Clicked"];

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"User Phone Verification Resent"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    self.verifyError.text = @"";
    self.resendError.text = @"";
    if (self.phoneNumberText.text == nil) {
        self.phoneNumberText.text = @"";
    }
    if (self.phoneCarrierText.text == nil) {
        self.phoneCarrierText.text = @"";
    }
    
    if ([self.phoneCarrierText.text isEqualToString:@""] || [self.phoneNumberText.text isEqualToString:@""]) {
        self.resendError.text = @"You must enter a number and a carrier to try again.";
    }else{
        
        if ([self.phoneCarrierText.text isEqualToString:@"I don't know."]) {
            
            NSString *ios = [[UIDevice currentDevice] systemVersion];
            
            bool canText = false;
            if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                
                if ([MFMessageComposeViewController canSendText]) {
                    
                    canText = true;
                    
                }
            }else { 
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]){
                    canText = false;
                }
            }

            
            if (canText) {
                
                self.sendingText = true;
                NSString *message = @"To validate your phone number, we need you to send a text to us from your phone.  Press 'Ok' to send the text now.";
                UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Confirm Phone" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [tmp show];
                
            }else{
                self.sendingText = false;
                NSString *message = @"To validate your phone number, we need you to send a text message (not an email) to 'join@rTeam.com', with the message 'yes'.  Please send this text from the device you entered the phone number for.  You can send the text at any time.";
                UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Confirm Phone" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [tmp show];
                
                
            }

            
        }else{
            [self.activity startAnimating];
            self.confirmCode.enabled = NO;
            self.verifyButton.enabled = NO;
            self.phoneNumberText.enabled = NO;
            self.carrierCheatButton.enabled = NO;
            self.resendButton.enabled = NO;
            self.finishButton.enabled = NO;
        
            self.thePhoneNumber = [NSString stringWithString:self.phoneNumberText.text];
            
            [self performSelectorInBackground:@selector(runResend) withObject:nil];
        }
    }
}

-(void)finish{
    
    [TraceSession addEventToSession:@"Verify Phone Page - Finish Button Clicked"];

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"User Phone Verification Skipped"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    SettingsTabs *nextController = [[SettingsTabs alloc] init];
    nextController.fromRegisterFlow = @"true";
    nextController.didRegister = @"true";
    [self.navigationController  pushViewController:nextController animated:NO];
}

-(void)carrierBeginEdit{
    [self.phoneCarrierText resignFirstResponder];
    self.carrierPicker.hidden = NO;
    self.selectCarrierButton.hidden = NO;
}

-(void)endText{
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
	
	return [self.carriers count] + 1;
}


-(NSString *)pickerView:(UIPickerView *)pickerView
			titleForRow:(NSInteger)row
		   forComponent:(NSInteger)component 
{
    
    if (row == 0) {
        return @"I don't know.";
    }else{
        MobileCarrier *tmpCarrier = [self.carriers objectAtIndex:row-1];
        return tmpCarrier.name;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.carrierPicked = true;
    
    if (row == 0) {
        self.selectedCarrier = @"I don't know.";
        self.carrierCode = @"";
    }else{
        MobileCarrier *tmpCarrier = [self.carriers objectAtIndex:row-1];
        self.selectedCarrier = tmpCarrier.name;
        self.carrierCode = tmpCarrier.code;
    }
    
	
}

-(void)dropPhonePad{
    
    [self.phoneNumberText resignFirstResponder];
}

-(void)selectCarrier{
    
    if (!self.carrierPicked) {
        self.selectedCarrier = @"I don't know.";
        self.carrierCode = @"";
    }
    self.phoneCarrierText.text = self.selectedCarrier;
    self.carrierPicker.hidden = YES;
    self.selectCarrierButton.hidden = YES;
    
}

- (void)autoFormatTextField:(id)sender {
    
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.phoneNumberText.text = [myPhoneNumberFormatter format:self.phoneNumberText.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.phoneNumberText resignFirstResponder];
    
}


-(void)runVerify{
 
	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :[NSData data] :@"" :@"" :@"" :@"" :self.theConfirmCode :@"false"];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.errorString = @"";
            
            mainDelegate.phoneNumber = self.thePhoneNumber;
            
            [mainDelegate saveUserInfo];
			
		}else{
			
			//self.memberTeams = [NSMutableArray array];
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
                case 547:
					//error connecting to server
					self.errorString = @"*Invalid Confirmation Code.";
					break;
				default:
					//should never get here
					self.errorString = @"*Error connecting to server";
					break;
			}
		}
        
        
        [self performSelectorOnMainThread:@selector(doneVerify) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)doneVerify{
    
    [self.activity stopAnimating];
    self.confirmCode.enabled = YES;
    self.verifyButton.enabled = YES;
    self.phoneNumberText.enabled = YES;
    self.carrierCheatButton.enabled = YES;
    self.resendButton.enabled = YES;
    self.finishButton.enabled = YES;
    
    if ([self.errorString isEqualToString:@""]) {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"User Phone Number Verified"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        SettingsTabs *nextController = [[SettingsTabs alloc] init];
        nextController.fromRegisterFlow = @"true";
        nextController.didRegister = @"true";
        [self.navigationController  pushViewController:nextController animated:NO];
        
    }else{
        
        self.verifyError.text = self.errorString;
    }
}

-(void)runResend{

	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :[NSData data] :@"" :@"" 
                                                      :self.thePhoneNumber
                                                      :self.carrierCode :@"" :@"true"];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            self.errorString = @"";
            
        }else{
            
            //self.memberTeams = [NSMutableArray array];
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
                case 547:
                    //error connecting to server
                    self.errorString = @"*Invalid Confirmation Code.";
                    break;
                default:
                    //should never get here
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        
        
        [self performSelectorOnMainThread:@selector(doneResend) withObject:nil waitUntilDone:NO];
    }
	
    
}
-(void)doneResend{
    
    [self.activity stopAnimating];
    self.confirmCode.enabled = YES;
    self.verifyButton.enabled = YES;
    self.phoneNumberText.enabled = YES;
    self.carrierCheatButton.enabled = YES;
    self.resendButton.enabled = YES;
    self.finishButton.enabled = YES;
    
    if ([self.errorString isEqualToString:@""]){
        
        self.resendError.text = @"A new text message has been sent.";
        self.resendError.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
    }else{
        self.resendError.text = self.errorString;
        self.resendError.textColor = [UIColor redColor];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (self.tryAgainText){
        self.tryAgainText = false;
        
        if (buttonIndex == 1) {
            
            MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
            messageViewController.messageComposeDelegate = self;
            NSArray *numbersToCall = [NSArray arrayWithObject:@"join@rteam.com"];
            [messageViewController setRecipients:numbersToCall];
            
            NSString *bodyMessage = @"yes";
            [messageViewController setBody:bodyMessage];
            [self presentModalViewController:messageViewController animated:YES];
            
        }else{
            //Cancel
            /*
            SettingsTabs *nextController = [[SettingsTabs alloc] init];
            nextController.fromRegisterFlow = @"true";
            nextController.didRegister = @"true";
            [self.navigationController  pushViewController:nextController animated:NO];
             */
            
        }
        
        
    }else{
        if (self.sendingText){
            
            NSString *ios = [[UIDevice currentDevice] systemVersion];
            
            if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                
                MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
                messageViewController.messageComposeDelegate = self;
                NSArray *numbersToCall = [NSArray arrayWithObject:@"join@rteam.com"];
                [messageViewController setRecipients:numbersToCall];
                
                NSString *bodyMessage = @"yes";
                [messageViewController setBody:bodyMessage];
                [self presentModalViewController:messageViewController animated:YES];
                
            }else { 
                
                NSString *url = [@"sms://" stringByAppendingString:@"join@rteam.com"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
                
            }
            
            
        }else{
            
            SettingsTabs *nextController = [[SettingsTabs alloc] init];
            nextController.fromRegisterFlow = @"true";
            nextController.didRegister = @"true";
            [self.navigationController  pushViewController:nextController animated:NO];
            
        }
        
    }
    
	
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
			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString = @"Text send failed.";
			break;
		default:
			displayString = @"Text send failed.";
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
    
    if (success) {
        
        SettingsTabs *nextController = [[SettingsTabs alloc] init];
        nextController.fromRegisterFlow = @"true";
        nextController.didRegister = @"true";
        [self.navigationController  pushViewController:nextController animated:NO];
        
    }else{
        
        self.tryAgainText = true;
        NSString *message = @"The text message was not sent.  To validate your phone number, you must send this text message.  You can try again, or cancel and finish registering without your phone number.";
        UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Text Not Sent" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
        [tmp show];
        
    }
	
	
	
	
}



-(void)viewDidUnload{
    
    verifyError = nil;
    verifyButton = nil;
    resendError = nil;
    resendButton = nil;
    finishButton = nil;
    phoneNumberText = nil;
    phoneCarrierText = nil;
    carrierPicker = nil;
    activity = nil;
    selectCarrierButton = nil;
    confirmCode = nil;
    carrierCheatButton = nil;
    [super viewDidUnload];
    
}

@end
