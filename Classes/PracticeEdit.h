//
//  PracticeEdit.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PracticeEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
	
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIButton *saveChanges;
	IBOutlet UITextField *practiceOpponent;
	IBOutlet UILabel *practiceDate;
	IBOutlet UITextView *practiceDescription;
	IBOutlet UIButton *practiceChangeDate;
	
	NSString *teamId;
	NSString *practiceId;
	NSString *stringDate;
	NSString *opponent;
	NSString *description;
	
	NSDate *practiceDateObject;
	
	bool notifyTeam;
	bool fromDateChange;
	bool createSuccess;
	
	IBOutlet UILabel *errorMessage;
	NSString *errorString;

	IBOutlet UIButton *deleteButton;
	
	UIActionSheet *deleteActionSheet;
	
	bool isCancel;
}
@property (nonatomic, retain) UIActionSheet *deleteActionSheet;

@property (nonatomic, retain) UIButton *deleteButton;


@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *practiceId;
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

-(IBAction)deletePractice;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;
@end
