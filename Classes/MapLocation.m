//
//  MapLocation.m
//  rTeam
//
//  Created by Nick Wroblewski on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapLocation.h"
#import "Directions.h"
#import <MapKit/MapKit.h>
#import "rTeamAppDelegate.h"
#import "FastActionSheet.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation MapLocation
@synthesize map, locationManager, latCoord, longCoord, eventLatCoord, eventLongCoord, directionsButton, cancelButton;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
    [TraceSession addEventToSession:@"MapLocation - View Will Appear"];

    
	CLLocation* myLocation = [[CLLocation alloc] initWithLatitude:self.eventLatCoord longitude:self.eventLongCoord];
	CLLocationCoordinate2D location = myLocation.coordinate;
	
	MKCoordinateRegion region;
    MKCoordinateSpan span;
	
    location.latitude  = self.eventLatCoord;
    location.longitude = self.eventLongCoord;
	
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
	
    region.span = span;
    region.center = location;
	
    [self.map setRegion:region animated:YES];
    [self.map regionThatFits:region];
	[self.map addAnnotation:myLocation];
	[self.map setNeedsDisplay];	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.directionsButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
   
}

-(void)cancel{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)viewDidLoad{
	
	self.title = @"Event Location";
	
    if (self.cancelButton) {
        UIBarButtonItem *tmp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        [self.navigationItem setLeftBarButtonItem:tmp];
    }
	
}


- (void)locationManager: (CLLocationManager *)manager
	didUpdateToLocation: (CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	
	self.latCoord = newLocation.coordinate.latitude;
	self.longCoord = newLocation.coordinate.longitude;
	
	
	//NSString *destinationString = @"Cupertino,California";
    NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f", self.latCoord, self.longCoord, self.eventLatCoord, self.eventLongCoord]; 
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	//NSString *newAddressPartOfURL = [addressPartOfURL stringByReplacingOccurrencesOfString:@" " withString:@""]
	
	Directions *tmp = [[Directions alloc] init];
	tmp.urlString = url;
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Location" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;
	[self.navigationController pushViewController:tmp animated:YES];
	[locationManager stopUpdatingLocation];
	
}

-(void)getDirections{
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"View Event Directions"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	[locationManager startUpdatingLocation];
	
	
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


-(void)viewDidUnload{
	map = nil;
	locationManager = nil;
	directionsButton = nil;
	[super viewDidUnload];
}

@end