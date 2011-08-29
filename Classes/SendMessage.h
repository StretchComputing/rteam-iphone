//
//  SendMessage.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendMessage : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIButton *sendButton;
	IBOutlet UITextField *subjectField;
	IBOutlet UITextView *messageField;
	
	IBOutlet UITextView *eventAssocLabel;
	IBOutlet UIButton *eventAssocButton;
	IBOutlet UISegmentedControl *confirmationControl;
	IBOutlet UIButton *selectRecipButton;
	
	NSString *teamId;
	IBOutlet UILabel *errorMessage;
	bool createSuccess;
	
	NSString *eventId;
	NSString *eventType;
	NSString *origLoc;
	
	NSString *subject;
	NSArray *recipients;
	bool toTeam;
	
	bool isReply;
	NSString *replyTo;
	NSString *replyToId;
	
	IBOutlet UILabel *recipientLabel;
	NSString *userRole;
	IBOutlet UILabel *chosenEvent;
	NSString *chosenEventDate;
	NSString *chosenEventType;
	
	NSString *fromWhere;
	NSString *sendTeamId;
	NSString *includeFans;
	
	bool fansOnly;
	IBOutlet UIButton *sendWithAlertButton;
	NSString *sendAlert;
	NSString *errorString;
	
	IBOutlet UIActivityIndicatorView *recipActivity;
    
    bool replyAlert;

    UIToolbar *keyboardToolbar;
}

@property (nonatomic, retain) UIToolbar *keyboardToolbar;

@property bool replyAlert;
@property (nonatomic, retain) UIButton *selectRecipButton;
@property (nonatomic, retain) UIActivityIndicatorView *recipActivity;

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *sendAlert;
@property (nonatomic, retain) UIButton *sendWithAlertButton;
@property bool fansOnly;
@property (nonatomic, retain) NSString *includeFans;
@property (nonatomic, retain) NSString *sendTeamId;
@property (nonatomic, retain) NSString *fromWhere;
@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) UILabel *recipientLabel;
@property (nonatomic, retain) NSString *subject;

@property (nonatomic,retain) UIActivityIndicatorView *activity;
@property (nonatomic,retain) UIButton *sendButton;
@property (nonatomic,retain) UITextView *messageField;
@property (nonatomic,retain) UITextField *subjectField;

@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UILabel *errorMessage;
@property bool createSuccess;

@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *origLoc;
@property (nonatomic, retain) NSArray *recipients;
@property bool toTeam;

@property bool isReply;
@property (nonatomic, retain) NSString *replyTo;
@property (nonatomic, retain) NSString *replyToId;

@property (nonatomic, retain) UITextView *eventAssocLabel;
@property (nonatomic, retain) UIButton *eventAssocButton;
@property (nonatomic, retain) UILabel *chosenEvent;
@property (nonatomic, retain) NSString *chosenEventDate;
@property (nonatomic, retain) NSString *chosenEventType;
@property (nonatomic, retain) UISegmentedControl *confirmationControl;

-(NSString *)buildRecipientList;
-(IBAction)send:(id)sender;
-(IBAction)endText;
-(IBAction)selectRecipients;
-(IBAction)associateEvent;
@end
