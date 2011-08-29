//
//  Login.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Login : UIViewController {
	
	IBOutlet UITextField *email;
	IBOutlet UITextField *password;
	IBOutlet UILabel *error;
	IBOutlet UILabel *success;
	IBOutlet UIActivityIndicatorView *registering;
	IBOutlet UIButton *submitButton;
	IBOutlet UIButton *resetPasswordButton;
	
	
	int numMemberTeams;
	bool createSuccess;
	bool invalidEmail;
	bool serverError;
	bool isMember;
	NSString *errorString;
	
	NSString *startEmail;
	
}
@property (nonatomic, retain) NSString *startEmail;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIButton *resetPasswordButton;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) UIActivityIndicatorView *registering;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *success;


@property int numMemberTeams;
@property bool createSuccess;
@property bool invalidEmail;
@property bool serverError;
@property bool isMember;


-(IBAction)submit;
-(IBAction)endText;
-(IBAction)resetPassword;

@end
