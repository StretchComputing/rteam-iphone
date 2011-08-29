//
//  NewTeam.h
//  iCoach
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PhoneNumberFormatter.h"



@interface NewTeam : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {

	IBOutlet UITextField *teamName;
	IBOutlet UILabel *errorLabel;
	NSString *from;
	NSArray *oldTeams;
	IBOutlet UIActivityIndicatorView *serverProcess;
	IBOutlet UIButton *submitButton;
	IBOutlet UISegmentedControl *enableTwitter;
	NSString *twitterUrl;
	bool createSuccess;
	bool other;
	
	PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
	
	NSString *errorString;
	
	IBOutlet UIButton *addButton;
	
	IBOutlet UIView *addViewBackground;
	IBOutlet UIView *addView;
	
	IBOutlet UIButton *closeButton;
	IBOutlet UIButton *saveButton;
	
	NSMutableArray *emailArray;
	NSString *teamId;
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
	
	NSMutableArray *phoneOnlyArray;
	
	UIAlertView *noMembers;
	bool showedMemberAlert;
    bool fromHome;
    
    NSMutableArray *multiplePhoneArray;
    NSMutableArray *multipleEmailArray;
    
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
@property (nonatomic, retain) NSMutableArray *multiplePhoneArray;
@property (nonatomic, retain) NSMutableArray *multipleEmailArray;

@property (nonatomic, retain) NSString *tmpMiniEmail;
@property (nonatomic, retain) NSString *tmpMiniPhone;
@property (nonatomic, retain) NSString *tmpMiniFirstName;
@property (nonatomic, retain) NSString *tmpMiniLastName;
@property (nonatomic, retain) NSString *miniMultiple;
@property (nonatomic, retain) UIAlertView *miniMultipleEmailAlert;
@property (nonatomic, retain) UIAlertView *miniMultiplePhoneAlert;

@property bool fromHome;
@property bool showedMemberAlert;
@property (nonatomic, retain) UIAlertView *noMembers;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;
@property (nonatomic, retain) UIView *miniBackgroundView;
@property (nonatomic, retain) UIView *miniForeGroundView;
@property (nonatomic, retain) UITextField *nameText;
@property (nonatomic, retain) UITextField *emailText;
@property (nonatomic, retain) UITextField *phoneText;
@property (nonatomic, retain) UILabel *miniErrorLabel;
@property (nonatomic, retain) UIButton *miniCancelButton;
@property (nonatomic, retain) UIButton *miniAddButton;

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIButton *addNewButton;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSMutableArray *emailArray;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIButton *saveButton;

@property (nonatomic, retain) UIView *addViewBackground;
@property (nonatomic, retain) UIView *addView;

@property (nonatomic, retain) UIButton *addButton;
@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSString *twitterUrl;
@property (nonatomic, retain) UITextField *teamName;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSArray *oldTeams;
@property (nonatomic, retain) UIActivityIndicatorView *serverProcess;
@property (nonatomic, retain) UISegmentedControl *enableTwitter;
@property (nonatomic, retain) UIButton *submitButton;
@property bool createSuccess;
@property bool other;

-(IBAction)create;
-(IBAction)endText;
-(IBAction)add;
-(IBAction)close;
-(IBAction)save;
-(IBAction)showPicker:(id)sender;
-(IBAction)addNew;
-(IBAction)addContact;

-(IBAction)miniAdd;
-(IBAction)miniCancel;
-(IBAction)miniGuardAdd;
-(IBAction)miniGuardCancel;
-(IBAction)removeGuardians;
-(NSString *)getType:(NSString *)typeLabel;
@end
