//
//  EventEditDate.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventEdit.h"
#import "EventEditDate.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"
#import "TraceSession.h"

@implementation EventEditDate
@synthesize practiceDate, practiceDatePicker, submitButton;

-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"EventEditDate - View Will Appear"];

}

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.title = @"New Date";
	NSDate *minDate = [NSDate date];
	
	self.practiceDatePicker.minimumDate = minDate;
	minDate = [minDate dateByAddingTimeInterval:300];
	[self.practiceDatePicker setDate:practiceDate];
	
    
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
}

-(void)chooseDate{
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 2;
	
	EventEdit *cont = [temp objectAtIndex:num];
	cont.practiceDateObject = self.practiceDatePicker.date;
	cont.fromDateChange = YES;
	[self.navigationController popToViewController:cont animated:YES];
	
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
	//practiceDate = nil;
	practiceDatePicker = nil;
	submitButton = nil;
	[super viewDidUnload];
}


@end


