//
//  MessageReply.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageReply : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    
	NSString *teamId;
	NSString *subject;
	NSString *origMessage;
	NSString *replyToName;
	NSString *replyToId;
	NSString *userRole;
	NSString *errorString;
	NSString *origMessageDate;
	
	IBOutlet UILabel *origMessageLabel;
	IBOutlet UILabel *toLabel;
	IBOutlet UITextView *newMessageText;
	IBOutlet UITextView *oldMessageText;
	IBOutlet UILabel *errorLabel;
	IBOutlet UIActivityIndicatorView *activity;
	
	IBOutlet UIButton *sendButton;
    
    bool replyAlert;
    
    UIToolbar *keyboardToolbar;
}

@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property bool replyAlert;
@property (nonatomic, strong) NSString *origMessageDate;
@property (nonatomic, strong) UILabel *origMessageLabel;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *origMessage;
@property (nonatomic, strong) NSString *replyToName;
@property (nonatomic, strong) NSString *replyToId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *errorString;

@property (nonatomic, strong) UILabel *toLabel;
@property (nonatomic, strong, getter = theNewMessageText) UITextView *newMessageText;
@property (nonatomic, strong) UITextView *oldMessageText;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UIButton *sendButton;

-(IBAction)send;

@end
