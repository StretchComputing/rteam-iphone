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
	
}
@property (nonatomic, strong) NSString *theEmail;
@property (nonatomic, strong) NSString *thePassword;
@property (nonatomic, strong) IBOutlet UIView *middleView;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UIButton *watchVideoButton;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UITextField *confirmEmail;
@property (nonatomic, strong) IBOutlet UIButton *memberLogin;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *registering;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *success;
@property (nonatomic, strong) IBOutlet UIScrollView *helpScreen;

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
