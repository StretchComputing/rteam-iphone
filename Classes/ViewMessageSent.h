//
//  ViewMessagesSent.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewMessageSent : UIViewController <UIActionSheetDelegate>{

	NSString *subject;
	NSString *body;
	NSString *createdDate;
	
	NSString *teamId;
	NSString *eventId;
	NSString *eventType;
	NSString *threadId;
		
	IBOutlet UILabel *displaySubject;
	IBOutlet UILabel *displayDate;
	IBOutlet UITextView *displayBody;
	IBOutlet UILabel *recipients;
	NSArray *individualReplies;
	
	IBOutlet UIButton *viewMoreDetailButton;
	IBOutlet UILabel *confirmStringLabel;
	NSString *confirmString;
	
	IBOutlet UILabel *messageNumber;
	NSArray *messageArray;              //Array of (Messages)
	int currentMessageNumber;
	IBOutlet UISegmentedControl *upDown;
	NSString *teamName;
	IBOutlet UILabel *teamNameLabel;
	
	NSString *origTeamId;
	
	NSDictionary *messageInfo;
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	IBOutlet UIBarButtonItem *deleteButton;
	
	IBOutlet UILabel *errorLabel;
	NSString *errorString;
}
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSString *errorString;

@property (nonatomic, retain) UIBarButtonItem *deleteButton;

@property (nonatomic, retain) NSDictionary *messageInfo;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) NSString *origTeamId;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) UILabel *teamNameLabel;
@property int currentMessageNumber;
@property (nonatomic, retain) UISegmentedControl *upDown;
@property (nonatomic, retain) NSArray *messageArray;
@property (nonatomic, retain) UILabel *messageNumber;


@property (nonatomic, retain) UIButton *viewMoreDetailButton;
@property (nonatomic, retain) NSArray *individualReplies;
@property (nonatomic, retain) NSString *threadId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *createdDate;

@property (nonatomic, retain) UILabel *displaySubject;
@property (nonatomic, retain) UILabel *displayDate;
@property (nonatomic, retain) UITextView *displayBody;
@property (nonatomic, retain) UILabel *recipients;
@property (nonatomic, retain) NSString *confirmString;
@property (nonatomic, retain) UILabel *confirmStringLabel;

-(void)initMessageInfo;

-(IBAction)deleteMessage;
-(IBAction)ViewDetailMessageReplies;

@end
