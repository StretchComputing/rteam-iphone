//
//  HomeScoreView.m
//  rTeam
//
//  Created by Nick Wroblewski on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeScoreView.h"
#import "GameTabs.h"
#import "GameTabsNoCoord.h"
#import "Gameday.h"
#import "GameAttendance.h"
#import "Vote.h"
#import "Home.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "GANTracker.h"
#import "NewActivity.h"
#import "TraceSession.h"
#import "MapLocation.h"
#import "Activity.h"
#import "Base64.h"
#import "ImageDisplayMultiple.h"

@implementation HomeScoreView
@synthesize fullScreenButton, isFullScreen, initY, teamName, scoreUs, scoreThem, interval, scoreUsLabel, scoreThemLabel, topLabel, usLabel, themLabel, intervalLabel, teamId, eventId, sport, participantRole, goToButton, scoreButton, eventDate, addUsButton, addThemButton, subUsButton, subThemButton, addIntervalButton, subIntervalButton, isKeepingScore, eventDescription, eventStringDate, gameOverButton, overActivity, homeSuperView, latitude,longitude, opponent, mapButton, myTimer, linkLine, linkLabel, gameday, cameraButton, isSwitch, gameImageArray, fullBackView, imageView, imageButton, imageBackView, rightButton, leftButton, currentImageDisplayCell, home, sendOrientation, postImageLabel, postImagePreview, postImageActivity, postImageBackView, postImageTextView, postImageFrontView, postImageErrorLabel, postImageCancelButton, postImageSubmitButton, imageDataToSend, postImageText, errorString, picCount, myAd, bannerIsVisible, frontView, scoreUsTextField, scoreThemTextField, saveScoreEditButton;


-(void)viewDidAppear:(BOOL)animated{
    if (self.bannerIsVisible) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        myAd.frame = CGRectMake(0, 430, 320, 50);
        self.frontView.frame = CGRectMake(0, 0, 320, 430);
        
        
        
        [UIView commitAnimations];
    }else{
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        self.frontView.frame = self.view.frame;
        
        [UIView commitAnimations];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
        
    if (self.gameday || self.home) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBar.hidden = YES;
        [self setLabels];
    }
    
  
    
  
  
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.myTimer invalidate];
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    self.saveScoreEditButton.hidden = YES;
    self.scoreUsTextField.hidden = YES;
    self.scoreThemTextField.hidden = YES;
    
    self.scoreUsTextField.backgroundColor = [UIColor clearColor];
    self.scoreThemTextField.backgroundColor = [UIColor clearColor];
    
    myAd = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 480, 320, 50)];
	myAd.delegate = self;
	myAd.hidden = YES;
	[self.view addSubview:myAd];
    
    self.gameImageArray = [NSMutableArray array];
    self.postImageBackView.hidden = YES;
    self.scoreUsTextField.enabled = YES;
    self.scoreThemTextField.enabled = YES;
    self.scoreButton.enabled = YES;
    self.cameraButton.enabled = YES;


    
    self.postImageBackView.layer.masksToBounds = YES;
    self.postImageBackView.layer.cornerRadius = 5.0;
    self.postImageFrontView.layer.masksToBounds = YES;
    self.postImageFrontView.layer.cornerRadius = 5.0;
    [TraceSession addEventToSession:@"HomeScoreView - View Did Load"];
    
    self.fullBackView.hidden = YES;
    

   
    self.addUsButton.hidden = YES;
    self.subUsButton.hidden = YES;
    self.addThemButton.hidden = YES;
    self.subThemButton.hidden = YES;
    self.addIntervalButton.hidden = YES;
    self.subIntervalButton.hidden = YES;
    self.gameOverButton.hidden = YES;


    //To make this view go full screen:         
    self.isFullScreen = false;
    self.frontView.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0];
    [super viewDidLoad];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.goToButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.scoreButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addUsButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addThemButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.subUsButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.subThemButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.addIntervalButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.subIntervalButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.gameOverButton setBackgroundImage:stretch forState:UIControlStateNormal];

}

-(void)setLabels{
    
    self.picCount = [self.gameImageArray count];
    [self performSelectorInBackground:@selector(getGameImages) withObject:nil];
    
    if (![self.latitude isEqualToString:@""] && (self.latitude != nil)) {
        self.mapButton.hidden = NO;
    }else{
        self.mapButton.hidden = YES;
        
    }
    
    if ([self.participantRole isEqualToString:@"creator"] || [self.participantRole isEqualToString:@"coordinator"]) {
        self.scoreButton.hidden = NO;
        CGRect frame = self.goToButton.frame;
        frame.origin.x = 146;
        self.goToButton.frame = frame;
    }else{
        self.scoreButton.hidden = YES;
        CGRect frame = self.goToButton.frame;
        frame.origin.x = 83;
        self.goToButton.frame = frame;
    }
    
    self.topLabel.text = [NSString stringWithFormat:@"%@", self.teamName];
    
    self.topLabel.text = @"Live Score";
    self.usLabel.text = [NSString stringWithFormat:@"%@", self.teamName];

    if ([self.opponent isEqualToString:@"Opponent TBD"] || [self.opponent isEqualToString:@""] || (self.opponent == nil)) {
        self.themLabel.text = @"Them";
    }else{
        self.themLabel.text = [NSString stringWithString:self.opponent];
    }
    
    if ([self.scoreUs isEqualToString:@""] || self.scoreUs == nil) {
        self.scoreUs = @"0";
    }
    if ([self.scoreThem isEqualToString:@""] || self.scoreThem == nil) {
        self.scoreThem = @"0";
    }
    self.scoreUsLabel.text = self.scoreUs;
    self.scoreThemLabel.text = self.scoreThem;
    
    [self setNewInterval];
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *eventDate1 = [dateFormat dateFromString:self.eventStringDate];
    [dateFormat setDateFormat:@"MM/dd"];
    
    NSString *dateString = [NSString stringWithFormat:@"for Game on %@", [dateFormat stringFromDate:eventDate1]];
    
    
     CGSize constraints = CGSizeMake(900, 900);
     CGSize totalSize = [dateString sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:17] constrainedToSize:constraints];
    
    float size = totalSize.width;

    float start = (320 - size)/2;
    

    self.linkLabel.text = dateString;
    CGRect frame = self.linkLabel.frame;
    frame.origin.x = start;
    frame.size.width = 320;
    self.linkLabel.frame = frame;
    
    CGRect frame2 = self.linkLine.frame;
    frame2.origin.x = start + 1;
    frame2.size.width = size - 2;
    self.linkLine.frame = frame2;
    
    if (!self.myTimer.isValid){
        [self startTimer];
    }
    
    
}

-(void)startTimer{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 30
                                                    target: self
                                                  selector: @selector(getNewScores)
                                                  userInfo: nil
                                                   repeats: YES];
}

-(void)getNewScores{
    
    [self performSelectorInBackground:@selector(getScores) withObject:nil];
}

-(void)getScores{
	
	@autoreleasepool {

        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        NSDictionary *gameInfo = @{};
        //If there is a token, do a DB lookup to find the game info 
        if (![token isEqualToString:@""]){
            
            
            NSDictionary *response = [ServerAPI getGameInfo:self.eventId :self.teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"100"]){
                
                gameInfo = [response valueForKey:@"gameInfo"];
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorString = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorString = @"*Error connecting to server";
                        break;
                    default:
                        //log status code
                       // self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        [self performSelectorOnMainThread:@selector(didFinish:) withObject:gameInfo waitUntilDone:NO];
        
    }
    
}

-(void)didFinish:(NSDictionary *)gameInfo{
        
        
        if ([gameInfo valueForKey:@"interval"] != nil) {
            
            self.interval = [[gameInfo valueForKey:@"interval"] stringValue];
            self.scoreUs = [[gameInfo valueForKey:@"scoreUs"] stringValue];
            self.scoreThem = [[gameInfo valueForKey:@"scoreThem"] stringValue];
            
            [self setLabels];
            
        }

	
}



-(void)setNewInterval{
    
    NSString *time = @"";
    int intInterval = [self.interval intValue];
    
    if (intInterval == 0) {
        time = @"-";
    }
    if (intInterval == 1) {
        time = @"1st";
    }
    
    if (intInterval == 2) {
        time = @"2nd";
    }
    
    if (intInterval == 3) {
        time = @"3rd";
    }
    
    if (intInterval >= 4) {
        time = [NSString stringWithFormat:@"%@th", self.interval];
    }
    
    if (intInterval == -1) {
        time = @"F";
    }
    
    if (intInterval == -2) {
        time = @"OT";
    }
    
    
    if (intInterval == -3) {
        time = @"";
    }
    
    self.intervalLabel.text = time;
    
}
-(void)fullScreen{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self dismissModalViewControllerAnimated:YES];
    
       
}

-(void)keepScore{
    
    if (self.isKeepingScore) {
        
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];

        self.scoreUsTextField.hidden = YES;
        self.scoreThemTextField.hidden = YES;
        
        [self.scoreButton setTitle:@"Keep Score" forState:UIControlStateNormal];
        
        self.isKeepingScore = false;
        
        self.addUsButton.hidden = YES;
        self.gameOverButton.hidden = YES;

        self.subUsButton.hidden = YES;
        self.addThemButton.hidden = YES;
        self.subThemButton.hidden = YES;
        self.addIntervalButton.hidden = YES;
        self.subIntervalButton.hidden = YES;
        
        [self startTimer];
        
        if ([self.gameImageArray count] > 0) {
            self.fullBackView.hidden = NO;
        }
        
    }else{
        
        [self.myTimer invalidate];
        
        self.scoreUsTextField.hidden = NO;
        self.scoreThemTextField.hidden = NO;
        
        [self.scoreButton setTitle:@"Save Score" forState:UIControlStateNormal];

        
       // if (!self.isFullScreen) {
         //   [self fullScreen];
        //}
        self.isKeepingScore = true;
        
        self.addUsButton.hidden = NO;
        self.gameOverButton.hidden = NO;

        self.subUsButton.hidden = NO;
        self.addThemButton.hidden = NO;
        self.subThemButton.hidden = NO;
        
        if (![self.interval isEqualToString:@"-3"]){
            self.addIntervalButton.hidden = NO;
            self.subIntervalButton.hidden = NO;
        }
   
        self.fullBackView.hidden = YES;
    }
}

-(void)goToPage{
        
    [self.myTimer invalidate];
    
    if (self.gameday) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Go To Event Page - Happening Now"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
        NSString *tmpUserRole = self.participantRole;
        NSString *tmpTeamId = self.teamId;
        
        if ([tmpUserRole isEqualToString:@"creator"] || [tmpUserRole isEqualToString:@"coordinator"]) {
            GameTabs *currentGameTab = [[GameTabs alloc] init];
            currentGameTab.fromHome = true;
            
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId = self.eventId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = tmpViews[0];
            currentNotes.gameId = self.eventId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = self.sport;
            currentNotes.description = self.eventDescription;
            currentNotes.startDate = self.eventStringDate;
            currentNotes.opponentString = @"";
            
            GameAttendance *currentAttendance = tmpViews[1];
            currentAttendance.gameId = self.eventId;
            currentAttendance.teamId = tmpTeamId;
            currentAttendance.startDate = self.eventStringDate;
            
            Vote *fans = tmpViews[2];
            fans.teamId = self.teamId;
            fans.userRole = self.participantRole;
            fans.gameId = self.eventId;
            
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            [self presentModalViewController:navController animated:NO];
            
        }else {
            
            GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
            currentGameTab.fromHome = true;
            NSArray *tmpViews = currentGameTab.viewControllers;
            currentGameTab.teamId = tmpTeamId;
            currentGameTab.gameId = self.eventId;
            currentGameTab.userRole = tmpUserRole;
            currentGameTab.teamName = self.teamName;
            
            Gameday *currentNotes = tmpViews[0];
            currentNotes.gameId = self.eventId;
            currentNotes.teamId = tmpTeamId;
            currentNotes.userRole = tmpUserRole;
            currentNotes.sport = self.sport;
            currentNotes.description = self.eventDescription;
            currentNotes.startDate = self.eventStringDate;
            currentNotes.opponentString = @"";
            
            Vote *fans = tmpViews[1];
            fans.teamId = self.teamId;
            fans.userRole = self.participantRole;
            fans.gameId = self.eventId;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            
            [navController pushViewController:currentGameTab animated:YES];
            
            [self presentModalViewController:navController animated:NO];
        }

    }
           
        
        
}

-(void)addUs{
    
    int scoreInt = [self.scoreUs intValue];
    scoreInt = scoreInt + 1;
    self.scoreUs = [NSString stringWithFormat:@"%d", scoreInt];
    
    self.scoreUsLabel.text = [NSString stringWithFormat:self.scoreUs];
    [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    
}

-(void)addThem{
    
    int scoreInt = [self.scoreThem intValue];
    scoreInt = scoreInt + 1;
    self.scoreThem = [NSString stringWithFormat:@"%d", scoreInt];
    
    self.scoreThemLabel.text = [NSString stringWithFormat:self.scoreThem];
    [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    
}

-(void)subUs{
    
    int scoreInt = [self.scoreUs intValue];
    
    if (scoreInt > 0) {
        scoreInt = scoreInt - 1;
        self.scoreUs = [NSString stringWithFormat:@"%d", scoreInt];
        
        self.scoreUsLabel.text = [NSString stringWithFormat:self.scoreUs];
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    }

    
}

-(void)subThem{
    
    
    int scoreInt = [self.scoreThem intValue];
    
    if (scoreInt > 0) {
        scoreInt = scoreInt - 1;
        self.scoreThem = [NSString stringWithFormat:@"%d", scoreInt];
        
        self.scoreThemLabel.text = [NSString stringWithFormat:self.scoreThem];
        [self performSelectorInBackground:@selector(runRequest) withObject:nil];
    }
}

-(void)addInterval{
    
    int theInterval = [self.interval intValue];
    
    if (theInterval == -1) {
        
    }else if (theInterval == -2){
        theInterval = -1;
    }else if (theInterval == 9){
        theInterval = -2;
    }else{
        //1-8
        theInterval = theInterval + 1;
    }
    
    self.interval = [NSString stringWithFormat:@"%d", theInterval];
    [self setNewInterval];

}


-(void)subInterval{
    
    int theInterval = [self.interval intValue];
    
    if (theInterval == -1) {
        theInterval = -2;
    }else if (theInterval == -2){
        theInterval = 9;
    }else if (theInterval == 1){

    }else{
        //2-9
        theInterval = theInterval - 1;
    }
    
    self.interval = [NSString stringWithFormat:@"%d", theInterval];
    [self setNewInterval];
    
}




- (void)runRequest {
    
	
	NSString *token = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
    
    if ([self.interval isEqualToString:@"0"]) {
        self.interval = @"1";
    }
    
	NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :self.scoreUs 
												  :self.scoreThem :self.interval :@"" :@"" :@""];
	
	NSString *status = [response valueForKey:@"status"];
	    
	if ([status isEqualToString:@"100"]){
		
		
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				//self.error.text = @"*Error connecting to server";
				break;
			case 1:
				//error connecting to server
				///self.error.text = @"*Error connecting to server";
				break;
				
			default:
				//should never get here
				//self.error.text = @"*Error connecting to server";
				break;
		}
	}
	
	
	
}

-(void)doReset{
    
    self.isFullScreen = false;
    self.isKeepingScore = false;
    [self.scoreButton setTitle:@"Keep Score" forState:UIControlStateNormal];
    self.addUsButton.hidden = YES;
    self.gameOverButton.hidden = YES;
    self.subUsButton.hidden = YES;
    self.addThemButton.hidden = YES;
    self.subThemButton.hidden = YES;
    self.addIntervalButton.hidden = YES;
    self.subIntervalButton.hidden = YES;
}

-(void)gameOver{
	
	NSString *message = [NSString stringWithFormat:@"Was the final score %@-%@?", self.scoreUs, self.scoreThem];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		self.interval = @"-1";

        self.gameOverButton.enabled = NO;
        self.addUsButton.enabled = NO;
        self.addThemButton.enabled = NO;
        self.addIntervalButton.enabled = NO;
        self.subIntervalButton.enabled = NO;
        self.subUsButton.enabled = NO;
        self.subThemButton.enabled = NO;
        
        [self.overActivity startAnimating];
		[self performSelectorInBackground:@selector(runRequestOver) withObject:nil];
		
		
	}
	
}

- (void)runRequestOver {
    
	
	NSString *token = @"";
    NSString *responseString = @"";
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	token = mainDelegate.token;
    
	NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :self.scoreUs 
												  :self.scoreThem :self.interval :@"" :@"" :@""];
	
	NSString *status = [response valueForKey:@"status"];
    
	if ([status isEqualToString:@"100"]){
		
		responseString = @"";
		
	}else{
		responseString = @"error";
		//Server hit failed...get status code out and display error accordingly
		int statusCode = [status intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				//self.error.text = @"*Error connecting to server";
				break;
			case 1:
				//error connecting to server
				///self.error.text = @"*Error connecting to server";
				break;
				
			default:
				//should never get here
				//self.error.text = @"*Error connecting to server";
				break;
		}
	}
	
	[self performSelectorOnMainThread:@selector(doneOver:) withObject:responseString waitUntilDone:NO];
	
}

-(void)doneOver:(NSString *)responseString{
    
    [self.overActivity stopAnimating];
    self.gameOverButton.enabled = YES;
    self.addUsButton.enabled = YES;
    self.addThemButton.enabled = YES;
    self.addIntervalButton.enabled = YES;
    self.subIntervalButton.enabled = YES;
    self.subUsButton.enabled = YES;
    self.subThemButton.enabled = YES;
    
    self.scoreUsTextField.hidden = YES;
    self.scoreThemTextField.hidden = YES;
    
    if ([responseString isEqualToString:@""]) {
        
        [self setLabels];
    
        
    }else{
  
    }
}

-(void)takePhoto{
   
    [self.myTimer invalidate];
    

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Take Game Photo - Happening Now"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    [self displayCamera];

}

-(void)displayCamera{
    
    @try {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:picker animated:YES];
    }
    @catch (NSException *exception) {
        
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    [picker dismissModalViewControllerAnimated:YES];	
    
    UIImage *tmpImage = info[UIImagePickerControllerOriginalImage];
    
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
    
    self.postImageBackView.hidden = NO;
    self.scoreUsTextField.enabled = NO;
    self.scoreThemTextField.enabled = NO;
    self.scoreButton.enabled = NO;
    self.cameraButton.enabled = NO;


    self.postImageErrorLabel.text = @"";
    self.postImageTextView.text = @"";
    [self.view bringSubviewToFront:self.postImageBackView];
    
    self.postImagePreview.image = [UIImage imageWithData:self.imageDataToSend];
    
  
    
    
    
} 


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
	[picker dismissModalViewControllerAnimated:YES];	
 
    self.scoreButton.enabled = YES;
    self.cameraButton.enabled = YES;
}

-(void)mapAction{
        
    [[UIApplication sharedApplication] setStatusBarHidden:NO];


    if (self.gameday || self.home) {
        
        MapLocation *next = [[MapLocation alloc] init];
        next.eventLatCoord = [self.latitude doubleValue];
        next.eventLongCoord = [self.longitude doubleValue];
        next.cancelButton = true;
        
        UINavigationController *navController = [[UINavigationController alloc] init];
        
        [navController pushViewController:next animated:YES];
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
        [self presentModalViewController:navController animated:YES];
        
    }
    
        
   
    
}


-(void)getGameImages{
    
    @autoreleasepool {
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
            NSDate *today = [NSDate date];
            NSDate *tomorrow = [NSDate dateWithTimeInterval:86400 sinceDate:today];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [format stringFromDate:tomorrow];
       
            NSDictionary *response = [ServerAPI getActivityGamePhotos:token maxCount:@"6" refreshFirst:@"" newOnly:@"" mostCurrentDate:dateString totalNumberOfDays:@"" includeDetails:@"true" mediaOnly:@"true" eventId:self.eventId teamId:self.teamId];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                tmpArray = [response valueForKey:@"activities"];
                                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 208:
                        //self.errorString = @"NA";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        
        [self performSelectorOnMainThread:@selector(doneGameImages:) withObject:tmpArray waitUntilDone:NO];
        
    }
	
}

-(void)doneGameImages:(NSMutableArray *)activityArray{
    
    
    if ([activityArray count] > 0) {
        
        
        if ([activityArray count] != self.picCount) {
            self.gameImageArray = [NSMutableArray arrayWithArray:activityArray];
            
            NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
            [self.gameImageArray sortUsingDescriptors:@[dateSort]];
            
            self.leftButton.enabled = NO;
            if ([activityArray count] > 1) {
                self.rightButton.enabled = YES;
            }else{
                self.rightButton.enabled = NO;
            }
            
            Activity *tmpActivity = (self.gameImageArray)[0];
            NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
            
            UIImage *tmpImage = [UIImage imageWithData:profileData];
            
            if (tmpImage.size.height > tmpImage.size.width) {
                self.imageBackView.frame = CGRectMake(114, 2, 75, 100);
                
            }else{
                self.imageBackView.frame = CGRectMake(102, 14, 100, 75);
            }
            
            self.imageView.frame = CGRectMake(1, 1, self.imageBackView.frame.size.width -2, self.imageBackView.frame.size.height - 2);
            self.imageView.image = tmpImage;
            
            self.imageBackView.layer.masksToBounds = YES;
            self.imageBackView.layer.cornerRadius = 4.0;
            self.imageView.layer.masksToBounds = YES;
            self.imageView.layer.cornerRadius = 4.0;
            
            self.currentImageDisplayCell = 0;
            self.fullBackView.hidden = NO;

        }
    }else{
        self.fullBackView.hidden = YES;
        self.gameImageArray = [NSMutableArray array];
    }
}


-(void)imageSelected:(id)sender{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    Activity *tmpActivity = (self.gameImageArray)[self.currentImageDisplayCell];

    ImageDisplayMultiple *newDisplay = [[ImageDisplayMultiple alloc] init];
    newDisplay.activityId = tmpActivity.activityId;
    newDisplay.teamId = self.teamId;
    newDisplay.fromScoreboard = true;
    
    [self.myTimer invalidate];
    
    UINavigationController *navController = [[UINavigationController alloc] init];
    
    [navController pushViewController:newDisplay animated:NO];
    
    //navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentModalViewController:navController animated:NO];
    
}

-(void)rightButtonAction{
    
    self.currentImageDisplayCell++;
    
    Activity *tmpActivity = (self.gameImageArray)[self.currentImageDisplayCell];
    NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
    
    UIImage *tmpImage = [UIImage imageWithData:profileData];
    
    self.imageView.image = tmpImage;
    
    if (tmpImage.size.height > tmpImage.size.width) {
        self.imageBackView.frame = CGRectMake(114, 2, 75, 100);
        
    }else{
        self.imageBackView.frame = CGRectMake(102, 14, 100, 75);
    }
    
    self.imageView.frame = CGRectMake(1, 1, self.imageBackView.frame.size.width -2, self.imageBackView.frame.size.height - 2);
    
    self.leftButton.enabled = YES;
    
    if (self.currentImageDisplayCell == [self.gameImageArray count] - 1) {
        self.rightButton.enabled = NO;
    }else{
        self.rightButton.enabled = YES;
    }
    
}
-(void)leftButtonAction{
    
    self.currentImageDisplayCell--;
    
    Activity *tmpActivity = (self.gameImageArray)[self.currentImageDisplayCell];
    NSData *profileData = [Base64 decode:tmpActivity.thumbnail];
    
    UIImage *tmpImage = [UIImage imageWithData:profileData];
    
    self.imageView.image = tmpImage;
    
    if (tmpImage.size.height > tmpImage.size.width) {
        self.imageBackView.frame = CGRectMake(114, 2, 75, 100);
        
    }else{
        self.imageBackView.frame = CGRectMake(102, 14, 100, 75);
    }
    
    self.imageView.frame = CGRectMake(1, 1, self.imageBackView.frame.size.width -2, self.imageBackView.frame.size.height - 2);
    
    self.rightButton.enabled = YES;
    
    if (self.currentImageDisplayCell == 0) {
        self.leftButton.enabled = NO;
    }else{
        self.leftButton.enabled = YES;
    }
    
}


-(void)postImageCancel{
    self.imageDataToSend = [NSData data];
    self.postImageBackView.hidden = YES;
    self.scoreUsTextField.enabled = YES;
    self.scoreThemTextField.enabled = YES;
}

-(void)postImageSubmit{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Image Posted to Actiivty - Gameday"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    

    self.postImageErrorLabel.text = @"";

    [self.postImageActivity startAnimating];
    self.postImageText = [NSString stringWithString:self.postImageTextView.text];
    [self performSelectorInBackground:@selector(postImage:) withObject:@""];
    
       
}


-(void)postImage:(NSString *)gameday{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSData *tmpData = [NSData data];
        
        tmpData = [NSData dataWithData:self.imageDataToSend];
        
        if (self.postImageText == nil) {
            self.postImageText = @"";
        }
        
        NSDictionary *response = [ServerAPI createActivity:mainDelegate.token teamId:self.teamId statusUpdate:self.postImageText photo:tmpData video:[NSData data] orientation:self.sendOrientation replyToId:@"" eventId:self.eventId newGame:@""];
        
        
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
        
        [self performSelectorOnMainThread:@selector(donePostImage) withObject:nil waitUntilDone:NO];
        
    }
    
    
}

-(void)donePostImage{
    
    [self.postImageActivity stopAnimating];
    
    if ([self.errorString isEqualToString:@""]) {
        self.postImageErrorLabel.text = @"Post Successful!";
        self.postImageErrorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0 blue:0.0 alpha:1.0];
        [self performSelector:@selector(hidePost) withObject:nil afterDelay:0.5];
    }else{
        if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can post to Activity.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else{
            self.postImageErrorLabel.text = self.errorString;
        }
    }
}

-(void)hidePost{
    self.postImageBackView.hidden = YES;
    self.scoreUsTextField.enabled = YES;
    self.scoreThemTextField.enabled = YES;
    self.scoreButton.enabled = YES;
    self.cameraButton.enabled = YES;
}


//iAd delegate methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
	
	return YES;
	
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    if (!self.bannerIsVisible) {
        
        self.bannerIsVisible = YES;
        myAd.hidden = NO;
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        myAd.frame = CGRectMake(0, 430, 320, 50);
        self.frontView.frame = CGRectMake(0, 0, 320, 430);

        
        
        [UIView commitAnimations];
        
        [self.view bringSubviewToFront:myAd]; 
    }
        
          
    
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    
    self.myAd.hidden = YES;
	if (self.bannerIsVisible) {
        
		self.bannerIsVisible = NO;
        
   
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        self.frontView.frame = CGRectMake(0, 0, 320, 480);
        
        
        
        [UIView commitAnimations];
        
        
	}
	
	
}




-(void)endText{
    
}

-(void)doneButton{
 
    self.saveScoreEditButton.hidden = YES;
  
    
    self.addUsButton.hidden = NO;
    self.subUsButton.hidden = NO;
    self.addThemButton.hidden =  NO;
    self.subThemButton.hidden = NO;
    
    if (![self.scoreUsTextField.text isEqualToString:@""] && (self.scoreUsTextField.text != nil)) {
        self.scoreUs = self.scoreUsTextField.text;
    }
    
    if (![self.scoreThemTextField.text isEqualToString:@""] && (self.scoreThemTextField.text != nil)) {
        self.scoreThem = self.scoreThemTextField.text;
    }
    
    [self.scoreUsTextField resignFirstResponder];
    [self.scoreThemTextField resignFirstResponder];
    self.scoreUsTextField.text = @"";
    self.scoreThemTextField.text = @"";
    self.scoreUsTextField.backgroundColor = [UIColor clearColor];
    self.scoreThemTextField.backgroundColor = [UIColor clearColor];
    
    [self performSelectorInBackground:@selector(runRequest) withObject:nil];

    [self setLabels];


}

- (void)keyboardWillShow:(NSNotification *)note {  
    // create custom button
    self.saveScoreEditButton.hidden = NO;
    
    self.addUsButton.hidden = YES;
    self.subUsButton.hidden = YES;
    self.addThemButton.hidden = YES;
    self.subThemButton.hidden = YES;
    
    self.scoreUsTextField.text = self.scoreUs;
    self.scoreThemTextField.text = self.scoreThem;
    
    if ([self.scoreThemTextField isFirstResponder]) {
        if ([self.scoreThemTextField.text isEqualToString:@"0"]) {
            self.scoreThemTextField.text = @"";
        }
    }
    
    if ([self.scoreUsTextField isFirstResponder]) {
        if ([self.scoreUsTextField.text isEqualToString:@"0"]) {
            self.scoreUsTextField.text = @"";
        }
    }
    
    
    
    
    self.scoreUsTextField.backgroundColor = [UIColor blackColor];
    self.scoreThemTextField.backgroundColor = [UIColor blackColor];
    
 

    
}

 


- (void)viewDidUnload
{
    overActivity = nil;
    fullScreenButton = nil;
    scoreUsLabel = nil;
    scoreThemLabel = nil;
    topLabel = nil;
    usLabel = nil;
    themLabel = nil;
    intervalLabel = nil;
    goToButton = nil;
    scoreButton = nil;
    addThemButton = nil;
    addUsButton = nil;
    subUsButton = nil;
    subThemButton = nil;
    addIntervalButton = nil;
    subIntervalButton = nil;
    gameOverButton = nil;
    mapButton = nil;
    linkLabel = nil;
    cameraButton = nil;
    linkLine = nil;
    fullBackView = nil;
    imageView = nil;
    imageButton = nil;
    imageBackView = nil;
    rightButton = nil;
    leftButton = nil;
    postImageErrorLabel = nil;
    postImageFrontView = nil;
    postImageLabel = nil;
    postImagePreview = nil;
    postImageCancelButton = nil;
    postImageBackView = nil;
    postImageActivity = nil;
    postImageTextView = nil;
    postImageSubmitButton = nil;
    frontView = nil;
    scoreThemTextField = nil;
    scoreUsTextField = nil;
    saveScoreEditButton = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];

}


@end
