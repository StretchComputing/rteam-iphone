//
//  ConfirmPollDetail.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ConfirmPollDetail : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate> {
	
	NSString *memberId;
	NSString *confirmDate;
	NSString *memberName;
	NSString *teamId;
	
	NSString *displayString;
	NSString *phoneNumber;
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *confirmLabel;
	
	IBOutlet UIButton *callTextButton;
	IBOutlet UIButton *markConfirmButton;
	IBOutlet UIButton *sendMessageButton;
	
	IBOutlet UILabel *displayLabel;
	bool messageSent;
	
	UIActionSheet *callTextActionSheet;
	
	NSString *replyString;
	IBOutlet UILabel *replyLabel;
	
	
}
@property (nonatomic, strong) NSString *replyString;
@property (nonatomic, strong) UILabel *replyLabel;

@property (nonatomic, strong) UIActionSheet *callTextActionSheet;
@property (nonatomic, strong) UILabel *displayLabel;
@property bool messageSent;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *displayString;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *confirmDate;
@property (nonatomic, strong) NSString *memberName;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *confirmLabel;

@property (nonatomic, strong) UIButton *callTextButton;
@property (nonatomic, strong) UIButton *markConfirmButton;
@property (nonatomic, strong) UIButton *sendMessageButton;


-(IBAction)sendMessage;
-(IBAction)callText;
-(IBAction)markConfirm;
@end

