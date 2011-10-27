//
//  TeamSettings.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Feedback.h"


@implementation Feedback
@synthesize displayLabel, feedbackButton, reviewButton;

-(void)viewDidLoad{
    
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.feedbackButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.reviewButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
	
}

-(void)review{
	
	NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
	str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str]; 
	str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
	
	// Here is the app id from itunesconnect
	str = [NSString stringWithFormat:@"%@407424453", str]; 
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
	
}

-(void)feedback{
	
	if ([MFMailComposeViewController canSendMail]) {
		
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
		mailViewController.mailComposeDelegate = self;
		[mailViewController setToRecipients:[NSArray arrayWithObject:@"feedback@rteam.com"]];
		[mailViewController setSubject:@"rTeam FeedBack"];
		
		[self presentModalViewController:mailViewController animated:YES];
		
	}else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:@"Your device cannot currently send email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	}
	
    
	
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	BOOL success = NO;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			self.displayLabel.text = @"";
			break;
		case MFMailComposeResultSent:
			self.displayLabel.text = @"Feedback sent successfully!";
			self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
			success = YES;
			break;
		case MFMailComposeResultFailed:
			self.displayLabel.text = @"Message Send Failed.";
			self.displayLabel.textColor = [UIColor redColor];
            
			break;
			
		case MFMailComposeResultSaved:
			self.displayLabel.text = @"Message Saved.";
			self.displayLabel.textColor =  [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
			success = YES;
			break;
		default:
			self.displayLabel.text = @"";
			
			break;
	}
	
	
	[self dismissModalViewControllerAnimated:YES];
	
}


-(void)viewDidUnload{
	feedbackButton = nil;
	displayLabel = nil;
	reviewButton = nil;
	[super viewDidUnload];
	
}

@end
