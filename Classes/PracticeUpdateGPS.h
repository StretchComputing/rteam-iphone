//
//  PracticeUpdateGPS.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PracticeUpdateGPS : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate> {

}
@property (nonatomic, strong) NSString *theLocationName;
@property bool updateAllSuccess;
@property bool haveGames;
@property bool practiceSuccess;
@property (nonatomic, strong) NSMutableArray *allPracticesArray;
@property bool nameOnly;
@property (nonatomic, strong) NSString *updateLat;
@property ( nonatomic, strong) NSString *updateLong;
@property (nonatomic, strong) IBOutlet UISegmentedControl *updateAllGames;

@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) IBOutlet UITextField *locationName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *practiceId;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *action;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *longt;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *useCurrentButton;
@property bool updateSuccess;

@property (nonatomic, strong) IBOutlet UILabel *errorMessage;

-(IBAction)save;
-(IBAction)useCurrent;
-(IBAction)endText;
@end
