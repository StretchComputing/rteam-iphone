//
//  ViewPracticeChatterMessage.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewPracticeChatterMessage.h"
#import "FastActionSheet.h"


@implementation ViewPracticeChatterMessage
@synthesize senderName, messageBody, messageDate, messageSubject, topLabel, dateLabel, bottomLabel, textView;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.title = @"Practice Message";
	
	if ([self.senderName isEqualToString:@""]) {
		self.topLabel.text = @"My Sent Practice Message";
		self.bottomLabel.hidden = NO;
	}else {
		self.topLabel.text = [NSString stringWithFormat:@"From: %@", self.senderName];
		self.bottomLabel.hidden = YES;
	}
	
	self.textView.text = self.messageBody;
	
	NSString *date = self.messageDate;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	NSDate *formatedDate = [dateFormat dateFromString:date];
	[dateFormat setDateFormat:@"MMM dd, hh:mm aa"];
	NSString *displayDate = [dateFormat stringFromDate:formatedDate];
	
	self.dateLabel.text = displayDate;
	[dateFormat release];
	
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
	
	topLabel = nil;
	dateLabel = nil;
	bottomLabel = nil;
	textView = nil;
	[super viewDidUnload];
	
}


-(void)dealloc{
	
	[senderName release];
	[messageBody release];
	[messageDate release];
	[messageSubject release];
	[topLabel release];
	[dateLabel release];
	[bottomLabel release];
	[textView release];
	[super dealloc];
}
@end
