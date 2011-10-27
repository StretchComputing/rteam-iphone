//
//  FastRequestSelectRecip.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastRequestSelectRecip.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Player.h"
#import "SendPoll.h"
#import "CurrentTeamTabs.h"
#import "Fan.h"
#import "FastRequestStatus2.h"


@implementation FastRequestSelectRecip
@synthesize teamId, members, selectedMembers, selectedMemberObjects, error, userRole, eventType, eventId, allFansObjects,
haveFans, memberTableView, saveButton, haveAttendance, allAbsentMembers, membersOnly;


- (void)viewDidLoad {
		
	self.memberTableView.delegate = self;
	self.memberTableView.dataSource = self;
	
	self.selectedMembers = [NSMutableArray array];
	self.selectedMemberObjects = [NSMutableArray array];
	self.allFansObjects = [NSMutableArray array];
	self.allAbsentMembers = [NSMutableArray array];
	self.membersOnly = [NSMutableArray array];
	
	self.title = @"Add Recipient(s)";
	
	[self getAllMembers];
	
	
	for (int i = 0; i < [self.members count] + 3; i++) {
		[self.selectedMembers addObject:@""];
	}
	for (int i = 0; i < [self.members count]; i++) {
		[self.selectedMemberObjects addObject:@""];
	}
	
	
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.saveButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	
	[self.memberTableView reloadData];
}

-(void)save{
	
	NSMutableArray *justMemberObjects = [NSMutableArray array];
	
	for (int i = 0; i < [self.selectedMemberObjects count]; i++) {
		if ([[self.selectedMemberObjects objectAtIndex:i] class] == [Player class]) {
			
			Player *tmp = [self.selectedMemberObjects objectAtIndex:i];
			
			[justMemberObjects addObject:tmp.memberId];
			
		}else if ([[self.selectedMemberObjects objectAtIndex:i] class] == [Fan class]) {
			Fan *tmp = [self.selectedMemberObjects objectAtIndex:i];
			
			[justMemberObjects addObject:tmp.memberId];
			
		}
	}
	
	//Go back to FastRequestSelectRecip.m
	
	NSArray *views = [self.navigationController viewControllers];
	
	FastRequestStatus2 *tmp = [views objectAtIndex:[views count] - 2];
	
	
	if ([[self.selectedMembers objectAtIndex:0] isEqualToString:@"s"]) {
		//Everyone
		tmp.toTeam = true;
		tmp.includeFans = @"";
	}else if ([[self.selectedMembers objectAtIndex:1] isEqualToString:@"s"]) {
		//Team Only
		tmp.toTeam = true;
		tmp.includeFans = @"false";
	}else if ([[self.selectedMembers objectAtIndex:2] isEqualToString:@"s"]) {
		//Fans only
		tmp.recipients = self.allFansObjects;
		NSMutableArray *fanIds = [NSMutableArray array];
		
		for (int i = 0; i < [self.allFansObjects count]; i++) {
			Fan *tmpFan = [self.allFansObjects objectAtIndex:i];
			[fanIds addObject:tmpFan.memberId];
			
		}
		
		tmp.includeFans = @"";
		tmp.fansOnly = true;
		tmp.toTeam = false;
		tmp.recipients = fanIds;
		
	}else if ([[self.selectedMembers objectAtIndex:3] isEqualToString:@"s"]) {
		//Absent Members
		NSMutableArray *memberIds = [NSMutableArray array];
		
		for (int i = 0; i < [self.allAbsentMembers count]; i++) {
			Player *tmpPlayer = [self.allAbsentMembers objectAtIndex:i];
			[memberIds addObject:tmpPlayer.memberId];
			
		}
		
		tmp.includeFans = @"";
		tmp.fansOnly = false;
		tmp.toTeam = false;
		tmp.recipients = memberIds;
		
	}else {
		//Individual Selection
		tmp.toTeam = false;
		tmp.fansOnly = false;
		tmp.recipients = justMemberObjects;
		tmp.includeFans = @"";
	}

	[self.navigationController popViewControllerAnimated:NO];

	
}

-(void)getAllMembers{
	self.haveFans = false;
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfTeamMembers:self.teamId :token :@"all" :@"true"];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.members = [response valueForKey:@"members"];
			NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.members];
			
			//Remove not network auth
			for (int i = 0; i < [tmpArray count]; i++) {
				
				if ([[tmpArray objectAtIndex:i] class] == [Fan class]) {
					Fan *tmp = [tmpArray objectAtIndex:i];
					
					if (!tmp.isNetworkAuthenticated) {
						[tmpArray removeObjectAtIndex:i];
						i--;
					}
					
				}else {
					Player *tmp = [tmpArray objectAtIndex:i];
					bool remove = false;
                    
					if (!tmp.isNetworkAuthenticated) {
						if (tmp.guard1SmsConfirmed || tmp.guard1EmailConfirmed || tmp.guard2SmsConfirmed || tmp.guard2EmailConfirmed) {
                            remove = false;
                        }else{
                            remove = true;
                        }
					}
                    
                    if (remove) {
                        [tmpArray removeObjectAtIndex:i];
						i--;
                    }
				}
				
			}
			
			
			for (int i = 0; i < [tmpArray count]; i++) {
				
				if ([[tmpArray objectAtIndex:i] class] == [Fan class]) {
					Fan *tmp = [tmpArray objectAtIndex:i];
					[self.allFansObjects addObject:tmp];
					self.haveFans = true;
					[tmpArray removeObjectAtIndex:i];
					i--;
				}
				
			}
			
			self.membersOnly = [NSMutableArray arrayWithArray:tmpArray];
			[self performSelectorInBackground:@selector(getAttendance) withObject:nil];

			//tmpArray now holds no fans
			//Add fans to the end of the array
			for (int i = 0; i < [self.allFansObjects count]; i++) {
				[tmpArray addObject:[self.allFansObjects objectAtIndex:i]];
			}
			
			self.members = tmpArray;
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [status intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					self.error = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					self.error = @"*Error connecting to server";
					break;
				default:
					//Log the status code?
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	
}





- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.members count] + 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	static NSInteger selectedTag = 2;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 5;
		frame.origin.y = 10;
		frame.size.height = 20;
		frame.size.width = 280;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		
		frame.origin.x += 280;
		/*
		 UILabel *selectedLabel = [[UILabel alloc] initWithFrame:frame];
		 selectedLabel.tag = selectedTag;
		 [cell.contentView addSubview:selectedLabel];
		 */
		frame.size.height = 20;
		frame.size.width = 20;
		UIImageView *tmpView = [[UIImageView alloc] initWithFrame:frame];
		tmpView.image = [UIImage imageNamed:@"blueCheck.png"];
		tmpView.tag = selectedTag;
		[cell.contentView addSubview:tmpView];
		
	}
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	//UILabel *selectedLabel = (UILabel *)[cell.contentView viewWithTag:selectedTag];
	UIImageView *tmpView = (UIImageView *)[cell.contentView viewWithTag:selectedTag];
	
	nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	//selectedLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	//selectedLabel.textColor = [UIColor blueColor];
	
	nameLabel.textColor = [UIColor blackColor];
	nameLabel.backgroundColor = [UIColor clearColor];
	cell.contentView.backgroundColor = [UIColor whiteColor];
	
	NSUInteger row = [indexPath row];
	if (row == 0) {
		nameLabel.text = @"Everyone";
	}else if (row == 1) {
		nameLabel.text = @"Team Only";
	}else if (row == 2) {
		if (self.haveFans) {
			nameLabel.text = @"Fans Only";
			nameLabel.textColor = [UIColor blackColor];
		}else {
			nameLabel.textColor = [UIColor grayColor];
			nameLabel.text = @"Fans Only - (No fans found)";
		}
		
	}else if (row == 3) {
		
		if (self.haveAttendance) {
			nameLabel.text = @"Absent Members";
			nameLabel.textColor = [UIColor blackColor];
		}else {
			nameLabel.textColor = [UIColor grayColor];
			nameLabel.text = @"Absent Members - (None)";
		}
		
		
		
	}else{
		Player *controller = [self.members objectAtIndex:row-4];
		nameLabel.text = controller.firstName;
		if ([controller.userRole isEqualToString:@"fan"]) {
			cell.contentView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
			
		}
	}
	
	
	if ([[self.selectedMembers objectAtIndex:row] isEqualToString:@"s"]) {
		//selectedLabel.text = @"X";
		[tmpView setHidden:NO];
	}else{
		//selectedLabel.text = @"";
		[tmpView setHidden:YES];
	}
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];
	bool add = true;
	
	if ([[self.selectedMembers objectAtIndex:row] isEqualToString:@""]) {
		[self.selectedMembers replaceObjectAtIndex:row withObject:@"s"];
	}else {
		[self.selectedMembers replaceObjectAtIndex:row withObject:@""];
		add = false;
		
	}
	
	if (row == 0) {
		
		if (add) {
			[self.selectedMembers replaceObjectAtIndex:1 withObject:@""];
			[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
			[self.selectedMembers replaceObjectAtIndex:3 withObject:@""];
		}
		
		for (int i = 4; i < [self.selectedMembers count]; i++) {
			[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
		}
		
	}else if (row == 1){
		
		if (add) {
			[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
			[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
			[self.selectedMembers replaceObjectAtIndex:3 withObject:@""];

		}
		for (int i = 4; i < [self.selectedMembers count]; i++) {
			[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
		}
		
	}else if (row == 2){
		
		if (self.haveFans) {
			
			if (add) {
				[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
				[self.selectedMembers replaceObjectAtIndex:1 withObject:@""];
				[self.selectedMembers replaceObjectAtIndex:3 withObject:@""];

			}
			for (int i = 4; i < [self.selectedMembers count]; i++) {
				[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
			}
		}else {
			[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
		}
		
		
	}else if (row == 3){
		
		if (self.haveAttendance) {
			
			if (add) {
				[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
				[self.selectedMembers replaceObjectAtIndex:1 withObject:@""];
				[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];

			}
			for (int i = 4; i < [self.selectedMembers count]; i++) {
				[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
			}
		}else {
			[self.selectedMembers replaceObjectAtIndex:3 withObject:@""];
		}
		
		
	}else {
		
		[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
		[self.selectedMembers replaceObjectAtIndex:1 withObject:@""];
		[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
		[self.selectedMembers replaceObjectAtIndex:3 withObject:@""];

		Player *tmp = [self.members objectAtIndex:row-4];
		
		if (add) {
			[self.selectedMemberObjects replaceObjectAtIndex:row-4 withObject:tmp];
		}else {
			[self.selectedMemberObjects replaceObjectAtIndex:row-4 withObject:@""];
		}
		
	}
	
	
	[self.memberTableView reloadData];
}


-(void)getAttendance{

	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *token = @"";
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		NSDictionary *responseAtt = [NSDictionary dictionary];
		
		if ([self.eventType isEqualToString:@"game"]) {
			
			responseAtt = [ServerAPI getAttendeesGame:token :self.teamId :self.eventId :@"game"];

		}else if ([self.eventType isEqualToString:@"practice"]) {
			
			responseAtt = [ServerAPI getAttendeesGame:token :self.teamId :self.eventId :@"practice"];

		}else {
			
			responseAtt = [ServerAPI getAttendeesGame:token :self.teamId :self.eventId :@"generic"];

		}

		
		NSString *statusAtt = [responseAtt valueForKey:@"status"];
		
		if ([statusAtt isEqualToString:@"100"]){
						
			NSArray *attReport = [responseAtt valueForKey:@"attendance"];
			
			//self.membersOnly holds the members, filter through and set up an array of absent members
			
			
			for (int i = 0; i < [self.membersOnly count]; i++) {
				
				bool isPresent = false;
				Player *tmpPlayer = [self.membersOnly objectAtIndex:i];
								
				for (int j = 0; j < [attReport count]; j++) {
					
					NSDictionary *tmpAtt = [attReport objectAtIndex:j];
					
					
					NSString *memberId = [tmpAtt valueForKey:@"memberId"];
					NSString *present = [tmpAtt valueForKey:@"present"];
			
					if ([memberId isEqualToString:tmpPlayer.memberId]) {
						
						if ([present isEqualToString:@"yes"]) {
							isPresent = true;
							break;
						}
					}	
					
				}
				
				if (!isPresent) {
					[self.allAbsentMembers addObject:tmpPlayer];
				}
			}
			
			
		}else{
			
			//Server hit failed...get status code out and display error accordingly
			int statusCode = [statusAtt intValue];
			
			switch (statusCode) {
				case 0:
					//null parameter
					//self.successLabel.text = @"*Error connecting to server";
					break;
				case 1:
					//error connecting to server
					//self.successLabel.text = @"*Error connecting to server";
					break;
				default:
					//Log the status code?
					//self.successLabel.text = @"*Error connecting to server";
					break;
			}
		}
		
		
	}
	
	
	[self performSelectorOnMainThread:@selector(doneAttendance) withObject:nil waitUntilDone:NO];
}


-(void)doneAttendance{
	
	if ([self.allAbsentMembers count] > 0) {
		self.haveAttendance = true;
		[self.memberTableView reloadData];
	}
}

-(void)viewDidUnload{
	/*
	members = nil;
	teamId = nil;
	selectedMembers = nil;
	error = nil;
	userRole = nil;
	eventId = nil;
	eventType = nil;
	allFansObjects = nil;
	*/
	memberTableView = nil;
	///selectedMemberObjects = nil;
	saveButton = nil;
	//allAbsentMembers = nil;
	//membersOnly = nil;
	[super viewDidUnload];
}

@end

