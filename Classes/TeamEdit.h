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
@property (nonatomic, retain) UIActionSheet *disconnect;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSDictionary *teamInfo;
@property (nonatomic, retain) UIButton *disconnectTwitterButton;
@property (nonatomic, retain) NSString *twitterUrl;
@property bool updateTwitter;
@property bool twitterUser;
@property (nonatomic, retain) UIButton *connectTwitterButton;
@property (nonatomic, retain) UILabel *connectTwitterLabel;
@property (nonatomic, retain) NSString *newTeamName;
@property bool saveSuccess;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UILabel *sportLabel;
@property (nonatomic, retain) UITextView *description;
@property (nonatomic, retain) UITextField *teamName;
@property (nonatomic, retain) UILabel *errorLabel;

@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UIButton *changeSportButton;
@property (nonatomic, retain) UIButton *saveChangesButton;

-(void)getGameInfo;
-(IBAction)changeSport;
-(IBAction)saveChanges;
-(IBAction)endText;
-(IBAction)connectTwitter;
-(IBAction)disconnectTwitter;
@end
