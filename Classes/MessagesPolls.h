//
//  MessagesPolls.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesPolls : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *results;
	NSString *teamName;
	NSString *teamId;
	UILabel *error;
	
	IBOutlet UIButton *sendButton;
	
	NSMutableArray *pseudoSelectedArray;
	
	bool inPseudoEditMode;
	
	UIBarButtonItem *editDone;
	bool deleteSuccess;
	
	NSMutableArray *threadIdsToArchive;
	
	UIButton *deleteButton;
	IBOutlet UIActivityIndicatorView *deleteActivity;
	
	IBOutlet UIView *messageDeleteView;
	IBOutlet UIButton *cancelDeleteButton;
	IBOutlet UIButton *deleteMessagesButton;
	
	IBOutlet UITableView *messagesTableView;
	
	bool displayFilter;
	
	IBOutlet UIScrollView *scroll;
	IBOutlet UITableView *teamTable;
	NSArray *teamList;
	bool haveTeamList;
	
	IBOutlet UIScrollView *tmpBlack;
	
	NSString *errorString;

	NSMutableArray *teamListCount;
	
	IBOutlet UIActivityIndicatorView *pollActivity;
	IBOutlet UILabel *pollActivityLabel;
	UIActivityIndicatorView *barActivity;
	
	bool teamListFailed;
	
	IBOutlet UIActivityIndicatorView *sendPollButtonActivity;
}
@property (nonatomic, retain) UIActivityIndicatorView *sendPollButtonActivity;
@property bool teamListFailed;
@property (nonatomic, retain) UILabel *pollActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *pollActivity;
@property (nonatomic, retain) UIActivityIndicatorView *barActivity;
@property (nonatomic, retain) NSMutableArray *teamListCount;

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIView *messageDeleteView;
@property (nonatomic, retain) UIButton *cancelDeleteButton;
@property (nonatomic, retain) UIButton *deleteMessagesButton;

@property (nonatomic, retain) UITableView *messagesTableView;


@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) UITableView *teamTable;
@property (nonatomic, retain) NSArray *teamList;
@property bool haveTeamList;

@property (nonatomic, retain) UIScrollView *tmpBlack;

@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) UIActivityIndicatorView *deleteActivity;

@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchive;
@property bool deleteSuccess;
@property (nonatomic, retain) UIBarButtonItem *editDone;
@property (nonatomic, retain) NSMutableArray *pseduoSelectedArray;
@property bool inPseudoEditMode;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;

-(IBAction)sendPoll;
-(IBAction)cancelDelete;
-(IBAction)messageDelete;

-(void)getAllPolls;
-(NSString *)formatDateString:(NSString *)messageSent;
@end
