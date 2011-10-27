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

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UITextView *followUpMessage;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *messageThreadId;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *errorMessage;
@property bool createSuccess;

-(IBAction)confirm;
@end
