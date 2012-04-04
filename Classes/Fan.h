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
    
    
    PhoneNumberFormatter *myPhoneNumberFormatter;
    int myTextFieldSemaphore;

    
}

@property (nonatomic, strong) NSString *theFirstEdit;
@property (nonatomic, strong) NSString *theLastEdit;
@property (nonatomic, strong) NSString *theEmailEdit;
@property (nonatomic, strong) NSString *theMobileEdit;


@property bool justChose;
@property bool isEmailConfirmed;

@property (nonatomic, strong) IBOutlet UIButton *callTextButton;
@property (nonatomic, strong) UIActionSheet *callTextAction;
@property (nonatomic, strong, getter = theNewPhoneAlert) UIAlertView *newPhoneAlert;
@property (nonatomic, strong, getter = initialPhone, setter = initialPhone:) NSString *initPhone;
@property (nonatomic, strong) NSMutableArray *phoneOnlyArray;
@property (nonatomic, strong) IBOutlet UITextField *mobileEdit;
@property bool isSmsConfirmed;
@property (nonatomic, strong) UIActionSheet *deleteFanAction;
@property bool portrait;
@property bool isCurrentUser;
@property (nonatomic, strong) IBOutlet UIButton *profilePhotoButton;

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) IBOutlet UILabel *switchToMemberLabel;
@property (nonatomic, strong) IBOutlet UIButton *switchToMemberButton;
@property bool fromCameraSelect;

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSData *selectedData;
@property (nonatomic, strong, getter = theNewImage) UIImage *newImage;
@property (nonatomic, strong) UIActionSheet *changeProfilePicAction;
@property (nonatomic, strong) NSDictionary *playerInfo;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) NSString *errorString;
@property bool isUser;
@property bool isNetworkAuthenticated;
@property bool deleteSuccess;
@property (nonatomic, strong) IBOutlet UIButton *deleteFanButton;
@property bool fromSearch;


@property (nonatomic, strong) NSData *origCompressImage;
@property (nonatomic, strong) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSString *headUserRole;


@property (nonatomic, strong) IBOutlet UIButton *startEditButton;
@property (nonatomic, strong) IBOutlet UIButton *endEditButton;
@property bool isEditing;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *fromEdit;
@property (nonatomic, strong) NSData *compressImage;
@property (nonatomic, strong) UIImage *tempProfileImage;

@property (nonatomic, strong) IBOutlet UITextField *firstEdit;
@property (nonatomic, strong) IBOutlet UITextField *lastEdit;
@property (nonatomic, strong) IBOutlet UITextField *emailEdit;

@property (nonatomic, strong) IBOutlet UILabel *emailLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *sendMessageButton;

@property (nonatomic, strong) IBOutlet UIButton *addPhotoButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) IBOutlet UIImageView *profileImage;

@property (nonatomic, strong) IBOutlet UILabel *displayMessage;
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
