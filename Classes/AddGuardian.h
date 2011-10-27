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
@property (nonatomic, strong) NSMutableArray *multipleEmailArrayLabels;
@property (nonatomic, strong) NSMutableArray *multiplePhoneArrayLabels;
@property (nonatomic, strong) UIAlertView *multipleEmailAlert;
@property (nonatomic, strong) UIAlertView *multiplePhoneAlert;

@property bool twoAlerts;
@property (nonatomic, strong) NSMutableArray *multipleEmailArray;
@property (nonatomic, strong) NSMutableArray *multiplePhoneArray;
@property (nonatomic, strong) NSString *currentGuardFirstName;
@property (nonatomic, strong) NSString *currentGuardLastName;
@property (nonatomic, strong) NSString *currentGuardEmail;
@property (nonatomic, strong) NSString *currentGuardPhone;
@property bool addContactGuard1;
@property (nonatomic, strong) UIButton *removeGuardians;
//Parent/Guardian
@property (nonatomic, strong) NSString *guardianTwoPhone;
@property (nonatomic, strong) NSString *guardianOnePhone;
@property (nonatomic, strong) NSString *guardianOneFirst;
@property (nonatomic, strong) NSString *guardianOneLast;
@property (nonatomic, strong) NSString *guardianOneEmail;
@property (nonatomic, strong) NSString *guardianTwoFirst;
@property (nonatomic, strong) NSString *guardianTwoLast;
@property (nonatomic, strong) NSString *guardianTwoEmail;

@property (nonatomic, strong) UITextField *oneFirstName;
@property (nonatomic, strong) UITextField *oneLastName;
@property (nonatomic, strong) UITextField *oneEmail;
@property (nonatomic, strong) UITextField *onePhone;

@property (nonatomic, strong) UITextField *twoFirstName;
@property (nonatomic, strong) UITextField *twoLastName;
@property (nonatomic, strong) UITextField *twoEmail;
@property (nonatomic, strong) UITextField *twoPhone;


@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UIButton *saveButton;

-(IBAction)endText;
-(IBAction)save;
-(IBAction)removeGuard;

-(IBAction)showPicker:(id)sender;

-(NSString *)getType:(NSString *)typeLabel;
@end
