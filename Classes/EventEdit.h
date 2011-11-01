//
//  EventEdit.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
	
}
@property (nonatomic, strong) NSString *thePracticeOpponent;
@property (nonatomic, strong) NSString *thePracticeDescription;
@property (nonatomic, strong) NSString *theEventName;


@property bool isCancel;
@property (nonatomic, strong) UIActionSheet *deleteActionSheet;

@property (nonatomic, strong) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) IBOutlet UITextField *eventName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *stringDate;
@property (nonatomic, strong) NSString *opponent;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIButton *saveChanges;
@property (nonatomic, strong) IBOutlet UIButton *practiceChangeDate;
@property (nonatomic, strong) IBOutlet UITextView *practiceDescription;
@property (nonatomic, strong) IBOutlet UITextField *practiceOpponent;
@property (nonatomic, strong) IBOutlet UILabel *practiceDate;

@property (nonatomic, strong) NSDate *practiceDateObject;
@property (nonatomic, strong) IBOutlet UILabel *errorMessage;

@property bool notifyTeam;
@property bool fromDateChange;
@property bool createSuccess;

-(IBAction)deleteEvent;
-(IBAction)submit;
-(IBAction)changeDate;
-(IBAction)endText;

@end
