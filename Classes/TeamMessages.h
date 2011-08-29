//
//  TeamMessages.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface TeamMessages : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *results;
	NSString *teamName;
	NSString *teamId;
	
	NSMutableArray *inboxResults;
	NSMutableArray *outboxResults;
	
	NSString *userRole;
	
	bool noInbox;
	bool noOutbox;
	
	NSString *error;
	
	IBOutlet UIButton *sendPollButton;
	IBOutlet UIButton *sendMessageButton;
	IBOutlet UIButton *deleteButton;
	
	IBOutlet UITableView *myTableView;
	
	NSMutableArray *pseudoSelectedArrayZero;
	NSMutableArray *pseudoSelectedArrayOne;

	bool inPseudoEditMode;
	bool deleteSuccess;
	NSMutableArray *threadIdsToArchiveInbox;
	NSMutableArray *threadIdsToArchiveOutbox;
	
	IBOutlet UIActivityIndicatorView *deleteActivity;

	NSMutableArray *messagesOnlyArray;
	NSMutableArray *pollsOnlyArray;
	
	NSMutableArray *messagesSentArray;
	NSMutableArray *pollsSentArray;

	IBOutlet UIActivityIndicatorView *messageActivity;
	IBOutlet UILabel *messageActivityLabel;
	
	UIActivityIndicatorView *barActivity;
	
	IBOutlet UIView *messageDeleteView;
	
	bool doneInbox;
	bool doneOutbox;

}
@property (nonatomic, retain) UIView *messageDeleteView;

@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) UILabel *messageActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *messageActivity;

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *messagesSentArray;
@property (nonatomic, retain) NSMutableArray *pollsSentArray;
@property (nonatomic, retain) NSMutableArray *messagesOnlyArray;
@property (nonatomic, retain) NSMutableArray *pollsOnlyArray;
@property (nonatomic, retain) UIActivityIndicatorView *deleteActivity;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchiveInbox;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchiveOutbox;

@property bool deleteSuccess;
@property (nonatomic, retain) NSMutableArray *pseudoSelectedArrayZero;
@property (nonatomic, retain) NSMutableArray *pseudoSelectedArrayOne;

@property bool inPseudoEditMode;
@property (nonatomic, retain) UIButton *sendPollButton;
@property (nonatomic, retain) UIButton *sendMessageButton;
@property (nonatomic, retain) UIButton *deleteButton;

@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSMutableArray *inboxResults;
@property (nonatomic, retain) NSMutableArray *outboxResults;
@property (nonatomic, retain) NSString *userRole;
@property bool noInbox;
@property bool noOutbox;
@property bool doneInbox;
@property bool doneOutbox;

-(void)getAllMessages;
-(IBAction)deleteMessages;
-(IBAction)cancelDelete;
-(IBAction)sendPoll;
-(IBAction)sendMessage;
@end
