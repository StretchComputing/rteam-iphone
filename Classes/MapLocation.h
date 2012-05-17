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

	
}
@property bool cancelButton;
@property (nonatomic, strong ) IBOutlet UIButton *directionsButton;
@property double eventLatCoord;
@property double eventLongCoord;
@property double latCoord;
@property double longCoord;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *map;

-(IBAction)getDirections;

@end
