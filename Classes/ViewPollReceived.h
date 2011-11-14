//
//  ViewPollReceived.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PollResultsView.h"
#import "NewActivity.h"

@interface ViewPollReceived : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	
}
@property (nonatomic, strong) NewActivity *fromClass;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *respondingActivity;

@property (nonatomic, strong)  IBOutlet UILabel *errorLabel;
@property (nonatomic, strong)  NSString *errorString;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, strong) NSDictionary *messageThreadInfo;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) PollResultsView *myPollResultsView;
@property (nonatomic, strong) IBOutlet UIView *myLineView;
@property (nonatomic, strong) NSString *origTeamId;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UILabel *teamNameLabel;

@property int currentPollNumber;
@property (nonatomic, strong) IBOutlet UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *pollArray;
@property (nonatomic, strong) IBOutlet UILabel *pollNumber;


@property (nonatomic, strong) IBOutlet UIImageView *downArrow;
@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) IBOutlet UIButton *viewMoreDetailButton;
@property (nonatomic, strong) IBOutlet UIScrollView *displayScroll;
@property (nonatomic, strong) IBOutlet UILabel *ownReply;
@property (nonatomic, strong) IBOutlet UITextView *followUpMessage;
@property bool displayResults;
@property (nonatomic, strong) IBOutlet UITextView *finalizedMessage;
@property (nonatomic, strong) IBOutlet UITextView *howToRespondMessage;
@property (nonatomic, strong) NSString *status;
@property BOOL wasViewed;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) IBOutlet UILabel *displayFrom;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *finalAnswer;
@property (nonatomic, strong) NSArray *pollChoices;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *receivedDate;

@property (nonatomic, strong) IBOutlet UILabel *displaySubject;
@property (nonatomic, strong) IBOutlet UILabel *displayDate;
@property (nonatomic, strong) IBOutlet UITextView *displayBody;

@property (nonatomic, strong) IBOutlet UIButton *buttonOption1;
@property (nonatomic, strong) IBOutlet UIButton *buttonOption2;
@property (nonatomic, strong) IBOutlet UIButton *buttonOption3;
@property (nonatomic, strong) IBOutlet UIButton *buttonOption4;
@property (nonatomic, strong) IBOutlet UIButton *buttonOption5;

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
