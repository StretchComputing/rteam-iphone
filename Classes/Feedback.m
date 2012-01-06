//
//  TeamSettings.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Feedback.h"
#import "GoogleAppEngine.h"
#import "rTeamAppDelegate.h"
#import "TraceSession.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GANTracker.h"

@implementation Feedback
@synthesize isRecording, recordButton, sendLabel, sendButton, errorLabel, recordedData, recordingLabel, recordingActivity, sendingActivity, recordedDate, recordedUserName, recordedInstanceUrl, previewButton, temporaryRecFile, myPlayer, recorder;

- (void)viewDidLoad
{
    
    [TraceSession addEventToSession:@"Audio Feedback - Page Loaded"];
    
    self.title = @"Feedback";
    
    self.recordingLabel.hidden = YES;
    self.recordingActivity.hidden = YES;
    
    
    self.sendLabel.hidden = YES;
    self.sendButton.hidden = YES;
    self.errorLabel.hidden = YES;
    self.previewButton.hidden = YES;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.previewButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.previewButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    
    
    [super viewDidLoad];
    
    
    
    
}


-(void)record{
    
    [TraceSession addEventToSession:@"Feedback - Record Button Selected"];
    
    self.errorLabel.text = @"";
    if (isRecording) {
        isRecording = false;
        
        [self.navigationItem setHidesBackButton:NO];
        
        self.recordingActivity.hidden = YES;
        self.recordingLabel.hidden = YES;
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [self.recorder stop];
        
        self.recordedData = [[NSData alloc] initWithContentsOfURL:self.temporaryRecFile];
        
        self.errorLabel.hidden = NO;
        if ([recordedData length] > 0) {
            self.sendLabel.hidden = NO;
            self.sendButton.hidden = NO;
            //self.previewButton.hidden = NO;
            self.errorLabel.text = @"*Recording Successful!";
            self.errorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        }else{
            self.errorLabel.textColor = [UIColor redColor];
            self.errorLabel.text = @"*Recording failed...";
        }
        
    }else{
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        [session setActive:YES error:nil];
        
        isRecording = true;
        [self.navigationItem setHidesBackButton:YES];
        self.recordingLabel.hidden = NO;
        self.recordingActivity.hidden = NO;
        self.sendLabel.hidden = YES;
        self.sendButton.hidden = YES;
        self.previewButton.hidden = YES;
        self.errorLabel.hidden = YES;
        
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.temporaryRecFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithString:@"VoiceFile1.mp4"]]];
        
        NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                                        [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                        [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                        [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,
                                        nil];
        
        
        
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.temporaryRecFile settings:recordSettings error:nil];
        [self.recorder setDelegate:self];
        [self.recorder prepareToRecord];
        [self.recorder record];
        
        
    }
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    
}

-(void)submit{
    
    [TraceSession addEventToSession:@"Audio Feedback - Submit Button Selected"];
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Audio Feedback Sent"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    // send recorded feedback to GAE
    self.sendButton.hidden = YES;
    [self.sendingActivity startAnimating];
    self.recordButton.enabled = NO;
    self.recordedDate = [NSDate date];
    self.recordedUserName = mainDelegate.displayName;
    [self performSelectorInBackground:@selector(sendResults) withObject:nil];
    
}

-(void)sendResults{
    
    @autoreleasepool {
        [GoogleAppEngine sendFeedback:self.recordedData theRecordedDate:self.recordedDate theRecordedUserName:self.recordedUserName theInstanceUrl:self.recordedInstanceUrl];
        
        [self performSelectorOnMainThread:@selector(doneResults) withObject:nil waitUntilDone:NO];
    }
    
    
}

-(void)doneResults{
    
    self.recordButton.enabled = YES;
    self.previewButton.hidden = YES;
    [self.sendingActivity stopAnimating];
    self.sendLabel.hidden = YES;
    self.errorLabel.text = @"Feedback Sent!";
    self.errorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
    
}

-(void)preview{
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [TraceSession addEventToSession:@"Audio Feedback - Preview Button Selected"];
    
    
    NSError* error = nil;
    AVAudioPlayer *newAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:self.temporaryRecFile error:&error];
    newAudio.delegate = self;
    //self.myPlayer = [[AVAudioPlayer alloc] initWithData:self.recordedData error:&error];
    
    
    
    [newAudio prepareToPlay];
    
    // set it up and play
    [newAudio setNumberOfLoops:0];
    [newAudio setVolume: 1.0];
    [newAudio play];
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    
}

- (void)viewDidUnload
{
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtURL:self.temporaryRecFile error:nil];
    
    sendLabel = nil;
    sendButton = nil;
    recordButton = nil;
    errorLabel = nil;
    recordingLabel = nil;
    recordingActivity = nil;
    sendingActivity = nil;
    previewButton = nil;
    [super viewDidUnload];
    
}


@end
