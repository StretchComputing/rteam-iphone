//
//  Player.m
//  rTeam

//  Created by Nick Wroblewski on 12/29/09.z
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
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
#import "FastActionSheet.h"
#import "ProfilePhoto.h"
#import "Players.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}




@implementation Player
@synthesize firstName, lastName, jersey, email, memberId, teamId, tempProfileImage, fromEdit, compressImage, firstEdit, lastEdit, mobileEdit,
emailEdit, nameLabel, jerseyLabel, emailLabel, sendMessageButton, addContactButton, callNumberButton, profileImage, startEditButton, endEditButton, jerseyEdit,
addPhotoButton, activity, messageSent, displayMessage, contactAdded, userRole, changeRoleButton, changeRoleText, alertContact, alertRole,
changedRole, shouldChangeRole, phone, headUserRole, isEditing, errorLabel, origCompressImage, fromSearch,
editGuardianInfoButton, guardiansArray, deleteButton, scrollView, alertDelete, deleteSuccess, fromImage, alertCallText, isUser, 
isNetworkAuthenticated, errorString, deleteActionSheet, roleActionSheet, callTextActionSheet, playerInfo, loadingActivity, loadingLabel,
changeProfilePicAction, newImage, fromCameraSelect, selectedImage, selectedData, shouldUnload, switchFanLabel, switchFanButton, teamName, profilePhotoButton, isCurrentUser, portrait, guard1NA, guard1Last, guard2Last, guard1Email, guard1First, guard1Phone, guard2Email, guard2First, guard2Phone, guard1SmsConfirmed, guard2SmsConfirmed, guard2NA, guard1Key, guard2Key, isSmsConfirmed, guard1isUser, guard2isUser, phoneOnlyArray, callOrTextWho, callTextWhoAlertView, scenario, initPhone, newPhoneAlert, isEmailConfirmed, guard1EmailConfirmed, guard2EmailConfirmed, didHideMessage;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];

}


-(void)viewDidLoad{

    self.initPhone = @"";
	self.playerInfo = [NSDictionary dictionary];
    self.phoneOnlyArray = [NSMutableArray array];
	
	self.switchFanLabel.hidden = YES;
	self.switchFanButton.hidden = YES;
	
	self.profilePhotoButton.enabled = NO;
	self.profilePhotoButton.hidden = NO;

    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 3.0;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.startEditButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.endEditButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addPhotoButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	[self.sendMessageButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.callNumberButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.changeRoleButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addContactButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.editGuardianInfoButton setBackgroundImage:stretch forState:UIControlStateNormal];
	//[self.deleteButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.switchFanButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
    
    myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    
	myTextFieldSemaphore = 0;
	self.mobileEdit.textColor = [UIColor blackColor];
	[self.mobileEdit addTarget:self
						action:@selector(autoFormatTextField:)
			  forControlEvents:UIControlEventEditingChanged
	 ];
    
   
	
}

- (void)viewWillAppear:(BOOL)animated{
	
	if (self.isEditing) {
		self.isEditing = false;
	}
	
    self.editGuardianInfoButton.hidden = YES;
	self.switchFanLabel.hidden = YES;
	self.switchFanButton.hidden = YES;
	
	//self.profilePhotoButton.enabled = NO;
	//self.profilePhotoButton.hidden = NO;
	
    if (self.profileImage.image.size.height > self.profileImage.image.size.width) {
        //Portrait
        self.profileImage.frame = CGRectMake(26, 34, 61, 81);
        self.profilePhotoButton.frame = CGRectMake(26, 34, 61, 81);
        
    }else{
        
        self.profileImage.frame = CGRectMake(16, 54, 81, 61);
        self.profilePhotoButton.frame = CGRectMake(16, 54, 81, 61);
        
    }
    
	
	self.nameLabel.hidden = YES;
	self.emailLabel.hidden = YES;
	self.addContactButton.hidden = YES;
	self.sendMessageButton.hidden = YES;
	self.editGuardianInfoButton.hidden = YES;
	self.callNumberButton.hidden = YES;
	self.startEditButton.hidden = YES;
	
	[self.loadingActivity startAnimating];
	[self.loadingLabel setHidden:NO];
	[self performSelectorInBackground:@selector(memberInfo) withObject:nil];
	[self.deleteButton setHidden:YES];
	
	
	[self.scrollView setContentSize:CGSizeMake(320, 416)];	
	if (self.messageSent) {
		self.displayMessage.text = @"*Message sent successfully!";
	}else if (self.contactAdded) {
		self.displayMessage.text = @"*Member added to phone contacts!";
	}else {
		self.displayMessage.text = @"";
	}
	
	self.title = @"Member Info";
	
    
	
	self.mobileEdit.delegate = self;
	
	self.contactAdded = FALSE;
	self.messageSent = FALSE;
	//userRole setup
	self.shouldChangeRole = FALSE;
	self.changeRoleText.backgroundColor = [UIColor clearColor];
	
	if ([self.headUserRole isEqualToString:@"coordinator"] || [self.headUserRole isEqualToString:@"creator"]) {
		
		if ([self.userRole isEqualToString:@"coordinator"]) {
			if (!self.isNetworkAuthenticated) {
				[self.changeRoleButton setTitle:@"Make Participant" forState:UIControlStateNormal];
				self.changeRoleText.text = @"*Making this member a participant will prevent them from being able to make changes to the team through this app.";
				self.changeRoleText.textAlignment = UITextAlignmentCenter;
			}else {
				[self.changeRoleText setHidden:YES];
				[self.changeRoleButton setHidden:YES];
			}
			
		}else if ([self.userRole isEqualToString:@"member"]) {
			[self.changeRoleButton setTitle:@"Make Coordinator" forState:UIControlStateNormal];
			self.changeRoleText.text = @"*Making this member a coordinator will allow them to make changes to the team, such as creating or editing team members, games or practices.";
			self.changeRoleText.textAlignment = UITextAlignmentCenter;
		}else {
			[self.changeRoleText setHidden:YES];
			[self.changeRoleButton setHidden:YES];
		}
		
	}else {
		[self.changeRoleText setHidden:YES];
		[self.changeRoleButton setHidden:YES];
	}
	
	[self.errorLabel setHidden:YES];
	
	
	[self.firstEdit setHidden:YES];
	[self.lastEdit setHidden:YES];
	[self.emailEdit setHidden:YES];
	[self.mobileEdit setHidden:YES];
	[self.jerseyEdit setHidden:YES];
	[self.addPhotoButton setHidden:YES];
	
	
	[self.endEditButton setHidden:YES];
	
	if (!self.fromSearch) {
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
		[self.navigationItem setRightBarButtonItem:doneButton];
	}
	
	
	self.firstEdit.placeholder = @"First";
	self.lastEdit.placeholder = @"Last";
	self.jerseyEdit.placeholder = @"Jersey #";
	self.emailEdit.placeholder = @"Email";
	self.mobileEdit.placeholder = @"Mobile";
	
	
	
    
	
	
}

-(void)memberInfo{
	
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	//self.playerInfo = [NSArray array];
	
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
-(void)getMemberInformation{
	[self.loadingActivity stopAnimating];
	[self.loadingLabel setHidden:YES];
	
	if ([self.errorString isEqualToString:@""]) {
		
	if ([self.playerInfo valueForKey:@"guardians"] != nil) {
		
		self.guardiansArray = [playerInfo valueForKey:@"guardians"];
		
		if ([self.guardiansArray count] > 0) {
			//[self.editGuardianInfoButton setHidden:NO];
            [self.editGuardianInfoButton setTitle:@"Edit Parent/Guardian Info" forState:UIControlStateNormal];

		}else {
			//[self.editGuardianInfoButton setHidden:NO];
            [self.editGuardianInfoButton setTitle:@"+ Add Parent/Guardian Info" forState:UIControlStateNormal];
		}
		
	}else {
		//[self.editGuardianInfoButton setHidden:YES];
        [self.editGuardianInfoButton setTitle:@"+ Add Parent/Guardian Info" forState:UIControlStateNormal];

	}
	
	NSString *jerseyNumber = [playerInfo valueForKey:@"jerseyNumber"];
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
	
	
	
	
	self.emailLabel.text = [playerInfo valueForKey:@"emailAddress"];
	
	if (jerseyNumber == nil || [jerseyNumber isEqualToString:@""] || [jerseyNumber isEqualToString:@"Jersey #"]) {
		self.jerseyLabel.text = @"";
	}else {
		self.jerseyLabel.text = [@"#" stringByAppendingString:jerseyNumber];
		self.jersey = jerseyNumber;
	}
	
	if ([playerInfo valueForKey:@"phoneNumber"] != nil) {
		self.phone = [playerInfo valueForKey:@"phoneNumber"];
        
        NSString *myLocale = @"";
        self.initPhone = [myPhoneNumberFormatter format:self.phone withLocale:myLocale];
        
		
        if (![self.phone isEqualToString:@""]) {
            [self.callNumberButton setTitle:@"Call/Text" forState:UIControlStateNormal]; 
            [self.callNumberButton setHidden:NO];
        }else if (([self.guard1Phone length] > 0) || ([self.guard2Phone length] > 0)) {
            [self.callNumberButton setTitle:@"Call/Text" forState:UIControlStateNormal]; 
            [self.callNumberButton setHidden:NO];
        }
        
		
	}else {
       
        if (([self.guard1Phone length] > 0) || ([self.guard2Phone length] > 0)) {
            [self.callNumberButton setTitle:@"Call/Text" forState:UIControlStateNormal]; 
            [self.callNumberButton setHidden:NO];
        }else{
            self.phone = @"";
            [self.callNumberButton setHidden:YES];
        }
		
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
				
				
				NSString *thumbNail = [playerInfo valueForKey:@"thumbNail"];
				
				if ((thumbNail == nil) || ([thumbNail isEqualToString:@""])) {
					
					self.profileImage.image = [UIImage imageNamed:@"profile1.png"];

				}else {
					
					NSData *thumbnailData = [Base64 decode:thumbNail];
					self.compressImage = thumbnailData;
					self.origCompressImage = thumbnailData;
					self.profileImage.image = [UIImage imageWithData:thumbnailData];

					self.profilePhotoButton.enabled = YES;
				}

				
				
			}else {
				
				NSData *profileData = [Base64 decode:profile];
              
                if (!justChose) {
                    self.compressImage = profileData;
                    self.origCompressImage = profileData;
                }else{
                    justChose = false;
                }
				
				self.profileImage.image = [UIImage imageWithData:profileData];
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
    
        
	self.nameLabel.hidden = NO;
	self.emailLabel.hidden = NO;
    self.addContactButton.hidden = NO;
        
        bool hideButton = false;
            if (!self.isNetworkAuthenticated && !self.isSmsConfirmed && !self.guard1SmsConfirmed && !self.guard1NA && !self.guard2SmsConfirmed && !self.guard2NA) {
                hideButton = true;
            }
        
				        
		if ([self.headUserRole isEqualToString:@"coordinator"] || [self.headUserRole isEqualToString:@"creator"]) {
			self.startEditButton.hidden = NO;
            if (!hideButton) {
                self.sendMessageButton.hidden = NO;
                
            }

		}else {
			self.startEditButton.hidden = YES;
			
			if (![self.headUserRole isEqualToString:@"member"]) {
				self.sendMessageButton.hidden = YES;
			}else {
                if (!hideButton) {
                    self.sendMessageButton.hidden = NO;

                }
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


-(void)editStart{
	
	if (!self.isEditing) {
		
        
        if (self.sendMessageButton.hidden != YES) {
            self.sendMessageButton.hidden = YES;
            self.didHideMessage = true;
        }
        self.addContactButton.hidden = YES;
        self.editGuardianInfoButton.hidden = NO;
        
        
		self.isEditing = true;
		self.profilePhotoButton.enabled = NO;
		
        if ([self.headUserRole isEqualToString:@"creator"] || [self.headUserRole isEqualToString:@"coordinator"]) {
           
            if (![self.userRole isEqualToString:@"creator"]) {
                self.deleteButton.hidden = NO;
            }
        }
		
		[self.startEditButton setHidden:YES];
		[self.endEditButton setHidden:NO];
		
		self.switchFanLabel.hidden = NO;
		self.switchFanButton.hidden = NO;
		self.changeRoleButton.hidden = YES;
		self.changeRoleText.hidden = YES;

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

		
		if ([self.jerseyLabel.text length] > 0) {
			self.jerseyEdit.text = self.jersey;
			self.jerseyEdit.textColor = [UIColor blackColor];
		}else {
		}
		
		
		if (![self.phone isEqualToString:@""]) {
			//self.mobileEdit.text = self.phone; jlhkjh
            NSString *myLocale;
            self.mobileEdit.text = [myPhoneNumberFormatter format:self.phone withLocale:myLocale];
			self.mobileEdit.textColor = [UIColor blackColor];
		}else {
		}


		//hide labels, and unhide text fields
		[self.nameLabel setHidden:YES];
		[self.jerseyLabel setHidden:YES];
		[self.emailLabel setHidden:YES];
		
		[self.firstEdit setHidden:NO];
		[self.lastEdit setHidden:NO];
		
		
		

        [self.emailEdit setHidden:NO];
		[self.mobileEdit setHidden:NO];
		[self.jerseyEdit setHidden:NO];
		[self.addPhotoButton setHidden:NO];
		
        if (self.isUser) {
            
            if (self.isEmailConfirmed) {
                [self.emailEdit setHidden:YES];
            }
            
            if (self.isSmsConfirmed) {
                [self.mobileEdit setHidden:YES];
            }
        }else{
            
            if (self.isEmailConfirmed) {
               // [self.emailEdit setHidden:YES];
            }
            
        }
        
		[self.callNumberButton setHidden:YES];
		
		[self.mobileEdit setClearsOnBeginEditing:NO];
		
	}else {
		

        if (self.didHideMessage) {
            self.sendMessageButton.hidden = NO;
            self.didHideMessage = false;
        }
        self.addContactButton.hidden = NO;
        self.editGuardianInfoButton.hidden = YES;
        
		self.isEditing = false;
		
		self.profilePhotoButton.enabled = YES;

		[self.startEditButton setHidden:NO];
		[self.endEditButton setHidden:YES];
		[self.deleteButton setHidden:YES];

		self.switchFanLabel.hidden = YES;
		self.switchFanButton.hidden = YES;
		self.changeRoleButton.hidden = NO;
		self.changeRoleText.hidden = NO;
		
		[self.nameLabel setHidden:NO];
		[self.jerseyLabel setHidden:NO];
		[self.emailLabel setHidden:NO];
		
		[self.firstEdit setHidden:YES];
		[self.lastEdit setHidden:YES];
		[self.emailEdit setHidden:YES];
		[self.mobileEdit setHidden:YES];
		[self.jerseyEdit setHidden:YES];
		
		[self.firstEdit resignFirstResponder];
		[self.lastEdit resignFirstResponder];
		[self.emailEdit resignFirstResponder];
		[self.mobileEdit resignFirstResponder];
		[self.jerseyEdit resignFirstResponder];
		
		[self.addPhotoButton setHidden:YES];
		//[self.callNumberButton setHidden:NO];
		
		//run and Update Member transaction
		[self.activity startAnimating];
		
		//self.isEditing = true;
		
		[self.startEditButton setEnabled:NO];
		[self.endEditButton setEnabled:NO];
		
		[self.navigationItem setHidesBackButton:YES];
		[self.sendMessageButton setEnabled:NO];
		[self.addContactButton setEnabled:NO];
		[self.callNumberButton setEnabled:NO];
		[self.changeRoleButton setEnabled:NO];
		[self.callNumberButton setHidden:YES];
        self.phoneOnlyArray = [NSMutableArray array];
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
	}

}



-(void)callNumber{
	
	[self showActionSheetCallText];
}

-(void)addContact{
	

	PlayerAttendance *tmp = [[PlayerAttendance alloc] init];
	tmp.memberId = self.memberId;
	tmp.teamId = self.teamId;
	tmp.fromSearch = self.fromSearch;
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;

	[self.navigationController pushViewController:tmp animated:YES];
	
}

-(void)changeRole{
	if ([self.userRole isEqualToString:@"coordinator"]) {
		//message = @"Change this members role to 'participant'?";
		self.changedRole = @"member";
	}else {
		//message = @"Change this members role to 'coordinator'?";
		self.changedRole = @"coordinator";
	}

	[self showActionSheetRole];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
    if (alertView == self.callTextWhoAlertView){
        
        
        if (self.scenario == 1) {
            
            if (buttonIndex == 1){
                self.callOrTextWho = @"guard1";
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard2";
                
            }
        }else if (self.scenario == 2){
            
            if (buttonIndex == 1){
                self.callOrTextWho = @"member";
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard2";
                
            }
            
        }else if (self.scenario == 3){
            
            if (buttonIndex == 1){
                self.callOrTextWho = @"member";
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard1";
                
            }
            
        }else if (self.scenario == 4){
            
            if (buttonIndex == 1){
                self.callOrTextWho = @"member";
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard1";
                
            }else if (buttonIndex == 3){
                self.callOrTextWho = @"guard2";

            }
            
        }
        
        if (buttonIndex != 0){
            self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this person?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
            self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.callTextActionSheet showInView:self.view];
        }
        
        
        
        
    }else if (alertView == self.newPhoneAlert){
        
        if (buttonIndex == 0) {
            
        }else{
            
            //Text
            @try{
                
                NSMutableArray *numbersToCall = [NSMutableArray array];
                bool call = false;
                
                for (int i = 0; i < [self.phoneOnlyArray count]; i++) {
                    
                    NSString *numberToCall = @"";
                    
                    NSString *tmpPhone = [self.phoneOnlyArray objectAtIndex:i];
                    
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
                        
                        NSString *url = [@"sms://" stringByAppendingString:[numbersToCall objectAtIndex:0]];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }
                    
                    
                }
                
            }@catch (NSException *e) {
                
            }
            
            
        }
        
        self.phoneOnlyArray = [NSMutableArray array];
        
    }
	
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
	tmp.userRole = self.userRole;
	tmp.origLoc = @"PlayerProfile";
	tmp.includeFans = @"false";
	[self.navigationController pushViewController:tmp animated:YES];
	*/
}

- (void)runRequest{
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
    
	if (![self.firstEdit.text isEqualToString:@""]) {
		first = self.firstEdit.text;
	}
	if (![self.lastEdit.text isEqualToString:@""]) {
		last = self.lastEdit.text;
	}
	if (![self.jerseyEdit.text isEqualToString:@""]) {
		jers = self.jerseyEdit.text;
	}
    
	if (![self.emailEdit.text isEqualToString:@""]) {
		newEmail = self.emailEdit.text;
	}
    if ([self.emailEdit.text isEqualToString:@""]) {
		newEmail = @"remove";
	}
	
	if (![self.mobileEdit.text isEqualToString:@""]) {
		newMobile = self.mobileEdit.text;
        
        if (![newMobile isEqualToString:self.initPhone] && !self.isEmailConfirmed) {
            [self.phoneOnlyArray addObject:newMobile];
        }
	}
    if ([self.mobileEdit.text isEqualToString:@""]) {
        newMobile = @"remove";
    }
		
	NSString *newRole = @"";
	if (self.shouldChangeRole) {
		newRole = self.changedRole;
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
                                                    :jers :rRoles :[NSArray array] :mainDelegate.token :profile :newEmail :newRole :newMobile :orientation];
	
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


- (void)runRequestRole{
	self.errorString = @"";

	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpRoles = [NSMutableArray array];
	
	NSString *role = @"player";
	
	[tmpRoles addObject:role];
	
	NSArray *rRoles = tmpRoles;
    
	NSString *newRole = @"";
	if (self.shouldChangeRole) {
		newRole = self.changedRole;
	}
	
	NSData *profile = [NSData data];
	if (![self.origCompressImage isEqualToData:self.compressImage]) {
		profile = self.compressImage;
	}
    
	
	NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@""
                                                    :@"" :rRoles :[NSArray array] :mainDelegate.token :[NSData data] :@"" :newRole :@"" :@""];
	
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


- (void)didFinish{
	
	if ([self.errorString isEqualToString:@""]) {
        if ([self.phoneOnlyArray count] > 0) {
            
            if (!self.isEmailConfirmed) {
                
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
                    NSString *message1 = @"You have changed the phone number of a member.  To receive messages, they must re-sign up for our texting service.  Would you like to send them a text right now with information on how to sign up?";
                    self.newPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
                    [self.newPhoneAlert show];
                }else {
                    NSString *message1 = @"You have changed the phone number of a member.  We can still send them rTeam messages if they sign up for our free texting service from this new phone.  Please notify them that they must send the text 'yes' to 'join@rteam.com' to sign up.";
                    self.newPhoneAlert = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [self.newPhoneAlert show];
                }

                
            }
                       
        }

    }
	self.errorLabel.text = self.errorString;
	[self.activity stopAnimating];
	[self.startEditButton setEnabled:YES];
	[self.endEditButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.sendMessageButton setEnabled:YES];
	[self.addContactButton setEnabled:YES];
	[self.callNumberButton setEnabled:YES];
	[self.changeRoleButton setEnabled:YES];
	[self.deleteButton setEnabled:YES];

	if (self.shouldChangeRole) {
		self.userRole = self.changedRole;
	}
	
	[self viewWillAppear:NO];
}




- (void)runRequest2 {
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
	if (![self.firstEdit.text isEqualToString:@""]) {
		first = self.firstEdit.text;
	}
	if (![self.lastEdit.text isEqualToString:@""]) {
		last = self.lastEdit.text;
	}
	if (![self.jerseyEdit.text isEqualToString:@""]) {
		jers = self.jerseyEdit.text;
	}
	if (![self.emailEdit.text isEqualToString:@""]) {
		newEmail = self.emailEdit.text;
	}
	
	if (![self.mobileEdit.text isEqualToString:@""]) {
		newMobile = self.mobileEdit.text;
	}
	
	NSString *newRole = @"";
	if (self.shouldChangeRole) {
		newRole = self.changedRole;
	}
	
	NSData *profile = [NSData data];
	NSData *newImageData = UIImagePNGRepresentation(self.newImage);
	if (![self.origCompressImage isEqualToData:newImageData]) {
		profile = newImageData;
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
													:jers :rRoles :[NSArray array] :mainDelegate.token :profile :newEmail :newRole :newMobile :orientation];
	
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

- (void)didFinish2{
	
	self.errorLabel.text = self.errorString;
	[self.activity stopAnimating];
	[self.startEditButton setEnabled:YES];
	[self.endEditButton setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	[self.sendMessageButton setEnabled:YES];
	[self.addContactButton setEnabled:YES];
	[self.callNumberButton setEnabled:YES];
	[self.changeRoleButton setEnabled:YES];
	[self.deleteButton setEnabled:YES];

	self.profileImage.image = self.newImage;
    
    if (self.profileImage.image.size.height > self.profileImage.image.size.width) {
        //Portrait
        self.profileImage.frame = CGRectMake(26, 34, 61, 81);
        self.profilePhotoButton.frame = CGRectMake(26, 34, 61, 81);
        
    }else{
        
        self.profileImage.frame = CGRectMake(16, 54, 81, 61);
        self.profilePhotoButton.frame = CGRectMake(16, 54, 81, 61);
        
    }
    
	if (self.shouldChangeRole) {
		self.userRole = self.changedRole;
	}
	
	//[self viewWillAppear:NO];
}


- (void)runDelete {
	

	
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

- (void)didFinishDelete{
	[self.activity stopAnimating];

	
	if (self.deleteSuccess) {
		
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num-2;
		
		if ([[temp objectAtIndex:num] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *cont = [temp objectAtIndex:num];
			[self.navigationController popToViewController:cont animated:YES];
		}else {
			[self.activity stopAnimating];
			[self.startEditButton setEnabled:YES];
			[self.endEditButton setEnabled:YES];
			[self.navigationItem setHidesBackButton:NO];
			[self.sendMessageButton setEnabled:YES];
			[self.addContactButton setEnabled:YES];
			[self.callNumberButton setEnabled:YES];
			[self.changeRoleButton setEnabled:YES];
			[self.deleteButton setEnabled:YES];

		}

		
		
	}else {
		self.errorLabel.text = self.errorString;
		[self.activity stopAnimating];
		[self.startEditButton setEnabled:YES];
		[self.endEditButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.sendMessageButton setEnabled:YES];
		[self.addContactButton setEnabled:YES];
		[self.callNumberButton setEnabled:YES];
		[self.changeRoleButton setEnabled:YES];
		[self.deleteButton setEnabled:YES];
		[self.errorLabel setHidden:NO];

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

-(void)getPhoto:(NSString *)option {
	
	self.isEditing = false;
	
	if([option isEqualToString:@"library"]) {
		UIImagePickerController * picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentModalViewController:picker animated:YES];
		
	} else {

		self.shouldUnload = false;
		CameraSelectionProfile *tmp = [[CameraSelectionProfile alloc] init];
		[self.navigationController pushViewController:tmp animated:NO];
	}
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];	
	
	UIImageView *tmpView = [[UIImageView alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
	
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

	UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
	
	[myThumbNail drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
	
	UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	 
	
	self.compressImage = UIImageJPEGRepresentation(newImage1, 1.0);
	
		
	//self.profileImage.image = [UIImage imageWithData:self.compressImage];
	self.newImage = [UIImage imageWithData:self.compressImage];
	
	[self.activity startAnimating];
	self.isEditing = false;

    self.profilePhotoButton.enabled = YES;
    self.profilePhotoButton.hidden = NO;
	[self.nameLabel setHidden:NO];
	[self.emailLabel setHidden:NO];
	[self.jerseyLabel setHidden:NO];
    justChose = true;
	[self performSelectorInBackground:@selector(runRequest2) withObject:nil];

	
} 


//handle events
- (void)autoFormatTextField:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.mobileEdit.text = [myPhoneNumberFormatter format:self.mobileEdit.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

-(void)editGuardianInfo{
	
	EditGuardianInfo *tmp = [[EditGuardianInfo alloc] init];
	tmp.guardianArray = self.guardiansArray;
	tmp.teamId = self.teamId;
	tmp.memberId = self.memberId;
    tmp.guard1Na = self.guard1NA;
    tmp.guard2Na = self.guard2NA;
    tmp. guard1isUser = self.guard1isUser;
    tmp. guard2isUser = self.guard2isUser;
    tmp. guard1EmailConfirmed = self.guard1EmailConfirmed;
    tmp. guard2EmailConfirmed = self.guard2EmailConfirmed;
    tmp. guard1SmsConfirmed = self.guard1SmsConfirmed;
    tmp. guard2SmsConfirmed =  self.guard2SmsConfirmed;
    tmp.teamName = self.teamName;
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)deleteMember{
	/*
	self.alertDelete = [[UIAlertView alloc] initWithTitle:@"Delete this member?" message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[self.alertDelete show];
	 */
	[self showActionSheetDelete];
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.mobileEdit resignFirstResponder];
}


-(void)showActionSheetDelete{
    self.deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Member" otherButtonTitles:nil];
    self.deleteActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.deleteActionSheet showInView:self.view];
}

-(void)showActionSheetCallText{
    
    NSString *g2Phone = @"";
    NSString *g1Phone = @"";
    
    if (self.guard1Phone != nil){
        g1Phone = self.guard1Phone;
    }
    if (self.guard2Phone != nil){
        g2Phone = self.guard2Phone;
    }
    
 
    if (![self.phone isEqualToString:@""]) {
        //At least the member

        if (![g1Phone isEqualToString:@""] || ![g2Phone isEqualToString:@""]) {
            
            if (![g1Phone isEqualToString:@""] && [g2Phone isEqualToString:@""]) {
                //Just guardian 1 and member
                self.scenario = 1;
                
                self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this member?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                
                [self.callTextActionSheet addButtonWithTitle:@"Call"];
                [self.callTextActionSheet addButtonWithTitle:@"Text"];
                [self.callTextActionSheet addButtonWithTitle:@"Call Guardian"];
                [self.callTextActionSheet addButtonWithTitle:@"Text Guardian"];
                
                [self.callTextActionSheet addButtonWithTitle:@"Cancel"];            
                [self.callTextActionSheet setCancelButtonIndex:4];
                
                [self.callTextActionSheet showInView:self.view];
            }
            
            if ([g1Phone isEqualToString:@""] && ![g2Phone isEqualToString:@""]) {
                //Just guardian 2 and member
                self.scenario = 2;
                
                self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this member?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                
                [self.callTextActionSheet addButtonWithTitle:@"Call"];
                [self.callTextActionSheet addButtonWithTitle:@"Text"];
                [self.callTextActionSheet addButtonWithTitle:@"Call Guardian"];
                [self.callTextActionSheet addButtonWithTitle:@"Text Guardian"];
                
                [self.callTextActionSheet addButtonWithTitle:@"Cancel"];            
                [self.callTextActionSheet setCancelButtonIndex:4];
                
                [self.callTextActionSheet showInView:self.view];
            }
            
            if (![g1Phone isEqualToString:@""] && ![g2Phone isEqualToString:@""]) {
                //Just guardian 2 and member
                self.scenario = 3;
                
                self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this member?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                
                [self.callTextActionSheet addButtonWithTitle:@"Call"];
                [self.callTextActionSheet addButtonWithTitle:@"Text"];
                [self.callTextActionSheet addButtonWithTitle:@"Call Guardian One"];
                [self.callTextActionSheet addButtonWithTitle:@"Text Guardian One"];
                [self.callTextActionSheet addButtonWithTitle:@"Call Guardian Two"];
                [self.callTextActionSheet addButtonWithTitle:@"Text Guardian Two"];
                
                [self.callTextActionSheet addButtonWithTitle:@"Cancel"];            
                [self.callTextActionSheet setCancelButtonIndex:6];
                
                [self.callTextActionSheet showInView:self.view];
            }
            
            
        }else{
            self.scenario = 0;
            
            self.callOrTextWho = @"member";

            self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this member?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
            self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.callTextActionSheet showInView:self.view];
            
        }
       
        
        
    }else if (![g1Phone isEqualToString:@""]) {
        //At least guardian1
        
        if (![g2Phone isEqualToString:@""]) {
            self.scenario = 4;
            
            self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text a guardian?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            
            [self.callTextActionSheet addButtonWithTitle:@"Call Guardian One"];
            [self.callTextActionSheet addButtonWithTitle:@"Text Guardian One"];
            [self.callTextActionSheet addButtonWithTitle:@"Call Guardian Two"];
            [self.callTextActionSheet addButtonWithTitle:@"Text Guardian Two"];
            
            [self.callTextActionSheet addButtonWithTitle:@"Cancel"];            
            [self.callTextActionSheet setCancelButtonIndex:4];

            [self.callTextActionSheet showInView:self.view];
        }else{
            self.callOrTextWho = @"guard1";
            
            
            self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this member's guardian?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
            self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.callTextActionSheet showInView:self.view];

        }
                
        
    }else if (![g2Phone isEqualToString:@""]) {
        //Only guardian2
        
        
            self.callOrTextWho = @"guard2";
            
            self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this member's guardian?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
            self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [self.callTextActionSheet showInView:self.view];
        
        
        
        
        
    }   
}


-(void)showActionSheetRole{
	NSString *buttonTitle = @"";
	if ([self.changedRole isEqualToString:@"member"]) {
		buttonTitle = @"Make Participant";
	}else {
		buttonTitle = @"Make Coordinator";
	}

	self.roleActionSheet = [[UIActionSheet alloc] initWithTitle:@"Change Member's Role?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:buttonTitle, nil];
    self.roleActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.roleActionSheet showInView:self.view];
	
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet == self.deleteActionSheet) {
		if (buttonIndex == 0) {
			
			[self.activity startAnimating];
			
			
			[self.startEditButton setEnabled:NO];
			[self.endEditButton setEnabled:NO];
			
			[self.navigationItem setHidesBackButton:YES];
			[self.sendMessageButton setEnabled:NO];
			[self.addContactButton setEnabled:NO];
			[self.callNumberButton setEnabled:NO];
			[self.changeRoleButton setEnabled:NO];
			[self.callNumberButton setHidden:YES];
			[self.deleteButton setEnabled:NO];
			
			[self performSelectorInBackground:@selector(runDelete) withObject:nil];
			
			
		}else {
			
		}
	}else if (actionSheet == self.roleActionSheet) {
	
		if (buttonIndex == 0) {
		
			self.shouldChangeRole = TRUE;
				
				
			[self.activity startAnimating];
			[self.startEditButton setEnabled:NO];
			[self.endEditButton setEnabled:NO];
			[self.navigationItem setHidesBackButton:YES];
			[self.sendMessageButton setEnabled:NO];
			[self.addContactButton setEnabled:NO];
			[self.callNumberButton setEnabled:NO];
			[self.changeRoleButton setEnabled:NO];
            self.phoneOnlyArray = [NSMutableArray array];
			[self performSelectorInBackground:@selector(runRequestRole) withObject:nil];
		}
		
	}else if (actionSheet == self.callTextActionSheet) {
	
		//CallText
        
        if (self.scenario == 0) {
            if (buttonIndex == 2) {			
                
                
            }else if (buttonIndex == 0){
                
                //Call
                
                [self callPhone];			
                
                
            }else {
                
                [self textPhone];
                
                
            }
        }else if (self.scenario == 1){
            
            if (buttonIndex == 0) {
                self.callOrTextWho = @"member";
                [self callPhone];
            }else if (buttonIndex == 1){
                self.callOrTextWho = @"member";
                [self textPhone];

            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard1";
                [self callPhone];

            }else if (buttonIndex == 3){
                self.callOrTextWho = @"guard1";
                [self textPhone];

            }
        }else if (self.scenario == 2){
            
            if (buttonIndex == 0) {
                self.callOrTextWho = @"member";
                [self callPhone];
            }else if (buttonIndex == 1){
                self.callOrTextWho = @"member";
                [self textPhone];
                
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard2";
                [self callPhone];
                
            }else if (buttonIndex == 3){
                self.callOrTextWho = @"guard2";
                [self textPhone];
                
            }
            
        }else if (self.scenario == 3){
            
            if (buttonIndex == 0) {
                self.callOrTextWho = @"member";
                [self callPhone];
            }else if (buttonIndex == 1){
                self.callOrTextWho = @"member";
                [self textPhone];
                
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard1";
                [self callPhone];
                
            }else if (buttonIndex == 3){
                self.callOrTextWho = @"guard1";
                [self textPhone];
                
            }else if (buttonIndex == 4){
                self.callOrTextWho = @"guard2";
                [self callPhone];
                
            }else if (buttonIndex == 5){
                self.callOrTextWho = @"guard2";
                [self textPhone];
                
            }
            
        }else if (self.scenario == 4){
            
            if (buttonIndex == 0) {
                self.callOrTextWho = @"guard1";
                [self callPhone];
            }else if (buttonIndex == 1){
                self.callOrTextWho = @"guard1";
                [self textPhone];
                
            }else if (buttonIndex == 2){
                self.callOrTextWho = @"guard2";
                [self callPhone];
                
            }else if (buttonIndex == 3){
                self.callOrTextWho = @"guard2";
                [self textPhone];
                
            }
            
        }
		
		
	}else if (actionSheet == self.changeProfilePicAction){
		//Edit Profile Pic
		
		if (buttonIndex == 0) {
			//Take
			[self getPhoto:@"camera"];
		}else if (buttonIndex == 1){
			//ChoosePhoto
			[self getPhoto:@"library"];
			
		}
		
	}else {
		
		[FastActionSheet doAction:self :buttonIndex];

	}


    


	
}


-(void)callPhone{
    
    @try{
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]){
            
            NSString *phoneToUse = @"";
            if ([self.callOrTextWho isEqualToString:@"member"]) {
                phoneToUse = self.phone;
            }else if ([self.callOrTextWho isEqualToString:@"guard1"]){
                phoneToUse = self.guard1Phone;
            }else if ([self.callOrTextWho isEqualToString:@"guard2"]){
                phoneToUse = self.guard2Phone;
            }
            
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
                NSString *url = [@"tel://" stringByAppendingString:numberToCall];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
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
            NSString *phoneToUse = @"";
            if ([self.callOrTextWho isEqualToString:@"member"]) {
                phoneToUse = self.phone;
            }else if ([self.callOrTextWho isEqualToString:@"guard1"]){
                phoneToUse = self.guard1Phone;
            }else if ([self.callOrTextWho isEqualToString:@"guard2"]){
                phoneToUse = self.guard2Phone;
            }
            
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
                        [messageViewController setRecipients:[NSArray arrayWithObject:numberToCall]];
                        [self presentModalViewController:messageViewController animated:YES];
                        
                    }
                }else { 
                    NSString *url = [@"sms://" stringByAppendingString:numberToCall];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}






- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)switchFan{
	
	[self.activity startAnimating];
	
	self.startEditButton.enabled = NO;
	self.sendMessageButton.enabled = NO;
	
	[self performSelectorInBackground:@selector(makeFan) withObject:nil];
}

- (void)makeFan {

	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@"" :@"" :[NSArray array] :[NSArray array] :mainDelegate.token 
													:[NSData data] :@"" :@"fan" :@"" :@""];
	
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
	 @selector(finishedFan)
						   withObject:nil
						waitUntilDone:NO
	 ];
	
}

- (void)finishedFan{
		
	[self.activity stopAnimating];
	
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
-(void)cancel{

}

-(void)viewDidUnload{

    startEditButton = nil;
	endEditButton = nil;
	nameLabel = nil;
	jerseyLabel = nil;
	emailLabel = nil;
	firstEdit = nil;
	lastEdit = nil;
	emailEdit = nil;
	mobileEdit = nil;
	jerseyEdit = nil;
	sendMessageButton = nil;
	addContactButton = nil;
	callNumberButton = nil;
	addPhotoButton = nil;
	profileImage = nil;
	activity = nil;
	displayMessage = nil;
	changeRoleButton = nil;
	changeRoleText = nil;
	errorLabel = nil;
	editGuardianInfoButton = nil;
	deleteButton = nil;
	scrollView = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	switchFanButton = nil;
	switchFanLabel = nil;
	profilePhotoButton = nil;
	[super viewDidUnload];
	 
}



@end