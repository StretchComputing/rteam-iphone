//
//  PracticeNotes.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PracticeNotes.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "JSON/JSON.h"
#import "PracticeUpdateGPS.h"
#import "MapLocation.h"
#import "PracticeEdit.h"
#import "TraceSession.h"
#import "GANTracker.h"

@implementation PracticeNotes
@synthesize practiceId, teamId, opponent, day, time, description, locationManager, updateSuccess, latitude, longitude, 
fromNextUpdate, errorLabel, updateLocationButton, viewMapButton, userRole, editDone, opponentString, descriptionString, startDateString, loading,
errorString, dayString, timeString;

-(void)viewDidLoad{
	

	self.tabBarController.navigationItem.title = @"Practice Day";

	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.viewMapButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.updateLocationButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
		
		
		[self.updateLocationButton setHidden:NO];
		
	}else {
		[self.updateLocationButton setHidden:YES];
	}
	
	
	
	
	[self.loading startAnimating];

	self.latitude = @"";
	self.longitude = @"";
	self.viewMapButton.hidden = YES;
	
}

-(void)editPractice{
	
    [TraceSession addEventToSession:@"PracticeDay - Edit Button Clicked"];

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Edit Practice"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	PracticeEdit *editPractice = [[PracticeEdit alloc] init];
	
	editPractice.stringDate = self.startDateString;
	editPractice.opponent = self.opponentString;
	editPractice.description = self.descriptionString;
	editPractice.teamId = self.teamId;
	editPractice.practiceId = self.practiceId;
	
	
	[self.navigationController pushViewController:editPractice animated:YES];
	
}


-(void)viewWillAppear:(BOOL)animated{
	if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		self.editDone = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPractice)];
		[self.tabBarController.navigationItem setRightBarButtonItem:self.editDone];
	}
	
	[self.loading startAnimating];
	[self performSelectorInBackground:@selector(getPracticeInfo) withObject:nil];
	
	
}

-(void)getPracticeInfo{

	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        NSDictionary *practiceInfo = [NSDictionary dictionary];
        
        //If there is a token, do a DB lookup to find the game info 
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getEventInfo:self.practiceId :self.teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                practiceInfo = [response valueForKey:@"eventInfo"];
                
                NSString *startDate = [practiceInfo valueForKey:@"startDate"];
                self.startDateString = [practiceInfo valueForKey:@"startDate"];
                //NSString *endDate = [gameInfo valueForKey:@"endDate"];
                NSString *desc = [practiceInfo valueForKey:@"description"];
                NSString *opp = [practiceInfo valueForKey:@"opponent"];
                
                if ([practiceInfo valueForKey:@"latitude"] != nil) {
                    
                    self.latitude = [[practiceInfo valueForKey:@"latitude"] stringValue];
                    self.longitude = [[practiceInfo valueForKey:@"longitude"] stringValue];
                }else{
                }
                
                self.opponentString = opp;
                self.descriptionString = desc;
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
                NSDate *formatStartDate = [dateFormat dateFromString:startDate];
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"EEE, MMM dd"];
                [timeFormat setDateFormat:@"hh:mm aa"];
                
                self.dayString = [format stringFromDate:formatStartDate];
                self.timeString = [timeFormat stringFromDate:formatStartDate];
                
                
                
                
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
                        //log status code
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        [self performSelectorOnMainThread:@selector(finishedInfo) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)finishedInfo{
	[self.loading stopAnimating];

	self.opponent.text = self.opponentString;
	self.errorLabel.text = self.errorString;
	self.description.text = self.descriptionString;
	self.day.text = self.dayString;
	self.time.text = self.timeString;
	
	if (![self.latitude isEqualToString:@""]) {
		self.viewMapButton.hidden = NO;
	}else {
		self.viewMapButton.hidden = YES;
	}

}

-(void)updateLocationAction{
	
	PracticeUpdateGPS *tmp = [[PracticeUpdateGPS alloc] init];
	tmp.teamId = self.teamId;
	tmp.practiceId = self.practiceId;
	tmp.locationString = self.opponent.text;

	
	[self.navigationController pushViewController:tmp animated:YES];

}

-(void)viewMapAction{
	
	MapLocation *tmp = [[MapLocation alloc] init];
	tmp.eventLatCoord = [self.latitude doubleValue];
	tmp.eventLongCoord = [self.longitude doubleValue];
	[self.navigationController pushViewController:tmp animated:YES];
	
}


-(void)viewDidUnload{

	opponent = nil;
	day = nil;
	time = nil;
	description = nil;
	locationManager = nil;
	errorLabel = nil;
	updateLocationButton = nil;
	viewMapButton = nil;

	editDone = nil;

	loading = nil;

	[super viewDidUnload];

}




@end
