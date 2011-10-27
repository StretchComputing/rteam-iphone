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

@property (nonatomic, strong) UIButton *callTextButton;
@property (nonatomic, strong) UIActionSheet *callTextAction;
@property (nonatomic, strong, getter = theNewPhoneAlert) UIAlertView *newPhoneAlert;
@property (nonatomic, strong) NSString *initPhone;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) UITextField *mobileEdit;
@property bool isSmsConfirmed;
@property (nonatomic, strong) UIActionSheet *deleteFanAction;
@property bool portrait;
@property bool isCurrentUser;
@property (nonatomic, strong) UIButton *profilePhotoButton;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) UILabel *switchToMemberLabel;
@property (nonatomic, strong) UIButton *switchToMemberButton;
@property bool fromCameraSelect;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSData *selectedData;
@property (nonatomic, strong, getter = theNewImage) UIImage *newImage;
@property (nonatomic, strong) UIActionSheet *changeProfilePicAction;
@property (nonatomic, strong) NSDictionary *playerInfo;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *errorString;
@property bool isUser;
@property bool isNetworkAuthenticated;
@property bool deleteSuccess;
@property (nonatomic, strong) UIButton *deleteFanButton;
@property bool fromSearch;


@property (nonatomic, strong) NSData *origCompressImage;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) NSString *headUserRole;


@property (nonatomic, strong) UIButton *startEditButton;
@property (nonatomic, strong) UIButton *endEditButton;
@property bool isEditing;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *fromEdit;
@property (nonatomic, strong) NSData *compressImage;
@property (nonatomic, strong) UIImage *tempProfileImage;

@property (nonatomic, strong) UITextField *firstEdit;
@property (nonatomic, strong) UITextField *lastEdit;
@property (nonatomic, strong) UITextField *emailEdit;

@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *sendMessageButton;

@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UIImageView *profileImage;

@property (nonatomic, strong) UILabel *displayMessage;
@property bool messageSent;

@property (nonatomic, strong) NSString *userRole;

@property (nonatomic, strong) NSString *phone;

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
