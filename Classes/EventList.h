//
//  EventList.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface EventList : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIActionSheetDelegate> {
	NSArray *events;
	NSString *teamName;
	NSString *teamId;
	NSString *userRole;
	int deleteRow;
	int actionRow;
	bool isPastGame;
	bool fromEdit;
	
	IBOutlet UILabel *error;
	
	UIBarButtonItem *addButton;
	
	NSString *sport;
	
	IBOutlet UILabel *eventActivityLabel;
	IBOutlet UITableView *eventsTableView;
	
	IBOutlet UIActivityIndicatorView *barActivity;
	
	UIActionSheet *undoCancel;
	
	IBOutlet UIActivityIndicatorView *editEventActiviy;
}
@property (nonatomic, retain) UIActivityIndicatorView *editEventActiviy;
@property int actionRow;
@property (nonatomic, retain) UIActionSheet *undoCancel;
@property (nonatomic, retain) UITableView *eventsTableView;

@property (nonatomic, retain) UIActivityIndicatorView *barActivity;

@property (nonatomic, retain) UILabel *eventActivityLabel;

@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property int deleteRow;
@property bool isPastGame;
@property bool fromEdit;
@property (nonatomic, retain) NSString *userRole;

-(void)getAllEvents;
-(void)deleteActionSheet;

-(void)scrollToCurrent;
@end
