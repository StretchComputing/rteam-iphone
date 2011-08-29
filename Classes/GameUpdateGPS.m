//
//  GameUpdateGPS.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameUpdateGPS.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "rTeamAppDelegate.h"
#import "Gameday.h"
#import "GameTabs.h"
#import "Game.h"
#import "FastActionSheet.h"

@implementation GameUpdateGPS
@synthesize gameId, teamId, locationName, action, lat, longt, locationManager, saveButton, useCurrentButton, updateSuccess, errorMessage, 
locationString, errorString, updateAllGames, nameOnly, updateLat, updateLong, allGamesArray, haveGames, gameSuccess, updateAllSuccess;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	self.locationName.text = self.locationString;
}

-(void)viewDidLoad{

	self.allGamesArray = [NSMutableArray array];
	self.haveGames = false;
	[self performSelectorInBackground:@selector(getAllGames) withObject:nil];
	self.title = @"Game Location";
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
	
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];

	
}
 
-(void)useCurrent{
	
	
	self.nameOnly = false;
	[action startAnimating];
	[self.navigationItem setHidesBackButton:YES];
	[self.saveButton setEnabled:NO];
	[self.useCurrentButton setEnabled:NO];
	self.saveButton.titleLabel.text = @"TEST";
	self.saveButton.enabled = NO;
	self.useCurrentButton.enabled = NO;
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
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
	
	
	
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}
- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error
{
}

- (void)runRequest{
	
	NSAutoreleasePool * pool;
	
    pool = [[NSAutoreleasePool alloc] init];
    assert(pool != nil);
	
	
	NSString *locationStr = @"";
	NSString *paramLat = @"";
	NSString *paramLong = @"";
	
	if (self.nameOnly) {
		
		locationStr = self.locationName.text;
		
	}else {
		
		paramLat = self.updateLat;
		paramLong = self.updateLong;
		
		if (![self.locationName.text isEqualToString:@""] && (self.locationName.text != nil)) {
			locationStr = self.locationName.text;
		}
	}

	NSString *updateAll = @"";
	
	if (self.updateAllGames.selectedSegmentIndex == 0) {
		updateAll = @"true";
	}
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSString *token = @"";
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	}
	
	NSDictionary *response =[NSDictionary dictionary];
	//If there is a token, do a DB lookup to find the game info 
	if (![token isEqualToString:@""]){
		

		response = [ServerAPI updateGame:token :self.teamId :self.gameId :@"" :@"" :@"" :@"" :paramLat :paramLong :@"" :locationStr :@"" :@"" :@"" :@"" :@"" :updateAll];
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
	
    [pool drain];
}

- (void)didFinish{
	
	//When background thread is done, return to main thread
	[action stopAnimating];
	
	if (self.updateSuccess){
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 2;
		
		GameTabs *cont = [tempCont objectAtIndex:tempNum];
		NSArray *viewControllers = cont.viewControllers;
		
		Gameday *currentNotes = [viewControllers objectAtIndex:0];
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
		[actionSheet release];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}




- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)getAllGames{
	
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	NSString *token = @"";
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (mainDelegate.token != nil){
		token = mainDelegate.token;
	} 
	
	
	
	//If there is a token, do a DB lookup to find the players associated with this team:
	if (![token isEqualToString:@""]){
		
		NSDictionary *response = [ServerAPI getListOfGames:self.teamId :token];
		
		NSString *status = [response valueForKey:@"status"];
		
		if ([status isEqualToString:@"100"]){
			
			self.allGamesArray = [response valueForKey:@"games"];
			self.haveGames = true;
			self.gameSuccess = true;
			
		}else{
			
			self.gameSuccess = false;
			
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
	
	[pool drain];

}




-(void)viewDidUnload{
	//gameId = nil;
	//teamId = nil;
	locationName = nil;
	action = nil;
	//lat = nil;
	//longt = nil;
	locationManager = nil;
	useCurrentButton = nil;
	saveButton = nil;
	errorMessage = nil;
	//locationString = nil;
	//errorString = nil;
	updateAllGames = nil;
	[super viewDidUnload];

	
	
}

-(void)dealloc{
	[gameId release];
	[teamId release];
	[locationName release];
	[action release];
	[lat release];
	[longt release];
	[locationManager release];
	[saveButton release];
	[useCurrentButton release];
	[errorMessage release];
	[locationString release];
	[errorString release];
	[updateAllGames release];
	[updateLat release];
	[updateLong release];
	[allGamesArray release];
	[super dealloc];
}
@end
