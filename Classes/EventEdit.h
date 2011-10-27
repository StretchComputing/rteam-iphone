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
@property (nonatomic, strong) UIActionSheet *deleteActionSheet;

@property (nonatomic, strong) UIButton *deleteButton;



@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) UITextField *eventName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *stringDate;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *saveChanges;
@property (nonatomic, strong) UIButton *practiceChangeDate;
@property (nonatomic, strong) UITextView *practiceDescription;
@property (nonatomic, strong) UITextField *practiceOpponent;
@property (nonatomic, strong) UILabel *practiceDate;

@property (nonatomic, strong) NSDate *practiceDateObject;
@property (nonatomic, strong) UILabel *errorMessage;

@property bool notifyTeam;
@property bool fromDateChange;
@property bool createSuccess;

-(IBAction)deleteEvent;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;

@end
