//
//  SendPrivateMessage.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPrivateMessage : UIViewController <UITextViewDelegate>

@property bool keyboardIsUp;
@property (nonatomic, retain) NSMutableArray *recipients;
@property (nonatomic, retain) NSArray *recipientObjects;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *teamId;

@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) IBOutlet UILabel *recipLabel;
@property (nonatomic, retain) IBOutlet UIButton *cancelMessageButton;
@property (nonatomic, retain) IBOutlet UITextView *messageText;
@property (nonatomic, retain) IBOutlet UIButton *keyboardButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;


-(IBAction)cancelMessage;
-(IBAction)keyboard;
@end
