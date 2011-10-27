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
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *errorString;
@property bool success;
@property (nonatomic, strong) UITextView *questionField;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) UITextView *answerField;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIButton *submitButton;

-(IBAction)submit;
@end
