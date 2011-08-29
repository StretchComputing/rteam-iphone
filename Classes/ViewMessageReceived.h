//
//  ViewMessageReceived.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewMessageReceived : UIViewController <UIActionSheetDelegate> {

	NSString *subject;
	NSString *body;
	NSString *receivedDate;
	
	NSString *teamId;
	NSString *eventId;
	NSString *eventType;
	NSString *threadId;
	BOOL wasViewed;
	
	IBOutlet UILabel *displaySubject;
	IBOutlet UILabel *displayDate;
	IBOutlet UITextView *displayBody;
	IBOutlet UILabel *displaySender;
	
	IBOutlet UIBarButtonItem *replyButton;
	IBOutlet UIToolbar *myToolbar;
	
	NSString *senderName;
	NSString *senderId;
	
	NSString *userRole;
	
	bool replySuccess;
	IBOutlet UILabel *replyMessage;
	
	IBOutlet UIButton *viewMoreDetailButton;
	IBOutlet UILabel *confirmationsLabel;
	
	NSString *confirmStatus;
	
	NSArray *individualReplies;
	
	IBOutlet UILabel *messageNumber;
	NSArray *messageArray;              //Array of (Messages)
	int currentMessageNumber;
	IBOutlet UISegmentedControl *upDown;
	NSString *teamName;
	IBOutlet UILabel *teamLabel;

	NSString *origTeamId;
    
    bool isAlert;

}
@property bool isAlert;
@property (nonatomic, retain) NSString *origTeamId;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) UILabel *teamLabel;
@property int currentMessageNumber;
@property (nonatomic, retain) UISegmentedControl *upDown;
@property (nonatomic, retain) NSArray *messageArray;
@property (nonatomic, retain) UILabel *messageNumber;

@property (nonatomic, retain) NSArray *individualReplies;
@property (nonatomic, retain) NSString *confirmStatus;
@property (nonatomic, retain) UIButton *viewMoreDetailButton;
@property (nonatomic, retain) UILabel *confirmationsLabel;
@property bool replySuccess;
@property (nonatomic, retain) UILabel *replyMessage;
@property (nonatomic, retain) UIToolbar *myToolbar;
@property (nonatomic, retain) UIBarButtonItem *replyButton;
@property (nonatomic, retain) UILabel *displaySender;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *senderId;
@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) NSString *threadId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *receivedDate;

@property (nonatomic, retain) UILabel *displaySubject;
@property (nonatomic, retain) UILabel *displayDate;
@property (nonatomic, retain) UITextView *displayBody;
@property BOOL wasViewed;

-(void)initMessageInfo;

-(IBAction)reply;
-(IBAction)deleteMessage;
-(IBAction)viewMoreDetail;
@end
