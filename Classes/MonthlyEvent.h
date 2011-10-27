//
//  MonthlyEvent.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MonthlyEvent : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
	
	NSString *frequency;
	
	IBOutlet UIDatePicker *timePicker;
	
	IBOutlet UIPickerView *dayPicker;
	IBOutlet UIPickerView *datePicker;
	
	IBOutlet UITextField *startDate;
	IBOutlet UITextField *endDate;
	
	IBOutlet UITextField *timeField;
	IBOutlet UITextField *dayField;
	IBOutlet UITextField *dateField;
	
	IBOutlet UIButton *submitButton;
	
	IBOutlet UIButton *okTimeButton;
    
    IBOutlet UITextField *location;
	
	IBOutlet UIDatePicker *startEndPicker;
	IBOutlet UIButton *selectDateButton;
	
	bool isStart;
	bool isTime;
	
	NSString *currentDay;
	
	IBOutlet UILabel *titleLabel;
	
	IBOutlet UILabel *dayLabel;
	
	IBOutlet UILabel *errorLabel;
	IBOutlet UIActivityIndicatorView *activity;
	
	NSString *currentDate;
	
	bool isDay;
	
	NSString *eventType;
	NSMutableArray *allEventsArray;
	
	NSString *teamId;
	NSString *errorString;
}
@property (nonatomic, strong) UITextField *location;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSMutableArray *allEventsArray;
@property (nonatomic, strong) NSString *eventType;
@property bool isDay;
@property (nonatomic, strong) UITextField *dateField;

@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property bool isTime;
@property (nonatomic, strong) NSString *currentDay;
@property bool isStart;
@property (nonatomic, strong) UIButton *selectDateButton;
@property (nonatomic, strong) UIDatePicker *startEndPicker;
@property (nonatomic, strong) UIButton *okTimeButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextField *startDate;
@property (nonatomic, strong) UITextField *endDate;

@property (nonatomic, strong) UITextField *timeField;
@property (nonatomic, strong) UITextField *dayField;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) UIDatePicker *timePicker;
@property (nonatomic, strong) UIPickerView *dayPicker;

-(IBAction)dayBegin;
-(IBAction)timeBegin;
-(IBAction)endText;
-(IBAction)submit;
-(IBAction)okTime;
-(IBAction)selectDate;
-(IBAction)startDateBegin;
-(IBAction)endDateBegin;
-(IBAction)dateBegin;

-(void)preCreateEvent;
-(void)populateEventArray;
-(NSDate *)addMonth:(NSDate *)initDate;
@end
