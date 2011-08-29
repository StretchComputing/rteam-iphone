//
//  CameraSelectionUser.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraSelectionUser.h"
#import "AddChangeProfilePic.h"

@implementation CameraSelectionUser


-(void)viewDidLoad{
	
	
	
}


-(void)viewDidAppear:(BOOL)animated{
	
	
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
	
	
	
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	UIImageView *tmpView = [[UIImageView alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
	
    float xVal;
    float yVal;
    
    if (tmpView.image.size.height > tmpView.image.size.width) {
        //Portrait
        xVal = 210.0;
        yVal = 280.0;
        
    }else{
        //Landscape
        xVal = 280.0;
        yVal = 210.0;
        
    }
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpView.image, 1.0);
	
	[tmpView release];
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	[myThumbNail release];
	
	NSArray *views = [self.navigationController viewControllers];
	
	if ([AddChangeProfilePic class] == [[views objectAtIndex:[views count] - 2] class]) {
		AddChangeProfilePic *tmpController = (AddChangeProfilePic *)[views objectAtIndex:[views count] - 2];
		
		tmpController.fromCameraSelect = true;
		tmpController.imageData = UIImageJPEGRepresentation(newImage1, 0.80);
		tmpController.selectedImage = [UIImage imageWithData:tmpController.imageData];
        tmpController.newImage = true;
		
		[self.navigationController popToViewController:tmpController animated:NO];
	}
	
	
	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	NSArray *views = [self.navigationController viewControllers];
	
	AddChangeProfilePic *tmpController = (AddChangeProfilePic *)[views objectAtIndex:[views count] - 2];
	
	
	[self.navigationController popToViewController:tmpController animated:NO];
	
	
}


-(void)dealloc{
	
	[super dealloc];
}

@end
