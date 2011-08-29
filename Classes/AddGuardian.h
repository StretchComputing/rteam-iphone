//
//  AddGuardian.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumberFormatter.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddGuardian : UIViewController <UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate> {

    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore1;
    int myTextFieldSemaphore2;
    
	IBOutlet UITextField *oneFirstName;
	IBOutlet UITextField *oneLastName;
	IBOutlet UITextField *oneEmail;
    IBOutlet UITextField *onePhone;

	IBOutlet UITextField *twoFirstName;
	IBOutlet UITextField *twoLastName;
	IBOutlet UITextField *twoEmail;
    IBOutlet UITextField *twoPhone;
    
	IBOutlet UILabel *errorLabel;
	
	IBOutlet UIButton *saveButton;

	NSString *guardianOneFirst;
	NSString *guardianOneLast;
	NSString *guardianOneEmail;
	NSString *guardianTwoFirst;
	NSString *guardianTwoLast;
	NSString *guardianTwoEmail;
    NSString *guardianTwoPhone;
    NSString *guardianOnePhone;
    
    IBOutlet UIButton *removeGuardians;
    bool addContactGuard1;
    
    bool twoAlerts;
    NSMutableArray *multipleEmailArray;
    NSMutableArray *multiplePhoneArray;
    NSString *currentGuardFirstName;
    NSString *currentGuardLastName;
    NSString *currentGuardEmail;
    NSString *currentGuardPhone;
    
    UIAlertView *multipleEmailAlert;
    UIAlertView *multiplePhoneAlert;
    
    NSMutableArray *multipleEmailArrayLabels;
    NSMutableArray *multiplePhoneArrayLabels;
}
@property (nonatomic, retain) NSMutableArray *multipleEmailArrayLabels;
@property (nonatomic, retain) NSMutableArray *multiplePhoneArrayLabels;
@property (nonatomic, retain) UIAlertView *multipleEmailAlert;
@property (nonatomic, retain) UIAlertView *multiplePhoneAlert;

@property bool twoAlerts;
@property (nonatomic, retain) NSMutableArray *multipleEmailArray;
@property (nonatomic, retain) NSMutableArray *multiplePhoneArray;
@property (nonatomic, retain) NSString *currentGuardFirstName;
@property (nonatomic, retain) NSString *currentGuardLastName;
@property (nonatomic, retain) NSString *currentGuardEmail;
@property (nonatomic, retain) NSString *currentGuardPhone;
@property bool addContactGuard1;
@property (nonatomic, retain) UIButton *removeGuardians;
//Parent/Guardian
@property (nonatomic, retain) NSString *guardianTwoPhone;
@property (nonatomic, retain) NSString *guardianOnePhone;
@property (nonatomic, retain) NSString *guardianOneFirst;
@property (nonatomic, retain) NSString *guardianOneLast;
@property (nonatomic, retain) NSString *guardianOneEmail;
@property (nonatomic, retain) NSString *guardianTwoFirst;
@property (nonatomic, retain) NSString *guardianTwoLast;
@property (nonatomic, retain) NSString *guardianTwoEmail;

@property (nonatomic, retain) UITextField *oneFirstName;
@property (nonatomic, retain) UITextField *oneLastName;
@property (nonatomic, retain) UITextField *oneEmail;
@property (nonatomic, retain) UITextField *onePhone;

@property (nonatomic, retain) UITextField *twoFirstName;
@property (nonatomic, retain) UITextField *twoLastName;
@property (nonatomic, retain) UITextField *twoEmail;
@property (nonatomic, retain) UITextField *twoPhone;


@property (nonatomic, retain) UILabel *errorLabel;

@property (nonatomic, retain) UIButton *saveButton;

-(IBAction)endText;
-(IBAction)save;
-(IBAction)removeGuard;

-(IBAction)showPicker:(id)sender;

-(NSString *)getType:(NSString *)typeLabel;
@end
