//
//  AddGamePhoto.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddGamePhoto.h"
#import "FastActionSheet.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "TraceSession.h"

@implementation AddGamePhoto
@synthesize hideAction, photoAction, newPhotoButton, submitButton, imagePreview, stayHere, imageData, activityText, countLabel, noImageLabel,
errorLabel, submitActivity, errorString, teamId, fromCameraSelect, selectedImage, selectedImageData, removePhotoButton, movieData, portrait, theActivityText;

-(void)viewDidLoad{
    
	self.title = @"Game Photo";
	self.countLabel.text = @"140";
	self.activityText.delegate = self;
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.newPhotoButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.imageData = nil;
	self.imagePreview.image = nil;
	self.errorLabel.textColor = [UIColor redColor];
	self.removePhotoButton.hidden = YES;
    
    self.imagePreview.layer.masksToBounds = YES;
    self.imagePreview.layer.cornerRadius = 7.0;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"AddGamePhoto - View Did Appear"];

    
	if (!self.hideAction) {
        
		self.photoAction = [[UIActionSheet alloc] initWithTitle:@"Post a Game Photo or Video to Activity?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", @"Take Video", nil];
		self.photoAction.actionSheetStyle = UIActionSheetStyleDefault;
		[self.photoAction showInView:self.view];
	}
	
	if (self.fromCameraSelect) {
		
		self.imagePreview.image = self.selectedImage;
        
        if(self.imagePreview.image.size.height > self.imagePreview.image.size.width){
            //Portrait
            self.imagePreview.frame = CGRectMake(84, 117, 150, 200);
        }else{
            
            self.imagePreview.frame = CGRectMake(59, 142, 200, 150);
            
        }
		self.imageData = self.selectedImageData;
		self.fromCameraSelect = false;
		self.noImageLabel.hidden = YES;
		self.removePhotoButton.hidden = NO;
        
		
	}
	
	[self becomeFirstResponder];
    
    
}

-(void)newPhoto{
	self.errorLabel.text = @"";
    
	self.photoAction = [[UIActionSheet alloc] initWithTitle:@"Post a Game Photo or Video to Activity?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", @"Take Video", nil];
	self.photoAction.actionSheetStyle = UIActionSheetStyleDefault;
	[self.photoAction showInView:self.view];
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
	self.errorLabel.text = @"";
    
	
	if (![string isEqualToString:@"\n"]) {
		
		int charLeft = 140 - newLength;
		
		if (charLeft <= 0) {
			charLeft = 0;
		}
		self.countLabel.text = [NSString stringWithFormat:@"%d", charLeft];
		
		
	}
	
	
    return (newLength > 140) ? NO : YES;
}


-(void)submit{
	self.errorLabel.text = @"";
	if ((self.imageData == nil) && [self.activityText.text isEqualToString:@""]) {
		self.errorLabel.text = @"*Choose an image or enter text.";
	}else {
		
		//There is at least an image or activity text
		
		if ([self.activityText.text isEqualToString:@""]) {
			self.activityText.text = @"Check out this game picture!";
		}
		
		[self.submitActivity startAnimating];
		self.newPhotoButton.enabled = NO;
		self.submitButton.enabled = NO;
		self.activityText.enabled = NO;
		self.removePhotoButton.enabled = NO;
        
        self.theActivityText = [NSString stringWithString:self.activityText.text];
        
		[self performSelectorInBackground:@selector(createActivity) withObject:nil];
		
		
	}
    
	
}


-(void)createActivity{
    
	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
            NSData *tmpData = [NSData data];
            
            if ([self.imageData length] > 0) {
                tmpData = self.imageData;
            }
            
            NSData *tmpMovieData = [NSData data];
            
            
            if ([self.movieData length] > 0) {
                tmpMovieData = self.movieData;
            }
            
            NSString *orientation = @"";
            
            if ([tmpData length] > 0) {
                
                if (self.portrait) {
                    orientation = @"portrait";
                }else{
                    orientation = @"landscape";
                }
            }
                        
            NSDictionary *response = [ServerAPI createActivity:token teamId:self.teamId statusUpdate:self.theActivityText photo:tmpData video:tmpMovieData orientation:orientation replyToId:@"" eventId:@"" newGame:@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString = @"";
                
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
                    default:
                        //log status code?
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        [self performSelectorOnMainThread:@selector(doneActivity) withObject:nil waitUntilDone:NO];

    }

}

-(void)doneActivity{
	
	self.newPhotoButton.enabled = YES;
	self.submitButton.enabled = YES;
	self.activityText.enabled = YES;
	self.removePhotoButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		//success
		self.errorLabel.text = @"Submit Successful!";
		self.errorLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
		[self performSelector:@selector(doneSuccess) withObject:nil afterDelay:1];
        
	}else {
		self.errorLabel.text = self.errorString;
		[self.submitActivity stopAnimating];
        
	}
    
	
}

-(void)doneSuccess{
    
	[self.navigationController popViewControllerAnimated:NO];
	
}
-(void)getImageCamera{
    
    /*
	self.hideAction = true;
    
	CameraSelectionGame *tmp = [[CameraSelectionGame alloc] init];
	
	[self.navigationController pushViewController:tmp animated:NO];
	
	*/
}

-(void)getImageVideo{
    /*
	self.hideAction = true;
	
	VideoSelection *tmp = [[VideoSelection alloc] init];
	
	[self.navigationController pushViewController:tmp animated:NO];
	*/
	
}

-(void)getImageLibrary{
	
	self.hideAction = true;
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	//picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:picker animated:YES];
	
	
	
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	self.noImageLabel.hidden = YES;
	
	UIImage *tmpImage = info[UIImagePickerControllerOriginalImage];
	
    float xVal;
    float yVal;
    
    if (tmpImage.size.height > tmpImage.size.width) {
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
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpImage, 1.0);
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
	
    
	UIGraphicsEndImageContext();
	
    
	self.imageData = UIImageJPEGRepresentation(newImage, 1.0);
	
	self.imagePreview.image = tmpImage;
    
    if(self.imagePreview.image.size.height > self.imagePreview.image.size.width){
        //Portrait
        self.imagePreview.frame = CGRectMake(84, 117, 150, 200);
    }else{
        
        self.imagePreview.frame = CGRectMake(59, 142, 200, 150);
        
    }
    
	self.removePhotoButton.hidden = NO;
	
	
} 



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == self.photoAction) {
		
		if (buttonIndex == 0) {
			//Take picture
			self.stayHere = true;
			[self getImageCamera];
		}else if (buttonIndex == 1) {
			//choose picture
			self.stayHere = true;
			[self getImageLibrary];
		}else if (buttonIndex == 2) {
			self.stayHere = true;
			[self getImageVideo];
		}else {
			//Cancel
			if (!self.stayHere) {
				[self.navigationController popViewControllerAnimated:NO];
			}
		}
        
		
        
		
	}else{
		[FastActionSheet doAction:self :buttonIndex];
        
	}
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)endText{
	
	[self becomeFirstResponder];
	
}

-(void)removePhoto{
	
	self.imageData = nil;
	self.imagePreview.image = nil;
	self.removePhotoButton.hidden = YES;
	self.noImageLabel.hidden = NO;
	
}

-(void)viewDidUnload{
	
	newPhotoButton = nil;
	submitButton = nil;
	imagePreview = nil;
	activityText = nil;
	countLabel = nil;
	noImageLabel = nil;
	errorLabel = nil;
	submitActivity = nil;
	removePhotoButton = nil;
	[super viewDidUnload];
	
	
}

@end
