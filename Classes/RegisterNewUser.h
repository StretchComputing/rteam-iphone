//
//  RegisterNewUser.h
//  iCoach
//
//  Created by Nick Wroblewski on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MapKit/MapKit.h>


@interface RegisterNewUser : UIViewController <CLLocationManagerDelegate, UIPickerViewDelegate, MFMessageComposeViewControllerDelegate, MKReverseGeocoderDelegate> {
	
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
	
}
@property (nonatomic, retain) NSString *locationString;
@property bool usingHardCarriers;
@property (nonatomic, strong) NSArray *hardCarriers;
@property bool didGetCarrierList;
@property bool tryAgainText;
@property bool sendingText;
@property (nonatomic, strong) NSString *carrierCode;
@property (nonatomic, strong) NSString *selectedCarrier;
@property (nonatomic, strong) IBOutlet UIButton *selectCarrierButton;
@property (nonatomic, strong) NSArray *carriers;
@property (nonatomic, strong) IBOutlet UILabel *carrierLabel;
@property (nonatomic, strong) IBOutlet UITextField *carrierText;
@property (nonatomic, strong) IBOutlet UIPickerView *carrierPicker;
@property (nonatomic, strong) IBOutlet UITextView *phoneExplain;
@property (nonatomic, strong) IBOutlet UITextView *carrierExplain;

@property (nonatomic, strong) IBOutlet UITextField *phoneText;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *updateLat;
@property (nonatomic, strong) NSString *updateLong;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *firstString;
@property (nonatomic, strong) NSString *lastString;
@property (nonatomic, strong) IBOutlet UITextField *firstName;
@property (nonatomic, strong) IBOutlet UITextField *lastName;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *registering;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

@property bool createSuccess;

-(IBAction)submit;
-(IBAction)endText;
-(IBAction)carrierBegin;
-(IBAction)selectCarrier;
-(IBAction)carrierBeginCheat;

-(void)buildTempArray;

@end
