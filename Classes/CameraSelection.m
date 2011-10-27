//
//  CameraSelection.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraSelection.h"

@implementation CameraSelection


-(void)viewDidLoad{
	
	
}

-(void)viewDidAppear:(BOOL)animated{
	
	
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:picker animated:YES];
	
	
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	/*
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
    }else{
        //Landscape
        xVal = 280.0;
        yVal = 210.0;
        isPort = false;
        
    }
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpImage, 1.0);
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
    
	NSArray *views = [self.navigationController viewControllers];
	
    
	AllActivity *belowStack = [views objectAtIndex:[views count] - 2];
	
	belowStack.selectedImageData = UIImageJPEGRepresentation(newImage, 0.80);
    
	belowStack.portrait = isPort;
	belowStack.selectedImage = tmpImage;
	belowStack.fromCameraSelect = true;
	*/
	[self.navigationController popViewControllerAnimated:NO];
	
	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	[picker dismissModalViewControllerAnimated:YES];	
    
	[self.navigationController popViewControllerAnimated:NO];
	
}

-(void)viewDidUnload{
	
	
}



@end
