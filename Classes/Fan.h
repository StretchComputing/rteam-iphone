//
//  Fan.h
//  rTeam
//
//  Created by Nick Wroblewski on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumberFormatter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface Fan : UIViewController  < UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate,
MFMessageComposeViewControllerDelegate> {
	NSString *firstName;
	NSString *lastName;
	NSString *email;
	NSString *memberId;
	NSString *teamId;
	bool isUser;
	bool isNetworkAuthenticated;
	NSString *errorString;
    bool justChose;
	
	UIImage *tempProfileImage;
	
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;
    
	NSString *fromEdit;
	NSData *compressImage;
	NSData *origCompressImage;
	IBOutlet UIButton *startEditButton;
	IBOutlet UIButton *endEditButton;
	bool isEditing;
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *emailLabel;
	
	IBOutlet UITextField *firstEdit;
	IBOutlet UITextField *lastEdit;
	IBOutlet UITextField *emailEdit;

	
	IBOutlet UIButton *sendMessageButton;

	IBOutlet UIButton *addPhotoButton;
	
	IBOutlet UIImageView *profileImage;
	IBOutlet UIActivityIndicatorView *activity;
	
	IBOutlet UILabel *displayMessage;
    IBOutlet UITextField *mobileEdit;
	bool messageSent;
	bool contactAdded;
	

	NSString *userRole;
	

	
	
	
	NSString *phone;
	NSString *headUserRole;
	
	IBOutlet UILabel *errorLabel;

	bool fromSearch;
	
	IBOutlet UIButton *deleteFanButton;
	bool deleteSuccess;
	
	NSDictionary *playerInfo;
	IBOutlet UILabel *loadingLabel;
	IBOutlet UIActivityIndicatorView *loadingActivity;
	
	UIActionSheet *changeProfilePicAction;
	
	UIImage *newImage;
	
	bool fromCameraSelect;
	
	UIImage *selectedImage;
	NSData *selectedData;
	
	IBOutlet UILabel *switchToMemberLabel;
	IBOutlet UIButton *switchToMemberButton;
	
	NSString *teamName;
	
	IBOutlet UIButton *profilePhotoButton;
    
    bool isCurrentUser;
    
    bool portrait;

    UIActionSheet *deleteFanAction;
    
    bool isSmsConfirmed;
    
    NSMutableArray *phoneOnlyArray;
    NSString *initPhone;
    UIAlertView *newPhoneAlert;
    
    IBOutlet UIButton *callTextButton;
    UIActionSheet *callTextAction;

    bool isEmailConfirmed;
    
}
@property bool isEmailConfirmed;

@property (nonatomic, retain) UIButton *callTextButton;
@property (nonatomic, retain) UIActionSheet *callTextAction;
@property (nonatomic, retain) UIAlertView *newPhoneAlert;
@property (nonatomic, retain) NSString *initPhone;
@property (nonatomic, retain) NSMutableArray *phoneOnlyArray;
@property (nonatomic, retain) UITextField *mobileEdit;
@property bool isSmsConfirmed;
@property (nonatomic, retain) UIActionSheet *deleteFanAction;
@property bool portrait;
@property bool isCurrentUser;
@property (nonatomic, retain) UIButton *profilePhotoButton;

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) UILabel *switchToMemberLabel;
@property (nonatomic, retain) UIButton *switchToMemberButton;
@property bool fromCameraSelect;

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSData *selectedData;
@property (nonatomic, retain) UIImage *newImage;
@property (nonatomic, retain) UIActionSheet *changeProfilePicAction;
@property (nonatomic, retain) NSDictionary *playerInfo;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, retain) NSString *errorString;
@property bool isUser;
@property bool isNetworkAuthenticated;
@property bool deleteSuccess;
@property (nonatomic, retain) UIButton *deleteFanButton;
@property bool fromSearch;


@property (nonatomic, retain) NSData *origCompressImage;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) NSString *headUserRole;


@property (nonatomic, retain) UIButton *startEditButton;
@property (nonatomic, retain) UIButton *endEditButton;
@property bool isEditing;

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *memberId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *fromEdit;
@property (nonatomic, retain) NSData *compressImage;
@property (nonatomic, retain) UIImage *tempProfileImage;

@property (nonatomic, retain) UITextField *firstEdit;
@property (nonatomic, retain) UITextField *lastEdit;
@property (nonatomic, retain) UITextField *emailEdit;

@property (nonatomic, retain) UILabel *emailLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIButton *sendMessageButton;

@property (nonatomic, retain) UIButton *addPhotoButton;
@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) UIImageView *profileImage;

@property (nonatomic, retain) UILabel *displayMessage;
@property bool messageSent;

@property (nonatomic, retain) NSString *userRole;

@property (nonatomic, retain) NSString *phone;

-(IBAction) sendMessage;
-(IBAction) endText;

-(IBAction)editProfilePic;
-(void) getPhoto:(NSString *)option;

-(IBAction)editStart;


-(IBAction)switchToMember;
-(IBAction)deleteFan;

-(IBAction)profilePhoto;
-(IBAction)callText;

-(void)callPhone;
-(void)textPhone;
@end
