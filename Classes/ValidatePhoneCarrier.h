//
//  ValidatePhoneCarrier.h
//  rTeam
//
//  Created by Nick Wroblewski on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface ValidatePhoneCarrier : UIViewController <UIPickerViewDelegate, MFMessageComposeViewControllerDelegate> {
    
    NSString *phoneNumber;
    NSString *carrierCode;
    NSArray *carriers;
    
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

    
    IBOutlet UIButton *verifyButton;
    IBOutlet UIButton *resendButton;
    IBOutlet UIButton *finishButton;
    
    IBOutlet UILabel *verifyError;
    IBOutlet UILabel *resendError;
    
    IBOutlet UITextField *phoneNumberText;
    IBOutlet UITextField *phoneCarrierText;
    IBOutlet UITextField *confirmCode;
    
    IBOutlet UIPickerView *carrierPicker;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    IBOutlet UIButton *selectCarrierButton;
    
    NSString *selectedCarrier;
    NSString *errorString;
    
    IBOutlet UIButton *carrierCheatButton;
    
    bool sendingText;
    bool tryAgainText;
    bool carrierPicked;
    
}
@property bool carrierPicked;
@property bool sendingText;
@property bool tryAgainText;
@property (nonatomic, retain) UIButton *carrierCheatButton;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) UITextField *confirmCode;
@property (nonatomic, retain) NSString *selectedCarrier;
@property (nonatomic, retain) UIButton *selectCarrierButton;

@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain)  UIButton *verifyButton;
@property (nonatomic, retain)  UIButton *resendButton;
@property (nonatomic, retain)  UIButton *finishButton;

@property (nonatomic, retain)  UILabel *verifyError;
@property (nonatomic, retain)  UILabel *resendError;

@property (nonatomic, retain)  UITextField *phoneNumberText;
@property (nonatomic, retain)  UITextField *phoneCarrierText;

@property (nonatomic, retain)  UIPickerView *carrierPicker;

@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *carrierCode;
@property (nonatomic, retain) NSArray *carriers;


-(IBAction)verifiy;
-(IBAction)resend;
-(IBAction)finish;
-(IBAction)carrierBeginEdit;
-(IBAction)endText;
-(IBAction)selectCarrier;
-(IBAction)carrierBeginCheat;

-(IBAction)dropPhonePad;
@end
