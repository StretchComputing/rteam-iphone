//
//  VideoDisplay.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoDisplay.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Base64.h"
#import "TraceSession.h"

@implementation VideoDisplay
@synthesize movieData, basePath, errorString, activityId, teamId, movieString, isPlayingMovie, activity, errorLabel;


-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"ImageDisplayMultiple - View Will Appear"];

    self.errorLabel.text = @"";
    if (!self.isPlayingMovie) {
        self.isPlayingMovie = true;
        [self performSelectorInBackground:@selector(getVideo) withObject:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)viewDidLoad{
    
    self.title = @"Video";
}

-(void)getVideo{
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            
            
            
            NSDictionary *response = [ServerAPI getActivityVideo:token :self.activityId :self.teamId];
            
            
            NSString *status = [response valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"100"]){
                
                self.movieString = [response valueForKey:@"video"];
                self.errorString = @"";
                
                
            }else{
                
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
                        //log status code?
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        
        [self performSelectorOnMainThread:@selector(doneImage) withObject:nil waitUntilDone:NO];

    }
		
}

-(void)doneImage{
	
	[self.activity stopAnimating];
	if ([self.errorString isEqualToString:@""]) {
		
		self.movieData = [Base64 decode:self.movieString];
		
        [self performSelector:@selector(playMovie)];
        self.errorLabel.text = @"";
		
	}else {
		self.errorLabel.text = @"*Error loading movie...";
	}
	
	
}



-(void)playMovie{
    
	NSArray * documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	self.basePath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
	
	[movieData writeToFile:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"] 
				atomically:YES];
	MPMoviePlayerViewController *tmpMoviePlayViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:[self.basePath stringByAppendingPathComponent:@"tmpMovie.MOV"]]];
	
	if (tmpMoviePlayViewController) {
		[self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController]; tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile; 
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieViewFinishedCallback1:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
		[tmpMoviePlayViewController.moviePlayer play];
		
		
	}
	
}

-(void)viewDidUnload{
    errorLabel = nil;
    activity = nil;
}

@end
