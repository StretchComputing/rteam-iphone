//
//  AllEventsCalendar.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCalendarView.h"
#import "CheckmarkTile.h"

@interface AllEventsCalendar : UIViewController<KLCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	KLCalendarView *calendarView;
	KLTile *currentTile;
	UITableView *myTableView;
	NSMutableArray *tableViewData;
	KLTile *tile;
	BOOL shouldPushAnotherView;
	
	NSMutableArray *allGames;           //All Games
	NSMutableArray *allPractices;       //All Practices
	NSMutableArray *allEvents;          //All Games + Practices + Generic Events
	NSMutableArray *allGenericEvents;   //All Generic Events
	
	NSMutableArray *gamesToday;
	NSMutableArray *practicesToday;
	NSMutableArray *eventsToday;        //All Games + Practices + Generic Events today
	
	NSString *eventType;
	
	NSDate *dateSelected;
	UIToolbar *bottomBar;
	UISegmentedControl *segmentedControl;
	NSString *error;
	
	bool createdEvent;
	
	UIActivityIndicatorView *loadingActivity;
	UILabel *activityLabel;
	
	UIActivityIndicatorView *deleteActivity;
	UIActionSheet *deleteAction;
	
	NSString *deleteEventType;
	NSString *deleteEventId;
	NSString *deleteEventTeamId;
	
	int deleteCell;
	
	bool emptyGames;
	bool emptyPractices;
	bool emptyEvents;
	
	bool gDelete;
	bool pDelete;
	bool eDelete;
	
	bool gotGames;
	bool gotPractices;
	bool gotEvents;
	
	UIActionSheet *canceledAction;
}

@property (nonatomic, retain) UIActionSheet *canceledAction;
@property bool gotGames;
@property bool gotPractices;
@property bool gotEvents;

@property bool gDelete;
@property bool pDelete;
@property bool eDelete;

@property bool emptyGames;
@property bool emptyPractices;
@property bool emptyEvents;
@property int deleteCell;
@property (nonatomic, retain) NSString *deleteEventTeamId;
@property (nonatomic, retain) NSString *deleteEventType;
@property (nonatomic, retain) NSString *deleteEventId;
@property (nonatomic, retain) UIActivityIndicatorView *deleteActivity;
@property (nonatomic, retain) UIActionSheet *deleteAction;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) UILabel *activityLabel;
@property (nonatomic, retain) NSMutableArray *allGenericEvents;
@property bool createdEvent;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIToolbar *bottomBar;
@property (nonatomic, retain) NSMutableArray *allGames;
@property (nonatomic, retain) NSMutableArray *allPractices;
@property (nonatomic, retain) NSMutableArray *allEvents;

@property (nonatomic, retain) NSMutableArray *gamesToday;
@property (nonatomic, retain) NSMutableArray *practicesToday;
@property (nonatomic, retain) NSMutableArray *eventsToday;

@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSDate *dateSelected;
-(void)getAllEvents;
-(void)getAllGames;
-(void)filterGames;
-(void)filterPractices;
-(void)filterAllEvents;
-(void)finishSetup;
@end

