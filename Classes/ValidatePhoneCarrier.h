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

    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

    
}
@property (nonatomic, strong) NSString *thePhoneNumber;
@property (nonatomic, strong) NSString *theConfirmCode;
@property bool carrierPicked;
@property bool sendingText;
@property bool tryAgainText;
@property (nonatomic, strong) IBOutlet UIButton *carrierCheatButton;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) IBOutlet UITextField *confirmCode;
@property (nonatomic, strong) NSString *selectedCarrier;
@property (nonatomic, strong) IBOutlet UIButton *selectCarrierButton;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong)  IBOutlet UIButton *verifyButton;
@property (nonatomic, strong)  IBOutlet UIButton *resendButton;
@property (nonatomic, strong)  IBOutlet UIButton *finishButton;

@property (nonatomic, strong)  IBOutlet UILabel *verifyError;
@property (nonatomic, strong)  IBOutlet UILabel *resendError;

@property (nonatomic, strong)  IBOutlet UITextField *phoneNumberText;
@property (nonatomic, strong)  IBOutlet UITextField *phoneCarrierText;

@property (nonatomic, strong)  IBOutlet UIPickerView *carrierPicker;

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
