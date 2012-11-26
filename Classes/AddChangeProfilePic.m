//
//  AddChangeProfilePic.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddChangeProfilePic.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Base64.h"
#import "CameraSelectionUser.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation AddChangeProfilePic
@synthesize removeButton, addChangeButton, profilePic, titleLabel, loadingImageLabel, loadingImageActivity, displayLabel, addImage, hasImage,
imageString, imageData, fromCameraSelect, selectedImage, activity, errorString, newImage, portrait;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"AddChangeProfilePic - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	

	
	if (self.fromCameraSelect) {
		
		self.profilePic.image = selectedImage;
        
        if (self.profilePic.image.size.height > self.profilePic.image.size.width) {
            //Portrait
            self.profilePic.frame = CGRectMake(71, 97, 180, 240);
            self.portrait = true;
        }else{
            //Landscape
            self.profilePic.frame = CGRectMake(40, 105, 240, 180);
            self.portrait = false;

        }
		[self.addChangeButton setTitle:@"Change" forState:UIControlStateNormal];
		self.removeButton.hidden = NO;
		self.titleLabel.text = @"Your current profile picture.";
		
		[self.activity startAnimating];
		[self performSelectorInBackground:@selector(updateImage) withObject:nil];
        self.fromCameraSelect = false;
	}
	
}
-(void)viewDidLoad{
	
	self.title = @"Profile Pic";
	
    if (!self.newImage) {
        
        self.loadingImageLabel.hidden = NO;
        [self.loadingImageActivity startAnimating];
        [self performSelectorInBackground:@selector(getImage) withObject:nil];
        
        self.profilePic.image = nil;
        self.removeButton.hidden = YES;
        self.addChangeButton.hidden = YES;
    }else{
        self.loadingImageLabel.hidden = YES;
        self.newImage = false;
    }
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.addChangeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.removeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	

	
}


-(void)getImage{

    @autoreleasepool {
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getUserInfo:token :@"true"];
            
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSDictionary *info = [response valueForKey:@"userInfo"];
                
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
	self.addChangeButton.hidden = NO;
	if (self.hasImage) {
		
		self.removeButton.hidden = NO;
		[self.addChangeButton setTitle:@"Change" forState:UIControlStateNormal];
		
		NSData *tmpData = [Base64 decode:self.imageString];
		
		self.profilePic.image = [UIImage imageWithData:tmpData];
        
        if (self.profilePic.image.size.height > self.profilePic.image.size.width) {
            //Portrait
            self.profilePic.frame = CGRectMake(71, 97, 180, 240);
        }else{
            //Landscape
            self.profilePic.frame = CGRectMake(40, 105, 240, 180);
            
        }
        
		self.titleLabel.text = @"Your current profile picture";

		
	}else {
		
		self.profilePic.image = [UIImage imageNamed:@"profile1.png"];
		self.titleLabel.text = @"You currently have no uploaded picture.";
		self.removeButton.hidden = YES;
	}

}




-(void)remove{
	self.displayLabel.text = @"";
	self.addImage = false;
	self.profilePic.image = [UIImage imageNamed:@"profile1.png"];
	self.titleLabel.text = @"You currently have no uploaded picture.";
	[self.addChangeButton setTitle:@"Add" forState:UIControlStateNormal];
	self.removeButton.hidden = YES;
	
	[self.activity startAnimating];
	[self performSelectorInBackground:@selector(updateImage) withObject:nil];
}

-(void)addChange{
	
	self.addImage = true;
	self.displayLabel.text = @"";

	UIActionSheet *tmpSheet =  [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
	tmpSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [tmpSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
		if (buttonIndex == 0) {
			//Take
			[self getPhoto:@"camera"];
		}else if (buttonIndex == 1){
			//ChoosePhoto
			[self getPhoto:@"library"];
			
		}


}


-(void)getPhoto:(NSString *)option {
	
	
	if([option isEqualToString:@"library"]) {
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:picker animated:YES];
				
	} else {
		
		CameraSelectionUser *tmp = [[CameraSelectionUser alloc] init];
		[self.navigationController pushViewController:tmp animated:NO];
	}
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];	
	
	UIImageView *tmpView = [[UIImageView alloc] initWithImage:info[UIImagePickerControllerOriginalImage]];
	
    float xVal;
    float yVal;
    
    if (tmpView.image.size.height > tmpView.image.size.width) {
        //Portrait
        xVal = 210.0;
        yVal = 280.0;
        self.portrait = true;
        
    }else{
        //Landscape
        xVal = 280.0;
        yVal = 210.0;
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
	
	self.profilePic.image = tmpImage;
        
    if (self.profilePic.image.size.height > self.profilePic.image.size.width) {
        //Portrait
        self.profilePic.frame = CGRectMake(71, 97, 180, 240);
    }else{
        //Landscape
        self.profilePic.frame = CGRectMake(40, 105, 240, 180);
        
    }

	[self.addChangeButton setTitle:@"Change" forState:UIControlStateNormal];
	self.removeButton.hidden = NO;
	self.titleLabel.text = @"Your current profile picture.";
    self.newImage = true;
	[self.activity startAnimating];
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Add/Change Profile Picture"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
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
        
        NSString *addRemove = @"";
        
        if (!self.addImage) {
            addRemove = @"remove";
        }
        
        NSData *tmpData = [NSData data];
        
        if (self.imageData != nil) {
            tmpData = [NSData dataWithData:self.imageData];
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
            
            
            NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :@"" :@"" :@""
                                                          :@"" :@"" :@""
                                                          :@"" :@"" :@"" :tmpData :addRemove :orientation :@"" :@"" :@"" :@""];
            
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




-(void)viewDidUnload{
	
	removeButton = nil;
	addChangeButton = nil;
	profilePic = nil;
	titleLabel = nil;
	loadingImageLabel = nil;
	loadingImageActivity = nil;
	displayLabel = nil;
	activity = nil;
	[super viewDidUnload];
	
}



@end
