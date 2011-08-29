//
//  ConfirmMessageDetail.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ConfirmMessageDetail : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate> {

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
	
	
}
@property (nonatomic, retain) UIActionSheet *callTextActionSheet;
@property (nonatomic, retain) UILabel *displayLabel;
@property bool messageSent;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *displayString;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *memberId;
@property (nonatomic, retain) NSString *confirmDate;
@property (nonatomic, retain) NSString *memberName;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *confirmLabel;

@property (nonatomic, retain) UIButton *callTextButton;
@property (nonatomic, retain) UIButton *markConfirmButton;
@property (nonatomic, retain) UIButton *sendMessageButton;


-(IBAction)sendMessage;
-(IBAction)callText;
-(IBAction)markConfirm;
@end
