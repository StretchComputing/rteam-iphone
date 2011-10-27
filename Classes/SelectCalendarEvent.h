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
@property (nonatomic, strong) UIBarButtonItem *createButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *errorString;
@property bool isEventToday;
@property (nonatomic, strong) UIButton *addEventButton;

@property (nonatomic, strong) UITextField *eventTimeField;
@property (nonatomic, strong) UIButton *removeEventButton;

@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) UIButton *cancelTimeButton;
@property (nonatomic, strong) UIButton *okTimeButton;

@property (nonatomic, strong) UIView *explainPickerView;
@property (nonatomic, strong) UILabel *explainPickerLabel;

@property (nonatomic, strong) UILabel *eventLabel;
@property BOOL shouldPushAnotherView;
@property (nonatomic, strong) NSString *error;

@property (nonatomic, strong) NSMutableArray *allEvents;



@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSDate *dateSelected;


-(IBAction)timeEditStart;
-(IBAction)okTime;
-(IBAction)cancelTime;
-(IBAction)removeEvent;
-(IBAction)addEvent;
@end

