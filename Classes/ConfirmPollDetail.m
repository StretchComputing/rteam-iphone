//
//  ConfirmPollDetail.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConfirmPollDetail.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "SendMessage.h"
#import "FastActionSheet.h"

@implementation ConfirmPollDetail
@synthesize memberId, teamId, confirmDate, memberName, nameLabel, confirmLabel, markConfirmButton, callTextButton, sendMessageButton, phoneNumber,
displayString, messageSent, displayLabel, callTextActionSheet, replyString, replyLabel;

-(void)viewDidAppear:(BOOL)animated{
	
	if (self.messageSent) {
		self.messageSent = false;
		//self.displayLabel.textColor = [UIColor greenColor];
		self.displayLabel.text = @"Message Sent Successfully!";
		
	}
	
	[self becomeFirstResponder];
	
}
-(void)viewDidLoad{
	
	self.title = @"Recipient";
	
	if ([self.replyString isEqualToString:@""]) {
		self.replyLabel.hidden = YES;
	}else {
		self.replyLabel.text = self.replyString;
		self.replyLabel.hidden = NO;
	}

	[self performSelectorInBackground:@selector(getMemberInfo) withObject:nil];
	self.nameLabel.text = self.memberName;
	
	self.phoneNumber = @"";
	self.callTextButton.hidden = YES;
	
	if ([self.confirmDate isEqualToString:@""]) {
		
		self.confirmLabel.text = @"Did Not Reply Yet.";
		self.confirmLabel.textColor = [UIColor grayColor];
		self.markConfirmButton.hidden = YES;
	}else {
		self.confirmLabel.text = self.confirmDate;
		self.confirmLabel.textColor = [UIColor blueColor];
		self.markConfirmButton.hidden = YES;
	}
	
	self.markConfirmButton.hidden = YES;

	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.sendMessageButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.markConfirmButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.callTextButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
}

-(void)getMemberInfo{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	//self.playerInfo = [NSArray array];
	
	NSDictionary *response = [ServerAPI getMemberInfo:self.teamId :self.memberId :mainDelegate.token :@""];
	
	NSString *status = [response valueForKey:@"status"];
	
	if ([status isEqualToString:@"100"]){
		
		NSDictionary *playerInfo = [response valueForKey:@"memberInfo"];
		
		if ([playerInfo valueForKey:@"phoneNumber"] != nil) {
			self.phoneNumber = [playerInfo valueForKey:@"phoneNumber"];
		}
		self.displayString = @"";
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				self.displayString = @"*Error connecting to server";
				break;
			case 1:
				//error connecting to server
				self.displayString = @"*Error connecting to server";
				break;
			default:
				//Log the status code?
				self.displayString = @"*Error connecting to server";
				break;
		}
	}
	
	
	
	[self performSelectorOnMainThread:@selector(doneMemberInfo) withObject:nil waitUntilDone:NO];
	[pool drain];
	
}

-(void)doneMemberInfo{
	
	if ([self.displayString isEqualToString:@""]) {
		
		if ([self.phoneNumber length] > 0) {
			self.callTextButton.hidden = NO;
		}
	}else {
		//self.displayLabel.text = self.displays
	}
	
	
}
-(void)sendMessage{
	
	SendMessage *tmp = [[SendMessage alloc] init];
	tmp.teamId = self.teamId;
	tmp.sendTeamId = self.teamId;
	tmp.isReply = true;
	tmp.replyTo = self.memberName;
	tmp.replyToId = self.memberId;
	tmp.origLoc = @"ConfirmPollDetail";
	//tmp.userRole = self.userRole;
	tmp.includeFans = @"false";
	[self.navigationController pushViewController:tmp animated:YES];
	
}

-(void)callText{
    self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this person?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
    self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.callTextActionSheet showInView:self.view];
    [self.callTextActionSheet release];
}

-(void)markConfirm{
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet == self.callTextActionSheet) {
		
		//CallText
		if (buttonIndex == 2) {			
			
			
		}else if (buttonIndex == 0){
			
			//Call
			
			@try{
				if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]){
					
					NSString *numberToCall = @"";
					bool call = false;
					
					if ([self.phoneNumber length] == 16) {
						call = true;
						
						NSRange first3 = NSMakeRange(3, 3);
						NSRange sec3 = NSMakeRange(8, 3);
						NSRange end4 = NSMakeRange(12, 4);
						numberToCall = [NSString stringWithFormat:@"%@%@%@", [self.phoneNumber substringWithRange:first3], [self.phoneNumber substringWithRange:sec3],
										[self.phoneNumber substringWithRange:end4]];
						
					}else if ([self.phoneNumber length] == 14) {
						call = true;
						
						NSRange first3 = NSMakeRange(1, 3);
						NSRange sec3 = NSMakeRange(6, 3);
						NSRange end4 = NSMakeRange(10, 4);
						numberToCall = [NSString stringWithFormat:@"%@%@%@", [self.phoneNumber substringWithRange:first3], [self.phoneNumber substringWithRange:sec3],
										[self.phoneNumber substringWithRange:end4]];
						
					}else if (([self.phoneNumber length] == 11) || ([self.phoneNumber length] == 10)) {
						call = true;
						numberToCall = self.phoneNumber;
					}
					
					if (call) {
						NSString *url = [@"tel://" stringByAppendingString:numberToCall];
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
						
					}
					
					
					
				}else {
					
					NSString *message1 = @"You cannot make calls from this device.";
					UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert1 show];
					
				}				
			}@catch (NSException *e) {
				
			}
			
			
			
		}else {
			//Text
			@try{
				
				
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
					
					@try{
						
						NSString *numberToCall = @"";
						bool call = false;
						if ([self.phoneNumber length] == 16) {
							call = true;
							
							NSRange first3 = NSMakeRange(3, 3);
							NSRange sec3 = NSMakeRange(8, 3);
							NSRange end4 = NSMakeRange(12, 4);
							numberToCall = [NSString stringWithFormat:@"%@%@%@", [self.phoneNumber substringWithRange:first3], [self.phoneNumber substringWithRange:sec3],
											[self.phoneNumber substringWithRange:end4]];
							
						}else if ([self.phoneNumber length] == 14) {
							call = true;
							
							NSRange first3 = NSMakeRange(1, 3);
							NSRange sec3 = NSMakeRange(6, 3);
							NSRange end4 = NSMakeRange(10, 4);
							numberToCall = [NSString stringWithFormat:@"%@%@%@", [self.phoneNumber substringWithRange:first3], [self.phoneNumber substringWithRange:sec3],
											[self.phoneNumber substringWithRange:end4]];
							
						}else if (([self.phoneNumber length] == 11) || ([self.phoneNumber length] == 10)) {
							call = true;
							numberToCall = self.phoneNumber;
						}
						
						if (call) {
							
							NSString *ios = [[UIDevice currentDevice] systemVersion];
							
							if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
								
								if ([MFMessageComposeViewController canSendText]) {
									
									MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
									messageViewController.messageComposeDelegate = self;
									[messageViewController setRecipients:[NSArray arrayWithObject:numberToCall]];
									[self presentModalViewController:messageViewController animated:YES];
									[messageViewController release];
									
								}
							}else {
								NSString *url = [@"sms://" stringByAppendingString:numberToCall];
								[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
							}
							
							
						}
						
						
					}@catch (NSException *e) {
						
					}
					
				}else {
					
					NSString *message1 = @"You cannot send text messages from this device.";
					UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Texting Not Available." message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alert1 show];
					
				}
				
			}@catch (NSException *e) {
				
			}
			
			
		}
		
	}else {
		
		[FastActionSheet doAction:self :buttonIndex];
		
	}
	
	
    
	
	
	
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	self.displayLabel.hidden = NO;
	
	NSString *displayString1 = @"";
	BOOL success = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			displayString1 = @"";
			break;
		case MessageComposeResultSent:
			displayString1 = @"Text sent successfully!";
			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString1 = @"Text send failed.";
			break;
		default:
			displayString1 = @"Text send failed.";
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	
	if (![displayString1 isEqualToString:@""]) {
		
		if (success) {
			self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
		}else {
			self.displayLabel.textColor = [UIColor redColor];
		}
		
		self.displayLabel.text = displayString1;
	}else {
		self.displayLabel.hidden = YES;
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


- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)viewDidUnload{
	callTextActionSheet = nil;
	nameLabel = nil;
	confirmLabel = nil;
	markConfirmButton = nil;
	callTextButton = nil;
	sendMessageButton = nil;
	displayLabel = nil;
	replyLabel = nil;
	[super viewDidUnload];
	
}

-(void)dealloc{
	
	[memberId release];
	[confirmDate release];
	[memberName release];
	[nameLabel release];
	[markConfirmButton release];
	[callTextButton release];
	[sendMessageButton release];
	[phoneNumber release];
	[displayString release];
	[displayLabel release];
	[teamId release];
	[callTextActionSheet release];
	[replyString release];
	[replyLabel release];
	[super dealloc];
	
}


@end
