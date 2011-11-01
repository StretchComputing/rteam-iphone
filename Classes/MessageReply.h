//
//  MessageReply.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageReply : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

}
@property (nonatomic, retain) NSString *theNewMessage;
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property bool replyAlert;
@property (nonatomic, strong) NSString *origMessageDate;
@property (nonatomic, strong) IBOutlet UILabel *origMessageLabel;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *origMessage;
@property (nonatomic, strong) NSString *replyToName;
@property (nonatomic, strong) NSString *replyToId;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *errorString;

@property (nonatomic, strong) IBOutlet UILabel *toLabel;
@property (nonatomic, strong, getter = theNewMessageText) IBOutlet UITextView *newMessageText;
@property (nonatomic, strong) IBOutlet UITextView *oldMessageText;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) IBOutlet UIButton *sendButton;

-(IBAction)send;

@end
