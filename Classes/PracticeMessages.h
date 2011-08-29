//
//  PracticeMessages.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface PracticeMessages : SecondLevelViewController <UITableViewDelegate> {
	NSArray *results;
	NSString *teamName;
	NSString *teamId;
	NSString *practiceId;
	NSMutableArray *inboxResults;
	NSMutableArray *outboxResults;
	
	bool noInbox;
	bool noOutbox;
	
	NSString *error;
	NSString *userRole;
	
	
	UIButton *sendPollButton;
	UIButton *sendMessageButton;
	UIButton *deleteButton;
	
	
	NSMutableArray *pseudoSelectedArrayZero;
	NSMutableArray *pseudoSelectedArrayOne;

	bool inPseudoEditMode;
	UIBarButtonItem *editDone;
	bool deleteSuccess;
	NSMutableArray *threadIdsToArchiveInbox;
	NSMutableArray *threadIdsToArchiveOutbox;


	UIActivityIndicatorView *delteActivity;

	NSMutableArray *messagesOnlyArray;
	NSMutableArray *pollsOnlyArray;
}

@property (nonatomic, retain) NSMutableArray *messagesOnlyArray;
@property (nonatomic, retain) NSMutableArray *pollsOnlyArray;

@property (nonatomic, retain) UIActivityIndicatorView *deleteActivity;

@property (nonatomic, retain) NSMutableArray *threadIdsToArchiveInbox;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchiveOutbox;

@property bool deleteSuccess;
@property (nonatomic, retain) UIBarButtonItem *editDone;
@property (nonatomic, retain) NSMutableArray *pseudoSelectedArrayZero;
@property (nonatomic, retain) NSMutableArray *pseudoSelectedArrayOne;

@property bool inPseudoEditMode;
@property (nonatomic, retain) UIButton *sendPollButton;
@property (nonatomic, retain) UIButton *sendMessageButton;
@property (nonatomic, retain) UIButton *deleteButton;


@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *practiceId;
@property (nonatomic, retain) NSMutableArray *inboxResults;
@property (nonatomic, retain) NSMutableArray *outboxResults;

@property bool noInbox;
@property bool noOutbox;
-(void)getAllMessages;
@end
