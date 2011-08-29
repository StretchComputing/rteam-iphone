//
//  ResetPassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResetPassword : UIViewController {

	IBOutlet UITextField *email;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *error;
	IBOutlet UIButton *resetButton;
	
	bool hasQuestion;
	bool success;
	
	NSString *question;
	NSString *errorString;
}
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *question;
@property bool success;
@property bool hasQuestion;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) UIButton *resetButton;

-(IBAction)reset;
-(IBAction)endText;
@end
