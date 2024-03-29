//
//  FastRequestStatus.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastRequestStatus.h"
#import "FastRequestStatus2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CurrentEvent.h"
#import "FastRequestSelectRecip.h"

@implementation FastRequestStatus
@synthesize rightArrowButton, leftArrowButton, cancelButton, myTableView, currentEventLabel, currentInterval, loadingLabel, loadingActivity,
eventsArray, eventsError, eventsNowSuccess, currentEventIndex, teamLabel, recipients, recipLabel, editRecipButton, includeFans, fansOnly, toTeam,
noEventsText;



-(void)viewDidLoad{
	
	self.noEventsText.hidden = YES;
	
	self.rightArrowButton.hidden = YES;
	self.leftArrowButton.hidden = YES;

	self.teamLabel.hidden = YES;
	self.title = @"Status";
	self.myTableView.dataSource = self;
	self.myTableView.delegate = self;
	self.currentInterval = 3;
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.cancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.editRecipButton setBackgroundImage:stretch forState:UIControlStateNormal];
	self.editRecipButton.hidden = YES;
	self.recipLabel.hidden = YES;
	
	self.currentEventLabel.hidden = YES;
	self.loadingLabel.hidden = NO;
	[self.loadingActivity startAnimating];
	[self performSelectorInBackground:@selector(getCurrentEvents) withObject:nil];
	
	UIImageView *tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noLogoNoCrowd.png"]];
	
	NSString *ios = [[UIDevice currentDevice] systemVersion];
	if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
		
		self.myTableView.backgroundView = tmp;
		
	}
	
	
}


-(void)getCurrentEvents{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	self.eventsArray = [NSMutableArray array];
	
	//Retrieve teams from DB
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	
	//If there is a token, do a DB lookup to find the teams associated with this coach:
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfEventsNow:token];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			self.eventsNowSuccess = true;
			NSArray *eventsToday = [response valueForKey:@"eventsToday"];
			NSArray *eventsTomorrow = [response valueForKey:@"eventsTomorrow"];
			
			self.eventsArray = [NSMutableArray arrayWithArray:eventsToday];
			
			for (int i = 0; i < [eventsTomorrow count]; i++) {
				[self.eventsArray addObject:[eventsTomorrow objectAtIndex:i]];
			}
			
			
		}else{
			self.eventsNowSuccess = false;
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.error = @"*Error connecting to server";
					break;
				default:
					//should never get here
					//self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		
		
	}
	
	
	
	[pool drain];
	[self performSelectorOnMainThread:@selector(doneEvents) withObject:nil waitUntilDone:NO];
	
}

-(void)doneEvents{
	
	self.loadingLabel.hidden = YES;
	[self.loadingActivity stopAnimating];
	
	if (self.eventsNowSuccess) {
		
		if ([self.eventsArray count] > 0) {
			
			self.rightArrowButton.hidden = NO;
			self.leftArrowButton.hidden = NO;
			
			self.teamLabel.hidden = NO;
			self.currentEventLabel.hidden = NO;
			
			self.currentEventLabel.text = [self getEventLabel:[self.eventsArray objectAtIndex:0]];
			self.currentEventIndex = 0;
			
			CurrentEvent *tmp = [self.eventsArray objectAtIndex:0];
			self.teamLabel.text = [NSString stringWithFormat:@"Team: %@", tmp.teamName];
			
		}else {
			self.eventsError.text = @"";
			self.noEventsText.hidden = NO;
		}
		
	}else {
		self.eventsError.text = @"*Error retreiving events.";
	}
	
	
	
}


-(void)cancel{
	
	[self.navigationController popViewControllerAnimated:NO];
}

-(void)leftArrow{
	
	if (self.currentEventIndex > 0) {
		self.currentEventIndex--;
	}else {
        self.currentEventIndex = [self.eventsArray count] - 1;
	}
	
	CurrentEvent *tmpEvent = [self.eventsArray objectAtIndex:self.currentEventIndex];
	
	self.currentEventLabel.text = [self getEventLabel:tmpEvent];
	
	self.teamLabel.text = [NSString stringWithFormat:@"Team: %@", tmpEvent.teamName];
}

-(void)rightArrow{
	
	if (self.currentEventIndex < [self.eventsArray count] - 1) {
		self.currentEventIndex++;
	}else {
        self.currentEventIndex = 0;
	}
	
	CurrentEvent *tmpEvent = [self.eventsArray objectAtIndex:self.currentEventIndex];
	
	self.currentEventLabel.text = [self getEventLabel:tmpEvent];
	
	self.teamLabel.text = [NSString stringWithFormat:@"Team: %@", tmpEvent.teamName];
	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	static NSString *firstLevelCell = @"FirstLevelCell";
	
	static NSInteger optionTag = 1;
	//static NSInteger imageOneTag = 2;
	//static NSInteger imageTwoTag = 3;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstLevelCell];
	
	
	
	if (cell == nil){
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:firstLevelCell] autorelease];
		
		
		
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 22;
		frame.size.width = 280;
		
		UILabel *optionLabel = [[UILabel alloc] initWithFrame:frame];
		optionLabel.tag = optionTag;
		[cell.contentView addSubview:optionLabel];
		[optionLabel release];
		
		
		
		
		
	}
	
	UILabel *optionLabel = (UILabel *)[cell.contentView viewWithTag:optionTag];
	
	UIButton *rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	rightArrow.frame = CGRectMake(260, 0, 40, 45);
	[rightArrow setImage:[UIImage imageNamed:@"right-arrow.png"] forState:UIControlStateNormal];
	[rightArrow addTarget:self action:@selector(rightCell) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:rightArrow];
	
	UIButton *leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
	leftArrow.frame = CGRectMake(0, 0, 40, 45);
	[leftArrow setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
	[leftArrow addTarget:self action:@selector(leftCell) forControlEvents:UIControlEventTouchUpInside];
	[cell.contentView addSubview:leftArrow];
	
	rightArrow.hidden = YES;
	leftArrow.hidden = YES;
	optionLabel.textAlignment = UITextAlignmentLeft;
	optionLabel.frame = CGRectMake(10, 10, 280, 22);
	
	if (row == 0) {
		optionLabel.text = @"• Event Reminder";
	}else if (row == 1) {
		optionLabel.text = @"• Are you coming?";
	}else if (row == 2) {
		optionLabel.text = [NSString stringWithFormat:@"We only have %d people so far.", self.currentInterval];
		optionLabel.textAlignment = UITextAlignmentCenter;
		rightArrow.hidden = NO;
		leftArrow.hidden = NO;
		optionLabel.frame = CGRectMake(0, 10, 300, 22);
	}
	
	return cell;
}


-(void)rightCell{
	
	if (self.currentInterval != 10) {
		self.currentInterval++;
	}else {
		self.currentInterval = 3;
	}

	
	[self.myTableView reloadData];
	
}

-(void)leftCell{
	
	if (self.currentInterval != 3) {
		self.currentInterval--;
	}else {
		self.currentInterval = 10;
	}

	
	
	[self.myTableView reloadData];
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (([self.eventsArray count] > 0) && self.eventsNowSuccess) {
		
		int row = [indexPath row];
		NSString *message = @"";
		
		if (row == 0) {
			message = @"• Event Reminder.";
		}else if (row == 1) {
			message = @"• Are you coming?";
		}else if (row == 2) {
			message = [NSString stringWithFormat:@"We only have %d people so far.", self.currentInterval];
		}
		
		FastRequestStatus2 *tmp = [[FastRequestStatus2 alloc] init];
		tmp.messageString = message;
		tmp.selectedEvent = [self.eventsArray objectAtIndex:self.currentEventIndex];
		tmp.toTeam = self.toTeam;
		tmp.includeFans = self.includeFans;
		tmp.fansOnly = self.fansOnly;
		[self.navigationController pushViewController:tmp animated:YES];

		
	}
		
	
}


-(NSString *)getEventLabel:(id)event{
	
	NSString *label = @"";
	
	CurrentEvent *tmpEvent = (CurrentEvent *)event;
	
	NSString *eventLabel = @"";
	NSString *timeLabel;
	if ([tmpEvent.eventType isEqualToString:@"game"]) {
		eventLabel = @"Game";
	}else if ([tmpEvent.eventType isEqualToString:@"practice"]) {
		eventLabel = @"Practice";
	}else {
		eventLabel = @"Event";
	}
	
	NSString *date = tmpEvent.eventDate;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	NSDate *eventDate = [dateFormat dateFromString:date];
	NSDate *todaysDate = [NSDate date];
	
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	NSString *eventDateString = [dateFormat stringFromDate:eventDate];
	NSString *todayDateString = [dateFormat stringFromDate:todaysDate];
	
	if ([eventDateString isEqualToString:todayDateString]) {
		//time format
		[dateFormat setDateFormat:@"hh:mm"];
		timeLabel = [dateFormat stringFromDate:eventDate];
		
		[dateFormat setDateFormat:@"a"];
		NSString *ampm = [dateFormat stringFromDate:eventDate];
		ampm = [ampm lowercaseString];
		ampm = [ampm substringToIndex:1];
		timeLabel = [timeLabel stringByAppendingString:ampm];
	}else {
		[dateFormat setDateFormat:@"MM/dd"];
		timeLabel = [dateFormat stringFromDate:eventDate];
	}
	
	[dateFormat release];
	
	label = [NSString stringWithFormat:@"%@ %@", eventLabel, timeLabel];
	
	
	
	return label;
}


-(void)editRecipients{
	
	CurrentEvent *tmpEvent = [self.eventsArray objectAtIndex:self.currentEventIndex];
	FastRequestSelectRecip *tmp = [[FastRequestSelectRecip alloc] init];
	tmp.teamId = tmpEvent.teamId;
	
	[self.navigationController pushViewController:tmp animated:YES];
	
}


-(void)viewDidUnload{
	
	rightArrowButton = nil;
	leftArrowButton = nil;
	cancelButton = nil;
	myTableView = nil;
	currentEventLabel = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	//eventsArray = nil;
	teamLabel = nil;
	//recipients = nil;
	recipLabel = nil;
	editRecipButton = nil;
	noEventsText = nil;
	//includeFans = nil;
	[super viewDidUnload];
}

-(void)dealloc{
	
	[rightArrowButton release];
	[leftArrowButton release];
	[cancelButton release];
	[myTableView release];
	[currentEventLabel release];
	[loadingLabel release];
	[loadingActivity release];
	[eventsArray release];
	[teamLabel release];
	[recipients release];
	[recipLabel release];
	[includeFans release];
	[editRecipButton release];
	[noEventsText release];
	[super dealloc];
}

@end

