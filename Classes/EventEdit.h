//
//  EventEdit.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIButton *saveChanges;
	IBOutlet UITextField *practiceOpponent;
	IBOutlet UILabel *practiceDate;
	IBOutlet UITextView *practiceDescription;
	IBOutlet UIButton *practiceChangeDate;
	IBOutlet UITextField *eventName;
	
	NSString *teamId;
	NSString *eventId;
	NSString *stringDate;
	NSString *opponent;
	NSString *description;
	
	NSDate *practiceDateObject;
	
	bool notifyTeam;
	bool fromDateChange;
	bool createSuccess;
	
	IBOutlet UILabel *errorMessage;
	NSString *nameString;
	NSString *errorString;
	IBOutlet UIButton *deleteButton;
	
	UIActionSheet *deleteActionSheet;
	
	bool isCancel;
}
@property (nonatomic, retain) UIActionSheet *deleteActionSheet;

@property (nonatomic, retain) UIButton *deleteButton;


	
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *nameString;
@property (nonatomic, retain) UITextField *eventName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *stringDate;
@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) NSString *description;

@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UIButton *saveChanges;
@property (nonatomic, retain) UIButton *practiceChangeDate;
@property (nonatomic, retain) UITextView *practiceDescription;
@property (nonatomic, retain) UITextField *practiceOpponent;
@property (nonatomic, retain) UILabel *practiceDate;

@property (nonatomic, retain) NSDate *practiceDateObject;
@property (nonatomic, retain) UILabel *errorMessage;

@property bool notifyTeam;
@property bool fromDateChange;
@property bool createSuccess;

-(IBAction)deleteEvent;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;

@end
