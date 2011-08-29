//
//  CameraSelectionProfile.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraSelectionProfile.h"
#import "Player.h"
#import "Fan.h"

@implementation CameraSelectionProfile


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
    
    bool isPort;
    
    if (tmpView.image.size.height > tmpView.image.size.width) {
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
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpView.image, 1.0);
	
	[tmpView release];
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	[myThumbNail release];
	
	NSArray *views = [self.navigationController viewControllers];
	
    int count = [views count];
    
    if ((count - 2) >= 0) {
        
        if ([Player class] == [[views objectAtIndex:[views count] - 2] class]) {
            Player *tmpController = (Player *)[views objectAtIndex:[views count] - 2];
            
            tmpController.fromCameraSelect = true;
            tmpController.selectedData = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.selectedImage = [UIImage imageWithData:tmpController.selectedData];
            tmpController.compressImage = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.profilePhotoButton.enabled = YES;
            tmpController.portrait = isPort;
            [self.navigationController popToViewController:tmpController animated:NO];
        }else if ([Fan class] == [[views objectAtIndex:[views count] - 2] class]) {
            Fan *tmpController = (Fan *)[views objectAtIndex:[views count] - 2];
            
            tmpController.fromCameraSelect = true;
            tmpController.selectedData = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.selectedImage = [UIImage imageWithData:tmpController.selectedData];
            tmpController.compressImage = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.profilePhotoButton.enabled = YES;
            tmpController.portrait = isPort;

            [self.navigationController popToViewController:tmpController animated:NO];
        }
        
    }
    if ((count - 3) >= 0) {
        
        if ([Player class] == [[views objectAtIndex:[views count] - 3] class]) {
            
            Player *tmpController = (Player *)[views objectAtIndex:[views count] - 3];
            
            tmpController.fromCameraSelect = true;
            tmpController.selectedData = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.selectedImage = [UIImage imageWithData:tmpController.selectedData];
            tmpController.compressImage = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.profilePhotoButton.enabled = YES;
            tmpController.profilePhotoButton.enabled = YES;
            tmpController.portrait = isPort;

            [self.navigationController popToViewController:tmpController animated:NO];
            
        }else if ([Fan class] == [[views objectAtIndex:[views count] - 3] class]) {
            Fan *tmpController = (Fan *)[views objectAtIndex:[views count] - 3];
            
            tmpController.fromCameraSelect = true;
            tmpController.selectedData = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.selectedImage = [UIImage imageWithData:tmpController.selectedData];
            tmpController.compressImage = UIImageJPEGRepresentation(newImage1, 0.80);
            tmpController.profilePhotoButton.enabled = YES;
            tmpController.portrait = isPort;

            [self.navigationController popToViewController:tmpController animated:NO];
        }
        
    }
	

	
	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	[picker dismissModalViewControllerAnimated:YES];	
    
    NSArray *views = [self.navigationController viewControllers];

	int count = [views count];
    
    if ((count - 2) >= 0) {
        
        if ([Player class] == [[views objectAtIndex:[views count] - 2] class]) {
            Player *tmpController = (Player *)[views objectAtIndex:[views count] - 2];
      
            
            [self.navigationController popToViewController:tmpController animated:NO];
        }else if ([Fan class] == [[views objectAtIndex:[views count] - 2] class]) {
            Fan *tmpController = (Fan *)[views objectAtIndex:[views count] - 2];
         
            
            [self.navigationController popToViewController:tmpController animated:NO];
        }
        
    }
    if ((count - 3) >= 0) {
        
        if ([Player class] == [[views objectAtIndex:[views count] - 3] class]) {
            
            Player *tmpController = (Player *)[views objectAtIndex:[views count] - 3];
                     
            [self.navigationController popToViewController:tmpController animated:NO];
            
        }else if ([Fan class] == [[views objectAtIndex:[views count] - 3] class]) {
            Fan *tmpController = (Fan *)[views objectAtIndex:[views count] - 3];
          
            
            [self.navigationController popToViewController:tmpController animated:NO];
        }
        
    }
	
	
}


-(void)dealloc{
	
	[super dealloc];
}

@end
