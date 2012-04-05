//
//  CameraSelectionTeamPicture.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraSelectionTeamPicture.h"
#import "TeamPicture.h"
#import "CurrentTeamTabs.h"
@implementation CameraSelectionTeamPicture


-(void)viewDidLoad{
	
	
	
}


-(void)viewDidAppear:(BOOL)animated{
	
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
	
	UIImageView *tmpView = [[UIImageView alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
	
    float xVal;
    float yVal;
    
    if (tmpView.image.size.height > tmpView.image.size.width) {
        //Portrait
        xVal = 240.0;
        yVal = 320.0;
        
    }else{
        //Landscape
        xVal = 320.0;
        yVal = 240.0;
        
    }
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpView.image, 1.0);
	
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	
	NSArray *views = [self.navigationController viewControllers];
    
	if ([TeamPicture class] == [[views objectAtIndex:[views count] - 3] class]) {
		TeamPicture *tmpController = (TeamPicture *)[views objectAtIndex:[views count] - 3];
		
		tmpController.fromCameraSelect = true;
		tmpController.imageData = UIImageJPEGRepresentation(newImage1, 0.95);
		tmpController.selectedImage = [UIImage imageWithData:tmpController.imageData];
        
		tmpController.newImage = true;
		
        if ([TeamPicture class] == [[views objectAtIndex:[views count] - 3] class]) {
            TeamPicture *tmpController1 = (TeamPicture *)[views objectAtIndex:[views count] - 3];
            
            tmpController1.fromCameraSelect = true;
            tmpController1.imageData = UIImageJPEGRepresentation(newImage1, 0.95);
            tmpController1.selectedImage = [UIImage imageWithData:tmpController.imageData];
            
            tmpController1.newImage = true;
            [self.navigationController popToViewController:tmpController1 animated:NO];
        }else if ([TeamPicture class] == [[views objectAtIndex:[views count] - 2] class]) {            
            TeamPicture *tmpController2 = (TeamPicture *)[views objectAtIndex:[views count] - 2];
            
            tmpController2.fromCameraSelect = true;
            tmpController2.imageData = UIImageJPEGRepresentation(newImage1, 0.95);
            tmpController2.selectedImage = [UIImage imageWithData:tmpController.imageData];
            tmpController2.newImage = true;
            [self.navigationController popToViewController:tmpController2 animated:NO];
        }
        
	}else if ([TeamPicture class] == [[views objectAtIndex:[views count] - 2] class]) {
        
        
		TeamPicture *tmpController = (TeamPicture *)[views objectAtIndex:[views count] - 2];
		
		tmpController.fromCameraSelect = true;
		tmpController.imageData = UIImageJPEGRepresentation(newImage1, 0.95);
		tmpController.selectedImage = [UIImage imageWithData:tmpController.imageData];
		tmpController.newImage = true;
		[self.navigationController popToViewController:tmpController animated:NO];
	}
	
	
	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	[picker dismissModalViewControllerAnimated:YES];	
	
	NSArray *views = [self.navigationController viewControllers];
    
	if ([TeamPicture class] == [[views objectAtIndex:[views count] - 3] class]) {
		TeamPicture *tmpController = (TeamPicture *)[views objectAtIndex:[views count] - 3];
		
		[self.navigationController popToViewController:tmpController animated:NO];
	}else if ([TeamPicture class] == [[views objectAtIndex:[views count] - 2] class]) {
		TeamPicture *tmpController = (TeamPicture *)[views objectAtIndex:[views count] - 2];
		
        
		[self.navigationController popToViewController:tmpController animated:NO];
	}
    
	
	
}



@end

