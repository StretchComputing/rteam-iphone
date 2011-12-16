//
//  ActivityPost.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPost.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Team.h"
#import "SelectTeams.h"
#import "SelectRecipients.h"
#import <MobileCoreServices/UTCoreTypes.h> 
#import "GANTracker.h"
#import "TraceSession.h"

@implementation ActivityPost
@synthesize messageText, postTeamId, teamSelectButton, hasTeams, teams, savedTeams, selectedTeams, keyboardIsUp, keyboardButton, sendPollButton, sendPrivateButton, activity, segControl, theMessageText, previewImage, cameraSaveMessage, cancelImageButton, imageDataToSend, isTakeVideo, isSendVideo, sendOrientation, errorLabel, errorString, videoDataToSend, fromClass;




-(void)viewWillAppear:(BOOL)animated{
    
    if (self.savedTeams) {
        self.savedTeams = false;
        
        NSString *titleString = @"";
        
        for (int i = 0; i < [self.selectedTeams count]; i++) {
            
            if (![[self.selectedTeams objectAtIndex:i] isEqualToString:@""]) {
                
                Team *tmpTeam = [self.teams objectAtIndex:i];
                
                if ([titleString isEqualToString:@""]) {
                    titleString = [titleString stringByAppendingFormat:@"%@", tmpTeam.name];
                }else{
                    titleString = [titleString stringByAppendingFormat:@", %@", tmpTeam.name];
                }
            }
        }
        
        [self.teamSelectButton setTitle:titleString forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad
{
    self.cancelImageButton.hidden = YES;
    self.keyboardIsUp = false;
    self.title = @"Post to Activity";
    
    self.hasTeams = false;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	[self.navigationItem setLeftBarButtonItem:addButton];
    
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
	[self.navigationItem setRightBarButtonItem:postButton];
    
    [self performSelectorInBackground:@selector(getListOfTeams) withObject:nil];
    
    [self.teamSelectButton setTitle:@"Loading Teams..." forState:UIControlStateNormal];
    self.messageText.delegate = self;
    
    self.sendOrientation = @"";
    self.imageDataToSend = [NSData data];
    self.videoDataToSend = [NSData data];
    [super viewDidLoad];

}

-(void)post{
    
    [TraceSession addEventToSession:@"Activity Post Page - Post Button Clicked"];

    if ([self.teams count] > 0) {
        self.theMessageText = [NSString stringWithString:self.messageText.text];
        
        
        [self.activity startAnimating];
        [self.sendPrivateButton setEnabled:NO];
        [self.sendPollButton setEnabled:NO];
        [self.keyboardButton setEnabled:NO];
        [self.teamSelectButton setEnabled:NO];
        [self.segControl setEnabled:NO];
        
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Post to Activity"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
        [self performSelectorInBackground:@selector(createActivity) withObject:nil];
    }else{
        NSString *tmp = @"You must create or join at least one team before posting Activity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    
}
-(void)cancel{
    
    [TraceSession addEventToSession:@"Activity Post Page - Cancel Button Clicked"];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)createActivity{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                
        NSData *tmpData = [NSData data];
        NSData *tmpMovieData = [NSData data];
        
        if (self.isSendVideo) {
            tmpMovieData = [NSData dataWithData:self.videoDataToSend];
        }
        tmpData = [NSData dataWithData:self.imageDataToSend];

 
        
        NSDictionary *response = [ServerAPI createActivity:mainDelegate.token :self.postTeamId :self.theMessageText :tmpData :tmpMovieData :self.sendOrientation];
        
        
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
    [self.sendPrivateButton setEnabled:YES];
    [self.sendPollButton setEnabled:YES];
    [self.keyboardButton setEnabled:YES];
    [self.teamSelectButton setEnabled:YES];
    [self.segControl setEnabled:YES];

    if ([self.errorString isEqualToString:@""]) {
        
        fromClass.fromPost = true;
        [self.navigationController dismissModalViewControllerAnimated:YES];

    }else{
                
        if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can post to Activity.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else{
            self.errorLabel.text = self.errorString;
        }
    }
}


-(void)getListOfTeams{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            NSDictionary *response = [ServerAPI getListOfTeams:token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSArray *teamsHere = [response valueForKey:@"teams"];
                
                self.teams = [NSMutableArray arrayWithArray:teamsHere];
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        [self performSelectorOnMainThread:@selector(doneTeams) withObject:nil waitUntilDone:NO];
    }
	
	
}

-(void)doneTeams{
    
    if ([self.teams count] > 0) {
        Team *tmpTeam = [self.teams objectAtIndex:0];
        hasTeams = true;
        [self.teamSelectButton setTitle:tmpTeam.name forState:UIControlStateNormal];
        self.postTeamId = tmpTeam.teamId;  
        
        self.selectedTeams = [NSMutableArray array];
        for (int i = 0; i < [self.teams count]; i++) {
            [self.selectedTeams addObject:@""];
        }
        [self.selectedTeams replaceObjectAtIndex:0 withObject:@"s"];
    }else{
        [self.teamSelectButton setTitle:@"No Teams Found..." forState:UIControlStateNormal];

    }
    
}

-(void)teamSelect{
    
    if (self.hasTeams) {
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        
        SelectTeams *tmp = [[SelectTeams alloc] init];
        tmp.myTeams = [NSMutableArray arrayWithArray:self.teams];
        tmp.rowsSelected = [NSMutableArray arrayWithArray:self.selectedTeams];
        [self.navigationController pushViewController:tmp animated:YES];
    }
}
-(void)sendPoll{
    
    [TraceSession addEventToSession:@"Activity Post Page - Send Poll Button Clicked"];

    
    if ([self.teams count] > 0) {
        
        if ([self.teams count] == 1) {
            
            Team *tmpTeam = [self.teams objectAtIndex:0];
            
            SelectRecipients *tmp = [[SelectRecipients alloc] init];
            tmp.teamId = tmpTeam.teamId;
            tmp.isPoll = true;
            [self.navigationController pushViewController:tmp animated:YES];
            
        }else{
            
            SelectTeams *tmp = [[SelectTeams alloc] init];
            tmp.myTeams = [NSMutableArray arrayWithArray:self.teams];
            tmp.isPoll = true;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i = 0; i < [self.teams count]; i++) {
                [tmpArray addObject:@""];
            }
            tmp.rowsSelected = [NSMutableArray arrayWithArray:tmpArray];
            
            [self.navigationController pushViewController:tmp animated:YES];
            
        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found" message:@"You must have at least one team to send a poll." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)privateMessage{
    
    [TraceSession addEventToSession:@"Activity Post Page - Private Message Button Clicked"];

    if ([self.teams count] > 0) {
        
        if ([self.teams count] == 1) {
            
            Team *tmpTeam = [self.teams objectAtIndex:0];
            
            SelectRecipients *tmp = [[SelectRecipients alloc] init];
            tmp.teamId = tmpTeam.teamId;
            tmp.isPrivate = true;
            [self.navigationController pushViewController:tmp animated:YES];
            
        }else{
            
            SelectTeams *tmp = [[SelectTeams alloc] init];
            tmp.myTeams = [NSMutableArray arrayWithArray:self.teams];
            tmp.isPrivate = true;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i = 0; i < [self.teams count]; i++) {
                [tmpArray addObject:@""];
            }
            tmp.rowsSelected = [NSMutableArray arrayWithArray:tmpArray];
     
            [self.navigationController pushViewController:tmp animated:YES];
            
        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found" message:@"You must have at least one team to send a message." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.keyboardIsUp = true;
    [self.keyboardButton setImage:[UIImage imageNamed:@"keyboarddown.png"] forState:UIControlStateNormal];
}

-(void)keyboard{
    
    if (self.keyboardIsUp) {
        self.keyboardIsUp = false;
        [self.messageText resignFirstResponder];
        [self.keyboardButton setImage:[UIImage imageNamed:@"keyboardup.png"] forState:UIControlStateNormal];

    }else{
        self.keyboardIsUp = true;
        [self.messageText becomeFirstResponder];
        [self.keyboardButton setImage:[UIImage imageNamed:@"keyboarddown.png"] forState:UIControlStateNormal];

    }
    
}


-(void)segmentSelect{
    
    if (self.segControl.selectedSegmentIndex == 2) {
        
        [TraceSession addEventToSession:@"Activity Post Page - Video Button Clicked"];

        self.isTakeVideo = true;
     
        [self performSelector:@selector(selectVideo) withObject:nil afterDelay:0.2];

        [self performSelector:@selector(reset) withObject:nil afterDelay:0.2];
        
        
    }else if (self.segControl.selectedSegmentIndex == 0){
        
        [TraceSession addEventToSession:@"Activity Post Page - Camera Button Clicked"];

        
        self.isTakeVideo = false;
        [self performSelector:@selector(selectCamera) withObject:nil afterDelay:0.2];
        [self performSelector:@selector(reset) withObject:nil afterDelay:2.0];
        
        
        
    }else if (self.segControl.selectedSegmentIndex == 1){
        
        [TraceSession addEventToSession:@"Activity Post Page - Image Library Button Clicked"];

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
        self.previewImage.image = tmpImage;
        
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
        self.previewImage.image = [UIImage imageWithData:self.imageDataToSend];

        
    }
       
    self.previewImage.hidden = NO;
    self.cancelImageButton.hidden = NO;

} 

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)cancelImage{
    
    self.imageDataToSend = [NSData data];
    self.previewImage.hidden = YES;
    self.previewImage.image = nil;
    self.cancelImageButton.hidden = YES;
    self.videoDataToSend = [NSData data];
}

- (void)viewDidUnload
{
    cancelImageButton = nil;
    previewImage = nil;
    messageText = nil;
    teamSelectButton = nil;
    keyboardButton = nil;
    segControl = nil;
    activity = nil;
    sendPollButton = nil;
    sendPrivateButton = nil;
    errorLabel = nil;
    [super viewDidUnload];

}


@end
