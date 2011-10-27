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
@property (nonatomic, strong) UIButton *carrierCheatButton;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UITextField *confirmCode;
@property (nonatomic, strong) NSString *selectedCarrier;
@property (nonatomic, strong) UIButton *selectCarrierButton;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong)  UIButton *verifyButton;
@property (nonatomic, strong)  UIButton *resendButton;
@property (nonatomic, strong)  UIButton *finishButton;

@property (nonatomic, strong)  UILabel *verifyError;
@property (nonatomic, strong)  UILabel *resendError;

@property (nonatomic, strong)  UITextField *phoneNumberText;
@property (nonatomic, strong)  UITextField *phoneCarrierText;

@property (nonatomic, strong)  UIPickerView *carrierPicker;

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *carrierCode;
@property (nonatomic, strong) NSArray *carriers;


-(IBAction)verifiy;
-(IBAction)resend;
-(IBAction)finish;
-(IBAction)carrierBeginEdit;
-(IBAction)endText;
-(IBAction)selectCarrier;
-(IBAction)carrierBeginCheat;

-(IBAction)dropPhonePad;
@end
