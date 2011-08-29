//
//  GameChatter.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameChatter : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	NSArray *results;
	NSString *teamName;
	NSString *teamId;
	NSString *gameId;
	NSMutableArray *inboxResults;
	NSMutableArray *outboxResults;
	
	NSString *userRole;
	
	bool noInbox;
	bool noOutbox;
	bool callReload;
	
	NSString *error;
	
	IBOutlet UIButton *sendMessageButton;
	
	IBOutlet UITableView *myTableView;
	
	NSMutableArray *pseudoSelectedArrayZero;
	NSMutableArray *pseudoSelectedArrayOne;
	
	bool inPseudoEditMode;
	UIBarButtonItem *editDone;
	bool deleteSuccess;
	NSMutableArray *threadIdsToArchiveInbox;
	NSMutableArray *threadIdsToArchiveOutbox;
	
	
	NSMutableArray *messagesOnlyArray;
	NSMutableArray *pollsOnlyArray;
	
	NSMutableArray *messagesSentArray;
	NSMutableArray *pollsSentArray;
	
	IBOutlet UIActivityIndicatorView *messageActivity;
	IBOutlet UILabel *messageActivityLabel;
	
	UIActivityIndicatorView *barActivity;
	
	
	bool doneInbox;
	bool doneOutbox;
	
	NSMutableArray *allMessages;
	
	IBOutlet UITextField *messageField;
	
	IBOutlet UILabel *errorLabel;
	NSString *errorString;
	
	IBOutlet UILabel *noMessagesLabel;
	
	NSMutableArray *tmpAllMessages;
	
	NSString *startDate;
	
	IBOutlet UITextView *infoText;
	bool hideTab;
	
	NSTimer *myTimer;
	
}
@property (nonatomic, retain) UITextView *infoText;
@property bool hideTab;

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSMutableArray *tmpAllMessages;
@property (nonatomic, retain) UILabel *noMessagesLabel;

@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSString *errorString;

@property (nonatomic, retain) UITextField *messageField;
@property (nonatomic, retain) NSMutableArray *allMessages;
@property bool callReload;
@property (nonatomic, retain) NSString *gameId;

@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) UILabel *messageActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *messageActivity;

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *messagesSentArray;
@property (nonatomic, retain) NSMutableArray *pollsSentArray;
@property (nonatomic, retain) NSMutableArray *messagesOnlyArray;
@property (nonatomic, retain) NSMutableArray *pollsOnlyArray;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchiveInbox;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchiveOutbox;

@property bool deleteSuccess;
@property (nonatomic, retain) UIBarButtonItem *editDone;
@property (nonatomic, retain) NSMutableArray *pseudoSelectedArrayZero;
@property (nonatomic, retain) NSMutableArray *pseudoSelectedArrayOne;

@property bool inPseudoEditMode;
@property (nonatomic, retain) UIButton *sendMessageButton;

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
-(IBAction)textDidStart;
-(IBAction)textDidEnd;
-(IBAction)endText;
-(IBAction)sendMessage;
@end