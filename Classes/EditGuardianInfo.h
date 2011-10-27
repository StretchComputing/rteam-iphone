//
//  EditGuardianInfo.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface EditGuardianInfo : UIViewController <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>  {
    
	NSArray *guardianArray;
	
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
    
	IBOutlet UITextField *oneFirstName;
	IBOutlet UITextField *oneLastName;
	IBOutlet UITextField *oneEmail;
	IBOutlet UITextField *twoFirstName;
	IBOutlet UITextField *twoLastName;
	IBOutlet UITextField *twoEmail;
    IBOutlet UITextField *onePhone;
    IBOutlet UITextField *twoPhone;
	
	IBOutlet UILabel *errorLabel;
	
	IBOutlet UIButton *saveChangesButton;
	IBOutlet UIButton *removeGuardiansButton;
	
	IBOutlet UIActivityIndicatorView *activity;
	
	NSString *teamId;
	NSString *memberId;
	NSString *errorString;
    
    NSString *oneKey;
    NSString *twoKey;
    
    bool guard1Na;
    bool guard2Na;
    
    IBOutlet UILabel *confirmedLabel;
    
    NSMutableArray *phoneOnlyArray;
    
    NSString *initGuard1Phone;
    NSString *initGuard2Phone;
    
    NSString *teamName;
    
    bool guard1isUser;
    bool guard2isUser;
    bool guard1EmailConfirmed;
    bool guard2EmailConfirmed;
    bool guard1SmsConfirmed;
    bool guard2SmsConfirmed;
	
}
@property bool guard1isUser;
@property bool guard2isUser;
@property bool guard1EmailConfirmed;
@property bool guard2EmailConfirmed;
@property bool guard1SmsConfirmed;
@property bool guard2SmsConfirmed;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *initGuard1Phone;
@property (nonatomic, strong) NSString *initGuard2Phone;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) UILabel *confirmedLabel;

@property bool guard1Na;
@property bool guard2Na;

@property (nonatomic, strong) NSString *oneKey;
@property (nonatomic, strong) NSString *twoKey;

@property (nonatomic, strong) UITextField *onePhone;
@property (nonatomic, strong) UITextField *twoPhone;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *memberId;

@property (nonatomic, strong) UITextField *oneFirstName;
@property (nonatomic, strong) UITextField *oneLastName;
@property (nonatomic, strong) UITextField *oneEmail;
@property (nonatomic, strong) UITextField *twoFirstName;
@property (nonatomic, strong) UITextField *twoLastName;
@property (nonatomic, strong) UITextField *twoEmail;

@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UIButton *saveChangesButton;
@property (nonatomic, strong) UIButton *removeGuardiansButton;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSArray *guardianArray;


-(IBAction)removeGuardians;
-(IBAction)saveChanges;
-(IBAction)endText;
@end
