//
//  CoachRegister.h
//  iCoach
//
//  Created by Nick Wroblewski on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface Register : UIViewController {
	
	IBOutlet UITextField *email;
	IBOutlet UITextField *password;
	IBOutlet UILabel *error;
	IBOutlet UILabel *success;
	IBOutlet UIActivityIndicatorView *registering;
	IBOutlet UIButton *submitButton;
	IBOutlet UIScrollView *helpScreen;
	IBOutlet UITextField *confirmEmail;
	IBOutlet UIButton *memberLogin;
	IBOutlet UIButton *closeButton;
	
	UIBarButtonItem *barItem;
	
	int numMemberTeams;
	bool createSuccess;
	bool invalidEmail;
	bool serverError;
	bool isMember;
	bool isHelpOpen;
	
	NSString *firstName;
	NSString *lastName;

	IBOutlet UIButton *watchVideoButton;
	
	NSString *errorString;
	
	IBOutlet UIView *middleView;
	IBOutlet UIButton *loginButton;
	
}
@property (nonatomic, retain) UIView *middleView;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UIButton *watchVideoButton;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UITextField *confirmEmail;
@property (nonatomic, retain) UIButton *memberLogin;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) UIActivityIndicatorView *registering;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *success;
@property (nonatomic, retain) UIScrollView *helpScreen;

@property (nonatomic, retain) UIBarButtonItem *barItem;

@property int numMemberTeams;
@property bool createSuccess;
@property bool invalidEmail;
@property bool serverError;
@property bool isMember;
@property bool isHelpOpen;

-(IBAction)memberLoginAction;
-(IBAction)submit;
-(IBAction)closeHelp;
-(IBAction)endText;
-(IBAction)watchVideo;

@end
