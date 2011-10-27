//
//  InviteFanFinal.h
//  rTeam
//
//  Created by Nick Wroblewski on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface InviteFanFinal : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate> {
    
    NSString *teamName;
	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *email;
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
    
    
    NSString *addContactWhere;
    
    NSMutableArray *multipleEmailArrayLabels;
    NSMutableArray *multiplePhoneArrayLabels;
    
    IBOutlet UISegmentedControl *coordinatorSegment;
    
    UIAlertView *phoneTextAlert;
}
@property (nonatomic, strong) UIAlertView *phoneTextAlert;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UISegmentedControl *coordinatorSegment;

@property (nonatomic, strong) NSMutableArray *multipleEmailArrayLabels;
@property (nonatomic, strong) NSMutableArray *multiplePhoneArrayLabels;



@property (nonatomic, strong) NSString *addContactWhere;


@property bool twoAlerts;

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



@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *sendEmailButton;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *email;
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
-(IBAction)showPicker:(id)sender;
-(IBAction)addMultipleMembers;

-(IBAction)addNew;
-(IBAction)closeMultiple;
-(IBAction)saveMultiple;
-(IBAction)miniAdd;
-(IBAction)miniCancel;



-(NSString *)getType:(NSString *)typeLabel;

@end
