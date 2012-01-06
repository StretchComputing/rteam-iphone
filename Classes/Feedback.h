//
//  TeamSettings.h
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface Feedback : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    
    
    bool isRecording;
    
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *sendButton;
    IBOutlet UILabel *errorLabel;
    IBOutlet UILabel *sendLabel;
    
    IBOutlet UILabel *recordingLabel;
    IBOutlet UIActivityIndicatorView *recordingActivity;
    IBOutlet UIActivityIndicatorView *sendingActivity;
    
    
}

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *myPlayer;
@property (nonatomic, strong) NSURL *temporaryRecFile;
@property (nonatomic, strong) IBOutlet UIButton *previewButton;
@property (nonatomic, strong) UILabel *recordingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *recordingActivity;
@property (nonatomic, strong) UIActivityIndicatorView *sendingActivity;

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) NSData *recordedData;
@property (nonatomic, strong) NSString *recordedUserName;
@property (nonatomic, strong) NSDate *recordedDate;
@property (nonatomic, strong) NSString *recordedInstanceUrl;

@property bool isRecording;
-(IBAction)record;
-(IBAction)submit;
-(IBAction)preview;
@end
