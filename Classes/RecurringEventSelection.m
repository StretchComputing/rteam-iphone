//
//  RecurringEventSelection.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecurringEventSelection.h"
#import "SelectCalendarEvent.h"
#import "DailyWeeklyEvent.h"
#import "MonthlyEvent.h"
#import "FastActionSheet.h"

@implementation RecurringEventSelection
@synthesize myTableView, calendarButton, eventType, typeLabel, teamId, calendarLabel, orLabel;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}


-(void)viewDidLoad{
	self.title = @"Event Frequency";
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.calendarButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	NSString *type = @"";
	if ([self.eventType isEqualToString:@"game"]) {
		type = @"Game";
	}else if ([self.eventType isEqualToString:@"practice"]) {
		type = @"Practice";
        
	}else {
		type = @"Event";
        
	}
	
	self.typeLabel.text = [NSString stringWithFormat:@"If the %@ is recurring, how often does it occur?", type];
	
	NSString *ios = [[UIDevice currentDevice] systemVersion];
	if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
		
		self.myTableView.backgroundColor = [UIColor clearColor];
		self.myTableView.opaque = NO;
		self.myTableView.backgroundView = nil;
		
	}
	
	
	if (!(![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
		[self.calendarButton setHidden:YES];
		self.calendarLabel.hidden = YES;
		self.orLabel.hidden = YES;
		
	}
    
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger cellTag = 1;
	static NSInteger segTag = 2;
	static NSInteger feedbackTag = 3;
	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 22;
		frame.size.width = 200;
		
		
		UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
		cellLabel.tag = cellTag;
		[cell.contentView addSubview:cellLabel];
		
		frame.origin.x = 125;
		frame.size.width = 150;
		UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:frame];
		feedbackLabel.tag = feedbackTag;
		[cell.contentView addSubview:feedbackLabel];
		
		
		frame.size.height = 30;
		frame.origin.y = 6;
		frame.origin.x = 200;
		frame.size.width = 90;
		UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithFrame:frame];
		segControl.tag = segTag;
		[cell.contentView addSubview:segControl];
		
		
	}
	
	UILabel *cellLabel = (UILabel *)[cell.contentView viewWithTag:cellTag];
	UISegmentedControl *segControl = (UISegmentedControl *)[cell.contentView viewWithTag:segTag];
	
	UILabel *feedbackLabel = (UILabel *)[cell.contentView viewWithTag:feedbackTag];
	
	segControl.hidden = YES;
	cellLabel.frame = CGRectMake(0, 10, 150, 22);
	cellLabel.textAlignment = UITextAlignmentCenter;
	NSInteger row = [indexPath row];
	feedbackLabel.hidden = YES;
	cell.accessoryType = UITableViewCellAccessoryNone;
	
    cellLabel.backgroundColor = [UIColor clearColor];
	if (row == 0) {
		cellLabel.text = @"Daily";
	}else if (row == 1) {
		cellLabel.text = @"Weekly";
		
	}else if (row == 2) {
		cellLabel.text = @"Every Other Week";
		
	}else if (row == 3) {
		cellLabel.text = @"Monthly";
		
	}else if (row == 4) {
		cellLabel.text = @"Twice a Month";
		
	}
	
	return cell;
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	
	if (section == 0) {
		
		if (row == 0) {
			
			DailyWeeklyEvent *tmp = [[DailyWeeklyEvent alloc] init];
			tmp.frequency = @"daily";
			tmp.eventType = self.eventType;
			tmp.teamId = self.teamId;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 1) {
			
			DailyWeeklyEvent *tmp = [[DailyWeeklyEvent alloc] init];
			tmp.frequency = @"weekly";
			tmp.eventType = self.eventType;
			tmp.teamId = self.teamId;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 2) {
			
			DailyWeeklyEvent *tmp = [[DailyWeeklyEvent alloc] init];
			tmp.frequency = @"biweekly";
			tmp.eventType = self.eventType;
			tmp.teamId = self.teamId;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 3) {
			
			MonthlyEvent *tmp = [[MonthlyEvent alloc] init];
			tmp.frequency = @"monthly";
			tmp.eventType = self.eventType;
			tmp.teamId = self.teamId;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}else if (row == 4) {
			
			MonthlyEvent *tmp = [[MonthlyEvent alloc] init];
			tmp.frequency = @"bimonthly";
			tmp.eventType = self.eventType;
			tmp.teamId = self.teamId;
			[self.navigationController pushViewController:tmp animated:YES];
			
		}
		
		
		
	}
	
	
	
	
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return 4;
	
	
}

-(void)calendar{
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	
	SelectCalendarEvent *tmp = [[SelectCalendarEvent alloc] init];
	tmp.teamId = self.teamId;
	tmp.eventType = self.eventType;
	[self.navigationController pushViewController:tmp animated:YES];
	
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
	
	myTableView = nil;
	typeLabel = nil;
	calendarButton = nil;
	calendarLabel = nil;
	orLabel = nil;
	[super viewDidUnload];
}

@end
