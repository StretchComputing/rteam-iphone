//
//  ChangePassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChangePassword : UIViewController {

	IBOutlet UIButton *submitButton;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UITextField *password;
	IBOutlet UITextField *confirmPassword;
	IBOutlet UILabel *error;
	
	bool changeSuccess;
	NSString *errorString;
}
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITextField *confirmPassword;
@property (nonatomic, retain) UILabel *error;

@property bool changeSuccess;

-(IBAction)submit;
-(IBAction)endText;
@end
