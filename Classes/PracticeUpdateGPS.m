//
//  PracticeUpdateGPS.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PracticeUpdateGPS.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "rTeamAppDelegate.h"
#import "PracticeNotes.h"
#import "PracticeTabs.h"
#import "FastActionSheet.h"
#import "Practice.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation PracticeUpdateGPS
@synthesize practiceId, teamId, locationName, action, lat, longt, locationManager, saveButton, useCurrentButton, updateSuccess, errorMessage, 
locationString, errorString,updateAllGames, nameOnly, updateLat, updateLong, allPracticesArray, haveGames, practiceSuccess, updateAllSuccess, theLocationName;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"PracticeUpdateGPS - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{

	self.allPracticesArray = [NSMutableArray array];
	self.haveGames = false;
	[self performSelectorInBackground:@selector(getAllPractices) withObject:nil];
	
	
	self.title = @"Practice Location";
	self.locationName.text = self.locationString;
	self.errorMessage.enabled = NO;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.useCurrentButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.saveButton setBackgroundImage:stretch forState:UIControlStateNormal];
}

-(void)save{
	
	self.nameOnly = true;
	
	[action startAnimating];
	[self.navigationItem setHidesBackButton:YES];
	self.saveButton.enabled = NO;
	self.useCurrentButton.enabled = NO;
	
    self.theLocationName = [NSString stringWithString:self.locationName.text];

    
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}

-(void)useCurrent{
	[action startAnimating];
	[self.navigationItem setHidesBackButton:YES];
	[self.saveButton setEnabled:NO];
	[self.useCurrentButton setEnabled:NO];
	self.saveButton.titleLabel.text = @"TEST";
	self.saveButton.enabled = NO;
	self.useCurrentButton.enabled = NO;
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	[locationManager startUpdatingLocation];
}


- (void)locationManager: (CLLocationManager *)manager
	didUpdateToLocation: (CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	
	double degrees = newLocation.coordinate.latitude;
	NSString *currentLat = [NSString stringWithFormat:@"%f", degrees];
	
	[self.saveButton setEnabled:NO];
	[self.useCurrentButton setEnabled:NO];
	
	degrees = newLocation.coordinate.longitude;
	NSString *currentLongt = [NSString stringWithFormat:@"%f", degrees];
	
	self.updateLat = currentLat;
	self.updateLong = currentLongt;
	
    if (self.locationName.text == nil) {
        self.locationName.text = @"";
    }
	
    self.theLocationName = [NSString stringWithString:self.locationName.text];
    
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
}
- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error
{
}

- (void)runRequest {

	@autoreleasepool {
        
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Update Location - Practice"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
        NSString *locationStr = @"";
        NSString *paramLat = @"";
        NSString *paramLong = @"";
        
        if (self.nameOnly) {
            
            locationStr = self.theLocationName;
            
        }else {
            
            paramLat = self.updateLat;
            paramLong = self.updateLong;
            
            if (![self.theLocationName isEqualToString:@""] && (self.theLocationName != nil)) {
                locationStr =self.theLocationName;
            }
        }
        
        
        NSString *updateAll = @"";
        
        if (self.updateAllGames.selectedSegmentIndex == 0) {
            updateAll = @"true";
        }
        
        //rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        NSDictionary *response =@{};
        //If there is a token, do a DB lookup to find the practice info 
        if (![token isEqualToString:@""]){
            
            response = [ServerAPI updateEvent:token :self.teamId :self.practiceId :@"" :@"" :@"" :@"" :paramLat :paramLong :locationStr :@"" :@"" :updateAll :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.updateSuccess = true;
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                self.updateSuccess = false;
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
                        //log status code
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        [self performSelectorOnMainThread:
         @selector(didFinish)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[action stopAnimating];
	
	if (self.updateSuccess){
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 2;
		
		PracticeTabs *cont = tempCont[tempNum];
		NSArray *viewControllers = cont.viewControllers;
		
		PracticeNotes *currentNotes = viewControllers[0];
		currentNotes.fromNextUpdate = true;
		
		[self.navigationController popToViewController:cont animated:YES];
		
	}else {
		//if it failed, re-enable all fields so user can make changes
		self.errorMessage.text = self.errorString;
		self.errorMessage.enabled = YES;
		self.saveButton.enabled = YES;
		self.useCurrentButton.enabled = YES;
		[self.navigationItem setHidesBackButton:NO];
		
		
	}
	
}

-(void)endText{
	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}




- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)getAllPractices{
	
	@autoreleasepool {
        NSString *token = @"";
        
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfEvents:self.teamId :token :@"practice"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.allPracticesArray = [response valueForKey:@"events"];
                self.haveGames = true;
                self.practiceSuccess = true;
                
            }else{
                
                self.practiceSuccess = false;
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.error.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.error.text = @"*Error connecting to server";
                        break;
                    default:
                        //Game retrieval failed, log error code?
                        //self.error.text = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }

    }
			
}





-(void)viewDidUnload{

	locationName = nil;
	action = nil;

	locationManager = nil;
	useCurrentButton = nil;
	saveButton = nil;
	errorMessage = nil;

	[super viewDidUnload];
	
	
}

@end
