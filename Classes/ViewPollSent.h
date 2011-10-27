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
@property (nonatomic, strong)  UILabel *errorLabel;
@property (nonatomic, strong)  NSString *errorString;
@property (nonatomic, strong) UILabel *resultsLabel;
@property (nonatomic, strong) NSDictionary *response;
@property (nonatomic, strong)  UILabel *loadingLabel;
@property (nonatomic, strong)  UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *origTeamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UILabel *teamNameLabel;
@property int currentPollNumber;
@property (nonatomic, strong) UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *pollArray;
@property (nonatomic, strong) UILabel *pollNumber;


@property (nonatomic, strong) UIImageView *downArrow;
@property (nonatomic, strong) UITextView *followUp;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *viewMoreDetailButton;
@property (nonatomic, strong) UIBarButtonItem *deletePollButton;
@property (nonatomic, strong) NSString *messageThreadId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *replyFraction;
@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) UILabel *subject;
@property (nonatomic, strong) UILabel *numReply;
@property (nonatomic, strong) UITextView *body;
@property (nonatomic, strong) UILabel *finalizedMessage;

@property (nonatomic, strong) UILabel *option1;
@property (nonatomic, strong) UILabel *option2;
@property (nonatomic, strong) UILabel *option3;
@property (nonatomic, strong) UILabel *option4;
@property (nonatomic, strong) UILabel *option5;

@property (nonatomic, strong) UIButton *finalizeButton;
-(void)initPollInfo;

-(IBAction)viewDetailReplies;
-(IBAction)finalizePoll;
-(IBAction)deletePoll;
@end
