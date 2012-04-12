//
//  CameraSelectionTeam.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraSelectionTeam.h"
#import "CurrentTeamTabs.h"
#import "TraceSession.h"

@implementation CameraSelectionTeam


-(void)viewDidLoad{
	
	
	
}

-(void)viewDidAppear:(BOOL)animated{
	
    [TraceSession addEventToSession:@"CameraSelectionTeam - View Did Appear"];

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
	
	UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
    float xVal;
    float yVal;
    
    bool isPort;
    
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
	
	//UIImage *newImage    = UIGraphicsGetImageFromCurrentImageContext();
	
    
	UIGraphicsEndImageContext();
	
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 3;
	
    bool shouldRun = true;
    
    if (num >= 0) {
        if ([CurrentTeamTabs class] == [[temp objectAtIndex:num] class]) {
            shouldRun = false;
            CurrentTeamTabs *cont = [temp objectAtIndex:num];
            
            
            //NSArray *tabs = [cont viewControllers];
            
           
            
            [self.navigationController popToViewController:cont animated:NO];
            
            
        } 
    }
    
    num++;
    
    if (shouldRun){
        if (num >= 0) {
            
            if ([CurrentTeamTabs class] == [[temp objectAtIndex:num] class]){
                
                CurrentTeamTabs *cont = [temp objectAtIndex:num];
                
                
               // NSArray *tabs = [cont viewControllers];
                
            
                
                [self.navigationController popToViewController:cont animated:NO];
                
            }
        }
        
    }
    
	
} 

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
	[picker dismissModalViewControllerAnimated:YES];	
	
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	num = num - 3;
    
    bool shouldRun = true;
    
    if (num >= 0) {
        if ([CurrentTeamTabs class] == [[temp objectAtIndex:num] class]) {
            shouldRun = false;
            CurrentTeamTabs *cont = [temp objectAtIndex:num];
            
            [self.navigationController popToViewController:cont animated:NO];
            
            
        } 
    }
    
    num++;
    
    if (shouldRun){
        if (num >= 0) {
            
            if ([CurrentTeamTabs class] == [[temp objectAtIndex:num] class]){
                
                CurrentTeamTabs *cont = [temp objectAtIndex:num];
                
                
                [self.navigationController popToViewController:cont animated:NO];
                
            }
        }
        
    }
    
	
}


@end
