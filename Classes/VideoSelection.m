//
//  VideoSelection.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoSelection.h"
#import "AllActivity.h"
#import <MobileCoreServices/UTCoreTypes.h> 
#import "CurrentTeamTabs.h"
#import "TeamActivity.h"
#import "AddGamePhoto.h"

@implementation VideoSelection
@synthesize basePath, movieData;

-(void)viewDidLoad{
	
	
}



-(void)viewDidAppear:(BOOL)animated{
	
	
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
		
		[picker release];
	}
	@catch (NSException * e) {
		NSString *message1 = @"Video is not supported on this device.";
		UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Invalid Device" message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert1 show];
		
		[self.navigationController popViewControllerAnimated:NO];
		
	}
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];	

	NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
	NSData *movieData1 = [NSData dataWithContentsOfURL:videoURL];
	
	MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL: videoURL];
	player.useApplicationAudioSession = NO;
	player.shouldAutoplay = NO;
	UIImage *tmpImage = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
	[player release];

	NSArray *views = [self.navigationController viewControllers];
	

	if ([AllActivity class] == [[views objectAtIndex:[views count] - 2] class]) {
		AllActivity *belowStack = [views objectAtIndex:[views count] - 2];

		belowStack.movieData = movieData1;
		belowStack.selectedImageData = UIImageJPEGRepresentation(tmpImage, 1.0);
		belowStack.selectedImage = tmpImage;
		belowStack.fromCameraSelect = true;
		
		[self.navigationController popToViewController:belowStack animated:NO];

	
	}else if ([CurrentTeamTabs class] == [[views objectAtIndex:[views count] - 2] class]) {
		
		CurrentTeamTabs *belowStack = [views objectAtIndex:[views count] - 2];
		
		NSArray *tabs = [belowStack viewControllers];

		TeamActivity *tempController = [tabs objectAtIndex:1];

		
		tempController.movieData = movieData1;
		tempController.selectedImageData = UIImageJPEGRepresentation(tmpImage, 1.0);
		tempController.selectedImage = tmpImage;
		tempController.fromCameraSelect = true;
		
		[self.navigationController popToViewController:belowStack animated:NO];
		
		
	}else if ([AddGamePhoto class] == [[views objectAtIndex:[views count] - 2] class]) {
		
		AddGamePhoto *belowStack = [views objectAtIndex:[views count] - 2];
		
		belowStack.movieData = movieData1;
		belowStack.selectedImageData = UIImageJPEGRepresentation(tmpImage, 1.0);
		belowStack.selectedImage = tmpImage;
		belowStack.fromCameraSelect = true;
		
		[self.navigationController popToViewController:belowStack animated:NO];
		
	}
	
	if ([views count] > 2) {
		
		if ([CurrentTeamTabs class] == [[views objectAtIndex:[views count] - 3] class]) {
			
			CurrentTeamTabs *belowStack = [views objectAtIndex:[views count] - 3];
			
			TeamActivity *tempController = [[belowStack viewControllers] objectAtIndex:1];
			
			tempController.movieData = movieData1;
			tempController.selectedImageData = UIImageJPEGRepresentation(tmpImage, 1.0);
			tempController.selectedImage = tmpImage;
			tempController.fromCameraSelect = true;
			
			[self.navigationController popToViewController:belowStack animated:NO];
			
			
		}else if ([AllActivity class] == [[views objectAtIndex:[views count] - 3] class]) {
			
			AllActivity *belowStack = [views objectAtIndex:[views count] - 3];
			
			belowStack.movieData = movieData1;
			belowStack.selectedImageData = UIImageJPEGRepresentation(tmpImage, 1.0);
			belowStack.selectedImage = tmpImage;
			belowStack.fromCameraSelect = true;
			
			[self.navigationController popToViewController:belowStack animated:NO];
			
			
		}else if ([AddGamePhoto class] == [[views objectAtIndex:[views count] - 3] class]) {
			
			AddGamePhoto *belowStack = [views objectAtIndex:[views count] - 3];
			
			belowStack.movieData = movieData1;
			belowStack.selectedImageData = UIImageJPEGRepresentation(tmpImage, 1.0);
			belowStack.selectedImage = tmpImage;
			belowStack.fromCameraSelect = true;
			
			[self.navigationController popToViewController:belowStack animated:NO];
			
		}

		
	}
	
	
	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	NSArray *views = [self.navigationController viewControllers];

	
	if ([AllActivity class] == [[views objectAtIndex:[views count] - 2] class]) {
		
		AllActivity *belowStack = [views objectAtIndex:[views count] - 2];
		
		[self.navigationController popToViewController:belowStack animated:NO];

		
	}else if ([CurrentTeamTabs class] == [[views objectAtIndex:[views count] - 2] class]) {
		
		CurrentTeamTabs *belowStack = [views objectAtIndex:[views count] - 2];
		
		[self.navigationController popToViewController:belowStack animated:NO];

		
		
	} else if ([AddGamePhoto class] == [[views objectAtIndex:[views count] - 2] class]) {
		
		AddGamePhoto *belowStack = [views objectAtIndex:[views count] - 2];
		
		[self.navigationController popToViewController:belowStack animated:NO];
		
	}
	
	if ([views count] > 2) {
		if ([CurrentTeamTabs class] == [[views objectAtIndex:[views count] - 3] class]) {
			
			CurrentTeamTabs *belowStack = [views objectAtIndex:[views count] - 3];
			
			[self.navigationController popToViewController:belowStack animated:NO];
			
		}else if ([AllActivity class] == [[views objectAtIndex:[views count] - 3] class]) {
			
			AllActivity *belowStack = [views objectAtIndex:[views count] - 3];
			
			[self.navigationController popToViewController:belowStack animated:NO];
			
			
		}else if ([AddGamePhoto class] == [[views objectAtIndex:[views count] - 3] class]) {
			
			AddGamePhoto *belowStack = [views objectAtIndex:[views count] - 3];
	
			
			[self.navigationController popToViewController:belowStack animated:NO];
			
		}
	}
}

-(void)viewDidUnload{
	
	
}


-(void)dealloc{
	[movieData release];
	[basePath release];
	[super dealloc];
}

@end
