//
//  Fan.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Fan.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Base64.h"
#import "PhoneNumberFormatter.h"
#import "PlayerAttendance.h"
#include <math.h>
#import "QuartzCore/QuartzCore.h"
#import "EditGuardianInfo.h"
#import "CurrentTeamTabs.h"
#import "CameraSelectionProfile.h"
#import "ProfilePhoto.h"
#import "FastActionSheet.h"
#import "GANTracker.h"
#import "TraceSession.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}




@implementation Fan
@synthesize firstName, lastName, email, memberId, teamId, tempProfileImage, fromEdit, compressImage, firstEdit, lastEdit,
emailEdit, nameLabel, emailLabel, sendMessageButton, profileImage, startEditButton, endEditButton, switchToMemberLabel, switchToMemberButton,
addPhotoButton, activity, messageSent, displayMessage, userRole, headUserRole, isEditing, errorLabel, origCompressImage, 
fromSearch, deleteSuccess, deleteFanButton, isUser, isNetworkAuthenticated, errorString, playerInfo,
loadingActivity, loadingLabel, changeProfilePicAction, newImage, fromCameraSelect, selectedImage, selectedData, teamName, profilePhotoButton, phone,
isCurrentUser, portrait, deleteFanAction, isSmsConfirmed, mobileEdit, phoneOnlyArray, initPhone, newPhoneAlert, callTextAction, callTextButton,
isEmailConfirmed, justChose, theFirstEdit, theEmailEdit, theMobileEdit, theLastEdit;

-(void)viewDidLoad{
	
    self.firstEdit.text = @"";
    self.lastEdit.text = @"";
    self.mobileEdit.text = @"";
    self.emailEdit.text = @"";
    
    self.initPhone = @"";
	self.playerInfo = @{};
	
	self.profilePhotoButton.enabled = NO;
	
	self.deleteFanButton.hidden = YES;
    
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 3.0;
    
    myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    
	myTextFieldSemaphore = 0;
	self.mobileEdit.textColor = [UIColor blackColor];
	[self.mobileEdit addTarget:self
						action:@selector(autoFormatTextField:)
			  forControlEvents:UIControlEventEditingChanged
	 ];

	
}

-(void)viewDidAppear:(BOOL)animated{
	
	
	[self becomeFirstResponder];
}


-(void)memberInfo{
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response = [ServerAPI getMemberInfo:self.teamId :self.memberId :mainDelegate.token :@"true"];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            self.playerInfo = [response valueForKey:@"memberInfo"];
            
            self.errorString = @"";
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                default:
                    //Log the status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(getMemberInformation) withObject:nil waitUntilDone:NO];

    }
		
}
-(void)getMemberInformation{
	
	[self.loadingActivity stopAnimating];
	[self.loadingLabel setHidden:YES];
	
	if ([self.errorString isEqualToString:@""]) {
	
	self.firstName = [playerInfo valueForKey:@"firstName"];
	self.lastName = [playerInfo valueForKey:@"lastName"];
	
		self.nameLabel.text = @"";
		
		if (self.firstName != nil) {
			
			if (self.lastName != nil) {
				self.nameLabel.text = [[self.firstName stringByAppendingFormat:@" "] stringByAppendingString:self.lastName];
			}else {
				self.nameLabel.text = self.firstName;
			}
			
		}
        
        if (self.firstName == nil) {
            self.firstName = @"";
        }
        if (self.lastName == nil) {
            self.lastName = @"";
        }
		
	
        if ([playerInfo valueForKey:@"emailAddress"] != nil) {
            self.emailLabel.text = [playerInfo valueForKey:@"emailAddress"];
        }else{
            self.emailLabel.text = @"";
        }
        
        if ([playerInfo valueForKey:@"phoneNumber"] != nil) {
            self.phone = [playerInfo valueForKey:@"phoneNumber"];
            
            if (![self.phone isEqualToString:@""]) {
                
                NSString *myLocale = @"";
                self.initPhone = [myPhoneNumberFormatter format:self.phone withLocale:myLocale];
                self.callTextButton.hidden = NO;
            }
           
        }else{
            self.phone = @"";
        }
	

		if (self.fromCameraSelect) {
			self.fromCameraSelect = false;
			self.profileImage.image = self.selectedImage;
			self.newImage = self.selectedImage;
			self.compressImage = self.selectedData;
			[self.activity startAnimating];
			self.isEditing = false;
			
			[self performSelectorInBackground:@selector(runRequest2) withObject:nil];
		}else {
			NSString *profile = [playerInfo valueForKey:@"photo"];
			
			if ((profile == nil)  || ([profile isEqualToString:@""])){
				
				self.profileImage.image = [UIImage imageNamed:@"profileNew.png"];
			}else {
				
				NSData *profileData = [Base64 decode:profile];
				if (!justChose) {
                    self.compressImage = profileData;
                    self.origCompressImage = profileData;
                }else{
                    justChose = false;
                }
				self.profileImage.image = [UIImage imageWithData:profileData];
				//self.profileImage.image = [UIImage imageNamed:@"cellLacrosse.png"];
				self.profilePhotoButton.enabled = YES;
			}
			
		}

		if (self.profileImage.image.size.height > self.profileImage.image.size.width) {
            //Portrait
            self.profileImage.frame = CGRectMake(26, 34, 61, 81);
            self.profilePhotoButton.frame = CGRectMake(26, 34, 61, 81);
            
        }else{
            
            self.profileImage.frame = CGRectMake(16, 54, 81, 61);
            self.profilePhotoButton.frame = CGRectMake(16, 54, 81, 61);
            
        }
		
		self.emailLabel.hidden = NO;
		self.nameLabel.hidden =  NO;
		
		if ([self.headUserRole isEqualToString:@"coordinator"] || [self.headUserRole isEqualToString:@"creator"]) {
			self.startEditButton.hidden = NO;
			self.sendMessageButton.hidden = YES;//*MSGCHG
			
		}else {
			self.startEditButton.hidden = YES;
			
			if (![self.headUserRole isEqualToString:@"member"]) {
				self.sendMessageButton.hidden = YES;
			}else {
				self.sendMessageButton.hidden = YES;//*MSGCHG
			}
		}
        
        if (self.isCurrentUser){
            
            self.sendMessageButton.hidden = YES;
        }
		
	}else {
		self.errorLabel.text = self.errorString;
		[self.errorLabel setHidden:NO];
	}

	
}



- (void)viewWillAppear:(BOOL)animated{
	
    [TraceSession addEventToSession:@"Fan.m - View Will Appear"];

    self.callTextButton.hidden = YES;
	self.emailLabel.hidden = YES;
	self.nameLabel.hidden = YES;
	self.startEditButton.hidden = YES;
	self.sendMessageButton.hidden = YES;
	
	[self.loadingActivity startAnimating];
	[self.loadingLabel setHidden:NO];
	[self performSelectorInBackground:@selector(memberInfo) withObject:nil];
	
	
	if (self.messageSent) {
		self.displayMessage.text = @"*Message sent successfully!";
	}else {
		self.displayMessage.text = @"";
	}
	
	self.title = @"Fan Info";
	
	
	self.messageSent = FALSE;
	//userRole setup
		
	[self.errorLabel setHidden:YES];
	
	
	[self.firstEdit setHidden:YES];
	[self.lastEdit setHidden:YES];
	[self.emailEdit setHidden:YES];
    [self.mobileEdit setHidden:YES];

	[self.addPhotoButton setHidden:YES];
	
	
	[self.endEditButton setHidden:YES];
	//self.isEditing = false;
	
	if (!self.fromSearch) {
		//UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
		//[self.navigationItem setRightBarButtonItem:doneButton];
	}
	
	
	self.firstEdit.placeholder = @"First";
	self.lastEdit.placeholder = @"Last";
	self.emailEdit.placeholder = @"Email";
	
	self.switchToMemberLabel.hidden = YES;
	self.switchToMemberButton.hidden = YES;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.startEditButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.endEditButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addPhotoButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.callTextButton setBackgroundImage:stretch forState:UIControlStateNormal];


	[self.sendMessageButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.switchToMemberButton setBackgroundImage:stretch forState:UIControlStateNormal];

	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteFanButton setBackgroundImage:stretch1 forState:UIControlStateNormal];

	self.deleteFanButton.hidden = YES;
	
	
}




-(void)editStart{
	
	if (!self.isEditing) {
		
		self.isEditing = true;
		self.callTextButton.hidden = YES;
        if ([self.headUserRole isEqualToString:@"creator"] || [self.headUserRole isEqualToString:@"coordinator"]) {
            
            self.deleteFanButton.hidden = NO;
            
        }
        
        self.switchToMemberLabel.hidden = NO;
        self.switchToMemberButton.hidden = NO;

        
		self.profilePhotoButton.enabled = NO;
		
		
		[self.startEditButton setHidden:YES];
		[self.endEditButton setHidden:NO];
		[self.addPhotoButton setHidden:NO];

		
		//What to display when Edit button is clicked
		if ([self.firstName length] > 0) {
			self.firstEdit.text = self.firstName;
			self.firstEdit.textColor = [UIColor blackColor];
		}else {
			
		}
		
		
		if ([self.lastName length] > 0) {
			self.lastEdit.text = self.lastName;
			self.lastEdit.textColor = [UIColor blackColor];
		}else {
			
		}
		
		
		if ([self.emailLabel.text length] > 0) {
			self.emailEdit.text = self.emailLabel.text;
			self.emailEdit.textColor = [UIColor blackColor];
		}else {
			
		}
        
        if ([self.phone length] > 0) {
            NSString *myLocale;
            self.mobileEdit.text = [myPhoneNumberFormatter format:self.phone withLocale:myLocale];

			self.mobileEdit.textColor = [UIColor blackColor];
            self.callTextButton.hidden = NO;
		}else {
			
		}
		
	
		
		//hide labels, and unhide text fields
		[self.nameLabel setHidden:YES];
		[self.emailLabel setHidden:YES];
		
		[self.firstEdit setHidden:NO];
		[self.lastEdit setHidden:NO];
		[self.emailEdit setHidden:NO];
        [self.mobileEdit setHidden:NO];

        if (self.isUser) {
            
            if (self.isEmailConfirmed) {
                [self.emailEdit setHidden:YES];
            }
            
            if (self.isSmsConfirmed) {
                [self.mobileEdit setHidden:YES];
            }
        }else{
            
            if (self.isEmailConfirmed) {
                //[self.emailEdit setHidden:YES];
            }
            
        }

	
		
	}else {
		
		
		
		self.isEditing = false;
		
		self.deleteFanButton.hidden = NO;
		self.callTextButton.hidden = NO;

		self.profilePhotoButton.enabled = YES;
		self.switchToMemberLabel.hidden = YES;
		self.switchToMemberButton.hidden = YES;
		
		[self.startEditButton setHidden:NO];
		[self.endEditButton setHidden:YES];
		
		
		[self.nameLabel setHidden:NO];
		[self.emailLabel setHidden:NO];
		
		[self.firstEdit setHidden:YES];
		[self.lastEdit setHidden:YES];
		[self.emailEdit setHidden:YES];
        [self.mobileEdit setHidden:YES];

		
		[self.firstEdit resignFirstResponder];
		[self.lastEdit resignFirstResponder];
		[self.emailEdit resignFirstResponder];
        [self.mobileEdit resignFirstResponder];

		
		[self.addPhotoButton setHidden:YES];
		//[self.callNumberButton setHidden:NO];
		
		//run and Update Member transaction
		[self.activity startAnimating];
		
		//self.isEditing = true;
		
		[self.startEditButton setEnabled:NO];
		[self.endEditButton setEnabled:NO];
		
		[self.navigationItem setHidesBackButton:YES];
		[self.sendMessageButton setEnabled:NO];
	
        self.phoneOnlyArray = [NSMutableArray array];
        
        
        self.theFirstEdit = [NSString stringWithString:self.firstEdit.text];
        self.theLastEdit = [NSString stringWithString:self.lastEdit.text];
        self.theEmailEdit = [NSString stringWithString:self.emailEdit.text];
        self.theMobileEdit = [NSString stringWithString:self.mobileEdit.text];

        
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
	}
	
}








-(void)sendMessage{
	/*
	SendMessage *tmp = [[SendMessage alloc] init];
	tmp.teamId = self.teamId;
	tmp.sendTeamId = self.teamId;
	tmp.isReply = true;
	
	NSString *replyTo = @"";
	
	if (self.firstName != nil) {
		
		if (self.lastName != nil) {
			replyTo = [[self.firstName stringByAppendingFormat:@" "] stringByAppendingString:self.lastName];
		}else {
			replyTo = self.firstName;
		}
		
	}
	
	tmp.replyTo = replyTo;
	tmp.replyToId = self.memberId;
	tmp.origLoc = @"profile";
	tmp.userRole = self.userRole;
	tmp.origLoc = @"PlayerProfile";
	tmp.includeFans = @"false";
	
	[self.navigationController pushViewController:tmp animated:YES];
	*/
}

- (void)runRequest {
    
    @autoreleasepool {
        self.errorString = @"";
        
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *tmpRoles = [NSMutableArray array];
        
        NSString *role = @"player";
        
        [tmpRoles addObject:role];
        
        NSArray *rRoles = tmpRoles;
        
        NSString *first = @"";
        NSString *last = @"";
        NSString *jers = @"";
        NSString *newEmail = @"";
        NSString *newMobile = @"";
        if (![self.theFirstEdit isEqualToString:@""]) {
            first = self.theFirstEdit;
        }
        if (![self.theLastEdit isEqualToString:@""]) {
            last = self.theLastEdit;
        }
        
        if (![self.theEmailEdit isEqualToString:@""]) {
            newEmail = self.theEmailEdit;
        }
        
        if (![self.mobileEdit.text isEqualToString:@""]) {
            newMobile = self.theMobileEdit;
            
            if (![newMobile isEqualToString:self.initPhone] && !self.isEmailConfirmed) {
                [self.phoneOnlyArray addObject:newMobile];
            }
        }
        
        
        
        NSData *profile = [NSData data];
        if (![self.origCompressImage isEqualToData:self.compressImage]) {
            profile = self.compressImage;
        }
        
        NSString *orientation = @"";
        
        if ([profile length] > 0) {
            
            if (self.portrait) {
                orientation = @"portrait";
            }else{
                orientation = @"landscape";
            }
        }
        
        
        NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :first :last
                                                        :jers :rRoles :@[] :mainDelegate.token :profile :newEmail :@"fan" :newMobile :orientation];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            [self.errorLabel setHidden:YES];
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            [self.errorLabel setHidden:NO];
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                default:
                    //Log the status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
		
        
        [self performSelectorOnMainThread:
         @selector(didFinish)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

- (void)didFinish{
	
    if ([self.errorString isEqualToString:@""]) {
        if ([self.phoneOnlyArray count] > 0) {
            
            bool canText = false;
            
            NSString *ios = [[UIDevice currentDevice] systemVersion];
            
            
            if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                
                if ([MFMessageComposeViewController canSendText]) {
                    
                    canText = true;
                    
                }
            }else { 
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]){
                    canText = true;
                }
            }
            
            if (canText) {
                NSString *message1 = @"You have changed the phone number of a fan.  To receive messages, they must re-sign up for our texting service.  Would you like to send them a text right now with information on how to sign up?";
                self.newPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
                [self.newPhoneAlert show];
            }else {
                NSString *message1 = @"You have changed the phone number of a fan.  We can still send them rTeam messages if they sign up for our free texting service from this new phone.  Please notify them that they must send the text 'yes' to 'join@rteam.com' to sign up.";
                self.newPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [self.newPhoneAlert show];
            }
            
            
            
        }
        
    }

	self.errorLabel.text = self.errorString;
	[self.activity stopAnimating];
	[self.startEditButton setEnabled:YES];
	[self.endEditButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.sendMessageButton setEnabled:YES];

	
	[self viewWillAppear:NO];
}




- (void)runRequest2 {

    @autoreleasepool {
        self.errorString = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        NSData *profile = [NSData data];
        NSData *newImageData = UIImagePNGRepresentation(self.newImage);
        if (![self.origCompressImage isEqualToData:newImageData]) {
            profile = newImageData;
        }
        
        NSString *orientation = @"";
        
        if ([profile length] > 0) {
            
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Edit Fan Photo"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
            
            if (self.portrait) {
                orientation = @"portrait";
            }else{
                orientation = @"landscape";
            }
        }
        
        NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@""
                                                        :@"" :@[] :@[] :mainDelegate.token :profile :@"" :@"fan" :@"" :orientation];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            [self.errorLabel setHidden:YES];
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            [self.errorLabel setHidden:NO];
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                default:
                    //Log the status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        
        [self performSelectorOnMainThread:
         @selector(didFinish2)
                               withObject:nil
                            waitUntilDone:NO
         ];
    }
	
}



- (void)didFinish2 {
	
	self.errorLabel.text = self.errorString;
	[self.activity stopAnimating];
	[self.startEditButton setEnabled:YES];
	[self.endEditButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.sendMessageButton setEnabled:YES];
	
	self.profileImage.image = self.newImage;

    if (self.profileImage.image.size.height > self.profileImage.image.size.width) {
        //Portrait
        self.profileImage.frame = CGRectMake(26, 34, 61, 81);
        self.profilePhotoButton.frame = CGRectMake(26, 34, 61, 81);
        
    }else{
        
        self.profileImage.frame = CGRectMake(16, 54, 81, 61);
        self.profilePhotoButton.frame = CGRectMake(16, 54, 81, 61);
        
    }
    
	//[self viewWillAppear:NO];
}


- (void)runDelete {
	

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        NSDictionary *response = [ServerAPI deleteMember:self.memberId :self.teamId :mainDelegate.token];
        
        NSString *status = [response valueForKey:@"status"];
                        
        if ([status isEqualToString:@"100"]){
            
            self.deleteSuccess = true;
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            self.deleteSuccess = false;
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                case 208:
                    self.errorString = @"NA";
                    break;
                case 211:
                    self.errorString = @"*You cannot delete yourself";
                    break;
                default:
                    //Log the status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        
        [self performSelectorOnMainThread:
         @selector(didFinishDelete)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

- (void)didFinishDelete{
	[self.activity stopAnimating];
	
	
	if (self.deleteSuccess) {
		
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num-2;
		
		if ([temp[num] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *cont = temp[num];
			[self.navigationController popToViewController:cont animated:YES];
		}else {
			[self.activity stopAnimating];
			[self.startEditButton setEnabled:YES];
			[self.endEditButton setEnabled:YES];
			[self.navigationItem setHidesBackButton:NO];
			[self.sendMessageButton setEnabled:YES];
		
			
		}
		
		
		
	}else {
		[self.activity stopAnimating];
		[self.startEditButton setEnabled:YES];
		[self.endEditButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.sendMessageButton setEnabled:YES];
		
        if ([self.errorString isEqualToString:@"NA"]) {
			NSString *tmp = @"Only User's with confirmed email addresses can delete other members.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else{
            self.errorLabel.text = self.errorString;
            self.errorLabel.hidden = NO;
        }
          
            
        
		
	}
	
	
	
	
}



-(void) endText{
	[self becomeFirstResponder];

}

-(void)done{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

-(void)editProfilePic{
	
	self.changeProfilePicAction =  [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
	self.changeProfilePicAction.actionSheetStyle = UIActionSheetStyleDefault;
    [self.changeProfilePicAction showInView:self.view];
	
}

-(void) getPhoto:(NSString *)option{
	self.isEditing = false;
	
	if([option isEqualToString:@"library"]) {
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:picker animated:YES];
		
		
	} else {
		
		CameraSelectionProfile *tmp = [[CameraSelectionProfile alloc] init];
		[self.navigationController pushViewController:tmp animated:NO];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];	
	
	UIImageView *tmpView = [[UIImageView alloc] initWithImage:info[UIImagePickerControllerOriginalImage]];
	
    float xVal;
    float yVal;
    
    if (tmpView.image.size.height > tmpView.image.size.width) {
        //Portrait
        xVal = 210.0;
        yVal = 280.0;
        self.portrait = true;
        
    }else{
        //Landscape
        xVal = 280.0;
        yVal = 210.0;
        self.portrait = false;
    }
    
	NSData *jpegImage = UIImageJPEGRepresentation(tmpView.image, 1.0);
	
	
	UIImage *myThumbNail    = [[UIImage alloc] initWithData:jpegImage];
	
	UIGraphicsBeginImageContext(CGSizeMake(xVal,yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	
	self.compressImage = UIImageJPEGRepresentation(newImage1, 1.0);
	
	
	//self.profileImage.image = [UIImage imageWithData:self.compressImage];
	self.newImage = [UIImage imageWithData:self.compressImage];
	
	[self.activity startAnimating];
	self.isEditing = false;
    self.profilePhotoButton.enabled = YES;
    justChose = true;
	[self.nameLabel setHidden:NO];
	[self.emailLabel setHidden:NO];
	[self performSelectorInBackground:@selector(runRequest2) withObject:nil];
	
	
	
} 



-(void)deleteFan{
	
	
    self.deleteFanAction =  [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Fan" otherButtonTitles:nil];
	self.deleteFanAction.actionSheetStyle = UIActionSheetStyleDefault;
    [self.deleteFanAction showInView:self.view];

	
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (alertView == self.newPhoneAlert){
        
        if (buttonIndex == 0) {
            
        }else{
            
            //Text
            @try{
                
                NSMutableArray *numbersToCall = [NSMutableArray array];
                bool call = false;
                
                for (int i = 0; i < [self.phoneOnlyArray count]; i++) {
                    
                    NSString *numberToCall = @"";
                    
                    NSString *tmpPhone = (self.phoneOnlyArray)[i];
                    
                    if ([tmpPhone length] == 16) {
                        call = true;
                        
                        NSRange first3 = NSMakeRange(3, 3);
                        NSRange sec3 = NSMakeRange(8, 3);
                        NSRange end4 = NSMakeRange(12, 4);
                        numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
                                        [tmpPhone substringWithRange:end4]];
                        
                    }else if ([tmpPhone length] == 14) {
                        call = true;
                        
                        NSRange first3 = NSMakeRange(1, 3);
                        NSRange sec3 = NSMakeRange(6, 3);
                        NSRange end4 = NSMakeRange(10, 4);
                        numberToCall = [NSString stringWithFormat:@"%@%@%@", [tmpPhone substringWithRange:first3], [tmpPhone substringWithRange:sec3],
                                        [tmpPhone substringWithRange:end4]];
                        
                    }else if (([tmpPhone length] == 10) || ([tmpPhone length] == 11)) {
                        call = true;
                        numberToCall = tmpPhone;
                    }
                    
                    [numbersToCall addObject:numberToCall];
                }
                
                if (call) {
                    
                    NSString *ios = [[UIDevice currentDevice] systemVersion];
                    
                    if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                        
                        if ([MFMessageComposeViewController canSendText]) {
                            
                            MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
                            messageViewController.messageComposeDelegate = self;
                            [messageViewController setRecipients:numbersToCall];
                            
                            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                            
                            mainDelegate.displayName = @"";
                            
                            NSString *addition = @"";
                            
                            if (![mainDelegate.displayName isEqualToString:@""]) {
                                addition = [NSString stringWithFormat:@" by %@", mainDelegate.displayName];
                            }
                            
                            /*
                            NSString *bodyMessage = [NSString stringWithFormat:@"Hello, you have been added via rTeam to the team '%@'%@.  To automatically receive text messages from your team, please sign up for our texting service by sending a text message (not an email) to 'join@rteam.com' with the message 'yes'.", self.teamName, addition];
                             */
                            
                            NSString *teamNameShort = self.teamName;
                            int strLength = [self.teamName length];
                            
                            if (strLength > 13){
                                teamNameShort = [[self.teamName substringToIndex:10] stringByAppendingString:@".."];
                            }
                        
                            NSString *bodyMessage = [NSString stringWithFormat:@"Hi, you have been added via rTeam to the team '%@'. To sign up for our free texting service, send a text to 'join@rteam.com' with the message 'yes'.", teamNameShort];
                            [messageViewController setBody:bodyMessage];
                            [self presentModalViewController:messageViewController animated:YES];
                            
                        }
                    }else {
                        
                        if (numbersToCall[0] != nil) {
                            NSString *url = [@"sms://" stringByAppendingString:numbersToCall[0]];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                      
                    }
                    
                    
                }
                
            }@catch (NSException *e) {
                
            }
            
            
        }
        
        self.phoneOnlyArray = [NSMutableArray array];
        

    }
	

	
	
	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}





-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet == self.changeProfilePicAction){
		//Edit Profile Pic
		
		if (buttonIndex == 0) {
			//Take
			[self getPhoto:@"camera"];
		}else if (buttonIndex == 1){
			//ChoosePhoto
			[self getPhoto:@"library"];
			
		}
		
	}else if (actionSheet == self.deleteFanAction){
        
        if (buttonIndex == 1) {	
			
			
			
		}else if (buttonIndex == 0) {
			
            [TraceSession addEventToSession:@"Fan Info Page - Delete Fan Button Clicked"];

            
			[self.activity startAnimating];
			
			
			[self.startEditButton setEnabled:NO];
			[self.endEditButton setEnabled:NO];
			
			[self.navigationItem setHidesBackButton:YES];
			[self.sendMessageButton setEnabled:NO];
			
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Delete Fan"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
			[self performSelectorInBackground:@selector(runDelete) withObject:nil];
			
		}
        
    }else if (actionSheet == self.callTextAction) {
       
                
            if (buttonIndex == 0){
                
                //Call
                
                [self callPhone];			
                
                
            }else {
                
                [self textPhone];
                
                
            }
   
		
		
	}else {
			
		[FastActionSheet doAction:self :buttonIndex];

		
	}
	
	
}



- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)switchToMember{
	
    [TraceSession addEventToSession:@"Fan Info Page - Make Member Button Clicked"];

    
	[self.activity startAnimating];
	
	self.deleteFanButton.enabled = NO;
	self.startEditButton.enabled = NO;
	self.sendMessageButton.enabled = NO;
    
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Switch Fan to Member"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
	
	[self performSelectorInBackground:@selector(makeMember) withObject:nil];
}


- (void)makeMember {
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        
        
        NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@"" :@"" :@[] :@[] :mainDelegate.token 
                                                        :[NSData data] :@"" :@"member" :@"" :@""];
        
        NSString *status = [response valueForKey:@"status"];
		
        if ([status isEqualToString:@"100"]){
            
            self.errorString = @"";
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            [self.errorLabel setHidden:NO];
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server";
                    break;
                default:
                    //Log the status code?
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        
        
        [self performSelectorOnMainThread:
         @selector(finishedMember)
                               withObject:nil
                            waitUntilDone:NO
         ];

    }
		
}

- (void)finishedMember{
	
	[self.activity stopAnimating];
	
	self.deleteFanButton.enabled = YES;
	self.startEditButton.enabled = YES;
	self.sendMessageButton.enabled = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		[self.navigationController popViewControllerAnimated:NO];
	}else {
		self.errorLabel.text = self.errorString;
	}

}

-(void)profilePhoto{
	
	ProfilePhoto *tmp = [[ProfilePhoto alloc] init];
	tmp.nameString = self.nameLabel.text;
	tmp.teamString = self.teamName;
	tmp.imageData = self.compressImage;
	
	[self.navigationController pushViewController:tmp animated:YES];
}

- (void)autoFormatTextField:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.mobileEdit.text = [myPhoneNumberFormatter format:self.mobileEdit.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	self.displayMessage.hidden = NO;
	
	NSString *displayString = @"";
	BOOL success = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			displayString = @"";
			break;
		case MessageComposeResultSent:
			displayString = @"Text sent successfully!";
			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString = @"Text send failed.";
			break;
		default:
			displayString = @"Text send failed.";
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	
	if (![displayString isEqualToString:@""]) {
		
		if (success) {
			self.displayMessage.textColor = [UIColor colorWithRed:0.0 green:0.392 blue:0.0 alpha:1.0];
		}else {
			self.displayMessage.textColor = [UIColor redColor];
		}
        
		self.displayMessage.text = displayString;
	}else {
		self.displayMessage.hidden = YES;
	}
    
}

-(void)callText{
    
    [TraceSession addEventToSession:@"Fan Info Page - Call Text Button Clicked"];

    
    self.callTextAction = [[UIActionSheet alloc] initWithTitle:@"Call or Text this fan?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    self.callTextAction.actionSheetStyle = UIActionSheetStyleDefault;
    
    [self.callTextAction addButtonWithTitle:@"Call"];
    [self.callTextAction addButtonWithTitle:@"Text"];
    
    [self.callTextAction showInView:self.view];

}

-(void)callPhone{
    
    @try{
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]){
            
            NSString *phoneToUse = self.phone;
           
            
            NSString *numberToCall = @"";
            bool call = false;
            
            if ([phoneToUse length] == 16) {
                call = true;
                
                NSRange first3 = NSMakeRange(3, 3);
                NSRange sec3 = NSMakeRange(8, 3);
                NSRange end4 = NSMakeRange(12, 4);
                numberToCall = [NSString stringWithFormat:@"%@%@%@", [phoneToUse substringWithRange:first3], [phoneToUse substringWithRange:sec3],
                                [phoneToUse substringWithRange:end4]];
                
            }else if ([phoneToUse length] == 14) {
                call = true;
                
                NSRange first3 = NSMakeRange(1, 3);
                NSRange sec3 = NSMakeRange(6, 3);
                NSRange end4 = NSMakeRange(10, 4);
                numberToCall = [NSString stringWithFormat:@"%@%@%@", [phoneToUse substringWithRange:first3], [phoneToUse substringWithRange:sec3],
                                [phoneToUse substringWithRange:end4]];
                
            }else if (([phoneToUse length] == 11) || ([phoneToUse length] == 10) || ([phoneToUse length] == 7)) {
                call = true;
                numberToCall = phoneToUse;
            }else {
                call = true;
                numberToCall = phoneToUse;
            }
            
            if (call) {
                
                if (numberToCall != nil) {
                    NSString *url = [@"tel://" stringByAppendingString:numberToCall];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
               
                
            }
            
            
        }else {
            
            NSString *message1 = @"You cannot make calls from this device.";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert1 show];
            
        }
        
        
    }@catch (NSException *e) {
        
    }
    
}

-(void)textPhone{
    
    //Text
    bool canText = false;
    
    NSString *ios = [[UIDevice currentDevice] systemVersion];
    
    
    if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
        
        if ([MFMessageComposeViewController canSendText]) {
            
            canText = true;
            
        }
    }else { 
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]]){
            canText = true;
        }
    }
    
    if (canText) {
        
        @try{
            NSString *phoneToUse = self.phone;
            
            
            NSString *numberToCall = @"";
            bool call = false;
            if ([phoneToUse length] == 16) {
                call = true;
                
                NSRange first3 = NSMakeRange(3, 3);
                NSRange sec3 = NSMakeRange(8, 3);
                NSRange end4 = NSMakeRange(12, 4);
                numberToCall = [NSString stringWithFormat:@"%@%@%@", [phoneToUse substringWithRange:first3], [phoneToUse substringWithRange:sec3],
                                [phoneToUse substringWithRange:end4]];
                
            }else if ([phoneToUse length] == 14) {
                call = true;
                
                NSRange first3 = NSMakeRange(1, 3);
                NSRange sec3 = NSMakeRange(6, 3);
                NSRange end4 = NSMakeRange(10, 4);
                numberToCall = [NSString stringWithFormat:@"%@%@%@", [phoneToUse substringWithRange:first3], [phoneToUse substringWithRange:sec3],
                                [phoneToUse substringWithRange:end4]];
                
            }else if (([phoneToUse length] == 11) || ([phoneToUse length] == 10) || ([phoneToUse length] == 7)) {
                call = true;
                numberToCall = phoneToUse;
            }else {
                call = true;
                numberToCall = phoneToUse;
            }
            
            if (call) {
                
                
                if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                    
                    if ([MFMessageComposeViewController canSendText]) {
                        
                        MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
                        messageViewController.messageComposeDelegate = self;
                        [messageViewController setRecipients:@[numberToCall]];
                        [self presentModalViewController:messageViewController animated:YES];
                        
                    }
                }else { 
                    if (numberToCall != nil) {
                        NSString *url = [@"sms://" stringByAppendingString:numberToCall];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }
                   
                }
                
                
            }
            
        }@catch (NSException *e) {
            
        }
        
    }else {
        
        NSString *message1 = @"You cannot send text messages from this device.";
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Texting Not Available." message:message1 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        
    }
    
    
}


-(void)viewDidUnload{
	
    startEditButton = nil;
	endEditButton = nil;
	nameLabel = nil;
	emailLabel = nil;
	firstEdit = nil;
	lastEdit = nil;
	emailEdit = nil;
	sendMessageButton = nil;
	addPhotoButton = nil;
	profileImage = nil;
	activity = nil;
	displayMessage = nil;
	errorLabel = nil;
	deleteFanButton = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	switchToMemberLabel = nil;
	switchToMemberButton = nil;
	profilePhotoButton = nil;
    mobileEdit = nil;
    callTextButton = nil;
    [super viewDidUnload];
}


@end
