//
//  RegisterInvalidPassword.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RegisterInvalidPassword : UIViewController {
	
	IBOutlet UITextField *email;
	IBOutlet UITextField *password;
	IBOutlet UILabel *error;
	IBOutlet UIActivityIndicatorView *registering;
	IBOutlet UIButton *submitButton;
	IBOutlet UIButton *resetButton;
	
	NSString *sameEmail;
	
	bool createSuccess;
	bool invalidEmail;
	bool serverError;
	bool isMember;
	
}

@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) UIActivityIndicatorView *registering;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UIButton *resetButton;

@property (nonatomic, retain) NSString *sameEmail;

@property bool createSuccess;
@property bool invalidEmail;
@property bool serverError;
@property bool isMember;

-(IBAction)submit;
-(IBAction)endText;
-(IBAction)reset;

@end
