//
//  MessageAssocEvent.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageAssocEvent.h"
#import "Game.h"
#import "Practice.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "CurrentTeamTabs.h"
#import "Event.h"

@implementation MessageAssocEvent
@synthesize events, teamId, error;

- (void)viewDidLoad {
	
	
	self.title = @"Events";
	
	[self getAllEvents];
    
	
	NSInteger numEvents = [self.events count];
	
	
	//Header to be displayed if there are no players
	UIView *headerView =
	[[UIView alloc]
     initWithFrame:CGRectMake(0, 0, 300, 75)];
	
	NSString *display = @"";
	
	if (numEvents == 0) {
		display = @"You have no future games or practices entered for this team.";
	}else {
		display = @"Choose an event to associate your message with.";
	}
    
	UILabel *headerLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
	headerLabel.text = display;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textAlignment = UITextAlignmentCenter;
	headerLabel.numberOfLines = 2;
	[headerView addSubview:headerLabel];
	
	headerView.backgroundColor = [UIColor whiteColor];
	
	self.tableView.tableHeaderView = headerView;
    
    
}

-(void)getAllEvents{
	
	NSString *token = @"";
	NSArray *gameArray = [NSArray array];
	NSArray *practiceArray = [NSArray array];
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	if (self.teamId == nil) {
		self.teamId = @"";
	}
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		NSDictionary *response = [ServerAPI getListOfGames:self.teamId :token];
		NSDictionary *responsePractice = [ServerAPI getListOfEvents:self.teamId :token :@"all"];
		
		NSString *status = [response valueForKey:@"status"];
		NSString *statusPractice = [responsePractice valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			gameArray = [response valueForKey:@"games"];
			
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
					//Game retrieval failed, log error code?
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
		
		if ([statusPractice isEqualToString:@"100"]){
			
			practiceArray = [responsePractice valueForKey:@"events"];
			
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
					//Practice retrieval failed, log status code?
					self.error = @"*Error connecting to server";
					break;
			}
		}
		
	}
	
	//check for  old games;
	NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [gameArray count]; i++) {
		Game *tmpGame = [gameArray objectAtIndex:i];
		
		NSString *date = tmpGame.startDate;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:date];
		NSDate *todaysDate = [NSDate date];
		
		if ([todaysDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
			
			[tmpArray addObject:tmpGame];
			
		}
		
		
	}
	
	for (int i = 0; i < [practiceArray count]; i++) {
		
		if ([[practiceArray objectAtIndex:i] class] == [Practice class]) {
			
            Practice *tmpPractice = [practiceArray objectAtIndex:i];
            
            NSString *date = tmpPractice.startDate;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
            NSDate *formatedDate = [dateFormat dateFromString:date];
            NSDate *todaysDate = [NSDate date];
            
            if ([todaysDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
                
                [tmpArray addObject:tmpPractice];
                
            }
			
		}else {
			Event *tmpPractice = [practiceArray objectAtIndex:i];
			
			NSString *date = tmpPractice.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];
			NSDate *todaysDate = [NSDate date];
			
			if ([todaysDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
				
				[tmpArray addObject:tmpPractice];
				
			}
		}
        
		
		
	}
	
	
	self.events = tmpArray;
	
	
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger dateTag = 1;
	static NSInteger oppTag = 2;
	static NSInteger descTag = 3;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 300;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		frame.size.height = 17;
		frame.origin.y += 23;
		UILabel *oppLabel = [[UILabel alloc] initWithFrame:frame];
		oppLabel.tag = oppTag;
		[cell.contentView addSubview:oppLabel];
		
		frame.size.height = 15;
		frame.origin.y += 18;
		UILabel *descLabel = [[UILabel alloc] initWithFrame:frame];
		descLabel.tag = descTag;
		[cell.contentView addSubview:descLabel];
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	UILabel *oppLabel = (UILabel *)[cell.contentView viewWithTag:oppTag];
	UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:descTag];
	
	dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	oppLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	descLabel.textColor = [UIColor grayColor];
	descLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	
	//Configure the cell
	
    NSUInteger row = [indexPath row];
	NSString *date = @"";
	bool isGame = true;
	NSString *oppLabelText = @"";
	NSString *descLabelText = @"";
	
	
	if ([[self.events objectAtIndex:row] class] == [Game class]) {
		Game *tmp = [self.events objectAtIndex:row];
		date = tmp.startDate;
		oppLabelText = tmp.opponent;
		descLabelText = tmp.description;
	}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
		isGame = false;
		Practice *tmp = [self.events objectAtIndex:row];
		date = tmp.startDate;
		oppLabelText = [NSString stringWithFormat:@"at %@", tmp.location];
		descLabelText = tmp.description;
	}else {
		isGame = false;
		Event *tmp = [self.events objectAtIndex:row];
		date = tmp.startDate;
		descLabelText = [NSString stringWithFormat:@"at %@", tmp.location];
		oppLabelText = tmp.eventName;
	}
    
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSDate *formatedDate = [dateFormat dateFromString:date];
	NSDate *todaysDate = [NSDate date];
	
	if ([formatedDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
		
		//if the game is in the past, grey out the label
		dateLabel.textColor = [UIColor grayColor];
		oppLabel.textColor = [UIColor grayColor];
		
	}else {
		dateLabel.textColor = [UIColor blackColor];
		oppLabel.textColor = [UIColor blackColor];
	}
	
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM dd, hh:mm aa"];
	
	NSString *startDateString = [format stringFromDate:formatedDate];
	
	dateLabel.text = startDateString;
    
	
	if (isGame) {
		oppLabel.text = [@"vs. " stringByAppendingString:oppLabelText];
	}else {
		oppLabel.text = oppLabelText;
	}
	
	
	descLabel.text = descLabelText;
	
	return cell;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSUInteger row = [indexPath row];
	//Game *currentGame = [self.games objectAtIndex:row];
	NSString *gameOrPractice = @"";
	NSString *gpId = @"";
	NSString *date = @"";
	
	if ([[self.events objectAtIndex:row] class] == [Game class]) {
		Game *tmp = [self.events objectAtIndex:row];
		gpId = tmp.gameId;
		gameOrPractice = @"game";
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:tmp.startDate];
		[dateFormat setDateFormat:@"MMM dd"];
		date = [dateFormat stringFromDate:formatedDate];
		
	}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
		Practice *tmp = [self.events objectAtIndex:row];
		gpId = tmp.practiceId;
		gameOrPractice = @"practice";
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:tmp.startDate];
		[dateFormat setDateFormat:@"MMM dd"];
		date = [dateFormat stringFromDate:formatedDate];
	}else {
		Event *tmp = [self.events objectAtIndex:row];
		gpId = tmp.eventId;
		gameOrPractice = @"generic";
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:tmp.startDate];
		[dateFormat setDateFormat:@"MMM dd"];
		date = [dateFormat stringFromDate:formatedDate];
	}
    
    
	
	NSArray *tempCont = [self.navigationController viewControllers];
	int tempNum = [tempCont count];
	tempNum = tempNum - 2;

	
    
	
	
}





- (void)viewDidUnload {
	/*
     events = nil;
     teamId = nil;
     error = nil;
	 */
	[super viewDidUnload];
}





@end