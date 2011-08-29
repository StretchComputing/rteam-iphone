//
//  ResetPasswordWithQuestion.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResetPasswordWithQuestion : UIViewController <UITextViewDelegate> {

	NSString *question;
	IBOutlet UITextView *answerField;
	IBOutlet UITextView *questionField;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *errorLabel;
	IBOutlet UIButton *submitButton;
	
	NSString *email;
	bool success;
	NSString *errorString;
}
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *errorString;
@property bool success;
@property (nonatomic, retain) UITextView *questionField;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) UITextView *answerField;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIButton *submitButton;

-(IBAction)submit;
@end
