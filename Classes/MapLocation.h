//
//  MapLocation.h
//  rTeam
//
//  Created by Nick Wroblewski on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate> {
	
	IBOutlet MKMapView *map;
	CLLocationManager *locationManager;
	double latCoord;
	double longCoord;
	
	double eventLatCoord;
	double eventLongCoord;
	
	IBOutlet UIButton *directionsButton;
	
}
@property (nonatomic, retain ) UIButton *directionsButton;
@property double eventLatCoord;
@property double eventLongCoord;
@property double latCoord;
@property double longCoord;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MKMapView *map;

-(IBAction)getDirections;

@end
