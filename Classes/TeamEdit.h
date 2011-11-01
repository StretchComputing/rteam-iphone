//
//  TeamEdit.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamEdit : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {
    

}
@property (nonatomic, strong) NSString *theDescription;
@property (nonatomic, strong) NSString *theTeamName;
@property (nonatomic, strong) NSString *theSportLabel;


@property (nonatomic, strong) UIActionSheet *disconnect;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet  UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSDictionary *teamInfo;
@property (nonatomic, strong) IBOutlet UIButton *disconnectTwitterButton;
@property (nonatomic, strong) NSString *twitterUrl;
@property bool updateTwitter;
@property bool twitterUser;
@property (nonatomic, strong) IBOutlet UIButton *connectTwitterButton;
@property (nonatomic, strong) IBOutlet UILabel *connectTwitterLabel;
@property (nonatomic, strong, getter = theNewTeamName) NSString *newTeamName;
@property bool saveSuccess;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UILabel *sportLabel;
@property (nonatomic, strong) IBOutlet UITextView *description;
@property (nonatomic, strong) IBOutlet UITextField *teamName;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIButton *changeSportButton;
@property (nonatomic, strong) IBOutlet UIButton *saveChangesButton;

-(void)getGameInfo;
-(IBAction)changeSport;
-(IBAction)saveChanges;
-(IBAction)endText;
-(IBAction)connectTwitter;
-(IBAction)disconnectTwitter;
@end
