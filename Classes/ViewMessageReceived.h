//
//  ViewMessageReceived.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewMessageReceived : UIViewController <UIActionSheetDelegate> {

    
}
@property bool isAlert;
@property (nonatomic, strong) NSString *origTeamId;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property int currentMessageNumber;
@property (nonatomic, strong) IBOutlet UISegmentedControl *upDown;
@property (nonatomic, strong) NSArray *messageArray;
@property (nonatomic, strong) IBOutlet UILabel *messageNumber;

@property (nonatomic, strong) NSArray *individualReplies;
@property (nonatomic, strong) NSString *confirmStatus;
@property (nonatomic, strong) IBOutlet UIButton *viewMoreDetailButton;
@property (nonatomic, strong) IBOutlet UILabel *confirmationsLabel;
@property bool replySuccess;
@property (nonatomic, strong) IBOutlet UILabel *replyMessage;
@property (nonatomic, strong) IBOutlet UIToolbar *myToolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *replyButton;
@property (nonatomic, strong) IBOutlet UILabel *displaySender;
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

@property (nonatomic, strong) IBOutlet UILabel *displaySubject;
@property (nonatomic, strong) IBOutlet UILabel *displayDate;
@property (nonatomic, strong) IBOutlet UITextView *displayBody;
@property BOOL wasViewed;

-(void)initMessageInfo;

-(IBAction)reply;
-(IBAction)deleteMessage;
-(IBAction)viewMoreDetail;
-(NSString *)getDateLabel:(NSString *)dateCreated;

@end
