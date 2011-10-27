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
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIButton *watchVideoButton;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextField *confirmEmail;
@property (nonatomic, strong) UIButton *memberLogin;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UILabel *error;
@property (nonatomic, strong) UIActivityIndicatorView *registering;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *success;
@property (nonatomic, strong) UIScrollView *helpScreen;

@property (nonatomic, strong) UIBarButtonItem *barItem;

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
