//
//  SendPrivateMessage.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPrivateMessage : UIViewController <UITextViewDelegate>

@property bool isConfirm;
@property bool isReply;
@property (nonatomic, strong) IBOutlet UILabel *descripLabel;
@property (nonatomic, strong) NSString *theMessageText;
@property bool keyboardIsUp;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong) NSArray *recipientObjects;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *teamId;

@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UILabel *recipLabel;
@property (nonatomic, strong) IBOutlet UIButton *cancelMessageButton;
@property (nonatomic, strong) IBOutlet UITextView *messageText;
@property (nonatomic, strong) IBOutlet UIButton *keyboardButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;


-(IBAction)cancelMessage;
-(IBAction)keyboard;
@end
