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

	
	
}
@property (nonatomic, strong) UIActionSheet *callTextActionSheet;
@property (nonatomic, strong) IBOutlet UILabel *displayLabel;
@property bool messageSent;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *displayString;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *confirmDate;
@property (nonatomic, strong) NSString *memberName;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *confirmLabel;

@property (nonatomic, strong) IBOutlet UIButton *callTextButton;
@property (nonatomic, strong) IBOutlet UIButton *markConfirmButton;
@property (nonatomic, strong) IBOutlet UIButton *sendMessageButton;


-(IBAction)sendMessage;
-(IBAction)callText;
-(IBAction)markConfirm;
@end
