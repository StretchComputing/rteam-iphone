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
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong, getter = theNewQuestion) UITextView *newQuestion;
@property (nonatomic, strong, getter = theNewAnswer) UITextField *newAnswer;
@property (nonatomic, strong) UIButton *submitButton;

-(IBAction)submit;
-(IBAction)endText;
@end
