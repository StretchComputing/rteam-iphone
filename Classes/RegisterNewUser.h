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

@interface RegisterNewUser : UIViewController <CLLocationManagerDelegate, UIPickerViewDelegate, MFMessageComposeViewControllerDelegate> {
	
	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
    IBOutlet UITextField *phoneText;
	IBOutlet UILabel *error;
	IBOutlet UIActivityIndicatorView *registering;
	IBOutlet UIButton *submitButton;
	
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
    
	NSString *firstString;
	NSString *lastString;
	
	NSString *email;
	NSString *password;
	
	bool createSuccess;
	
	NSString *errorString;
	
	CLLocationManager *locationManager;
	NSString *updateLat;
	NSString *updateLong;
    
    IBOutlet UILabel *carrierLabel;
    IBOutlet UITextField *carrierText;
    IBOutlet UIPickerView *carrierPicker;
    IBOutlet UITextView *phoneExplain;
    IBOutlet UITextView *carrierExplain;
    
    NSArray *carriers;
    NSArray *hardCarriers;
    
    NSString *selectedCarrier;
    IBOutlet UIButton *selectCarrierButton;
    NSString *carrierCode;
    
    bool sendingText;
    bool tryAgainText;
    
    bool didGetCarrierList;
    bool usingHardCarriers;
	
}
@property bool usingHardCarriers;
@property (nonatomic, retain) NSArray *hardCarriers;
@property bool didGetCarrierList;
@property bool tryAgainText;
@property bool sendingText;
@property (nonatomic, retain) NSString *carrierCode;
@property (nonatomic, retain) NSString *selectedCarrier;
@property (nonatomic, retain) UIButton *selectCarrierButton;
@property (nonatomic, retain) NSArray *carriers;
@property (nonatomic, retain) UILabel *carrierLabel;
@property (nonatomic, retain) UITextField *carrierText;
@property (nonatomic, retain) UIPickerView *carrierPicker;
@property (nonatomic, retain) UITextView *phoneExplain;
@property (nonatomic, retain) UITextView *carrierExplain;

@property (nonatomic, retain) UITextField *phoneText;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *updateLat;
@property (nonatomic, retain) NSString *updateLong;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *firstString;
@property (nonatomic, retain) NSString *lastString;
@property (nonatomic, retain) UITextField *firstName;
@property (nonatomic, retain) UITextField *lastName;
@property (nonatomic, retain) UILabel *error;
@property (nonatomic, retain) UIActivityIndicatorView *registering;
@property (nonatomic, retain) UIButton *submitButton;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

@property bool createSuccess;

-(IBAction)submit;
-(IBAction)endText;
-(IBAction)carrierBegin;
-(IBAction)selectCarrier;
-(IBAction)carrierBeginCheat;

-(void)buildTempArray;

@end
