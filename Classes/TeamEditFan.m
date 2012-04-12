//
//  TeamEditFan.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeamEditFan.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation TeamEditFan
@synthesize errorLabel, activity, deleteButton, teamId, fromHome;

-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"TeamEditFan - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	
    self.title = @"Delete Team";
    
    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.deleteButton setBackgroundImage:stretch1 forState:UIControlStateNormal];

    
	
}



-(void)deleteTeam{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Team Edit Fan - Delete Team"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    [self.activity startAnimating];
    [self performSelectorInBackground:@selector(runDelete) withObject:nil];
}

-(void)runDelete{
    
    @autoreleasepool {
        
        NSString *errorString = @"";
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI deleteTeam:self.teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                
                if ([mainDelegate.quickLinkOne isEqualToString:self.teamId]) {
                    //if this first quick link team was just deleted
                    
                    mainDelegate.quickLinkOne = @"create";
                    mainDelegate.quickLinkOneName = @"";
                    
                    [mainDelegate saveUserInfo];
                }
                
                
                
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
                        //should never get here
                        errorString = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        
        [self performSelectorOnMainThread:@selector(doneDelete:) withObject:errorString waitUntilDone:NO];
        
    }
}

-(void)doneDelete:(NSString *)errorString{
    
    [self.activity stopAnimating];
    if ([errorString isEqualToString:@""]) {
        
        if (self.fromHome) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }else{
        self.errorLabel.text = errorString;
    }
}


-(void)viewDidUnload{

	errorLabel = nil;
	activity = nil;
    deleteButton = nil;

	[super viewDidUnload];
}


@end
