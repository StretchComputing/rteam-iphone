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
@property (nonatomic, strong) NSString *origTeamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UILabel *teamLabel;
@property int currentMessageNumber;
@property (nonatomic, strong) UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, strong) UILabel *messageNumber;

@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) NSString *confirmStatus;
@property (nonatomic, strong) UIButton *viewMoreDetailButton;
@property (nonatomic, strong) UILabel *confirmationsLabel;
@property bool replySuccess;
@property (nonatomic, strong) UILabel *replyMessage;
@property (nonatomic, strong) UIToolbar *myToolbar;
@property (nonatomic, strong) UIBarButtonItem *replyButton;
@property (nonatomic, strong) UILabel *displaySender;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *senderId;
@property (nonatomic, strong) NSString *userRole;

@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *receivedDate;

@property (nonatomic, strong) UILabel *displaySubject;
@property (nonatomic, strong) UILabel *displayDate;
@property (nonatomic, strong) UITextView *displayBody;
@property BOOL wasViewed;

-(void)initMessageInfo;

-(IBAction)reply;
-(IBAction)deleteMessage;
-(IBAction)viewMoreDetail;
-(NSString *)getDateLabel:(NSString *)dateCreated;

@end
