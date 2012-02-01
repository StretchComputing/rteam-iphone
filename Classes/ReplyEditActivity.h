//
//  ReplyEditActivity.h
//  rTeam
//
//  Created by Nick Wroblewski on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NewActivityDetail.h"

@interface ReplyEditActivity : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NewActivityDetail *displayClass;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *activityId;

@property (nonatomic, strong) NSString *originalMessage;
@property bool isReply;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, strong) IBOutlet UITextView *messageText;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIImageView *messageImage;
@property (nonatomic, strong) IBOutlet UIButton *cancelImageButton;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSData *imageDataToSend;
@property (nonatomic, strong) NSData *videoDataToSend;
@property bool isSendVideo;

@property (nonatomic, strong) NSString *theMessageText;
@property (nonatomic, strong) NSString *sendOrientation;
@property (nonatomic, strong) NSData *previewImageData;
@property bool cancelImageVideo;
@property bool isTakeVideo;
@property (nonatomic, strong) NSString *cameraSaveMessage;

-(IBAction)cancelImage;

-(IBAction)segmentSelect;

@end
