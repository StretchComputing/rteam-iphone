//
//  Players.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface Players : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate> {
	NSMutableArray *players;
	NSMutableArray *fans;
	NSMutableArray *playerPics;
	NSMutableArray *fanPics;
	NSString *teamName;
	NSString *teamId;
	NSString *userRole;
	
	NSString *error;
	NSString *currentMemberId;
	
	NSMutableArray *tmpPlayerPics;
	NSMutableArray *tmpFanPics;
	NSMutableArray *tmpPlayers;
	NSMutableArray *tmpFans;
	
	bool isFans;
	
	UISegmentedControl *segRosterFans;
	
	UIBarButtonItem *addButton;

	
	IBOutlet UIActivityIndicatorView *memberActivity;
	IBOutlet UILabel *memberActivityLabel;
	IBOutlet UITableView *memberTableView;
	
	IBOutlet UIActivityIndicatorView *barActivity;
	
	NSMutableArray *phoneOnlyArray;
}
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;
@property (nonatomic,retain) NSMutableArray *tmpPlayerPics;
@property (nonatomic,retain) NSMutableArray *tmpFanPics;

@property (nonatomic,retain) NSMutableArray *tmpPlayers;
@property (nonatomic,retain) NSMutableArray *tmpFans;


@property (nonatomic, retain) UITableView *memberTableView;

@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) UILabel *memberActivityLabel;
@property (nonatomic, retain) UIActivityIndicatorView *memberActivity;



@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) UISegmentedControl *segRosterFans;
@property bool isFans;
@property (nonatomic, retain) NSString *currentMemberId;
@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) NSMutableArray *fans;
@property (nonatomic, retain) NSMutableArray *playerPics;
@property (nonatomic, retain) NSMutableArray *fanPics;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *userRole;

-(void)getListOfMembers;
@end
