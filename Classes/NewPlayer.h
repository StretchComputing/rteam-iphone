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

@property (nonatomic, retain) UISegmentedControl *coordinatorSegment;

@property (nonatomic, retain) NSMutableArray *multipleEmailArrayLabels;
@property (nonatomic, retain) NSMutableArray *multiplePhoneArrayLabels;

@property (nonatomic, retain) NSString *currentGuardName;
@property (nonatomic, retain) NSString *currentGuardEmail;
@property (nonatomic, retain) NSString *currentGuardPhone;

@property (nonatomic, retain) NSString *addContactWhere;

@property (nonatomic, retain) UIAlertView *guard1EmailAlert;
@property (nonatomic, retain) UIAlertView *guard1PhoneAlert;
@property (nonatomic, retain) UIAlertView *guard2EmailAlert;
@property (nonatomic, retain) UIAlertView *guard2PhoneAlert;


@property (nonatomic, retain) UIButton *removeGuardiansButton;

@property (nonatomic, retain) UILabel *miniGuardErrorLabel;
@property int currentGuardianSelection;
@property (nonatomic, retain) UIView *guardianBackground;
@property (nonatomic, retain) UIButton *miniGuardAddButton;
@property (nonatomic, retain) UIButton *miniGuardCancelButton;

@property (nonatomic, retain) UITextField *oneName;
@property (nonatomic, retain) UITextField *oneEmail;
@property (nonatomic, retain) UITextField *onePhone;

@property (nonatomic, retain) UITextField *twoName;
@property (nonatomic, retain) UITextField *twoEmail;
@property (nonatomic, retain) UITextField *twoPhone;

@property bool twoAlerts;
@property (nonatomic, retain) NSString *guardianOnePhone;
@property (nonatomic, retain) NSString *guardianTwoPhone;
@property (nonatomic, retain) UIAlertView *miniMultipleEmailAlert;
@property (nonatomic, retain) UIAlertView *miniMultiplePhoneAlert;
@property (nonatomic, retain) NSString *miniMultiple;
@property (nonatomic, retain) NSString *tmpMiniEmail;
@property (nonatomic, retain) NSString *tmpMiniPhone;
@property (nonatomic, retain) NSString *tmpMiniFirstName;
@property (nonatomic, retain) NSString *tmpMiniLastName;

@property (nonatomic, retain) UIAlertView *multipleEmailAlert;
@property (nonatomic, retain) UIAlertView *multiplePhoneAlert;
@property (nonatomic, retain) NSMutableArray *multiplePhoneArray;
@property (nonatomic, retain) NSMutableArray *multipleEmailArray;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;

@property (nonatomic, retain) UIButton *addContactButton;
@property (nonatomic, retain) UIActivityIndicatorView *multipleActivity;
@property bool isMiniAdd;
@property (nonatomic, retain) UIView *addViewBackground;
@property (nonatomic, retain) UIView *addView;

@property (nonatomic, retain) UIButton *closeMultipleButton;
@property (nonatomic, retain) UIButton *saveButton;

@property (nonatomic, retain) NSMutableArray *emailArray;
@property (nonatomic, retain) UIButton *addNewButton;

@property (nonatomic, retain) UITableView *myTableView;

@property (nonatomic, retain) UIView *miniBackgroundView;
@property (nonatomic, retain) UIView *miniForeGroundView;
@property (nonatomic, retain) UITextField *nameText;
@property (nonatomic, retain) UITextField *emailText;
@property (nonatomic, retain) UITextField *phoneText;
@property (nonatomic, retain) UILabel *miniErrorLabel;
@property (nonatomic, retain) UIButton *miniCancelButton;
@property (nonatomic, retain) UIButton *miniAddButton;


@property (nonatomic, retain) UIButton *addMultipleMembersButton;

@property (nonatomic, retain) UITextField *phoneNumber;
@property (nonatomic, retain) NSString *firstNamePicked;
@property (nonatomic, retain) NSString *lastNamePicked;

@property (nonatomic, retain) NSString *errorString;
//Parent/Guardian
@property  bool useGuardians;
@property (nonatomic, retain) NSString *guardianOneFirst;
@property (nonatomic, retain) NSString *guardianOneLast;
@property (nonatomic, retain) NSString *guardianOneEmail;
@property (nonatomic, retain) NSString *guardianTwoFirst;
@property (nonatomic, retain) NSString *guardianTwoLast;
@property (nonatomic, retain) NSString *guardianTwoEmail;
@property (nonatomic, retain) UIButton *addParentGuardianButton;


@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIButton *sendEmailButton;
@property (nonatomic, retain) NSString *userRole;
@property (nonatomic, retain) UITextField *firstName;
@property (nonatomic, retain) UITextField *lastName;
@property (nonatomic, retain) UITextField *email;
@property (nonatomic, retain) NSArray *guardianEmail;
@property (nonatomic, retain) NSArray *roles;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) UIActivityIndicatorView *serverProcess;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *error;
@property bool createSuccess;
@property (nonatomic, retain) UISegmentedControl *isCoordinator;
@property (nonatomic, retain) UIScrollView *helpScreen;
@property (nonatomic, retain) UIBarButtonItem *barItem;

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
