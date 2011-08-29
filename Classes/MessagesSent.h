//
//  MessagesSent.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface MessagesSent : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *messages;
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

	IBOutlet UIActivityIndicatorView *pollActivity;
	IBOutlet UILabel *pollActivityLabel;
	UIActivityIndicatorView *barActivity;
	
	bool displayFilter;
}
@property (nonatomic, retain) UILabel *pollActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *pollActivity;
@property (nonatomic, retain) UIActivityIndicatorView *barActivity;



@property (nonatomic, retain) NSMutableArray *teamListCount;

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
@property (nonatomic, retain) NSMutableArray *threadIdsToArchive;
@property bool deleteSuccess;
@property (nonatomic, retain) UIView *myHeader;
@property (nonatomic, retain) UIBarButtonItem *editDone;
@property (nonatomic, retain) NSMutableArray *pseduoSelectedArray;
@property bool inPseudoEditMode;

@property (nonatomic, retain) NSArray *messages;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *error;

-(IBAction)cancelDelete;
-(IBAction)messageDelete;

-(void)getSentMessages;
-(NSString *)formatDateString:(NSString *)messageDate;
@end
