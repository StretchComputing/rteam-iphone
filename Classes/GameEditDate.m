//
//  GameEditDate.m
//  iCoach
//
//  Created by Nick Wroblewski on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameEditDate.h"
#import "GameEdit.h"
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"

@implementation GameEditDate
@synthesize gameDate, gameDatePicker, submitButton;;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.title = @"New Date";
	NSDate *minDate = [NSDate date];
	
	self.gameDatePicker.minimumDate = minDate;
	minDate = [minDate dateByAddingTimeInterval:300];
	[self.gameDatePicker setDate:gameDate];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
}

-(void)chooseDate{
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 2;
	
	GameEdit *cont = [temp objectAtIndex:num];
	cont.gameDateObject = self.gameDatePicker.date;
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
	gameDate = nil;
	gameDatePicker = nil;
	submitButton = nil;
	[super viewDidUnload];
}


@end
