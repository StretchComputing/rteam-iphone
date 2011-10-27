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
@property (nonatomic, strong, getter = theNewPhoneAlert) UIAlertView *newPhoneAlert;
@property (nonatomic, strong) NSString *initPhone;
@property int scenario;
@property (nonatomic, strong) UIAlertView *callTextWhoAlertView;
@property (nonatomic, strong) NSString *callOrTextWho;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property bool isSmsConfirmed;
@property (nonatomic, strong) NSString *guard1Key;
@property (nonatomic, strong) NSString *guard2Key;


@property (nonatomic, strong) NSString *guard1Email;
@property (nonatomic, strong) NSString *guard1Phone;
@property (nonatomic, strong) NSString *guard1First;
@property (nonatomic, strong) NSString *guard1Last;
@property bool guard1NA;
@property bool guard1SmsConfirmed;
@property bool guard1EmailConfirmed;
@property bool guard2EmailConfirmed;


@property bool guard1isUser;


@property (nonatomic, strong) NSString *guard2Email;
@property (nonatomic, strong) NSString *guard2Phone;
@property (nonatomic, strong) NSString *guard2First;
@property (nonatomic, strong) NSString *guard2Last;
@property bool guard2NA;
@property bool guard2SmsConfirmed;
@property bool guard2isUser;


@property bool portrait;
@property bool isCurrentUser;
@property (nonatomic, strong) UIButton *profilePhotoButton;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UILabel *switchFanLabel;
@property (nonatomic, strong) UIButton *switchFanButton;
@property bool shouldUnload;
@property bool fromCameraSelect;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSData *selectedData;

@property (nonatomic, strong, getter = theNewImage) UIImage *newImage;
@property (nonatomic, strong) UIActionSheet *changeProfilePicAction;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSDictionary *playerInfo;
@property (nonatomic, strong) UIActionSheet *callTextActionSheet;
@property (nonatomic, strong) UIActionSheet *deleteActionSheet;
@property (nonatomic, strong) UIActionSheet *roleActionSheet;
@property (nonatomic, strong) NSString *errorString;
@property bool isUser;
@property bool isNetworkAuthenticated;
@property (nonatomic, strong) UIAlertView *alertCallText;
@property bool fromImage;
@property bool deleteSuccess;
@property (nonatomic, strong) UIAlertView *alertDelete;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *guardiansArray;
@property (nonatomic, strong) IBOutlet UIButton *editGuardianInfoButton;
@property bool fromSearch;


@property (nonatomic, strong) NSData *origCompressImage;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) NSString *headUserRole;
@property (nonatomic, strong) NSString *phone;


@property (nonatomic, strong) UIButton *startEditButton;
@property (nonatomic, strong) UIButton *endEditButton;
@property bool isEditing;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *jersey;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *fromEdit;
@property (nonatomic, strong) NSData *compressImage;
@property (nonatomic, strong) UIImage *tempProfileImage;

@property (nonatomic, strong) UITextField *firstEdit;
@property (nonatomic, strong) UITextField *lastEdit;
@property (nonatomic, strong) UITextField *emailEdit;
@property (nonatomic, strong) UITextField *mobileEdit;
@property (nonatomic, strong) UITextField *jerseyEdit;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *jerseyLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, strong) UIButton *addContactButton;
@property (nonatomic, strong) UIButton *callNumberButton;
@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UIImageView *profileImage;

@property (nonatomic, strong) UILabel *displayMessage;
@property bool messageSent;
@property bool contactAdded;

@property (nonatomic, strong) UIButton *changeRoleButton;
@property (nonatomic, strong) UITextView *changeRoleText;
@property (nonatomic, strong) NSString *userRole;

@property (nonatomic, strong) UIAlertView *alertContact;
@property (nonatomic, strong) UIAlertView *alertRole;
@property (nonatomic, strong) NSString *changedRole;
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
