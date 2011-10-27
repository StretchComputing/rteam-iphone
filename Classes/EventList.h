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
@property (nonatomic, strong) UIActivityIndicatorView *editEventActiviy;
@property int actionRow;
@property (nonatomic, strong) UIActionSheet *undoCancel;
@property (nonatomic, strong) UITableView *eventsTableView;

@property (nonatomic, strong) UIActivityIndicatorView *barActivity;

@property (nonatomic, strong) UILabel *eventActivityLabel;

@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UILabel *error;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property int deleteRow;
@property bool isPastGame;
@property bool fromEdit;
@property (nonatomic, strong) NSString *userRole;

-(void)getAllEvents;
-(void)deleteActionSheet;

-(void)scrollToCurrent;
@end
