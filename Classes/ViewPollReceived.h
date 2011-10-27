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
@property (nonatomic, strong) UIActivityIndicatorView *respondingActivity;

@property (nonatomic, strong)  UILabel *errorLabel;
@property (nonatomic, strong)  NSString *errorString;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;
@property (nonatomic, strong) NSDictionary *messageThreadInfo;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) PollResultsView *myPollResultsView;
@property (nonatomic, strong) UIView *myLineView;
@property (nonatomic, strong) NSString *origTeamId;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UILabel *teamNameLabel;

@property int currentPollNumber;
@property (nonatomic, strong) UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *pollArray;
@property (nonatomic, strong) UILabel *pollNumber;


@property (nonatomic, strong) UIImageView *downArrow;
@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) UIButton *viewMoreDetailButton;
@property (nonatomic, strong) UIScrollView *displayScroll;
@property (nonatomic, strong) UILabel *ownReply;
@property (nonatomic, strong) UITextView *followUpMessage;
@property bool displayResults;
@property (nonatomic, strong) UITextView *finalizedMessage;
@property (nonatomic, strong) UITextView *howToRespondMessage;
@property (nonatomic, strong) NSString *status;
@property BOOL wasViewed;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) UILabel *displayFrom;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *finalAnswer;
@property (nonatomic, strong) NSArray *pollChoices;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *receivedDate;

@property (nonatomic, strong) UILabel *displaySubject;
@property (nonatomic, strong) UILabel *displayDate;
@property (nonatomic, strong) UITextView *displayBody;

@property (nonatomic, strong) UIButton *buttonOption1;
@property (nonatomic, strong) UIButton *buttonOption2;
@property (nonatomic, strong) UIButton *buttonOption3;
@property (nonatomic, strong) UIButton *buttonOption4;
@property (nonatomic, strong) UIButton *buttonOption5;

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
