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
	
}

@property (nonatomic, strong) UIActionSheet *canceledAction;
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
@property (nonatomic, strong) NSString *deleteEventTeamId;
@property (nonatomic, strong) NSString *deleteEventType;
@property (nonatomic, strong) NSString *deleteEventId;
@property (nonatomic, strong) UIActivityIndicatorView *deleteActivity;
@property (nonatomic, strong) UIActionSheet *deleteAction;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) UILabel *activityLabel;
@property (nonatomic, strong) NSMutableArray *allGenericEvents;
@property bool createdEvent;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIToolbar *bottomBar;
@property (nonatomic, strong) NSMutableArray *allGames;
@property (nonatomic, strong) NSMutableArray *allPractices;
@property (nonatomic, strong) NSMutableArray *allEvents;

@property (nonatomic, strong) NSMutableArray *gamesToday;
@property (nonatomic, strong) NSMutableArray *practicesToday;
@property (nonatomic, strong) NSMutableArray *eventsToday;

@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSDate *dateSelected;

-(void)getAllEvents;
-(void)getAllGames;
-(void)filterGames;
-(void)filterPractices;
-(void)filterAllEvents;
-(void)finishSetup;
@end

