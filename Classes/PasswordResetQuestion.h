//
//  PasswordResetQuestion.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasswordResetQuestion : UIViewController <UITextViewDelegate> {

	NSString *question;
	
	IBOutlet UITextView *newQuestion;
	IBOutlet UITextField *newAnswer;
	IBOutlet UIButton *submitButton;
	IBOutlet UILabel *errorLabel;
    IBOutlet UIActivityIndicatorView *activity;
	
    NSString *errorString;
}
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) UITextView *newQuestion;
@property (nonatomic, retain) UITextField *newAnswer;
@property (nonatomic, retain) UIButton *submitButton;

-(IBAction)submit;
-(IBAction)endText;
@end
