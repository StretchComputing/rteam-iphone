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
	
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

    
}
@property bool justChose;
@property (nonatomic, strong) NSString *theFirstEdit;
@property (nonatomic, strong) NSString *theLastEdit;
@property (nonatomic, strong) NSString *theJerseyEdit;
@property (nonatomic, strong) NSString *theEmailEdit;
@property (nonatomic, strong) NSString *theMobileEdit;


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
@property (nonatomic, strong) IBOutlet UIButton *profilePhotoButton;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UILabel *switchFanLabel;
@property (nonatomic, strong) IBOutlet UIButton *switchFanButton;
@property bool shouldUnload;
@property bool fromCameraSelect;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSData *selectedData;

@property (nonatomic, strong, getter = theNewImage) UIImage *newImage;
@property (nonatomic, strong) UIActionSheet *changeProfilePicAction;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
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
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *guardiansArray;
@property (nonatomic, strong) IBOutlet UIButton *editGuardianInfoButton;
@property bool fromSearch;


@property (nonatomic, strong) NSData *origCompressImage;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *headUserRole;
@property (nonatomic, strong) NSString *phone;


@property (nonatomic, strong) IBOutlet UIButton *startEditButton;
@property (nonatomic, strong) IBOutlet UIButton *endEditButton;
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

@property (nonatomic, strong) IBOutlet UITextField *firstEdit;
@property (nonatomic, strong) IBOutlet UITextField *lastEdit;
@property (nonatomic, strong) IBOutlet UITextField *emailEdit;
@property (nonatomic, strong) IBOutlet UITextField *mobileEdit;
@property (nonatomic, strong) IBOutlet UITextField *jerseyEdit;
@property (nonatomic, strong) IBOutlet UILabel *emailLabel;
@property (nonatomic, strong) IBOutlet UILabel *jerseyLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, strong) IBOutlet UIButton *addContactButton;
@property (nonatomic, strong) IBOutlet UIButton *callNumberButton;
@property (nonatomic, strong) IBOutlet UIButton *addPhotoButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) IBOutlet UIImageView *profileImage;

@property (nonatomic, strong) IBOutlet UILabel *displayMessage;
@property bool messageSent;
@property bool contactAdded;

@property (nonatomic, strong) IBOutlet UIButton *changeRoleButton;
@property (nonatomic, strong) IBOutlet UITextView *changeRoleText;
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
