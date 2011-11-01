//
//  ResetPasswordWithQuestion.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResetPasswordWithQuestion : UIViewController <UITextViewDelegate> {
  
}
@property (nonatomic, strong) NSString *theAnswerField;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *errorString;
@property bool success;
@property (nonatomic, strong) IBOutlet UITextView *questionField;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) IBOutlet UITextView *answerField;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;

-(IBAction)submit;
@end
