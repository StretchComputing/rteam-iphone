//
//  PlayerAttendance.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerAttendance.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "GANTracker.h"

@implementation PlayerAttendance
@synthesize teamId, memberId, errorMessage, attResults, displayAttResults, eventType, segmentEventType, segChange, fromSearch;

-(void)viewDidLoad{
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"View Member Attendance"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	self.title = @"Member Attendance";
	[self getAttendance];
	self.displayAttResults = self.attResults;
	
	UIView *headerView =
	[[UIView alloc]
     initWithFrame:CGRectMake(0, 0, 300, 70)];
	
	
	UILabel *headerLabel =
	[[UILabel alloc] initWithFrame:CGRectMake(75, 1, 300, 40)];
	headerLabel.text = NSLocalizedString(@"Player Attendance:", @"");
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.backgroundColor = [UIColor clearColor];
	//[headerView addSubview:headerLabel];
	
	
	NSArray *segments = [NSArray arrayWithObjects:@"Games", @"Practices", @"All", nil];
	
	self.segmentEventType = [[UISegmentedControl alloc] initWithItems:segments];
	self.segmentEventType.frame = CGRectMake(25, 20, 275, 30);
	self.segmentEventType.selectedSegmentIndex = 2;
	
	
	[self.segmentEventType addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	[headerView addSubview:self.segmentEventType];
	
	
	UIToolbar *tmp = [[UIToolbar alloc] init];
	[self.tableView addSubview:tmp];
	
	
	headerView.backgroundColor = [UIColor whiteColor];
	
	self.tableView.tableHeaderView = headerView;
	
	if (!self.fromSearch) {
		//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
		//[self.navigationItem setRightBarButtonItem:addButton];
	}
	
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 1)];
	UIColor *color = [[UIColor alloc] initWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
	line2.backgroundColor = color;
	[headerView addSubview:line2];
	
}


-(void)done{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

-(void)getAttendance{
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		if (self.eventType == nil) {
			self.eventType = @"";
		}
		
		
		NSDictionary *response = [ServerAPI getAttendeesMember:token :self.teamId :self.memberId :self.eventType :@"" :@""];
        
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
            
			self.attResults = [response valueForKey:@"attendance"];
			NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.attResults];
			
			NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"eventDate" ascending:YES];
			[tmp sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
            
			self.attResults = tmp;
			self.displayAttResults = tmp;
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.errorMessage = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.errorMessage = @"*Error connecting to server";
					break;
				default:
					//Log the status code?
					self.errorMessage = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
    
	
	[self.tableView reloadData];
    
}

-(void)filterAttendance:(NSString *)event{
	
	
	if ([event isEqualToString:@"all"]) {
		self.displayAttResults = self.attResults;
	}else{
		
        NSMutableArray *tmp = [NSMutableArray array];
        
        for (int i = 0; i < [self.attResults count]; i++) {
            
            NSDictionary *results = [self.attResults objectAtIndex:i];
            
            if ([[results objectForKey:@"eventType"] isEqualToString:event]) {
                [tmp addObject:results];
            }
            
        }
		self.displayAttResults = tmp;
		
	}
	
	[self.tableView reloadData];
	
}

-(void)segmentSelect:(id)sender{
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int selection = [segmentedControl selectedSegmentIndex];
	
    
	switch (selection) {
		case 0:
			self.eventType = @"game";
			segmentedControl.selectedSegmentIndex = 0;
			[self filterAttendance:@"game"];
			break;
		case 1:
			self.eventType = @"practice";
			segmentedControl.selectedSegmentIndex = 1;
			[self filterAttendance:@"practice"];
			break;
		case 2:
			self.eventType = @"";
			segmentedControl.selectedSegmentIndex = 2;
			[self filterAttendance:@"all"];
			break;
		default:
			break;
	}
	
	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
    if ([self.displayAttResults count] == 0){
        return 1;
    }
	return [self.displayAttResults count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger dateTag = 1;
	static NSInteger eventTag = 2;
	static NSInteger imageTag = 3;
	static NSInteger imageLabelTag = 4;
	static NSInteger eventNameTag = 5;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 150;
		
		UILabel *eventLabel = [[UILabel alloc] initWithFrame:frame];
		eventLabel.tag = eventTag;
		[cell.contentView addSubview:eventLabel];
		
		frame.size.height = 17;
		frame.origin.y += 23;
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		frame.size.height = 15;
		frame.origin.y += 20;
		UILabel *eventNameLabel = [[UILabel alloc] initWithFrame:frame];
		eventNameLabel.tag = eventNameTag;
		[cell.contentView addSubview:eventNameLabel];
		
		frame.size.height = 35;
		frame.size.width = 40;
		frame.origin.y = 5;
		frame.origin.x = 220;
		UIImageView *absentOrPresent = [[UIImageView alloc] initWithFrame:frame];
		absentOrPresent.tag = imageTag;
		[cell.contentView addSubview:absentOrPresent];
		
		frame.size.height = 23;
		frame.size.width = 70;
		frame.origin.y = 42;
		frame.origin.x = 220;
		UILabel *imageLabel = [[UILabel alloc] initWithFrame:frame];
		imageLabel.tag = imageLabelTag;
		[cell.contentView addSubview:imageLabel];
        
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	UILabel *eventLabel = (UILabel *)[cell.contentView viewWithTag:eventTag];
	UIImageView *absentOrPresent = (UIImageView *)[cell.contentView viewWithTag:imageTag];
	UILabel *imageLabel = (UILabel *)[cell.contentView viewWithTag:imageLabelTag];
	UILabel *eventNameLabel = (UILabel *)[cell.contentView viewWithTag:eventNameTag];
	
	eventNameLabel.textColor = [UIColor darkGrayColor];
	eventNameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	eventLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	dateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	imageLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
    if ([self.displayAttResults count] == 0) {
        
        dateLabel.text = @"No attendance records found...";
        dateLabel.textAlignment = UITextAlignmentCenter;
        
        dateLabel.frame = CGRectMake(0, 28, 320, 17);
        eventNameLabel.hidden = YES;
        imageLabel.hidden = YES;
        eventLabel.hidden = YES;
        absentOrPresent.hidden = YES;
    }else{
        
        dateLabel.frame = CGRectMake(10, 28, 150, 17);
        eventNameLabel.hidden = NO;
        imageLabel.hidden = NO;
        eventLabel.hidden = NO;
        absentOrPresent.hidden = NO;
        //Configure the cell
        
        NSUInteger row = [indexPath row];
        NSDictionary *results = [self.displayAttResults objectAtIndex:row];
        
        //format the start date (coming back as YYYY-MM-DD hh:mm)
        NSString *date = [results objectForKey:@"eventDate"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
        NSDate *formatedDate = [dateFormat dateFromString:date];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMM dd, hh:mm aa"];
        
        NSString *startDateString = [format stringFromDate:formatedDate];
        
        
        dateLabel.text = startDateString;
        dateLabel.textAlignment = UITextAlignmentLeft;
        
        //Is it a game or practice	
        eventNameLabel.text = @"";
        NSString *type = [results objectForKey:@"eventType"];
        if ([type isEqualToString:@"game"]) {
            eventLabel.text = @"Game";
        }else if ([type isEqualToString:@"practice"]){
            eventLabel.text = @"Practice";
        }else {
            eventLabel.text = @"Event";
            eventNameLabel.text = [NSString stringWithFormat:@"- %@", [results valueForKey:@"eventName"]];
            
        }
        
        
        //Was the member absent or present
        
        if ([[results objectForKey:@"present"] isEqualToString:@"yes"]) {
            absentOrPresent.image = [UIImage imageNamed:@"present.png"];
            imageLabel.text = @"Present";
        }else {
            absentOrPresent.image = [UIImage imageNamed:@"absent.png"];
            imageLabel.text = @"Absent";
        }
        
        
        
    }
    
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)viewDidUnload{
	/*
     teamId = nil;
     memberId = nil;
     errorMessage = nil;
     attResults = nil;
     eventType = nil;
	 */
	segmentEventType = nil;
	//displayAttResults = nil;
	[super viewDidUnload];
}


@end
