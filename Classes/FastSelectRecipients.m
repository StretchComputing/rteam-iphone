//
//  FastSelectRecipients.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FastSelectRecipients.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Player.h"
#import "SendPoll.h"
#import "FastSendMessage.h"
#import "CurrentTeamTabs.h"
#import "MessagesTabs.h" 
#import "Fan.h"

@implementation FastSelectRecipients
@synthesize teamId, members, selectedMembers, selectedMemberObjects, fromWhere, error, messageOrPoll, userRole, eventType, eventId, allFansObjects,
haveFans, memberTableView, saveButton, loadingActivity, loadingLabel, haveMembers;


- (void)viewDidLoad {
	
	self.memberTableView.delegate = self;
	self.memberTableView.dataSource = self;
	
	self.selectedMembers = [NSMutableArray array];
	self.selectedMemberObjects = [NSMutableArray array];
	self.allFansObjects = [NSMutableArray array];
	
	self.title = @"Add Recipient(s)";
	
	[self.loadingActivity startAnimating];
	[self.loadingLabel setHidden:NO];
	[self.saveButton setEnabled:NO];
	self.memberTableView.hidden = YES;
	[self performSelectorInBackground:@selector(getAllMembers) withObject:nil];
	

	
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.saveButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	
	[self.memberTableView reloadData];
}

-(void)save{
	
	NSMutableArray *justMemberObjects = [NSMutableArray array];
	
	for (int i = 0; i < [self.selectedMemberObjects count]; i++) {
		if ([[self.selectedMemberObjects objectAtIndex:i] class] == [Player class]) {
			[justMemberObjects addObject:[self.selectedMemberObjects objectAtIndex:i]];
		}else if ([[self.selectedMemberObjects objectAtIndex:i] class] == [Fan class]) {
			[justMemberObjects addObject:[self.selectedMemberObjects objectAtIndex:i]];
		}
	}
	
	//If its a Poll
	if ([self.messageOrPoll isEqualToString:@"poll"]) {
		SendPoll *tmp = [[SendPoll alloc] init];
		tmp.teamId = self.teamId;
		tmp.origLoc = self.fromWhere;
		if (self.userRole != nil) {
			tmp.userRole = self.userRole;
		}
		if (self.eventType != nil) {
			tmp.eventType = self.eventType;
			tmp.eventId = self.eventId;
		}
		
		if ([[self.selectedMembers objectAtIndex:0] isEqualToString:@"s"]) {
			tmp.toTeam = true;
			tmp.includeFans = @"";
		}else if ([[self.selectedMembers objectAtIndex:1] isEqualToString:@"s"]) {
			tmp.toTeam = true;
			tmp.includeFans = @"false";
		}else if ([[self.selectedMembers objectAtIndex:2] isEqualToString:@"s"]) {
			
			NSMutableArray *fanIds = [NSMutableArray array];
			for (int i = 0; i < [self.allFansObjects count]; i++) {
				Player *tmp = [self.allFansObjects objectAtIndex:i];
				[fanIds addObject:tmp.memberId];
				
			}
			tmp.recipients = fanIds;
			tmp.includeFans = @"";
			
		}else {
			
			NSMutableArray *mutableMemberIds = [NSMutableArray array];
			for (int i = 0; i < [justMemberObjects count]; i++) {
				Player *tmpPlayer = [justMemberObjects objectAtIndex:i];
				
				[mutableMemberIds addObject:tmpPlayer.memberId];
			}
			tmp.recipients = mutableMemberIds;
			tmp.includeFans = @"";
		}
		
		UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Recipients" style:UIBarButtonItemStyleDone target:nil action:nil];
		self.navigationItem.backBarButtonItem = temp;
		
		[self.navigationController pushViewController:tmp animated:YES];
	}else {
		
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 2;
		
			
			if ([[tempCont objectAtIndex:tempNum] class] == [FastSendMessage class]) {
				FastSendMessage *cont = [tempCont objectAtIndex:tempNum];
				
				cont.sendTeamId = self.teamId;
				
				if ([[self.selectedMembers objectAtIndex:0] isEqualToString:@"s"]) {
					cont.toTeam = true;
					cont.includeFans = @"";
				}else if ([[self.selectedMembers objectAtIndex:1] isEqualToString:@"s"]) {
					cont.toTeam = true;
					cont.includeFans = @"false";
				}else if ([[self.selectedMembers objectAtIndex:2] isEqualToString:@"s"]) {
					
					cont.recipients = self.allFansObjects;
					cont.includeFans = @"";
					cont.fansOnly = true;
					
				}else {
					cont.toTeam = false;
					
					cont.recipients = justMemberObjects;
					cont.includeFans = @"";
				}
				
				[self.navigationController popToViewController:cont animated:YES];
			}else if ([[tempCont objectAtIndex:tempNum - 1] class] == [FastSendMessage class]) {
				FastSendMessage *cont = [tempCont objectAtIndex:tempNum-1];
				cont.sendTeamId = self.teamId;
				
				if ([[self.selectedMembers objectAtIndex:0] isEqualToString:@"s"]) {
					cont.toTeam = true;
					cont.includeFans = @"";
				}else if ([[self.selectedMembers objectAtIndex:1] isEqualToString:@"s"]) {
					cont.toTeam = true;
					cont.includeFans = @"false";
				}else if ([[self.selectedMembers objectAtIndex:2] isEqualToString:@"s"]) {
					
					cont.recipients = self.allFansObjects;
					cont.includeFans = @"";
					cont.fansOnly = true;
					
				}else {
					cont.toTeam = false;
					
					cont.recipients = justMemberObjects;
					cont.includeFans = @"";
				}
				
				[self.navigationController popToViewController:cont animated:YES];
			}
		}
		
	
	
}

-(void)getAllMembers{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
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
	
	[self performSelectorOnMainThread:@selector(doneMembers) withObject:nil waitUntilDone:NO];
	[pool drain];
}


-(void)doneMembers{
	
	[self.loadingActivity stopAnimating];
	[self.loadingLabel setHidden:YES];
	[self.saveButton setEnabled:YES];
	self.haveMembers = true;
	self.memberTableView.hidden = NO;
	
	
	for (int i = 0; i < [self.members count] + 3; i++) {
		[self.selectedMembers addObject:@""];
	}
    [self.selectedMembers replaceObjectAtIndex:0 withObject:@"s"];

	for (int i = 0; i < [self.members count]; i++) {
		[self.selectedMemberObjects addObject:@""];
	}
	[self.memberTableView reloadData];
	
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (self.haveMembers){
		return [self.members count] + 3;
		
	}else {
		return 0;
	}
	
}



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	static NSInteger selectedTag = 2;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:FirstLevelCell] autorelease];
		CGRect frame;
		frame.origin.x = 5;
		frame.origin.y = 10;
		frame.size.height = 20;
		frame.size.width = 280;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];
		
		frame.origin.x += 280;
		/*
		 UILabel *selectedLabel = [[UILabel alloc] initWithFrame:frame];
		 selectedLabel.tag = selectedTag;
		 [cell.contentView addSubview:selectedLabel];
		 [selectedLabel release];
		 */
		frame.size.height = 20;
		frame.size.width = 20;
		UIImageView *tmpView = [[UIImageView alloc] initWithFrame:frame];
		tmpView.image = [UIImage imageNamed:@"blueCheck.png"];
		tmpView.tag = selectedTag;
		[cell.contentView addSubview:tmpView];
		[tmpView release];
		
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
		
	}else{
		Player *controller = [self.members objectAtIndex:row-3];
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
		}
		
		for (int i = 3; i < [self.selectedMembers count]; i++) {
			[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
		}
		
	}else if (row == 1){
		
		if (add) {
			[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
			[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
		}
		for (int i = 3; i < [self.selectedMembers count]; i++) {
			[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
		}
		
	}else if (row == 2){
		
		if (self.haveFans) {
			
			if (add) {
				[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
				[self.selectedMembers replaceObjectAtIndex:1 withObject:@""];
			}
			for (int i = 3; i < [self.selectedMembers count]; i++) {
				[self.selectedMembers replaceObjectAtIndex:i withObject:@""];
			}
		}else {
			[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
		}
		
		
	}else {
		
		[self.selectedMembers replaceObjectAtIndex:0 withObject:@""];
		[self.selectedMembers replaceObjectAtIndex:1 withObject:@""];
		[self.selectedMembers replaceObjectAtIndex:2 withObject:@""];
		Player *tmp = [self.members objectAtIndex:row-3];
		
		if (add) {
			[self.selectedMemberObjects replaceObjectAtIndex:row-3 withObject:tmp];
		}else {
			[self.selectedMemberObjects replaceObjectAtIndex:row-3 withObject:@""];
		}
		
	}
	
	
	[self.memberTableView reloadData];
}



-(void)viewDidUnload{
	//members = nil;
	//teamId = nil;
	//selectedMembers = nil;
	//error = nil;
	//messageOrPoll = nil;
	//fromWhere = nil;
	//userRole = nil;
	//eventId = nil;
	//eventType = nil;
	//allFansObjects = nil;
	memberTableView = nil;
	//selectedMemberObjects = nil;
	saveButton = nil;
	loadingActivity = nil;
	loadingLabel = nil;
	[super viewDidUnload];
	

	
}

- (void)dealloc {
	[members release];
	[teamId release];
	[selectedMembers release];
	[error release];
	[messageOrPoll release];
	[fromWhere release];
	[userRole release];
	[eventType release];
	[eventId release];
	[allFansObjects release];
	[memberTableView release];
	[selectedMemberObjects release];
	[saveButton release];
	[loadingActivity release];
	[loadingLabel release];
	[super dealloc];
}

@end