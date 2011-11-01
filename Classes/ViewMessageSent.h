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
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) NSString *errorString;

@property (nonatomic, strong) UIBarButtonItem *deleteButton;

@property (nonatomic, strong) NSDictionary *messageInfo;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *origTeamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UILabel *teamNameLabel;
@property int currentMessageNumber;
@property (nonatomic, strong) UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, strong) UILabel *messageNumber;


@property (nonatomic, strong) UIButton *viewMoreDetailButton;
@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *createdDate;

@property (nonatomic, strong) UILabel *displaySubject;
@property (nonatomic, strong) UILabel *displayDate;
@property (nonatomic, strong) UITextView *displayBody;
@property (nonatomic, strong) UILabel *recipients;
@property (nonatomic, strong) NSString *confirmString;
@property (nonatomic, strong) UILabel *confirmStringLabel;

-(void)initMessageInfo;

-(IBAction)deleteMessage;
-(IBAction)ViewDetailMessageReplies;
-(NSString *)getDateLabel:(NSString *)dateCreated;

@end
