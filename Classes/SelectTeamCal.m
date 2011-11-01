//
//  SelectTeamCal.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//
//  SelectTeamPost.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectTeamCal.h"
#import "Team.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "NewGame2.h"
#import "NewPractice2.h"
#import "NewEvent2.h"
#import "RecurringEventSelection.h"

@implementation SelectTeamCal
@synthesize teams, error, event, teamId, finalDate, singleOrMultiple;


- (void)viewDidLoad {
	
	self.title = @"Select Team";
    
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noLogoNoCrowd.png"]];
	self.tableView.backgroundView = imageView;
	
	[super viewDidLoad];
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.teams count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 20;
		frame.size.width = 290;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		
		
	}
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	
	nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    nameLabel.textAlignment = UITextAlignmentCenter;
	
	NSUInteger row = [indexPath row];
	
	Team *controller = [self.teams objectAtIndex:row];
	nameLabel.text = controller.name;
    
    nameLabel.backgroundColor = [UIColor clearColor];
    
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int row = [indexPath row];
	
	Team *tmpTeam = [self.teams objectAtIndex:row];
	self.teamId = tmpTeam.teamId;
    
	if ([self.singleOrMultiple isEqualToString:@"single"]) {
		if ([self.event isEqualToString:@"game"]) {
			//Game	
			NewGame2 *nextController = [[NewGame2 alloc] init];
			nextController.teamId = self.teamId;
			nextController.start = self.finalDate;
			[self.navigationController pushViewController:nextController animated:YES];	
		}else if ([self.event isEqualToString:@"practice"]) {
			//Practice
			NewPractice2 *nextController = [[NewPractice2 alloc] init];
			nextController.teamId = self.teamId;
			nextController.start = self.finalDate;
			[self.navigationController pushViewController:nextController animated:YES];	
		}else {
			//Other
			NewEvent2 *nextController = [[NewEvent2 alloc] init];
			nextController.teamId = self.teamId;
			nextController.start = self.finalDate;
			[self.navigationController pushViewController:nextController animated:YES];	
		}
		
	}else {
		
		RecurringEventSelection *tmp = [[RecurringEventSelection alloc] init];
		tmp.teamId = self.teamId;
		tmp.eventType = self.event;
		[self.navigationController pushViewController:tmp animated:YES];
		
	}
    
    
}





@end