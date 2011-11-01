//
//  Login.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Login : UIViewController {
	
	
}
@property (nonatomic, strong) NSString *theEmail;
@property (nonatomic, strong) NSString *thePassword;

@property (nonatomic, strong) NSString *startEmail;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIButton *resetPasswordButton;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *registering;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *success;


@property int numMemberTeams;
@property bool createSuccess;
@property bool invalidEmail;
@property bool serverError;
@property bool isMember;


-(IBAction)submit;
-(IBAction)endText;
-(IBAction)resetPassword;

@end
