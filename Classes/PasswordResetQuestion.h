//
//  PasswordResetQuestion.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasswordResetQuestion : UIViewController <UITextViewDelegate> {

}
@property (nonatomic, strong, getter = theNewQuestionString) NSString *newQuestionString;
@property (nonatomic, strong, getter = theNewAnswerString) NSString *newAnswerString;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong, getter = theNewQuestion) IBOutlet UITextView *newQuestion;
@property (nonatomic, strong, getter = theNewAnswer) IBOutlet UITextField *newAnswer;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;

-(IBAction)submit;
-(IBAction)endText;
@end
