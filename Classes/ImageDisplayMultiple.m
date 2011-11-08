//
//  ImageDisplayMultiple.m
//  ServiceNow-LiveFeed
//
//  Created by Nick Wroblewski on 10/3/11.
//  Copyright 2011 Fruition Partners. All rights reserved.
//

#import "ImageDisplayMultiple.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Base64.h"

@implementation ImageDisplayMultiple
@synthesize imageDataArray, didReply, commentText, isFullScreen, replyButton, isPortrait, myScrollview, currentPage, bigImageView, bigScrollView, activityId, teamId, encodedPhoto;


-(void)viewDidAppear:(BOOL)animated{
 
}


- (void)viewDidLoad
{
    self.myScrollview.hidden = YES;
    self.imageDataArray = [NSMutableArray array];
    [self performSelectorInBackground:@selector(getLargeImages) withObject:nil];
    self.currentPage = 0;
    self.title = @"Images";
    self.isFullScreen = false;
    


    self.bigScrollView.delegate = self;

    UITapGestureRecognizer *oneTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(goSmall:)];
    oneTap.numberOfTapsRequired = 1;
    [self.bigScrollView addGestureRecognizer:oneTap];
    
    
    self.bigScrollView.maximumZoomScale = 5.0;
    self.bigScrollView.minimumZoomScale = 1.0;
    self.bigScrollView.clipsToBounds = YES;

    self.bigScrollView.hidden= YES;

    [super viewDidLoad];
}

-(void)loadMyScroll{
    
    self.myScrollview.hidden = NO;
    int count = [self.imageDataArray count];

    self.myScrollview.contentSize = CGSizeMake(count * 320, 416);
    self.myScrollview.pagingEnabled = YES;
    
    for (int i = 0; i < count; i++) {
        
        UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 416)];
        addView.contentMode = UIViewContentModeScaleAspectFit;
        addView.image = [UIImage imageWithData:[self.imageDataArray objectAtIndex:i]];
        [self.myScrollview addSubview:addView];
    }
    
    self.myScrollview.delegate = self;
    UITapGestureRecognizer *singleTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(goBig:)];
    singleTap.numberOfTapsRequired = 1;
    [self.myScrollview addGestureRecognizer:singleTap];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == self.myScrollview){
        
        if (!self.isFullScreen) {
            double xOff = self.myScrollview.contentOffset.x;
            
            self.currentPage = floor(xOff/320.0);
        }
       
    }
}
-(void)resetScroll{
    
    [self.myScrollview removeFromSuperview];
    
    self.myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];

    int count = [self.imageDataArray count];
    self.myScrollview.contentSize = CGSizeMake(count * 320, 416);
    self.myScrollview.pagingEnabled = YES;
    
    for (int i = 0; i < count; i++) {
        
        UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 416)];
        addView.contentMode = UIViewContentModeScaleAspectFit;
        addView.image = [UIImage imageWithData:[self.imageDataArray objectAtIndex:i]];
        [self.myScrollview addSubview:addView];
    }
    self.myScrollview.delegate = self;
    UITapGestureRecognizer *singleTap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(goBig:)];
    singleTap.numberOfTapsRequired = 1;
    [self.myScrollview addGestureRecognizer:singleTap];
    
    [self.view bringSubviewToFront:self.myScrollview];
    [self.view addSubview:self.myScrollview];
     
    
}

-(void)goSmall:(id)sender{

    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];     
        
    [self resetScroll];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    self.replyButton.hidden = NO;
    self.commentText.hidden = NO;
    
    self.myScrollview.hidden = NO;
    self.bigScrollView.hidden = YES;
    
    self.myScrollview.frame = CGRectMake(0, 0, 320, 416);
        
    [self.myScrollview setContentOffset:CGPointMake(320*self.currentPage, 0) animated:NO];
     
    self.isFullScreen = false;
    
    //UIViewController *c = [[UIViewController alloc]init];
    //[self presentModalViewController:c animated:NO];
    //[self dismissModalViewControllerAnimated:NO];

}

-(void)goBig:(id)sender{
    
    self.isFullScreen = true;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.replyButton.hidden = YES;
    self.commentText.hidden = YES;
    self.bigImageView.image = [UIImage imageWithData:[self.imageDataArray objectAtIndex:self.currentPage]];
    self.bigScrollView.hidden = NO;
    self.myScrollview.hidden = YES;
    

}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.isFullScreen) {
        
        return self.bigImageView;
    }
    return nil;
}







- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    if (self.isFullScreen) {
        
        if (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
            return YES;
        }
        
    }
	
	
	return NO;
	
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
        if (self.isPortrait) {
            self.bigScrollView.frame = CGRectMake(0, 0, 320, 480);
            
        }else{
            self.bigScrollView.frame = CGRectMake(0, 0, 320, 480);
        }
        
    }else{
        
        if (self.isPortrait) {
            self.bigScrollView.frame = CGRectMake(0, 0, 480, 320);
            
        }else{
            self.bigScrollView.frame = CGRectMake(0, 0, 480, 320);
        }
        
    }
    
    
	
}

-(void)getLargeImages{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        NSString *errorString = @"";
        
        if (![token isEqualToString:@""]){	
            
            NSDictionary *response = [ServerAPI getActivityImage:token :self.activityId :self.teamId];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.encodedPhoto = [response valueForKey:@"photo"];
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        errorString = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        errorString = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        errorString = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        
        [self performSelectorOnMainThread:@selector(doneImage:) withObject:errorString waitUntilDone:NO];
    }
	
	
}

-(void)doneImage:(NSString *)errorString{
	

	
	if ([errorString isEqualToString:@""]) {
		
		NSData *profileData = [Base64 decode:self.encodedPhoto];
		
        [self.imageDataArray addObject:profileData];
        
        [self loadMyScroll];

	}else {

	}
    
	
}



- (void)viewDidUnload
{
    commentText = nil;
    replyButton = nil;
    myScrollview = nil;
    [super viewDidUnload];
    
}



@end