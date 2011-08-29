//
//  CameraSelectionGame.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraSelectionGame.h"
#import "AddGamePhoto.h"
#import "CurrentTeamTabs.h"

@implementation CameraSelectionGame

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
	
    [myThumbNail release];

	UIGraphicsEndImageContext();
	
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 2;
	
    if (num >= 0) {
        
        if ([AddGamePhoto class] == [[temp objectAtIndex:num] class]){
            
            AddGamePhoto *tmpStack = [temp objectAtIndex:num];
            
            tmpStack.selectedImageData = UIImageJPEGRepresentation(newImage, 0.85);
            tmpStack.selectedImage = tmpImage;
            tmpStack.fromCameraSelect = true;
            tmpStack.portrait = isPort;
            [self.navigationController popToViewController:tmpStack animated:NO];
            
        }
        
    }
    
    if ((num - 1) >= 0){
        
        if ([AddGamePhoto class] == [[temp objectAtIndex:num - 1] class]){
            
            AddGamePhoto *tmpStack = [temp objectAtIndex:num - 1];
            
            tmpStack.selectedImageData = UIImageJPEGRepresentation(newImage, 0.85);
            tmpStack.selectedImage = tmpImage;
            tmpStack.fromCameraSelect = true;
            tmpStack.portrait = isPort;
            [self.navigationController popToViewController:tmpStack animated:NO];
            
        }
        
    }

	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 3;
	
	AddGamePhoto *cont = [temp objectAtIndex:num];
	
	[self.navigationController popToViewController:cont animated:NO];
	
}

-(void)dealloc{
	
	[super dealloc];
}

@end
