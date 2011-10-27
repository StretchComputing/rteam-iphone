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
@property (nonatomic, strong) NSMutableArray *multiplePhoneArray;
@property (nonatomic, strong) NSMutableArray *multipleEmailArray;

@property (nonatomic, strong) NSString *tmpMiniEmail;
@property (nonatomic, strong) NSString *tmpMiniPhone;
@property (nonatomic, strong) NSString *tmpMiniFirstName;
@property (nonatomic, strong) NSString *tmpMiniLastName;
@property (nonatomic, strong) NSString *miniMultiple;
@property (nonatomic, strong) UIAlertView *miniMultipleEmailAlert;
@property (nonatomic, strong) UIAlertView *miniMultiplePhoneAlert;

@property bool fromHome;
@property bool showedMemberAlert;
@property (nonatomic, strong) UIAlertView *noMembers;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) UIView *miniBackgroundView;
@property (nonatomic, strong) UIView *miniForeGroundView;
@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *emailText;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UILabel *miniErrorLabel;
@property (nonatomic, strong) UIButton *miniCancelButton;
@property (nonatomic, strong) UIButton *miniAddButton;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *addNewButton;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIView *addViewBackground;
@property (nonatomic, strong) UIView *addView;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *twitterUrl;
@property (nonatomic, strong) UITextField *teamName;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSArray *oldTeams;
@property (nonatomic, strong) UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) UISegmentedControl *enableTwitter;
@property (nonatomic, strong) UIButton *submitButton;
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
