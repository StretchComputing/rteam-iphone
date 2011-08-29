//
//  DailyWeeklyEvent.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DailyWeeklyEvent : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {

	NSString *frequency;
	
	IBOutlet UIDatePicker *timePicker;
	IBOutlet UIPickerView *dayPicker;
	
	IBOutlet UITextField *startDate;
	IBOutlet UITextField *endDate;
	
	IBOutlet UITextField *timeField;
	IBOutlet UITextField *dayField;
	
	IBOutlet UIButton *submitButton;
	
	IBOutlet UIButton *okTimeButton;
	
	IBOutlet UIDatePicker *startEndPicker;
	IBOutlet UIButton *selectDateButton;
    
    IBOutlet UITextField *location;
	
	bool isStart;
	bool isTime;
	
	NSString *currentDay;
	
	IBOutlet UILabel *titleLabel;
	
	IBOutlet UILabel *dayLabel;
	
	IBOutlet UILabel *errorLabel;
	IBOutlet UIActivityIndicatorView *activity;
	
	NSMutableArray *allEventsArray;
	
	NSString *eventType;
	NSString *teamId;
	
	NSString *errorString;
}
@property (nonatomic, retain) UITextField *location;

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSMutableArray *allEventsArray;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) UILabel *titleLabel;

@property bool isTime;
@property (nonatomic, retain) NSString *currentDay;
@property bool isStart;
@property (nonatomic, retain) UIButton *selectDateButton;
@property (nonatomic, retain) UIDatePicker *startEndPicker;
@property (nonatomic, retain) UIButton *okTimeButton;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UITextField *startDate;
@property (nonatomic, retain) UITextField *endDate;

@property (nonatomic, retain) UITextField *timeField;
@property (nonatomic, retain) UITextField *dayField;
@property (nonatomic, retain) NSString *frequency;
@property (nonatomic, retain) UIDatePicker *timePicker;
@property (nonatomic, retain) UIPickerView *dayPicker;

-(IBAction)dayBegin;
-(IBAction)timeBegin;
-(IBAction)endText;
-(IBAction)submit;
-(IBAction)okTime;
-(IBAction)selectDate;
-(IBAction)startDateBegin;
-(IBAction)endDateBegin;
-(void)preCreateEvent;

-(void)setUpDaily;
-(void)setUpWeekly;
-(void)setUpBiWeekly;
@end
