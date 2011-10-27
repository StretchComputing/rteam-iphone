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
@property (nonatomic, strong)  UILabel *loadingLabel;
@property (nonatomic, strong)  UIActivityIndicatorView *loadingActivity;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UITableView *memberTableView;
@property bool haveFans;
@property (nonatomic, strong) NSMutableArray *allFansObjects;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *messageOrPoll;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *fromWhere;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSMutableArray *selectedMembers;
@property (nonatomic, strong) NSMutableArray *selectedMemberObjects;

-(IBAction)save;
-(void)getAllMembers;
-(void)save;
@end