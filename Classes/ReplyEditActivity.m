//
//  ReplyEditActivity.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReplyEditActivity.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h> 
#import "GANTracker.h"
#import "TraceSession.h"

@implementation ReplyEditActivity
@synthesize segControl, messageText, activity, messageImage, cancelImageButton, errorLabel, isReply, originalMessage, errorString, imageDataToSend, videoDataToSend, isSendVideo, teamId, activityId, theMessageText, sendOrientation, previewImageData, cancelImageVideo, isTakeVideo, cameraSaveMessage, displayClass;


-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"ReplyEditActivity - View Will Appear"];

    if ([self.previewImageData length] > 0) {
        self.cancelImageButton.hidden = NO;
        
        self.messageImage.image = [UIImage imageWithData:self.previewImageData];
        
    }else{
        self.cancelImageButton.hidden = YES;
    }
}
-(void)viewDidLoad{
    
    
    [self.messageText becomeFirstResponder];
    
    NSString *actionTitle = @"";
    if (self.isReply) {
        self.title = @"Reply";
        actionTitle = @"Send";
    }else{
        self.title = @"Edit Activity";
        actionTitle = @"Post";
        self.messageText.text = [NSString stringWithString:self.originalMessage];
    }
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	[self.navigationItem setLeftBarButtonItem:addButton];
    
    

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:actionTitle style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
	[self.navigationItem setRightBarButtonItem:saveButton];
}


-(void)cancelImage{
    
    self.cancelImageVideo = true;
    
    self.cancelImageButton.hidden = YES;
    self.previewImageData = [NSData data];
    self.imageDataToSend = [NSData data];
    self.videoDataToSend = [NSData data];
    self.messageImage.hidden = YES;
}

-(void)cancel{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)submit{
    
    self.errorLabel.text = @"";
    
    if ((self.messageText.text != nil) && ![self.messageText.text isEqualToString:@""]) {
        
        [self.activity startAnimating];
        self.theMessageText = self.messageText.text;
        
        if (self.isReply) {
            
            [self performSelectorInBackground:@selector(replyToActivity) withObject:nil];
        }else{
            
            [self performSelectorInBackground:@selector(editActivity) withObject:nil];

        }
        
    }else{
        
        self.errorLabel.text = @"*Message cannot be blank";
    }
    
   
}


-(void)editActivity{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSData *tmpData = [NSData data];
        NSData *tmpMovieData = [NSData data];
        
        if (self.isSendVideo) {
            tmpMovieData = [NSData dataWithData:self.videoDataToSend];
        }
        tmpData = [NSData dataWithData:self.imageDataToSend];
        
        NSString *sendString = @"false";
        
        if (self.cancelImageVideo) {
            sendString = @"true";
        }
        
        if (self.sendOrientation == nil) {
            self.sendOrientation = @"";
        }

        NSDictionary *response = [ServerAPI updateActivity:mainDelegate.token teamId:self.teamId activityId:self.activityId likeDislike:@"" statusUpdate:self.theMessageText photo:tmpData video:tmpMovieData orientation:self.sendOrientation cancelAttachment:sendString];
        
        
        
        NSString *status = [response valueForKey:@"status"];
        
        
        if ([status isEqualToString:@"100"]){
            
            self.errorString=@"";
            
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            //[self.errorLabel setHidden:NO];
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                case 208:
                    self.errorString = @"NA";
                    break;
                default:
                    //log status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(donePost) withObject:nil waitUntilDone:NO];
        
    }
    
    
}

-(void)donePost{
    
    [self.activity stopAnimating];
    [self.segControl setEnabled:YES];
    
    if ([self.errorString isEqualToString:@""]) {
                
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Edit Activity"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
                
        [mainDelegate.replyDictionary setValue:nil forKey:self.activityId];
        [mainDelegate.messageImageDictionary setValue:nil forKey:self.activityId];
        
        self.displayClass.displayMessage = self.theMessageText;
        self.displayClass.fromReplyEdit = @"true";
        
        if ([self.videoDataToSend length] > 0) {
            
            self.displayClass.isVideo = true;
            self.displayClass.postImageArray = [NSMutableArray arrayWithObject:self.imageDataToSend];
            
        }else if ([self.imageDataToSend length] > 0){
            
            self.displayClass.isVideo = false;
            self.displayClass.postImageArray = [NSMutableArray arrayWithObject:self.imageDataToSend];
        }else{
            self.displayClass.postImageArray = [NSMutableArray array];
        }
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
    }else{
    
        self.errorLabel.text = self.errorString;
        
    }
}


-(void)replyToActivity{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSData *tmpData = [NSData data];
        NSData *tmpMovieData = [NSData data];
        
        if (self.isSendVideo) {
            tmpMovieData = [NSData dataWithData:self.videoDataToSend];
        }
        tmpData = [NSData dataWithData:self.imageDataToSend];
        
        NSString *sendString = @"false";
        
        if (self.cancelImageVideo) {
            sendString = @"true";
        }
        
        if (self.sendOrientation == nil) {
            self.sendOrientation = @"";
        }
        
        
        NSDictionary *response = [ServerAPI createActivity:mainDelegate.token teamId:self.teamId statusUpdate:self.theMessageText photo:tmpData video:tmpMovieData orientation:self.sendOrientation replyToId:self.activityId eventId:@"" newGame:@""];
        
        NSString *status = [response valueForKey:@"status"];
        
        
        if ([status isEqualToString:@"100"]){
            
            self.errorString=@"";
            
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            //[self.errorLabel setHidden:NO];
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                case 208:
                    self.errorString = @"NA";
                    break;
                default:
                    //log status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneReply) withObject:nil waitUntilDone:NO];
        
    }
    
    
}

-(void)doneReply{
    
    [self.activity stopAnimating];
    [self.segControl setEnabled:YES];
    
    if ([self.errorString isEqualToString:@""]) {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Reply To Activity"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        
        [mainDelegate.replyDictionary setValue:nil forKey:self.activityId];
        [mainDelegate.messageImageDictionary setValue:nil forKey:self.activityId];
        
        //self.displayClass.displayMessage = self.theMessageText;
        self.displayClass.fromReplyEdit = @"true";
        
       
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
    }else{
        
        self.errorLabel.text = self.errorString;
        
    }
}


-(void)segmentSelect{
    
    if (self.segControl.selectedSegmentIndex == 2) {
        
        
        self.isTakeVideo = true;
        
        [self performSelector:@selector(selectVideo) withObject:nil afterDelay:0.2];
        
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.2];
        
        
    }else if (self.segControl.selectedSegmentIndex == 0){
        
        
        
        self.isTakeVideo = false;
        [self performSelector:@selector(selectCamera) withObject:nil afterDelay:0.2];
        [self performSelector:@selector(reset) withObject:nil afterDelay:2.0];
        
        
        
    }else if (self.segControl.selectedSegmentIndex == 1){
        
        
        self.isTakeVideo = false;
        [self performSelector:@selector(selectLibrary) withObject:nil afterDelay:0.2];
        [self performSelector:@selector(reset) withObject:nil afterDelay:2.0];
        
        
    }
    
}


-(void)selectCamera{
    self.cameraSaveMessage = self.messageText.text;
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentModalViewController:picker animated:YES];
    
}

-(void)selectLibrary{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
    
}

-(void)selectVideo{
    
    //video
    @try {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =  
        [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        picker.videoMaximumDuration = 30;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        [self presentModalViewController:picker animated:YES];
        
    }
    @catch (NSException * e) {
        NSString *message1 = @"Video is not supported on this device.";
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Invalid Device" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }
    
}
-(void)reset{
    
    self.segControl.selectedSegmentIndex = -1;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    if (self.isTakeVideo) {
        self.isSendVideo = true;
        [picker dismissModalViewControllerAnimated:YES];	
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoDataToSend = [NSData dataWithContentsOfURL:videoURL];
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL: videoURL];
        player.useApplicationAudioSession = NO;
        player.shouldAutoplay = NO;
        UIImage *tmpImage = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        if (tmpImage.size.height > tmpImage.size.width) {
            self.sendOrientation = @"portrait";
        }else{
            self.sendOrientation = @"landscape";
        }
        
        self.imageDataToSend = UIImageJPEGRepresentation(tmpImage, 0.90);
        self.messageImage.image = tmpImage;
        
    }else{
        self.isSendVideo = false;
        [picker dismissModalViewControllerAnimated:YES];	
        
        UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        float xVal;
        float yVal;
        
        bool isPort = true;
        
        if (tmpImage.size.height > tmpImage.size.width) {
            //Portrait
            
            xVal = 210.0;
            yVal = 280.0;
            isPort = true;
            self.sendOrientation = @"portrait";
        }else{
            //Landscape
            xVal = 280.0;
            yVal = 210.0;
            isPort = false;
            self.sendOrientation = @"landscape";
        }
        
        NSData *jpegImage = UIImageJPEGRepresentation(tmpImage, 1.0);
        
        UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
        
        UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
        
        [myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
        
        UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        self.imageDataToSend = UIImageJPEGRepresentation(newImage, 0.90);
        
        self.cancelImageButton.hidden = NO;
        self.messageImage.image = [UIImage imageWithData:self.imageDataToSend];
        
        
    }
    
    self.messageImage.hidden = NO;
    self.cancelImageButton.hidden = NO;
    
} 



-(void)viewDidUnload{
    
    segControl = nil;
    messageText = nil;
    activity = nil;
    messageImage = nil;
    cancelImageButton = nil;
    errorLabel = nil;
}
@end
