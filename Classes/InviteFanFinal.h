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
    
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

}

@property (nonatomic, strong) NSString *theFirstName;
@property (nonatomic, strong) NSString *theLastName;
@property (nonatomic, strong) NSString *theEmail;
@property (nonatomic, strong) NSString *thePhoneNumber;

@property (nonatomic, strong) UIAlertView *phoneTextAlert;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UISegmentedControl *coordinatorSegment;

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

@property (nonatomic, strong) IBOutlet UIButton *addContactButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *multipleActivity;
@property bool isMiniAdd;
@property (nonatomic, strong) IBOutlet UIView *addViewBackground;
@property (nonatomic, strong) IBOutlet UIView *addView;

@property (nonatomic, strong) IBOutlet UIButton *closeMultipleButton;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) IBOutlet UIButton *addNewButton;

@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) IBOutlet UIView *miniBackgroundView;
@property (nonatomic, strong) IBOutlet UIView *miniForeGroundView;
@property (nonatomic, strong) IBOutlet UITextField *nameText;
@property (nonatomic, strong) IBOutlet UITextField *emailText;
@property (nonatomic, strong) IBOutlet UITextField *phoneText;
@property (nonatomic, strong) IBOutlet  UILabel *miniErrorLabel;
@property (nonatomic, strong) IBOutlet UIButton *miniCancelButton;
@property (nonatomic, strong) IBOutlet UIButton *miniAddButton;


@property (nonatomic, strong) IBOutlet UIButton *addMultipleMembersButton;

@property (nonatomic, strong) IBOutlet UITextField *phoneNumber;
@property (nonatomic, strong) NSString *firstNamePicked;
@property (nonatomic, strong) NSString *lastNamePicked;

@property (nonatomic, strong) NSString *errorString;



@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIButton *sendEmailButton;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) IBOutlet UITextField *firstName;
@property (nonatomic, strong) IBOutlet UITextField *lastName;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) NSArray *roles;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *serverProcess;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *error;
@property bool createSuccess;
@property (nonatomic, strong) IBOutlet UISegmentedControl *isCoordinator;
@property (nonatomic, strong) IBOutlet UIScrollView *helpScreen;
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
