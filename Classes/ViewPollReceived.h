//
//  ViewPollReceived.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PollResultsView.h"

@interface ViewPollReceived : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	NSString *subject;
	NSString *body;
	NSString *receivedDate;
	
	NSString *teamId;
	NSString *eventId;
	NSString *eventType;
	NSArray *pollChoices;
	NSString *finalAnswer;
	
	NSString *teamName;
	IBOutlet UILabel *teamNameLabel;
	
	IBOutlet UILabel *displaySubject;
	IBOutlet UILabel *displayDate;
	IBOutlet UITextView *displayBody;
	
	IBOutlet UIButton *buttonOption1;
	IBOutlet UIButton *buttonOption2;
	IBOutlet UIButton *buttonOption3;
	IBOutlet UIButton *buttonOption4;
	IBOutlet UIButton *buttonOption5;
	
	IBOutlet UITextView *followUpMessage;
	
	NSString *threadId;
	BOOL wasViewed;
	
	IBOutlet UILabel *displayFrom;
    NSString *from;
	NSString *status;
	
	IBOutlet UITextView *finalizedMessage;
	IBOutlet UITextView *howToRespondMessage;
	
	bool displayResults;
	
	IBOutlet UILabel *ownReply;
	IBOutlet UIScrollView *displayScroll;
	
	IBOutlet UIButton *viewMoreDetailButton;
	
	NSArray *individualReplies;
	
	IBOutlet UIImageView *downArrow;

	IBOutlet UILabel *pollNumber;
	NSArray *pollArray;              //Array of (Messages)
	int currentPollNumber;
	
	IBOutlet UISegmentedControl *upDown;
	
	NSString *origTeamId;
	
	PollResultsView *myPollResultsView;
	UIView *myLineView;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	NSDictionary *messageThreadInfo;
	
	IBOutlet UIBarButtonItem *deleteButton;
	
	IBOutlet UILabel *errorLabel;
	NSString *errorString;
    
    IBOutlet UIActivityIndicatorView *respondingActivity;
	
}
@property (nonatomic, retain) UIActivityIndicatorView *respondingActivity;

@property (nonatomic, retain)  UILabel *errorLabel;
@property (nonatomic, retain)  NSString *errorString;
@property (nonatomic, retain) UIBarButtonItem *deleteButton;
@property (nonatomic, retain) NSDictionary *messageThreadInfo;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) PollResultsView *myPollResultsView;
@property (nonatomic, retain) UIView *myLineView;
@property (nonatomic, retain) NSString *origTeamId;

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) UILabel *teamNameLabel;

@property int currentPollNumber;
@property (nonatomic, retain) UISegmentedControl *upDown;
@property (nonatomic, retain) NSArray *pollArray;
@property (nonatomic, retain) UILabel *pollNumber;


@property (nonatomic, retain) UIImageView *downArrow;
@property (nonatomic, retain) NSArray *individualReplies;
@property (nonatomic, retain) UIButton *viewMoreDetailButton;
@property (nonatomic, retain) UIScrollView *displayScroll;
@property (nonatomic, retain) UILabel *ownReply;
@property (nonatomic, retain) UITextView *followUpMessage;
@property bool displayResults;
@property (nonatomic, retain) UITextView *finalizedMessage;
@property (nonatomic, retain) UITextView *howToRespondMessage;
@property (nonatomic, retain) NSString *status;
@property BOOL wasViewed;
@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) UILabel *displayFrom;
@property (nonatomic, retain) NSString *threadId;
@property (nonatomic, retain) NSString *finalAnswer;
@property (nonatomic, retain) NSArray *pollChoices;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventType;

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *receivedDate;

@property (nonatomic, retain) UILabel *displaySubject;
@property (nonatomic, retain) UILabel *displayDate;
@property (nonatomic, retain) UITextView *displayBody;

@property (nonatomic, retain) UIButton *buttonOption1;
@property (nonatomic, retain) UIButton *buttonOption2;
@property (nonatomic, retain) UIButton *buttonOption3;
@property (nonatomic, retain) UIButton *buttonOption4;
@property (nonatomic, retain) UIButton *buttonOption5;

-(void)finalReply:(NSString *)reply;
-(void)initPollInfo;

-(IBAction)replyOption1;
-(IBAction)replyOption2;
-(IBAction)replyOption3;
-(IBAction)replyOption4;
-(IBAction)replyOption5;

-(IBAction)deletePoll;

-(IBAction)viewMoreDetail;

-(void)sendPollResponse;


@end
