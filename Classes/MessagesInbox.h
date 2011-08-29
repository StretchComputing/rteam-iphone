//
//  MessagesInbox.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface MessagesInbox : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *results;
	NSString *teamName;
	NSString *teamId;
	NSString *userRole;
	NSString *error;
	
	NSMutableArray *pseudoSelectedArray;
	
	bool inPseudoEditMode;
	
	UIBarButtonItem *editDone;
	
	UIView *myHeader;
	bool deleteSuccess;
	
	NSMutableArray *threadIdsToArchive;
	
	UIButton *deleteButton;
	IBOutlet UIActivityIndicatorView *deleteActivity;
	
	NSMutableArray *messagesOnlyArray;
	NSMutableArray *pollsOnlyArray;
	
	IBOutlet UIView *messageDeleteView;
	IBOutlet UIButton *cancelDeleteButton;
	IBOutlet UIButton *deleteMessagesButton;
	
	IBOutlet UITableView *messagesTableView;
	
	
	IBOutlet UIScrollView *scroll;
	IBOutlet UITableView *teamTable;
	NSArray *teamList;
	bool haveTeamList;
	
	IBOutlet UIScrollView *tmpBlack;
	
	NSMutableArray *teamListCount;
	
	IBOutlet UIActivityIndicatorView *messageActivity;
	IBOutlet UILabel *messageActivityLabel;
	
	UIActivityIndicatorView *barActivity;
	
	bool displayFilter;
}
@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) UILabel *messageActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *messageActivity;

@property (nonatomic, retain) NSMutableArray *teamListCount;
@property (nonatomic, retain) UIScrollView *tmpBlack;
@property bool haveTeamList;
@property (nonatomic, retain) NSArray *teamList;
@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) UITableView *teamTable;
@property (nonatomic, retain) UITableView *messagesTableView;
@property (nonatomic, retain) UIView *messageDeleteView;
@property (nonatomic, retain) UIButton *cancelDeleteButton;
@property (nonatomic, retain) UIButton *deleteMessagesButton;
@property (nonatomic, retain) NSMutableArray *messagesOnlyArray;
@property (nonatomic, retain) NSMutableArray *pollsOnlyArray;
@property (nonatomic, retain) UIActivityIndicatorView *deleteActivity;

@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) NSMutableArray *threadIdsToArchive;
@property bool deleteSuccess;
@property (nonatomic, retain) UIView *myHeader;
@property (nonatomic, retain) UIBarButtonItem *editDone;
@property (nonatomic, retain) NSMutableArray *pseduoSelectedArray;
@property bool inPseudoEditMode;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;

-(IBAction)cancelDelete;
-(IBAction)messageDelete;
-(void)getAllMessages;
-(NSString *)formatDateString:(NSString *)messageSent;
@end
