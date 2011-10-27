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
@property (nonatomic, strong) NSMutableArray *membersOnly;
@property (nonatomic, strong) NSMutableArray *allAbsentMembers;
@property bool haveAttendance;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITableView *memberTableView;
@property bool haveFans;
@property (nonatomic, strong) NSMutableArray *allFansObjects;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSMutableArray *selectedMembers;
@property (nonatomic, strong) NSMutableArray *selectedMemberObjects;

-(IBAction)save;

-(void)getAllMembers;
-(void)save;
@end
