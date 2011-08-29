//
//  FastRequestSelectRecip.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastRequestSelectRecip : UIViewController <UITableViewDelegate, UITableViewDataSource > {
	
	NSArray *members;
	NSString *teamId;
	NSMutableArray *selectedMembers;
	NSMutableArray *selectedMemberObjects;
	NSMutableArray *allFansObjects;
	NSMutableArray *allAbsentMembers;
	NSMutableArray *membersOnly;
	
	NSString *error;
	
	NSString *userRole;
	NSString *eventType;
	NSString *eventId;
	
	bool haveFans;
	
	IBOutlet UIButton *saveButton;
	IBOutlet UITableView *memberTableView;
	
	bool haveAttendance;
}
@property (nonatomic, retain) NSMutableArray *membersOnly;
@property (nonatomic, retain) NSMutableArray *allAbsentMembers;
@property bool haveAttendance;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UITableView *memberTableView;
@property bool haveFans;
@property (nonatomic, retain) NSMutableArray *allFansObjects;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray *members;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSMutableArray *selectedMembers;
@property (nonatomic, retain) NSMutableArray *selectedMemberObjects;

-(IBAction)save;

-(void)getAllMembers;
-(void)save;
@end
