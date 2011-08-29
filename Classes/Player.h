//
//  Player.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface Player : UIViewController  < UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, 
MFMessageComposeViewControllerDelegate, UIActionSheetDelegate > {
	
	NSString *firstName;
	NSString *lastName;
	NSString *email;
	NSString *jersey;
	NSString *memberId;
	NSString *teamId;
	bool isUser;
	bool isNetworkAuthenticated;
	NSString *errorString;
    
    NSString *guard1Email;
    NSString *guard1Phone;
    NSString *guard1First;
    NSString *guard1Last;
    NSString *guard1Key;
    bool guard1NA;
    bool guard1SmsConfirmed;
    bool guard1EmailConfirmed;
    bool guard2EmailConfirmed;


    bool guard1isUser;
	
    NSString *guard2Email;
    NSString *guard2Phone;
    NSString *guard2First;
    NSString *guard2Last;
    NSString *guard2Key;
    bool guard2NA;
    bool guard2SmsConfirmed;
    bool guard2isUser;
    
	PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

	UIAlertView *alertContact;
	UIAlertView *alertRole;

	UIImage *tempProfileImage;
	
	NSString *fromEdit;
	NSData *compressImage;
	NSData *origCompressImage;
	IBOutlet UIButton *startEditButton;
	IBOutlet UIButton *endEditButton;
	bool isEditing;
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *jerseyLabel;
	IBOutlet UILabel *emailLabel;
	
	IBOutlet UITextField *firstEdit;
	IBOutlet UITextField *lastEdit;
	IBOutlet UITextField *emailEdit;
	IBOutlet UITextField *mobileEdit;
	IBOutlet UITextField *jerseyEdit;
	
	IBOutlet UIButton *sendMessageButton;
	IBOutlet UIButton *addContactButton;
	IBOutlet UIButton *callNumberButton;
	IBOutlet UIButton *addPhotoButton;
	
	IBOutlet UIImageView *profileImage;
	IBOutlet UIActivityIndicatorView *activity;
	
	IBOutlet UILabel *displayMessage;
	bool messageSent;
	bool contactAdded;
	
	IBOutlet UIButton *changeRoleButton;
	IBOutlet UITextView *changeRoleText;
	NSString *userRole;
	
	NSString *changedRole;
	bool shouldChangeRole;
	

	
	NSString *phone;
	NSString *headUserRole;
	
	IBOutlet UILabel *errorLabel;

	
	bool fromSearch;
	
	IBOutlet UIButton *editGuardianInfoButton;
	
	NSArray *guardiansArray;
	
	IBOutlet UIButton *deleteButton;
	IBOutlet UIScrollView *scrollView;
	
	UIAlertView *alertDelete;
	bool deleteSuccess;
	bool fromImage;
	UIAlertView *alertCallText;
											
	UIActionSheet *deleteActionSheet;
	UIActionSheet *roleActionSheet;
	UIActionSheet *callTextActionSheet;

	NSDictionary *playerInfo;
											
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
											
	UIActionSheet *changeProfilePicAction;
	
	UIImage *newImage;
	
	bool fromCameraSelect;
	UIImage *selectedImage;
	NSData *selectedData;
	
	bool shouldUnload;
	
	IBOutlet UIButton *switchFanButton;
	IBOutlet UILabel *switchFanLabel;
	
	NSString *teamName;
	
	IBOutlet UIButton *profilePhotoButton;
    
    bool isCurrentUser;
    
    bool justChose;
    
    bool portrait;
    bool isSmsConfirmed;
    
    NSMutableArray *phoneOnlyArray;
    
    NSString *callOrTextWho;
    
    UIAlertView *callTextWhoAlertView;
    
    int scenario;
    
    NSString *initPhone;
    
    UIAlertView *newPhoneAlert;
    bool isEmailConfirmed;
    bool didHideMessage;

}
@property bool didHideMessage;
@property bool isEmailConfirmed;
@property (nonatomic, retain) UIAlertView *newPhoneAlert;
@property (nonatomic, retain) NSString *initPhone;
@property int scenario;
@property (nonatomic, retain) UIAlertView *callTextWhoAlertView;
@property (nonatomic, retain) NSString *callOrTextWho;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;
@property bool isSmsConfirmed;
@property (nonatomic, retain) NSString *guard1Key;
@property (nonatomic, retain) NSString *guard2Key;


@property (nonatomic, retain) NSString *guard1Email;
@property (nonatomic, retain) NSString *guard1Phone;
@property (nonatomic, retain) NSString *guard1First;
@property (nonatomic, retain) NSString *guard1Last;
@property bool guard1NA;
@property bool guard1SmsConfirmed;
@property bool guard1EmailConfirmed;
@property bool guard2EmailConfirmed;


@property bool guard1isUser;


@property (nonatomic, retain) NSString *guard2Email;
@property (nonatomic, retain) NSString *guard2Phone;
@property (nonatomic, retain) NSString *guard2First;
@property (nonatomic, retain) NSString *guard2Last;
@property bool guard2NA;
@property bool guard2SmsConfirmed;
@property bool guard2isUser;


@property bool portrait;
@property bool isCurrentUser;
@property (nonatomic, retain) UIButton *profilePhotoButton;

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) UILabel *switchFanLabel;
@property (nonatomic, retain) UIButton *switchFanButton;
@property bool shouldUnload;
@property bool fromCameraSelect;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSData *selectedData;

@property (nonatomic, retain) UIImage *newImage;
@property (nonatomic, retain) UIActionSheet *changeProfilePicAction;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) NSDictionary *playerInfo;
@property (nonatomic, retain) UIActionSheet *callTextActionSheet;
@property (nonatomic, retain) UIActionSheet *deleteActionSheet;
@property (nonatomic, retain) UIActionSheet *roleActionSheet;
@property (nonatomic, retain) NSString *errorString;
@property bool isUser;
@property bool isNetworkAuthenticated;
@property (nonatomic, retain) UIAlertView *alertCallText;
@property bool fromImage;
@property bool deleteSuccess;
@property (nonatomic, retain) UIAlertView *alertDelete;
@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSArray *guardiansArray;
@property (nonatomic, retain) IBOutlet UIButton *editGuardianInfoButton;
@property bool fromSearch;


@property (nonatomic, retain) NSData *origCompressImage;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSString *headUserRole;
@property (nonatomic, retain) NSString *phone;


@property (nonatomic, retain) UIButton *startEditButton;
@property (nonatomic, retain) UIButton *endEditButton;
@property bool isEditing;

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *jersey;
@property (nonatomic, retain) NSString *memberId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *fromEdit;
@property (nonatomic, retain) NSData *compressImage;
@property (nonatomic, retain) UIImage *tempProfileImage;

@property (nonatomic, retain) UITextField *firstEdit;
@property (nonatomic, retain) UITextField *lastEdit;
@property (nonatomic, retain) UITextField *emailEdit;
@property (nonatomic, retain) UITextField *mobileEdit;
@property (nonatomic, retain) UITextField *jerseyEdit;
@property (nonatomic, retain) UILabel *emailLabel;
@property (nonatomic, retain) UILabel *jerseyLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIButton *sendMessageButton;
@property (nonatomic, retain) UIButton *addContactButton;
@property (nonatomic, retain) UIButton *callNumberButton;
@property (nonatomic, retain) UIButton *addPhotoButton;
@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) UIImageView *profileImage;

@property (nonatomic, retain) UILabel *displayMessage;
@property bool messageSent;
@property bool contactAdded;

@property (nonatomic, retain) UIButton *changeRoleButton;
@property (nonatomic, retain) UITextView *changeRoleText;
@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) UIAlertView *alertContact;
@property (nonatomic, retain) UIAlertView *alertRole;
@property (nonatomic, retain) NSString *changedRole;
@property bool shouldChangeRole;

-(IBAction) sendMessage;
-(IBAction) addContact;
-(IBAction) callNumber;
-(IBAction) endText;

-(IBAction)editProfilePic;
-(void) getPhoto:(NSString *)option;

-(IBAction)editStart;

-(IBAction)changeRole;
-(IBAction)editGuardianInfo;

-(void)getMemberInformation;
-(IBAction)deleteMember;


-(void)showActionSheetDelete;
-(void)showActionSheetRole;
-(void)showActionSheetCallText;

-(IBAction)switchFan;
-(IBAction)profilePhoto;

-(void)callPhone;
-(void)textPhone;

@end
