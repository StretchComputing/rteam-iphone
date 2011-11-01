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
@property (nonatomic, strong) IBOutlet UIButton *removeGuardians;
//Parent/Guardian
@property (nonatomic, strong) NSString *guardianTwoPhone;
@property (nonatomic, strong) NSString *guardianOnePhone;
@property (nonatomic, strong) NSString *guardianOneFirst;
@property (nonatomic, strong) NSString *guardianOneLast;
@property (nonatomic, strong) NSString *guardianOneEmail;
@property (nonatomic, strong) NSString *guardianTwoFirst;
@property (nonatomic, strong) NSString *guardianTwoLast;
@property (nonatomic, strong) NSString *guardianTwoEmail;

@property (nonatomic, strong) IBOutlet UITextField *oneFirstName;
@property (nonatomic, strong) IBOutlet UITextField *oneLastName;
@property (nonatomic, strong) IBOutlet UITextField *oneEmail;
@property (nonatomic, strong) IBOutlet UITextField *onePhone;

@property (nonatomic, strong) IBOutlet UITextField *twoFirstName;
@property (nonatomic, strong) IBOutlet UITextField *twoLastName;
@property (nonatomic, strong) IBOutlet UITextField *twoEmail;
@property (nonatomic, strong) IBOutlet UITextField *twoPhone;


@property (nonatomic, strong) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) IBOutlet UIButton *saveButton;

-(IBAction)endText;
-(IBAction)save;
-(IBAction)removeGuard;

-(IBAction)showPicker:(id)sender;

-(NSString *)getType:(NSString *)typeLabel;
@end
