//
//  FinalizePoll.h
//  rTeam
//
//  Created by Nick Wroblewski on 7/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FinalizePoll : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	IBOutlet UITextView *followUpMessage;
	IBOutlet UIButton *confirmButton;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *errorMessage;
	
	NSString *teamId;
	NSString *messageThreadId;
	
	bool createSuccess;
	NSString *errorString;
}

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UITextView *followUpMessage;
@property (nonatomic, retain) UIButton *confirmButton;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *messageThreadId;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *errorMessage;
@property bool createSuccess;

-(IBAction)confirm;
@end
