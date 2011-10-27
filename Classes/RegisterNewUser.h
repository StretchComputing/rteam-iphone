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
@property (nonatomic, strong) NSArray *hardCarriers;
@property bool didGetCarrierList;
@property bool tryAgainText;
@property bool sendingText;
@property (nonatomic, strong) NSString *carrierCode;
@property (nonatomic, strong) NSString *selectedCarrier;
@property (nonatomic, strong) UIButton *selectCarrierButton;
@property (nonatomic, strong) NSArray *carriers;
@property (nonatomic, strong) UILabel *carrierLabel;
@property (nonatomic, strong) UITextField *carrierText;
@property (nonatomic, strong) UIPickerView *carrierPicker;
@property (nonatomic, strong) UITextView *phoneExplain;
@property (nonatomic, strong) UITextView *carrierExplain;

@property (nonatomic, strong) UITextField *phoneText;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *updateLat;
@property (nonatomic, strong) NSString *updateLong;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *firstString;
@property (nonatomic, strong) NSString *lastString;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UILabel *error;
@property (nonatomic, strong) UIActivityIndicatorView *registering;
@property (nonatomic, strong) UIButton *submitButton;

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
