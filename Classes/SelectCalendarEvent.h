//
//  SelectCalendarEvent.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLCalendarView.h"
#import "CheckmarkTile.h"

@interface SelectCalendarEvent : UIViewController<KLCalendarViewDelegate, UIActionSheetDelegate> {
	KLCalendarView *calendarView;
	KLTile *currentTile;

	KLTile *tile;
	BOOL shouldPushAnotherView;
	
	NSMutableArray *allEvents;           //All Games
	NSString *eventType;
	
	NSDate *dateSelected;

	NSString *error;
	
	IBOutlet UILabel *eventLabel;
	IBOutlet UITextField *eventTimeField;
	IBOutlet UIButton *removeEventButton;
	
	IBOutlet UIDatePicker *timePicker;
	IBOutlet UIButton *cancelTimeButton;
	IBOutlet UIButton *okTimeButton;
	
	IBOutlet UIView *explainPickerView;
	IBOutlet UILabel *explainPickerLabel;
	
	IBOutlet UIButton *addEventButton;
	
	bool isEventToday;
	
	NSString *errorString;
	NSString *teamId;
	
	IBOutlet UILabel *errorLabel;
	IBOutlet UIActivityIndicatorView *activity;
	
	UIBarButtonItem *createButton;

	
}
@property (nonatomic, retain) UIBarButtonItem *createButton;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *errorString;
@property bool isEventToday;
@property (nonatomic, retain) UIButton *addEventButton;

@property (nonatomic, retain) UITextField *eventTimeField;
@property (nonatomic, retain) UIButton *removeEventButton;

@property (nonatomic, retain) UIDatePicker *timePicker;
@property (nonatomic, retain) UIButton *cancelTimeButton;
@property (nonatomic, retain) UIButton *okTimeButton;

@property (nonatomic, retain) UIView *explainPickerView;
@property (nonatomic, retain) UILabel *explainPickerLabel;

@property (nonatomic, retain) UILabel *eventLabel;
@property BOOL shouldPushAnotherView;
@property (nonatomic, retain) NSString *error;

@property (nonatomic, retain) NSMutableArray *allEvents;



@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSDate *dateSelected;


-(IBAction)timeEditStart;
-(IBAction)okTime;
-(IBAction)cancelTime;
-(IBAction)removeEvent;
-(IBAction)addEvent;
@end

