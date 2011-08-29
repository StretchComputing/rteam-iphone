//
//  AllEventCalList.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllEventCalList : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	
	NSArray *events;
	
	NSArray *allGames;
	NSArray *allPractices;
	NSArray *allEvents;
	
	UIToolbar *bottomBar;
	UISegmentedControl *segmentedControl;
	
	int initialSegment;
	
	NSMutableArray *dateArray;  //An array of arrays, each cell represents one date, and all events in that cells array have the same date
	
	IBOutlet UITableView *calendarList;
	
	bool scrolledOnce;
	
	UIActionSheet *canceledAction;
	int cancelRow;
	int cancelSection;
	
	IBOutlet UIActivityIndicatorView *delteActivity;
	
	NSString *gameIdCanceled;
	NSString *practiceIdCanceled;
	NSString *eventIdCanceled;
	bool isCancel; //if not, then a delete
}
@property bool isCancel;
@property (nonatomic, retain) NSString *gameIdCanceled;
@property (nonatomic, retain) NSString *practiceIdCanceled;
@property (nonatomic, retain) NSString *eventIdCanceled;

@property int cancelSection;
@property (nonatomic, retain) UIActivityIndicatorView *deleteActivity;
@property int cancelRow;
@property (nonatomic, retain) UIActionSheet *canceledAction;
@property bool scrolledOnce;
@property (nonatomic, retain) UITableView *calendarList;
@property (nonatomic, retain) NSMutableArray *dateArray;
@property int initialSegment;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UIToolbar *bottomBar;
@property (nonatomic, retain) NSArray *allGames;
@property (nonatomic, retain) NSArray *allPractices;
@property (nonatomic, retain) NSArray *allEvents;
@property (nonatomic, retain) NSArray *events;

-(void)buildDateArray;
-(NSString *)getDateForObject:(id)event;
-(void)scrollToCurrent;
@end
