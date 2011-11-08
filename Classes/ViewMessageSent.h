//
//  ViewMessagesSent.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewMessageSent : UIViewController <UIActionSheetDelegate>{

}
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *errorString;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *deleteButton;

@property (nonatomic, strong) NSDictionary *messageInfo;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *origTeamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UILabel *teamNameLabel;
@property int currentMessageNumber;
@property (nonatomic, strong) IBOutlet UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, strong) IBOutlet UILabel *messageNumber;


@property (nonatomic, strong) IBOutlet UIButton *viewMoreDetailButton;
@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) NSString *threadId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *eventType;

@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *createdDate;

@property (nonatomic, strong) IBOutlet UILabel *displaySubject;
@property (nonatomic, strong) IBOutlet UILabel *displayDate;
@property (nonatomic, strong) IBOutlet UITextView *displayBody;
@property (nonatomic, strong) IBOutlet UILabel *recipients;
@property (nonatomic, strong) NSString *confirmString;
@property (nonatomic, strong) IBOutlet UILabel *confirmStringLabel;

-(void)initMessageInfo;

-(IBAction)deleteMessage;
-(IBAction)ViewDetailMessageReplies;
-(NSString *)getDateLabel:(NSString *)dateCreated;

@end
