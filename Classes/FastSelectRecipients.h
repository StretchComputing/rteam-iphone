//
//  FastSelectRecipients.h
//  rTeam
//
//  Created by Nick Wroblewski on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FastSelectRecipients : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	
	NSArray *members;
	NSString *teamId;
	NSMutableArray *selectedMembers;
	NSMutableArray *selectedMemberObjects;
	NSMutableArray *allFansObjects;
	NSString *fromWhere;
	NSString *messageOrPoll;
	NSString *error;
	
	NSString *userRole;
	NSString *eventType;
	NSString *eventId;
	
	bool haveFans;
	
	IBOutlet UIButton *saveButton;
	IBOutlet UITableView *memberTableView;

	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	bool haveMembers;
}
@property bool haveMembers;
@property (nonatomic, retain)  UILabel *loadingLabel;
@property (nonatomic, retain)  UIActivityIndicatorView *loadingActivity;

@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UITableView *memberTableView;
@property bool haveFans;
@property (nonatomic, retain) NSMutableArray *allFansObjects;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *messageOrPoll;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *fromWhere;
@property (nonatomic, retain) NSArray *members;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSMutableArray *selectedMembers;
@property (nonatomic, retain) NSMutableArray *selectedMemberObjects;

-(IBAction)save;
-(void)getAllMembers;
-(void)save;
@end