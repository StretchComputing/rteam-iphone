//
//  ActivityPost.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NewActivity.h"

@interface ActivityPost : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NewActivity *fromClass;

@property (nonatomic, strong) NSData *videoDataToSend;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *sendOrientation;
@property bool isTakeVideo;
@property bool isSendVideo;
@property (nonatomic, strong) IBOutlet UIButton *cancelImageButton;
@property (nonatomic, strong) NSData *imageDataToSend;
@property (nonatomic, strong) NSString *cameraSaveMessage;
@property (nonatomic, strong) IBOutlet UIImageView *previewImage;


@property (nonatomic, strong) NSString *theMessageText;
@property bool keyboardIsUp;
@property (nonatomic, retain) NSMutableArray *selectedTeams;
@property bool savedTeams;
@property bool hasTeams;
@property (nonatomic, retain) NSString *postTeamId;
@property (nonatomic, retain) NSMutableArray *teams;

@property (nonatomic, retain) IBOutlet UIButton *teamSelectButton;
@property (nonatomic, retain) IBOutlet UITextView *messageText;
@property (nonatomic, retain) IBOutlet UIButton *keyboardButton;
@property (nonatomic, retain) IBOutlet UIButton *sendPollButton;
@property (nonatomic, retain) IBOutlet UIButton *sendPrivateButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segControl;

-(IBAction)teamSelect;
-(IBAction)sendPoll;
-(IBAction)privateMessage;
-(IBAction)keyboard;
-(IBAction)cancelImage;
-(IBAction)segmentSelect;
@end
