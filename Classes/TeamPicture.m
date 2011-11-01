//
//  TeamPicture.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "TeamPicture.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Base64.h"
#import "CameraSelectionTeamPicture.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@implementation TeamPicture
@synthesize removeButton, addChangeButton, profilePic, titleLabel, loadingImageLabel, loadingImageActivity, displayLabel, addImage, hasImage,
imageString, imageData, fromCameraSelect, selectedImage, activity, errorString, userRole, teamId, largeImageView, camerActionSheet, allWhiteView,
newImage, dontMove, toOrientation, portrait;

-(void)viewDidAppear:(BOOL)animated{
	
	
	if (self.fromCameraSelect) {
		
		self.profilePic.image = self.selectedImage;
        
        self.largeImageView.image = self.selectedImage;
        self.largeImageView.frame = CGRectMake(0, 0, 480, 320);
        
        if(self.profilePic.image.size.height > self.profilePic.image.size.width){
            //Portrait
            self.profilePic.frame = CGRectMake(56, 84, 210, 280);
            self.portrait = true;
            
        }else{
            //Landscape
            self.profilePic.frame = CGRectMake(0, 94, 320, 240);
            self.portrait = false;
        }
        
		[self.addChangeButton setTitle:@"Change" forState:UIControlStateNormal];
		self.removeButton.hidden = NO;
		self.titleLabel.text = @"Your current team picture.";
		
		[self.activity startAnimating];
		self.loadingImageLabel.hidden = YES;
		[self performSelectorInBackground:@selector(updateImage) withObject:nil];
        self.fromCameraSelect = false;
	}
	
	[self becomeFirstResponder];
	
}
-(void)viewDidLoad{
	
	self.title = @"Team Photo";
	
	
	if (!self.newImage) {
		self.largeImageView = [[UIImageView alloc] init];
		self.loadingImageLabel.hidden = NO;
		[self.loadingImageActivity startAnimating];
		[self performSelectorInBackground:@selector(getImage) withObject:nil];
        self.profilePic.image = nil;
        self.removeButton.hidden = YES;
        self.addChangeButton.hidden = YES;
	}else {
		self.loadingImageLabel.hidden = YES;
        self.newImage = false;
	}

	self.profilePic.layer.masksToBounds = YES;
    self.profilePic.layer.cornerRadius = 5.0;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.addChangeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.removeButton setBackgroundImage:stretch forState:UIControlStateNormal];


	
	self.allWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.allWhiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.allWhiteView];
    [self.view bringSubviewToFront:self.allWhiteView];
    self.allWhiteView.hidden = YES;
}


-(void)getImage{
   
	@autoreleasepool {
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getTeamInfo:self.teamId :token :@"true"];
            
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSDictionary *info = [response valueForKey:@"teamInfo"];
                
                if ([info valueForKey:@"photo"] != nil) {
                    self.hasImage = true;
                    self.imageString = [info valueForKey:@"photo"];
                }else {
                    self.hasImage = false;
                }
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.error = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.error = @"*Error connecting to server";
                        break;
                    default:
                        //log status code
                        //self.error = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        [self performSelectorOnMainThread:@selector(doneImage) withObject:nil waitUntilDone:NO];

    }
		
}


-(void)doneImage{
	
	self.loadingImageLabel.hidden = YES;
	[self.loadingImageActivity stopAnimating];
	
	if (self.hasImage) {
        		
		if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
            
            self.addChangeButton.hidden = NO;
            
        }else {
            self.addChangeButton.hidden = YES;
        }
        
		[self.addChangeButton setTitle:@"Change" forState:UIControlStateNormal];
		
		NSData *tmpData = [Base64 decode:self.imageString];
		
		self.profilePic.image = [UIImage imageWithData:tmpData];
        
        if(self.profilePic.image.size.height > self.profilePic.image.size.width){
            //Portrait
            self.profilePic.frame = CGRectMake(56, 84, 210, 280);
            
        }else{
            //Landscape
            self.profilePic.frame = CGRectMake(0, 94, 320, 240);
        }
        
		self.titleLabel.text = @"Your current team picture";
		
		self.largeImageView.image = [UIImage imageWithData:tmpData];
		self.largeImageView.frame = CGRectMake(0, 0, 480, 320);
		
		
	}else {
		
		self.profilePic.image = [UIImage imageNamed:@"rTeamLogo.png"];
		self.titleLabel.text = @"You currently have no uploaded picture.";
		self.removeButton.hidden = YES;
        
        if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
            self.addChangeButton.hidden = NO;
            
        }else {
            self.addChangeButton.hidden = YES;
        }
	}
	
}




-(void)remove{
	self.displayLabel.text = @"";
	self.addImage = false;
	self.profilePic.image = [UIImage imageNamed:@"rTeamLogo.png"];
	self.titleLabel.text = @"You currently have no uploaded picture.";
	[self.addChangeButton setTitle:@"Add" forState:UIControlStateNormal];
	self.removeButton.hidden = YES;
	
	[self.activity startAnimating];
	[self performSelectorInBackground:@selector(updateImage) withObject:nil];
}

-(void)addChange{
	
	self.addImage = true;
	self.displayLabel.text = @"";
	
	self.camerActionSheet =  [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
	self.camerActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.camerActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet == self.camerActionSheet) {
		if (buttonIndex == 0) {
			//Take
			[self getPhoto:@"camera"];
		}else if (buttonIndex == 1){
			//ChoosePhoto
			[self getPhoto:@"library"];
			
		}
	}else {
		
		[FastActionSheet doAction:self :buttonIndex];

	}

	
	
	
}


-(void)getPhoto:(NSString *)option {
	
	
	if([option isEqualToString:@"library"]) {
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:picker animated:YES];
		
		
	} else {
		
		CameraSelectionTeamPicture *tmp = [[CameraSelectionTeamPicture alloc] init];
		[self.navigationController pushViewController:tmp animated:NO];
	}
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];	
	
	UIImageView *tmpView = [[UIImageView alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
	
    float xVal;
    float yVal;
    
    if (tmpView.image.size.height > tmpView.image.size.width) {
        //Portrait
        xVal = 240.0;
        yVal = 320.0;
        self.portrait = true;
        
    }else{
        //Landscape
        xVal = 320.0;
        yVal = 240.0;
        self.portrait = false;
        
    }
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpView.image, 1.0);
	
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	
	self.imageData = UIImageJPEGRepresentation(newImage1, 1.0);
	
	
	UIImage *tmpImage = [UIImage imageWithData:self.imageData];
	
    self.largeImageView.image = [UIImage imageWithData:self.imageData];
    self.largeImageView.frame = CGRectMake(0, 0, 480, 320);
    
	self.profilePic.image = tmpImage;
    
    if(self.profilePic.image.size.height > self.profilePic.image.size.width){
        //Portrait
        self.profilePic.frame = CGRectMake(56, 84, 210, 280);

    }else{
        //Landscape
        self.profilePic.frame = CGRectMake(0, 94, 320, 240);
    }
    
	[self.addChangeButton setTitle:@"Change" forState:UIControlStateNormal];
	self.removeButton.hidden = NO;
	self.titleLabel.text = @"Your current profile picture.";
	self.newImage = true;
	[self.activity startAnimating];
	[self performSelectorInBackground:@selector(updateImage) withObject:nil];
	
	
} 


-(void)updateImage{
	

	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        //NSString *addRemove = @"";
        
        if (!self.addImage) {
            //addRemove = @"remove";
        }
        
        NSData *tmpData = [NSData data];
        
        if (self.imageData != nil) {
            tmpData = imageData;
        }
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            NSString *orientation = @"";
            
            if ([tmpData length] > 0) {
                
                if (self.portrait) {
                    orientation = @"portrait";
                }else{
                    orientation = @"landscape";
                }
            }
            
            NSDictionary *response = [ServerAPI updateTeam:token :self.teamId :@"" :@"" :@"" :@"" :@"" :tmpData :orientation];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString = @"";
                
            }else{
                
                //self.memberTeams = [NSMutableArray array];
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.errorString = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        self.errorString = @"*Error connecting to server";
                        break;
                    default:
                        //should never get here
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
            
            
            
        }
        
        
        [self performSelectorOnMainThread:@selector(doneUpdate) withObject:nil waitUntilDone:NO];
    }
	
	
}

-(void)doneUpdate{
	
	[self.activity stopAnimating];
	
	if ([self.errorString isEqualToString:@""]) {
		
		self.displayLabel.text = @"Update Successful!";
		self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];		
		
		
	}else {
		self.displayLabel.text = self.errorString;
		self.displayLabel.textColor = [UIColor redColor];
	}
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        if ([self.toOrientation isEqualToString:@"right"]){
            return NO;
        }
    }
    
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        if ([self.toOrientation isEqualToString:@"left"]){
            return NO;
        }
    }
    
	if (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
		return YES;
	}
	
	return NO;
	
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	

        self.allWhiteView.hidden = NO;
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
            self.toOrientation = @"up";
        }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            self.toOrientation = @"left";
        }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
            self.toOrientation = @"right";
        }

    
	
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
                
            
            self.allWhiteView.hidden = YES;
            
            if (fromInterfaceOrientation == UIInterfaceOrientationPortrait) {                
                
                [self.navigationController.view addSubview:self.largeImageView];
                
                [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
                
            }else {        
                if(self.profilePic.image.size.height > self.profilePic.image.size.width){
                    //Portrait
                    self.profilePic.frame = CGRectMake(56, 84, 210, 280);
                    
                }else{
                    //Landscape
                    self.profilePic.frame = CGRectMake(0, 94, 320, 240);
                }
                
                [self.largeImageView removeFromSuperview];
                [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
            }

        
        

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}


- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)viewDidUnload{
	
	removeButton = nil;
	addChangeButton = nil;
	profilePic = nil;
	titleLabel = nil;
	loadingImageLabel = nil;
	loadingImageActivity = nil;
	displayLabel = nil;
	activity = nil;
	allWhiteView = nil;
	[super viewDidUnload];
	
}


@end
