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
    
	PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

}
@property (nonatomic, strong) NSString *theTeamName;
@property (nonatomic, strong) IBOutlet UISegmentedControl *coordinatorSegment;

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

@property (nonatomic, strong) IBOutlet UIButton *removeGuardiansButton;

@property (nonatomic, strong) IBOutlet UILabel *miniGuardErrorLabel;
@property int currentGuardianSelection;
@property (nonatomic, strong) IBOutlet UIView *guardianBackground;
@property (nonatomic, strong) IBOutlet UIButton *miniGuardAddButton;
@property (nonatomic, strong) IBOutlet UIButton *miniGuardCancelButton;

@property (nonatomic, strong) IBOutlet UITextField *oneName;
@property (nonatomic, strong) IBOutlet UITextField *oneEmail;
@property (nonatomic, strong) IBOutlet UITextField *onePhone;

@property (nonatomic, strong) IBOutlet UITextField *twoName;
@property (nonatomic, strong) IBOutlet UITextField *twoEmail;
@property (nonatomic, strong) IBOutlet UITextField *twoPhone;


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
@property (nonatomic, strong) IBOutlet UIView *miniBackgroundView;
@property (nonatomic, strong) IBOutlet UIView *miniForeGroundView;
@property (nonatomic, strong) IBOutlet UITextField *nameText;
@property (nonatomic, strong) IBOutlet UITextField *emailText;
@property (nonatomic, strong) IBOutlet UITextField *phoneText;
@property (nonatomic, strong) IBOutlet UILabel *miniErrorLabel;
@property (nonatomic, strong) IBOutlet UIButton *miniCancelButton;
@property (nonatomic, strong) IBOutlet UIButton *miniAddButton;

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIButton *addNewButton;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong)IBOutlet  UIButton *saveButton;

@property (nonatomic, strong) IBOutlet UIView *addViewBackground;
@property (nonatomic, strong) IBOutlet UIView *addView;

@property (nonatomic, strong) IBOutlet UIButton *addButton;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) NSString *twitterUrl;
@property (nonatomic, strong) IBOutlet UITextField *teamName;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSArray *oldTeams;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) IBOutlet UISegmentedControl *enableTwitter;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
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
