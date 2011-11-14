//
//  ViewPollSent.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewActivity.h"

@interface ViewPollSent : UIViewController <UIActionSheetDelegate>{

	
	
}
@property (nonatomic, strong) NewActivity *fromClass;
@property (nonatomic, strong) IBOutlet  UILabel *errorLabel;
@property (nonatomic, strong)  NSString *errorString;
@property (nonatomic, strong) IBOutlet UILabel *resultsLabel;
@property (nonatomic, strong) NSDictionary *response;
@property (nonatomic, strong) IBOutlet   UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet   UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *origTeamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UILabel *teamNameLabel;
@property int currentPollNumber;
@property (nonatomic, strong) IBOutlet UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *pollArray;
@property (nonatomic, strong) IBOutlet UILabel *pollNumber;


@property (nonatomic, strong) IBOutlet UIImageView *downArrow;
@property (nonatomic, strong) UITextView *followUp;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *viewMoreDetailButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *deletePollButton;
@property (nonatomic, strong) NSString *messageThreadId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *replyFraction;
@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) IBOutlet UILabel *subject;
@property (nonatomic, strong) IBOutlet UILabel *numReply;
@property (nonatomic, strong) IBOutlet UITextView *body;
@property (nonatomic, strong) IBOutlet UILabel *finalizedMessage;

@property (nonatomic, strong) IBOutlet UILabel *option1;
@property (nonatomic, strong) IBOutlet UILabel *option2;
@property (nonatomic, strong) IBOutlet UILabel *option3;
@property (nonatomic, strong) IBOutlet UILabel *option4;
@property (nonatomic, strong) IBOutlet UILabel *option5;

@property (nonatomic, strong) IBOutlet UIButton *finalizeButton;
-(void)initPollInfo;

-(IBAction)viewDetailReplies;
-(IBAction)finalizePoll;
-(IBAction)deletePoll;
@end
