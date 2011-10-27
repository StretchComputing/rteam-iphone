//
//  NewPlayer.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PhoneNumberFormatter.h"


@interface NewPlayer : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *email;
	NSArray *guardianEmail;
	NSArray *roles;
	NSString *teamId;
	IBOutlet UIActivityIndicatorView *serverProcess;
	IBOutlet UIButton *submitButton;
	IBOutlet UILabel *error;
	bool createSuccess;
	
	PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
    
	IBOutlet UISegmentedControl *isCoordinator;
	
	IBOutlet UIScrollView *helpScreen;
	UIBarButtonItem * barItem;
	NSString *userRole;
	
	IBOutlet UIButton *closeButton;
	IBOutlet UIButton *sendEmailButton;
	
	//Parent/Guardian
	IBOutlet UIButton *addParentGuardianButton;
	bool useGuardians;
	NSString *guardianOneFirst;
	NSString *guardianOneLast;
	NSString *guardianOneEmail;
	NSString *guardianTwoFirst;
	NSString *guardianTwoLast;
	NSString *guardianTwoEmail;
    NSString *guardianOnePhone;
    NSString *guardianTwoPhone;
    
	
	NSString *errorString;
    
	NSString *firstNamePicked;
	NSString *lastNamePicked;
	
	IBOutlet UITextField *phoneNumber;
	
	
	
	IBOutlet UIButton *addMultipleMembersButton;
	
	IBOutlet UIView *addViewBackground;
	IBOutlet UIView *addView;
	
	IBOutlet UIButton *closeMultipleButton;
	IBOutlet UIButton *saveButton;
	
	NSMutableArray *emailArray;
	IBOutlet UIButton *addNewButton;
	
	IBOutlet UITableView *myTableView;
	
	IBOutlet UIView *miniBackgroundView;
	IBOutlet UIView *miniForeGroundView;
	IBOutlet UITextField *nameText;
	IBOutlet UITextField *emailText;
	IBOutlet UITextField *phoneText;
	IBOutlet UILabel *miniErrorLabel;
	IBOutlet UIButton *miniCancelButton;
	IBOutlet UIButton *miniAddButton;
	
	bool isMiniAdd;
	
	IBOutlet UIActivityIndicatorView *multipleActivity;
	
	IBOutlet UIButton *addContactButton;
	
	NSMutableArray *phoneOnlyArray;
    
    NSMutableArray *multiplePhoneArray;
    NSMutableArray *multipleEmailArray;
    
    UIAlertView *multipleEmailAlert;
    UIAlertView *multiplePhoneAlert;
    
    NSString *tmpMiniEmail;
    NSString *tmpMiniPhone;
    NSString *tmpMiniFirstName;
    NSString *tmpMiniLastName;
    NSString *miniMultiple;
    UIAlertView *miniMultipleEmailAlert;
    UIAlertView *miniMultiplePhoneAlert;
    
    bool twoAlerts;
    
    IBOutlet UIView *guardianBackground;
    IBOutlet UIButton *miniGuardAddButton;
    IBOutlet UIButton *miniGuardCancelButton;
    
    IBOutlet UITextField *oneName;
    IBOutlet UITextField *oneEmail;
    IBOutlet UITextField *onePhone;
    
    IBOutlet UITextField *twoName;
    IBOutlet UITextField *twoEmail;
    IBOutlet UITextField *twoPhone;
    
    int currentGuardianSelection;
    
    IBOutlet UILabel *miniGuardErrorLabel;
	
    IBOutlet UIButton *removeGuardiansButton;
	
    NSString *addContactWhere;
    
    UIAlertView *guard1EmailAlert;
    UIAlertView *guard1PhoneAlert;
    UIAlertView *guard2EmailAlert;
    UIAlertView *guard2PhoneAlert;
    
    NSString *currentGuardName;
    NSString *currentGuardEmail;
    NSString *currentGuardPhone;
	
    NSMutableArray *multipleEmailArrayLabels;
    NSMutableArray *multiplePhoneArrayLabels;
    
    IBOutlet UISegmentedControl *coordinatorSegment;
}

@property (nonatomic, strong) UISegmentedControl *coordinatorSegment;

@property (nonatomic, strong) NSMutableArray *multipleEmailArrayLabels;
@property (nonatomic, strong) NSMutableArray *multiplePhoneArrayLabels;

@property (nonatomic, strong) NSString *currentGuardName;
@property (nonatomic, strong) NSString *currentGuardEmail;
@property (nonatomic, strong) NSString *currentGuardPhone;

@property (nonatomic, strong) NSString *addContactWhere;

@property (nonatomic, strong) UIAlertView *guard1EmailAlert;
@property (nonatomic, strong) UIAlertView *guard1PhoneAlert;
@property (nonatomic, strong) UIAlertView *guard2EmailAlert;
@property (nonatomic, strong) UIAlertView *guard2PhoneAlert;


@property (nonatomic, strong) UIButton *removeGuardiansButton;

@property (nonatomic, strong) UILabel *miniGuardErrorLabel;
@property int currentGuardianSelection;
@property (nonatomic, strong) UIView *guardianBackground;
@property (nonatomic, strong) UIButton *miniGuardAddButton;
@property (nonatomic, strong) UIButton *miniGuardCancelButton;

@property (nonatomic, strong) UITextField *oneName;
@property (nonatomic, strong) UITextField *oneEmail;
@property (nonatomic, strong) UITextField *onePhone;

@property (nonatomic, strong) UITextField *twoName;
@property (nonatomic, strong) UITextField *twoEmail;
@property (nonatomic, strong) UITextField *twoPhone;

@property bool twoAlerts;
@property (nonatomic, strong) NSString *guardianOnePhone;
@property (nonatomic, strong) NSString *guardianTwoPhone;
@property (nonatomic, strong) UIAlertView *miniMultipleEmailAlert;
@property (nonatomic, strong) UIAlertView *miniMultiplePhoneAlert;
@property (nonatomic, strong) NSString *miniMultiple;
@property (nonatomic, strong) NSString *tmpMiniEmail;
@property (nonatomic, strong) NSString *tmpMiniPhone;
@property (nonatomic, strong) NSString *tmpMiniFirstName;
@property (nonatomic, strong) NSString *tmpMiniLastName;

@property (nonatomic, strong) UIAlertView *multipleEmailAlert;
@property (nonatomic, strong) UIAlertView *multiplePhoneAlert;
@property (nonatomic, strong) NSMutableArray *multiplePhoneArray;
@property (nonatomic, strong) NSMutableArray *multipleEmailArray;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;

@property (nonatomic, strong) UIButton *addContactButton;
@property (nonatomic, strong) UIActivityIndicatorView *multipleActivity;
@property bool isMiniAdd;
@property (nonatomic, strong) UIView *addViewBackground;
@property (nonatomic, strong) UIView *addView;

@property (nonatomic, strong) UIButton *closeMultipleButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) UIButton *addNewButton;

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UIView *miniBackgroundView;
@property (nonatomic, strong) UIView *miniForeGroundView;
@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *emailText;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UILabel *miniErrorLabel;
@property (nonatomic, strong) UIButton *miniCancelButton;
@property (nonatomic, strong) UIButton *miniAddButton;


@property (nonatomic, strong) UIButton *addMultipleMembersButton;

@property (nonatomic, strong) UITextField *phoneNumber;
@property (nonatomic, strong) NSString *firstNamePicked;
@property (nonatomic, strong) NSString *lastNamePicked;

@property (nonatomic, strong) NSString *errorString;
//Parent/Guardian
@property  bool useGuardians;
@property (nonatomic, strong) NSString *guardianOneFirst;
@property (nonatomic, strong) NSString *guardianOneLast;
@property (nonatomic, strong) NSString *guardianOneEmail;
@property (nonatomic, strong) NSString *guardianTwoFirst;
@property (nonatomic, strong) NSString *guardianTwoLast;
@property (nonatomic, strong) NSString *guardianTwoEmail;
@property (nonatomic, strong) UIButton *addParentGuardianButton;


@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *sendEmailButton;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *email;
@property (nonatomic, strong) NSArray *guardianEmail;
@property (nonatomic, strong) NSArray *roles;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *error;
@property bool createSuccess;
@property (nonatomic, strong) UISegmentedControl *isCoordinator;
@property (nonatomic, strong) UIScrollView *helpScreen;
@property (nonatomic, strong) UIBarButtonItem *barItem;

-(IBAction)sendEmail;
-(IBAction)closeHelp;
-(IBAction) create;
-(IBAction)endText;
-(IBAction)addParentGuardian;
-(IBAction)showPicker:(id)sender;
-(IBAction)addMultipleMembers;

-(IBAction)addNew;
-(IBAction)closeMultiple;
-(IBAction)saveMultiple;
-(IBAction)miniAdd;
-(IBAction)miniCancel;

-(IBAction)miniGuardAdd;
-(IBAction)miniGuardCancel;
-(IBAction)removeGuardians;

-(NSString *)getType:(NSString *)typeLabel;

@end
