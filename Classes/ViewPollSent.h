//
//  ViewPollSent.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewPollSent : UIViewController <UIActionSheetDelegate>{

	NSString *messageThreadId;
	NSString *teamId;
	NSString *replyFraction;
	NSString *status;
	
	NSArray *individualReplies;
	
	IBOutlet UILabel *subject;
	IBOutlet UITextView *body;
	IBOutlet UILabel *numReply;
	IBOutlet UILabel *finalizedMessage;
	
	IBOutlet UILabel *option1;
	IBOutlet UILabel *option2;
	IBOutlet UILabel *option3;
	IBOutlet UILabel *option4;
	IBOutlet UILabel *option5;
	
	IBOutlet UIButton *finalizeButton;
	IBOutlet UIButton *viewMoreDetailButton;
	
	IBOutlet UIBarButtonItem *deletePollButton;
	
	IBOutlet UIScrollView *scrollView;
	
	UITextView *followUp;
	
	IBOutlet UIImageView *downArrow;
	
	
	IBOutlet UILabel *pollNumber;
	NSArray *pollArray;              //Array of (Messages)
	int currentPollNumber;
	IBOutlet UISegmentedControl *upDown;
	NSString *teamName;
	IBOutlet UILabel *teamNameLabel;
	
	NSString *origTeamId;
	
	NSDictionary *response;
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	IBOutlet UILabel *resultsLabel;
	
	IBOutlet UILabel *errorLabel;
	NSString *errorString;
	
	
}
@property (nonatomic, retain)  UILabel *errorLabel;
@property (nonatomic, retain)  NSString *errorString;
@property (nonatomic, retain) UILabel *resultsLabel;
@property (nonatomic, retain) NSDictionary *response;
@property (nonatomic, retain)  UILabel *loadingLabel;
@property (nonatomic, retain)  UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) NSString *origTeamId;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) UILabel *teamNameLabel;
@property int currentPollNumber;
@property (nonatomic, retain) UISegmentedControl *upDown;
@property (nonatomic, retain) NSArray *pollArray;
@property (nonatomic, retain) UILabel *pollNumber;


@property (nonatomic, retain) UIImageView *downArrow;
@property (nonatomic, retain) UITextView *followUp;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *viewMoreDetailButton;
@property (nonatomic, retain) UIBarButtonItem *deletePollButton;
@property (nonatomic, retain) NSString *messageThreadId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *replyFraction;
@property (nonatomic, retain) NSArray *individualReplies;
@property (nonatomic, retain) NSString *status;

@property (nonatomic, retain) UILabel *subject;
@property (nonatomic, retain) UILabel *numReply;
@property (nonatomic, retain) UITextView *body;
@property (nonatomic, retain) UILabel *finalizedMessage;

@property (nonatomic, retain) UILabel *option1;
@property (nonatomic, retain) UILabel *option2;
@property (nonatomic, retain) UILabel *option3;
@property (nonatomic, retain) UILabel *option4;
@property (nonatomic, retain) UILabel *option5;

@property (nonatomic, retain) UIButton *finalizeButton;
-(void)initPollInfo;

-(IBAction)viewDetailReplies;
-(IBAction)finalizePoll;
-(IBAction)deletePoll;
@end
