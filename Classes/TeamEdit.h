//
//  TeamEdit.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    
	NSString *teamId;
	NSString *newTeamName;
	IBOutlet UILabel *sportLabel;
	IBOutlet UITextView *description;
	IBOutlet UITextField *teamName;
	IBOutlet UILabel *errorLabel;
	
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIButton *changeSportButton;
	IBOutlet UIButton *saveChangesButton;
	
	bool saveSuccess;
	bool twitterUser;
	bool updateTwitter;
	//Twitter
	IBOutlet UIButton *connectTwitterButton;
	IBOutlet UILabel *connectTwitterLabel;
	NSString *twitterUrl;
	IBOutlet UIButton *disconnectTwitterButton;
	
	NSString *errorString;
	NSDictionary *teamInfo;
	
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	UIActionSheet *disconnect;
}
@property (nonatomic, strong) UIActionSheet *disconnect;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSDictionary *teamInfo;
@property (nonatomic, strong) UIButton *disconnectTwitterButton;
@property (nonatomic, strong) NSString *twitterUrl;
@property bool updateTwitter;
@property bool twitterUser;
@property (nonatomic, strong) UIButton *connectTwitterButton;
@property (nonatomic, strong) UILabel *connectTwitterLabel;
@property (nonatomic, strong, getter = theNewTeamName) NSString *newTeamName;
@property bool saveSuccess;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UILabel *sportLabel;
@property (nonatomic, strong) UITextView *description;
@property (nonatomic, strong) UITextField *teamName;
@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UIButton *changeSportButton;
@property (nonatomic, strong) UIButton *saveChangesButton;

-(void)getGameInfo;
-(IBAction)changeSport;
-(IBAction)saveChanges;
-(IBAction)endText;
-(IBAction)connectTwitter;
-(IBAction)disconnectTwitter;
@end
