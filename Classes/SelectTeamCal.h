//
//  SelectTeamCal.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface SelectTeamCal : UITableViewController {
	
	NSArray *teams;
	NSString *error;
	NSString *event;
	NSString *teamId;
	NSDate *finalDate;
	NSString *singleOrMultiple;
}
@property (nonatomic, retain) NSString *singleOrMultiple;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSDate *finalDate;
@property (nonatomic, retain) NSString *event;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray *teams;


@end
