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
    
	
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
    

	
}
@property (nonatomic, strong) NSString *theOneFirstName;
@property (nonatomic, strong) NSString *theOneLastName;
@property (nonatomic, strong) NSString *theOneEmail;
@property (nonatomic, strong) NSString *theOnePhone;

@property (nonatomic, strong) NSString *theTwoFirstName;
@property (nonatomic, strong) NSString *theTwoLastName;
@property (nonatomic, strong) NSString *theTwoEmail;
@property (nonatomic, strong) NSString *theTwoPhone;




@property bool guard1isUser;
@property bool guard2isUser;
@property bool guard1EmailConfirmed;
@property bool guard2EmailConfirmed;
@property bool guard1SmsConfirmed;
@property bool guard2SmsConfirmed;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong, getter = initialGuard1Phone, setter = initialGuard1Phone:) NSString *initGuard1Phone;
@property (nonatomic, strong, getter = initialGuard2Phone, setter = initialGuard2Phone:) NSString *initGuard2Phone;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) IBOutlet UILabel *confirmedLabel;

@property bool guard1Na;
@property bool guard2Na;

@property (nonatomic, strong) NSString *oneKey;
@property (nonatomic, strong) NSString *twoKey;

@property (nonatomic, strong) IBOutlet UITextField *onePhone;
@property (nonatomic, strong) IBOutlet UITextField *twoPhone;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *memberId;

@property (nonatomic, strong) IBOutlet UITextField *oneFirstName;
@property (nonatomic, strong) IBOutlet UITextField *oneLastName;
@property (nonatomic, strong) IBOutlet UITextField *oneEmail;
@property (nonatomic, strong) IBOutlet UITextField *twoFirstName;
@property (nonatomic, strong) IBOutlet UITextField *twoLastName;
@property (nonatomic, strong) IBOutlet UITextField *twoEmail;

@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) IBOutlet UIButton *saveChangesButton;
@property (nonatomic, strong) IBOutlet UIButton *removeGuardiansButton;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSArray *guardianArray;


-(IBAction)removeGuardians;
-(IBAction)saveChanges;
-(IBAction)endText;
@end
