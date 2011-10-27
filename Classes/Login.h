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
@property (nonatomic, strong) NSString *startEmail;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIButton *resetPasswordButton;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UILabel *error;
@property (nonatomic, strong) UIActivityIndicatorView *registering;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *success;


@property int numMemberTeams;
@property bool createSuccess;
@property bool invalidEmail;
@property bool serverError;
@property bool isMember;


-(IBAction)submit;
-(IBAction)endText;
-(IBAction)resetPassword;

@end
