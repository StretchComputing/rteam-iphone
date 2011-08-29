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

@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property bool replyAlert;
@property (nonatomic, retain) NSString *origMessageDate;
@property (nonatomic, retain) UILabel *origMessageLabel;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *origMessage;
@property (nonatomic, retain) NSString *replyToName;
@property (nonatomic, retain) NSString *replyToId;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) NSString *errorString;

@property (nonatomic, retain) UILabel *toLabel;
@property (nonatomic, retain) UITextView *newMessageText;
@property (nonatomic, retain) UITextView *oldMessageText;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) UIButton *sendButton;

-(IBAction)send;

@end
