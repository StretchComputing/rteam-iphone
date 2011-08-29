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

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *initGuard1Phone;
@property (nonatomic, retain) NSString *initGuard2Phone;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;
@property (nonatomic, retain) UILabel *confirmedLabel;

@property bool guard1Na;
@property bool guard2Na;

@property (nonatomic, retain) NSString *oneKey;
@property (nonatomic, retain) NSString *twoKey;

@property (nonatomic, retain) UITextField *onePhone;
@property (nonatomic, retain) UITextField *twoPhone;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *memberId;

@property (nonatomic, retain) UITextField *oneFirstName;
@property (nonatomic, retain) UITextField *oneLastName;
@property (nonatomic, retain) UITextField *oneEmail;
@property (nonatomic, retain) UITextField *twoFirstName;
@property (nonatomic, retain) UITextField *twoLastName;
@property (nonatomic, retain) UITextField *twoEmail;

@property (nonatomic, retain) UILabel *errorLabel;

@property (nonatomic, retain) UIButton *saveChangesButton;
@property (nonatomic, retain) UIButton *removeGuardiansButton;

@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) NSArray *guardianArray;


-(IBAction)removeGuardians;
-(IBAction)saveChanges;
-(IBAction)endText;
@end
