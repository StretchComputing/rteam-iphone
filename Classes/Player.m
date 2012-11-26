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
#import "GANTracker.h"
#import "TraceSession.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}




@implementation Player
@synthesize firstName, lastName, jersey, email, memberId, teamId, tempProfileImage, fromEdit, compressImage, firstEdit, lastEdit, mobileEdit,
emailEdit, nameLabel, jerseyLabel, emailLabel, sendMessageButton, addContactButton, callNumberButton, profileImage, startEditButton, endEditButton, jerseyEdit,
addPhotoButton, activity, messageSent, displayMessage, contactAdded, userRole, changeRoleButton, changeRoleText, alertContact, alertRole,
changedRole, shouldChangeRole, phone, headUserRole, isEditing, errorLabel, origCompressImage, fromSearch,
editGuardianInfoButton, guardiansArray, deleteButton, scrollView, alertDelete, deleteSuccess, fromImage, alertCallText, isUser, 
isNetworkAuthenticated, errorString, deleteActionSheet, roleActionSheet, callTextActionSheet, playerInfo, loadingActivity, loadingLabel,
changeProfilePicAction, newImage, fromCameraSelect, selectedImage, selectedData, shouldUnload, switchFanLabel, switchFanButton, teamName, profilePhotoButton, isCurrentUser, portrait, guard1NA, guard1Last, guard2Last, guard1Email, guard1First, guard1Phone, guard2Email, guard2First, guard2Phone, guard1SmsConfirmed, guard2SmsConfirmed, guard2NA, guard1Key, guard2Key, isSmsConfirmed, guard1isUser, guard2isUser, phoneOnlyArray, callOrTextWho, callTextWhoAlertView, scenario, initPhone, newPhoneAlert, isEmailConfirmed, guard1EmailConfirmed, guard2EmailConfirmed, didHideMessage, theLastEdit, theEmailEdit, theFirstEdit, theJerseyEdit, theMobileEdit, justChose, editButtonBar, memberEmailTable, memberPhoneTable, playerEmailString, editNameTable, editRoleTable, editEmailPhoneTable, memberFanSegment, coordinatorSegment, finalUserRole, finalFanMember, cancelButton;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];

}


-(void)viewDidLoad{
    
    self.finalFanMember = @"";
    self.finalUserRole = @"";
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    self.memberEmailTable = [[UITableView alloc] initWithFrame:CGRectMake(4, 100, 312, 135) style:UITableViewStyleGrouped];
    self.memberEmailTable.delegate = self;
    self.memberEmailTable.dataSource = self;
    self.memberEmailTable.scrollEnabled = NO;
    self.memberEmailTable.backgroundColor = [UIColor clearColor];
    self.memberEmailTable.backgroundView = nil;
    self.memberEmailTable.hidden = YES;
    [self.view addSubview:self.memberEmailTable];
    
    self.memberPhoneTable = [[UITableView alloc] initWithFrame:CGRectMake(4, 210, 312, 135) style:UITableViewStyleGrouped];
    self.memberPhoneTable.delegate = self;
    self.memberPhoneTable.dataSource = self;
    self.memberPhoneTable.scrollEnabled = NO;
    self.memberPhoneTable.backgroundColor = [UIColor clearColor];
    self.memberPhoneTable.backgroundView = nil;
    self.memberPhoneTable.hidden = YES;
    [self.view addSubview:self.memberPhoneTable];
    
    
    self.editNameTable = [[UITableView alloc] initWithFrame:CGRectMake(95, 0, 220, 135) style:UITableViewStyleGrouped];
    self.editNameTable.delegate = self;
    self.editNameTable.dataSource = self;
    self.editNameTable.scrollEnabled = NO;
    self.editNameTable.backgroundColor = [UIColor clearColor];
    self.editNameTable.backgroundView = nil;
    self.editNameTable.hidden = YES;
    [self.view addSubview:self.editNameTable];
    
    self.editEmailPhoneTable = [[UITableView alloc] initWithFrame:CGRectMake(4, 135, 312, 95) style:UITableViewStyleGrouped];
    self.editEmailPhoneTable.delegate = self;
    self.editEmailPhoneTable.dataSource = self;
    self.editEmailPhoneTable.scrollEnabled = NO;
    self.editEmailPhoneTable.backgroundColor = [UIColor clearColor];
    self.editEmailPhoneTable.backgroundView = nil;
    self.editEmailPhoneTable.hidden = YES;
    [self.view addSubview:self.editEmailPhoneTable];
    
    self.editRoleTable = [[UITableView alloc] initWithFrame:CGRectMake(4, 230, 312, 95) style:UITableViewStyleGrouped];
    self.editRoleTable.delegate = self;
    self.editRoleTable.dataSource = self;
    self.editRoleTable.scrollEnabled = NO;
    self.editRoleTable.backgroundColor = [UIColor clearColor];
    self.editRoleTable.backgroundView = nil;
    self.editRoleTable.hidden = YES;
    [self.view addSubview:self.editRoleTable];
    
    
    self.firstEdit.text = @"";
    self.lastEdit.text = @"";
    self.jerseyEdit.text = @"";
    self.emailEdit.text = @"";
    self.mobileEdit.text = @"";
    
    
    self.initPhone = @"";
	self.playerInfo = @{};
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
	
    [TraceSession addEventToSession:@"Player.m - View Will Appear"];

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
        self.profileImage.frame = CGRectMake(26, 5, 61, 81);
        self.profilePhotoButton.frame = CGRectMake(26, 5, 61, 81);
        
    }else{
        
        self.profileImage.frame = CGRectMake(16, 25, 81, 61);
        self.profilePhotoButton.frame = CGRectMake(16, 25, 81, 61);
        
    }
    
	self.editNameTable.hidden = YES;
    self.editRoleTable.hidden = YES;
    self.editEmailPhoneTable.hidden = YES;
    
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
	

	
	self.firstEdit.placeholder = @"First";
	self.lastEdit.placeholder = @"Last";
	self.jerseyEdit.placeholder = @"Jersey #";
	self.emailEdit.placeholder = @"Email";
	self.mobileEdit.placeholder = @"Mobile";
	
	
    if ([self.headUserRole isEqualToString:@"coordinator"] || [self.headUserRole isEqualToString:@"creator"]) {

        self.editButtonBar = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editStart)];
        self.navigationItem.rightBarButtonItem = self.editButtonBar;
    }
    
	
	
}

-(void)memberInfo{
	
	@autoreleasepool {
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
	
	
}
-(void)getMemberInformation{
	
    @try {
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
            
            if (self.firstName == nil) {
                self.firstName = @"";
            }
            if (self.lastName == nil) {
                self.lastName = @"";
            }
            
            
            self.playerEmailString = [playerInfo valueForKey:@"emailAddress"];
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
                
                if (!self.firstEdit.text) {
                    self.firstEdit.text = @"";
                }
                
                if (!self.lastEdit.text) {
                    self.lastEdit.text = @"";
                }
                if (!self.mobileEdit.text) {
                    self.mobileEdit.text = @"";
                }
                if (!self.jerseyEdit.text) {
                    self.jerseyEdit.text = @"";
                }
                if (!self.emailEdit.text) {
                    self.emailEdit.text = @"";
                }

                
                self.theFirstEdit = [NSString stringWithString:self.firstEdit.text];
                self.theLastEdit = [NSString stringWithString:self.lastEdit.text];
                self.theJerseyEdit = [NSString stringWithString:self.jerseyEdit.text];
                self.theEmailEdit = [NSString stringWithString:self.emailEdit.text];
                self.theMobileEdit = [NSString stringWithString:self.mobileEdit.text];
                
                [self performSelectorInBackground:@selector(runRequest2) withObject:nil];
            }else {
                NSString *profile = [playerInfo valueForKey:@"photo"];
                
                if ((profile == nil)  || ([profile isEqualToString:@""])){
                    
                    
                    NSString *thumbNail = [playerInfo valueForKey:@"thumbNail"];
                    
                    if ((thumbNail == nil) || ([thumbNail isEqualToString:@""])) {
                        
                        self.profileImage.image = [UIImage imageNamed:@"profileNew.png"];
                        
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
                self.profileImage.frame = CGRectMake(26, 5, 61, 81);
                self.profilePhotoButton.frame = CGRectMake(26, 5, 61, 81);
                
            }else{
                
                self.profileImage.frame = CGRectMake(16, 25, 81, 61);
                self.profilePhotoButton.frame = CGRectMake(16, 25, 81, 61);
                
            }
            
            
            self.nameLabel.hidden = NO;
            self.emailLabel.hidden = NO;
            self.addContactButton.hidden = NO;
            
            
            [self.memberEmailTable reloadData];
            [self.memberPhoneTable reloadData];
            
        }else {
            self.errorLabel.text = self.errorString;
            [self.errorLabel setHidden:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }


	
}

-(void)cancelEdit{
    
    self.isEditing = false;

    self.editButtonBar.title = @"Edit";
    self.editButtonBar.style = UIBarButtonItemStylePlain;
    
    [self.navigationItem setHidesBackButton:NO];
    self.navigationItem.leftBarButtonItem = nil;
    
    self.editNameTable.hidden = YES;
    self.editRoleTable.hidden = YES;
    self.editEmailPhoneTable.hidden = YES;
    
    self.deleteButton.hidden = YES;
    self.editGuardianInfoButton.hidden = YES;

    self.addContactButton.hidden = NO;
    
    self.profilePhotoButton.enabled = YES;
    self.addPhotoButton.hidden = YES;

    [self.memberEmailTable reloadData];
    [self.memberPhoneTable reloadData];
}


-(void)editStart{
	
    [TraceSession addEventToSession:@"Member Info Page - Edit Button Clicked"];

    
    [self.firstEdit becomeFirstResponder];
	if (!self.isEditing) {
		
        
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.leftBarButtonItem = self.cancelButton;
        
        self.editButtonBar.title = @"Save";
        self.editButtonBar.style = UIBarButtonItemStyleDone;
    
        self.addContactButton.hidden = YES;
        self.editGuardianInfoButton.hidden = NO;
        
        
		self.isEditing = true;
		self.profilePhotoButton.enabled = NO;
		
        if ([self.headUserRole isEqualToString:@"creator"] || [self.headUserRole isEqualToString:@"coordinator"]) {
           
            if (![self.userRole isEqualToString:@"creator"]) {
                self.deleteButton.hidden = NO;
            }
        }
		


		[self.addPhotoButton setHidden:NO];
		
        
		
		[self.mobileEdit setClearsOnBeginEditing:NO];
		
        self.editNameTable.hidden = NO;
        self.editEmailPhoneTable.hidden = NO;
        self.editRoleTable.hidden = NO;
        
        [self.editNameTable reloadData];
        [self.editEmailPhoneTable reloadData];
        [self.editRoleTable reloadData];
        
        self.memberEmailTable.hidden = YES;
        self.memberPhoneTable.hidden = YES;
        
	}else {
        
        
        [self.navigationItem setHidesBackButton:NO];
        self.navigationItem.leftBarButtonItem = nil;
		
        self.editButtonBar.title = @"Edit";
        self.editButtonBar.style = UIBarButtonItemStylePlain;

      
        self.addContactButton.hidden = NO;
        self.editGuardianInfoButton.hidden = YES;
        
		self.isEditing = false;
		
		self.profilePhotoButton.enabled = YES;

		[self.startEditButton setHidden:NO];
		[self.endEditButton setHidden:YES];
		[self.deleteButton setHidden:YES];

		self.editNameTable.hidden = YES;
        self.editEmailPhoneTable.hidden = YES;
        self.editRoleTable.hidden = YES;
        self.memberEmailTable.hidden = NO;
		self.memberPhoneTable.hidden = NO;
        
		[self.firstEdit resignFirstResponder];
		[self.lastEdit resignFirstResponder];
		[self.emailEdit resignFirstResponder];
		[self.mobileEdit resignFirstResponder];
		[self.jerseyEdit resignFirstResponder];
		
		[self.addPhotoButton setHidden:YES];
		
		//run and Update Member transaction
		[self.activity startAnimating];
		
		[self.navigationItem setHidesBackButton:YES];
		
        self.phoneOnlyArray = [NSMutableArray array];
        
        if (self.firstEdit.text == nil) {
            self.firstEdit.text = @"";
        }
        
        if (self.lastEdit.text == nil) {
            self.lastEdit.text = @"";
        }
        
        if (self.jerseyEdit.text == nil) {
            self.jerseyEdit.text = @"";
        }
        
        if (self.emailEdit.text == nil) {
            self.emailEdit.text = @"";
        }
        
        if (self.mobileEdit.text == nil) {
            self.mobileEdit.text = @"";
        }
        
        self.theFirstEdit = [NSString stringWithString:self.firstEdit.text];
        self.theLastEdit = [NSString stringWithString:self.lastEdit.text];
        self.theJerseyEdit = [NSString stringWithString:self.jerseyEdit.text];
        self.theEmailEdit = [NSString stringWithString:self.emailEdit.text];
        self.theMobileEdit = [NSString stringWithString:self.mobileEdit.text];

        
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
        
        if ([self.finalUserRole isEqualToString:@"coordinator"]) {
            if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
                
            }else{
                //change them to coordinator
                [self performSelector:@selector(changeRole)];

            }
        }else if ([self.finalUserRole isEqualToString:@"member"]){
            if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
                //change them to NON coordinator
                [self performSelector:@selector(changeRole)];
            }
        }
		
        if ([self.finalFanMember isEqualToString:@"fan"]) {
            [self performSelector:@selector(switchFan)];
        }
	}

}



-(void)callNumber{
	
	[self showActionSheetCallText];
}

-(void)addContact{
	
    [TraceSession addEventToSession:@"Member Info Page - Attendance Button Clicked"];


	PlayerAttendance *tmp = [[PlayerAttendance alloc] init];
	tmp.memberId = self.memberId;
	tmp.teamId = self.teamId;
	tmp.fromSearch = self.fromSearch;
	UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.backBarButtonItem = temp;

	[self.navigationController pushViewController:tmp animated:YES];
	
}

-(void)changeRole{
    
    [TraceSession addEventToSession:@"Member Info Page - Change Role Button Clicked"];

    
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
        if (![self.theJerseyEdit isEqualToString:@""]) {
            jers = self.theJerseyEdit;
        }
        
        if (![self.theEmailEdit isEqualToString:@""]) {
            newEmail = self.theEmailEdit;
        }
        if ([self.theEmailEdit isEqualToString:@""]) {
            newEmail = @"remove";
        }
        
        if (![self.theMobileEdit isEqualToString:@""]) {
            newMobile = self.mobileEdit.text;
            
            if (![newMobile isEqualToString:self.initPhone] && !self.isEmailConfirmed) {
                [self.phoneOnlyArray addObject:newMobile];
            }
        }
        
        if ([self.theMobileEdit isEqualToString:@""]) {
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
                                                        :jers :rRoles :@[] :mainDelegate.token :profile :newEmail :newRole :newMobile :orientation];
        
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


- (void)runRequestRole{
    
    @autoreleasepool {
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
                                                        :@"" :rRoles :@[] :mainDelegate.token :[NSData data] :@"" :newRole :@"" :@""];
        
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
        if (![self.theJerseyEdit isEqualToString:@""]) {
            jers = self.theJerseyEdit;
        }
        if (![self.theEmailEdit isEqualToString:@""]) {
            newEmail = self.theEmailEdit;
        }
        
        if (![self.theMobileEdit isEqualToString:@""]) {
            newMobile = self.theMobileEdit;
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
            
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Edit Member Photo"
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
        
        NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :first :last
                                                        :jers :rRoles :@[] :mainDelegate.token :profile :newEmail :newRole :newMobile :orientation];
        
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
        self.profileImage.frame = CGRectMake(26, 5, 61, 81);
        self.profilePhotoButton.frame = CGRectMake(26, 5, 61, 81);
        
    }else{
        
        self.profileImage.frame = CGRectMake(16, 25, 81, 61);
        self.profilePhotoButton.frame = CGRectMake(16, 25, 81, 61);
        
    }
    
	if (self.shouldChangeRole) {
		self.userRole = self.changedRole;
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
	
    @try {
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
     
        if (!self.firstEdit.text) {
            self.firstEdit.text = @"";
        }
        
        if (!self.lastEdit.text) {
            self.lastEdit.text = @"";
        }
        if (!self.mobileEdit.text) {
            self.mobileEdit.text = @"";
        }
        if (!self.jerseyEdit.text) {
            self.jerseyEdit.text = @"";
        }
        if (!self.emailEdit.text) {
            self.emailEdit.text = @"";
        }
        
        self.theFirstEdit = [NSString stringWithString:self.firstEdit.text];
        self.theLastEdit = [NSString stringWithString:self.lastEdit.text];
        self.theJerseyEdit = [NSString stringWithString:self.jerseyEdit.text];
        self.theEmailEdit = [NSString stringWithString:self.emailEdit.text];
        self.theMobileEdit = [NSString stringWithString:self.mobileEdit.text];
        
        [self performSelectorInBackground:@selector(runRequest2) withObject:nil];

    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
   
  
	
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
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Add/Edit Guardian Info"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
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
    
    [TraceSession addEventToSession:@"Member Info Page - Call/Text Button Clicked"];

    
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
			
            [TraceSession addEventToSession:@"Member Info Page - Delete Member Button Clicked"];

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
			
            NSError *errors;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                                 action:@"Delete Member"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:&errors]) {
            }
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
	
    [TraceSession addEventToSession:@"Member Info Page - Make Fan Button Clicked"];

	[self.activity startAnimating];
	
	self.startEditButton.enabled = NO;
	self.sendMessageButton.enabled = NO;
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Switch Member to Fan"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	[self performSelectorInBackground:@selector(makeFan) withObject:nil];
}

- (void)makeFan {

        
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        NSDictionary *response = [ServerAPI updateMember:self.memberId :self.teamId :@"" :@"" :@"" :@[] :@[] :mainDelegate.token 
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



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (tableView == self.memberPhoneTable) {
        
        int returnNumber = 0;
        if (![self.initPhone isEqualToString:@""] && (self.initPhone != nil)) {
            returnNumber++;
        }
        
        if (![self.guard1Phone isEqualToString:@""] && (self.guard1Phone != nil)) {
            returnNumber++;
        }
        
        if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
            returnNumber++;
        }
        
        if (returnNumber == 0) {
            self.memberPhoneTable.hidden = YES;
        
            
        }else{
            self.memberPhoneTable.hidden = NO;
            
            int returnNumber1 = 0;
            if (![self.playerEmailString isEqualToString:@""] && (self.playerEmailString != nil)) {
                returnNumber1++;
            }
            
            if (![self.guard1Email isEqualToString:@""] && (self.guard1Email != nil)) {
                returnNumber1++;
            }
            
            if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                returnNumber1++;
            }
            
            CGRect frame = self.memberPhoneTable.frame;
            if (returnNumber1 ==0){
                frame.origin.y = 100;
        
            }else{
                frame.origin.y = 112 + (40*returnNumber1);
            }
            self.memberPhoneTable.frame = frame;
            
            CGRect frame2 = self.addContactButton.frame;
            frame2.origin.y = self.memberPhoneTable.frame.origin.y + (40*returnNumber) + 20;
            
            if (frame2.origin.y < 290) {
                frame2.origin.y = 290;
            }
            self.addContactButton.frame = frame2;

        }
        return returnNumber;
        
    }else if (tableView == self.memberEmailTable){
        
        int returnNumber = 0;
        if (![self.playerEmailString isEqualToString:@""] && (self.playerEmailString != nil)) {
            returnNumber++;
        }
        
        if (![self.guard1Email isEqualToString:@""] && (self.guard1Email != nil)) {
            returnNumber++;
        }
        
        if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
            returnNumber++;
        }
        
        if (returnNumber == 0) {
            self.memberEmailTable.hidden = YES;
        }else{
            self.memberEmailTable.hidden = NO;
        }
        return returnNumber;
        
    }else if (tableView == self.editNameTable){
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
	
    if (tableView == self.memberEmailTable) {
        static NSString *FirstLevelCell=@"FirstLevelCell";
        static NSInteger typeTag = 1;
        static NSInteger valueTag = 2;
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 20)];
            typeLabel.tag = typeTag;
            [cell.contentView addSubview:typeLabel];
            
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 205, 20)];
            valueLabel.tag = valueTag;
            [cell.contentView addSubview:valueLabel];
            
        }
        
        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:valueTag];
        typeLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
        
        typeLabel.backgroundColor = [UIColor clearColor];
        valueLabel.backgroundColor = [UIColor clearColor];
        
        typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        valueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        
        typeLabel.textAlignment = UITextAlignmentRight;
        
        if (row == 0) {
            //member, guard1 or guard2
            
            if (![self.playerEmailString isEqualToString:@""] && (self.playerEmailString != nil)) {
                valueLabel.text = self.playerEmailString;
                typeLabel.text = @"email";
            }else if (![self.guard1Email isEqualToString:@""] && (self.guard1Email != nil)) {
                valueLabel.text = self.guard1Email;
                typeLabel.text = @"g1 email";
            }else if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                valueLabel.text = self.guard2Email;
                typeLabel.text = @"g2 email";
            }
            
        }else if (row == 1){
            //guard1 or guard2
            
            if (![self.playerEmailString isEqualToString:@""] && (self.playerEmailString != nil)) {
                if (![self.guard1Email isEqualToString:@""] && (self.guard1Email != nil)) {
                    valueLabel.text = self.guard1Email;
                    typeLabel.text = @"g1 email";
                }else if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                    valueLabel.text = self.guard2Email;
                    typeLabel.text = @"g2 email";
                }
            }else if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                valueLabel.text = self.guard2Email;
                typeLabel.text = @"g2 email";
            }
            
        }else {
            //guard2
            valueLabel.text = self.guard2Email;
            typeLabel.text = @"g2 email";
        }
        
        
        return cell;
    }else if (tableView == self.memberPhoneTable) {
        static NSString *FirstLevelCell=@"FirstLevelCell";
        static NSInteger typeTag = 1;
        static NSInteger valueTag = 2;
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 20)];
            typeLabel.tag = typeTag;
            [cell.contentView addSubview:typeLabel];
            
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 205, 20)];
            valueLabel.tag = valueTag;
            [cell.contentView addSubview:valueLabel];
            
        }
        
        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:valueTag];
        typeLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
                
        typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        valueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        
        typeLabel.backgroundColor = [UIColor clearColor];
        valueLabel.backgroundColor = [UIColor clearColor];
        
        typeLabel.textAlignment = UITextAlignmentRight;

        if (row == 0) {
            //member, guard1 or guard2
            
            if (![self.initPhone isEqualToString:@""] && (self.initPhone != nil)) {
                valueLabel.text = self.initPhone;
                typeLabel.text = @"phone";
            }else if (![self.guard1Phone isEqualToString:@""] && (self.guard1Phone != nil)) {
                valueLabel.text = self.guard1Phone;
                typeLabel.text = @"g1 phone";
            }else if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
                valueLabel.text = self.guard2Phone;
                typeLabel.text = @"g2 phone";
            }
            
        }else if (row == 1){
            //guard1 or guard2
            
            if (![self.initPhone isEqualToString:@""] && (self.initPhone != nil)) {
                if (![self.guard1Phone isEqualToString:@""] && (self.guard1Phone != nil)) {
                    valueLabel.text = self.guard1Phone;
                    typeLabel.text = @"g1 phone";
                }else if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
                    valueLabel.text = self.guard2Phone;
                    typeLabel.text = @"g2 phone";
                }
            }else if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
                valueLabel.text = self.guard2Phone;
                typeLabel.text = @"g2 phone";
            }
            
        }else {
            //guard2
            valueLabel.text = self.guard2Phone;
            typeLabel.text = @"G2 Phone";
        }
        
        return cell;
        
    }else if (tableView == self.editNameTable) {
        
        static NSString *FirstLevelCell=@"FirstLevelCell";
        static NSInteger typeTag = 1;
        static NSInteger valueTag = 2;
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 20)];
            typeLabel.tag = typeTag;
            [cell.contentView addSubview:typeLabel];
            
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 205, 20)];
            valueLabel.tag = valueTag;
            [cell.contentView addSubview:valueLabel];
            
        }
        
        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:valueTag];
        typeLabel.hidden = YES;
        valueLabel.hidden = YES;
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        if (row == 0) {
            
            self.firstEdit = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 195, 20)];
            self.firstEdit.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.firstEdit.placeholder = @"First";
            self.firstEdit.returnKeyType = UIReturnKeyDone;
            self.firstEdit.delegate = self;
            self.firstEdit.backgroundColor = [UIColor clearColor];
            
            if ([self.firstName length] > 0) {
                self.firstEdit.text = self.firstName;
                self.firstEdit.textColor = [UIColor blackColor];
            }else {
                
            }
            
            [cell.contentView addSubview:self.firstEdit];

        }else if (row == 1){
            
            self.lastEdit = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 195, 20)];
            [self.lastEdit addTarget:self action:@selector(endText) forControlEvents:UIControlEventValueChanged];
            self.lastEdit.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.lastEdit.placeholder = @"Last";
            self.lastEdit.returnKeyType = UIReturnKeyDone;
            self.lastEdit.delegate = self;
            self.lastEdit.backgroundColor = [UIColor clearColor];
            
            if ([self.lastName length] > 0) {
                self.lastEdit.text = self.lastName;
                self.lastEdit.textColor = [UIColor blackColor];
            }else {
                
            }
            
            [cell.contentView addSubview:self.lastEdit];
            

        }else{
            self.jerseyEdit = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 195, 20)];
            [self.jerseyEdit addTarget:self action:@selector(endText) forControlEvents:UIControlEventValueChanged];
            self.jerseyEdit.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.jerseyEdit.placeholder = @"Jersey #";
            self.jerseyEdit.returnKeyType = UIReturnKeyDone;
            self.jerseyEdit.delegate = self;
            self.jerseyEdit.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.jerseyEdit.backgroundColor = [UIColor clearColor];
            
            if ([self.jersey length] > 0) {
                self.jerseyEdit.text = self.jersey;
                self.jerseyEdit.textColor = [UIColor blackColor];
            }else {
                
            }
            
            [cell.contentView addSubview:self.jerseyEdit];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
    }else if (tableView == self.editEmailPhoneTable) {
        
        static NSString *FirstLevelCell=@"FirstLevelCell";
        static NSInteger typeTag = 1;
        static NSInteger valueTag = 2;
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 20)];
            typeLabel.tag = typeTag;
            [cell.contentView addSubview:typeLabel];
            
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 205, 20)];
            valueLabel.tag = valueTag;
            [cell.contentView addSubview:valueLabel];
            
        }
        
        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:valueTag];
        typeLabel.hidden = YES;
        valueLabel.hidden = YES;
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        
        if (row == 0) {
            
            self.emailEdit = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 287, 20)];
            [self.emailEdit addTarget:self action:@selector(endText) forControlEvents:UIControlEventValueChanged];
            self.emailEdit.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.emailEdit.placeholder = @"Email";
            self.emailEdit.returnKeyType = UIReturnKeyDone;
            self.emailEdit.delegate = self;
            self.emailEdit.backgroundColor = [UIColor clearColor];
            
            if ([self.playerEmailString length] > 0) {
                self.emailEdit.text = self.playerEmailString;
                self.emailEdit.textColor = [UIColor blackColor];
            }else {
                
            }
            
            
            if (self.isUser) {
                
                if (self.isEmailConfirmed) {
                    [self.emailEdit setEnabled:NO];
                }
           
            }
            
            
            [cell.contentView addSubview:self.emailEdit];
            
        }else{
            
            self.mobileEdit = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 287, 20)];
            [self.mobileEdit addTarget:self action:@selector(endText) forControlEvents:UIControlEventValueChanged];
            self.mobileEdit.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.mobileEdit.placeholder = @"Phone";
            self.mobileEdit.returnKeyType = UIReturnKeyDone;
            self.mobileEdit.delegate = self;
            self.mobileEdit.backgroundColor = [UIColor clearColor];
            
            if (![self.phone isEqualToString:@""]) {

                NSString *myLocale;
                self.mobileEdit.text = [myPhoneNumberFormatter format:self.phone withLocale:myLocale];
                self.mobileEdit.textColor = [UIColor blackColor];
            }else {
                
            }

            if (self.isUser) {
            
                if (self.isSmsConfirmed) {
                    [self.mobileEdit setEnabled:NO];
                }
            }
            
            
            [cell.contentView addSubview:self.mobileEdit];
          
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        static NSString *FirstLevelCell=@"FirstLevelCell";
        static NSInteger typeTag = 1;
        static NSInteger valueTag = 2;
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 85, 20)];
            typeLabel.tag = typeTag;
            [cell.contentView addSubview:typeLabel];
            
            
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 205, 20)];
            valueLabel.tag = valueTag;
            [cell.contentView addSubview:valueLabel];
            
        }
        
        UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:valueTag];
        valueLabel.hidden = YES;
        
        typeLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
        
        typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        valueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        
        typeLabel.backgroundColor = [UIColor clearColor];
        valueLabel.backgroundColor = [UIColor clearColor];
        
        typeLabel.textAlignment = UITextAlignmentRight;
        
        for (UIView *view in [cell.contentView subviews]) {
            
            if ([view class] == [UISegmentedControl class]) {
                [view removeFromSuperview];
            }
        }
        
        
        if (row == 0) {
            
            self.coordinatorSegment = [[UISegmentedControl alloc] initWithItems:@[@"Yes", @"No"]];
            self.coordinatorSegment.frame = CGRectMake(105, 5, 182, 30);
            self.coordinatorSegment.segmentedControlStyle = UISegmentedControlStyleBar;
            
            [self.coordinatorSegment addTarget:self action:@selector(coordinatorChanged) forControlEvents:UIControlEventValueChanged];

            if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
                self.coordinatorSegment.selectedSegmentIndex = 0;
            }else{
                self.coordinatorSegment.selectedSegmentIndex = 1;
            }
            self.coordinatorSegment.enabled = YES;
            
            if ([self.userRole isEqualToString:@"creator"]) {
                self.coordinatorSegment.enabled = NO;
            }
            
            [cell.contentView addSubview:self.coordinatorSegment];
            typeLabel.text = @"coordinator";

            
        }else{
            typeLabel.text = @"role";

            self.memberFanSegment = [[UISegmentedControl alloc] initWithItems:@[@"Member", @"Fan"]];
            self.memberFanSegment.frame = CGRectMake(105, 5, 182, 30);
            self.memberFanSegment.segmentedControlStyle = UISegmentedControlStyleBar;
            self.memberFanSegment.selectedSegmentIndex = 0;
            [self.memberFanSegment addTarget:self action:@selector(memberFanChanged) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:self.memberFanSegment];

        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }


}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger row = [indexPath row];
    if (tableView == self.memberEmailTable) {
        
        NSString *emailString = @"";
        if (row == 0) {
            //member, guard1 or guard2
            
            if (![self.playerEmailString isEqualToString:@""] && (self.playerEmailString != nil)) {
                emailString = self.playerEmailString;
            }else if (![self.guard1Email isEqualToString:@""] && (self.guard1Email != nil)) {
                emailString = self.guard1Email;

            }else if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                emailString = self.guard2Email;
            }
            
        }else if (row == 1){
            //guard1 or guard2
            
            if (![self.playerEmailString isEqualToString:@""] && (self.playerEmailString != nil)) {
                if (![self.guard1Email isEqualToString:@""] && (self.guard1Email != nil)) {
                    emailString = self.guard1Email;

                }else if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                    emailString = self.guard2Email;
                }
            }else if (![self.guard2Email isEqualToString:@""] && (self.guard2Email != nil)) {
                emailString = self.guard2Email;
            }
            
        }else {
            //guard2
            emailString = self.guard2Email;
        }
        
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setToRecipients:@[emailString]];
            
            [self presentModalViewController:mailViewController animated:YES];
            
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Device." message:@"Your device cannot currently send email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
    }else if (tableView == self.memberPhoneTable){
        if (row == 0) {
            //member, guard1 or guard2
            if (![self.initPhone isEqualToString:@""] && (self.initPhone != nil)) {
                self.callOrTextWho = @"member";
            }else if (![self.guard1Phone isEqualToString:@""] && (self.guard1Phone != nil)) {
                self.callOrTextWho = @"guard1";
            }else if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
                self.callOrTextWho = @"guard2";

            }
            
        }else if (row == 1){
            //guard1 or guard2
            
            if (![self.initPhone isEqualToString:@""] && (self.initPhone != nil)) {
                if (![self.guard1Phone isEqualToString:@""] && (self.guard1Phone != nil)) {
                    self.callOrTextWho = @"guard1";

                }else if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
                    self.callOrTextWho = @"guard2";

                }
            }else if (![self.guard2Phone isEqualToString:@""] && (self.guard2Phone != nil)) {
                self.callOrTextWho = @"guard2";

            }
            
        }else {
            //guard2
           self.callOrTextWho = @"guard2";

        }
        
        self.callTextActionSheet = [[UIActionSheet alloc] initWithTitle:@"Call or Text this person?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Text", nil];
        self.callTextActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [self.callTextActionSheet showInView:self.view];
    }else if (tableView == self.editNameTable){

        if (row == 0) {
            [self.firstEdit becomeFirstResponder];

        }else if (row == 1){
            [self.lastEdit becomeFirstResponder];

        }else{
            [self.jerseyEdit becomeFirstResponder];
        }
    }else if (tableView == self.editEmailPhoneTable){

        if (row == 0) {
            [self.emailEdit becomeFirstResponder];
            
        }else{
            [self.mobileEdit becomeFirstResponder];
        }
        
    }else{

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSent:
            
			break;
		case MFMailComposeResultFailed:
            
			break;
			
		case MFMailComposeResultSaved:
            
			break;
		default:
			
			break;
	}
	
	
	[self dismissModalViewControllerAnimated:YES];
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	[textField resignFirstResponder];
    
    self.editNameTable.frame =CGRectMake(95, 0, 220, 135);
    self.editEmailPhoneTable.frame = CGRectMake(4, 135, 312, 95);
                                
	return YES;
    
}


- (void)keyboardWillShow:(NSNotification *)note {  
    
    if ([self.mobileEdit isFirstResponder]) {
        self.editNameTable.frame =CGRectMake(95, -50, 220, 135);
        self.editEmailPhoneTable.frame = CGRectMake(4, 85, 312, 95);
    }else{
        self.editNameTable.frame =CGRectMake(95, 0, 220, 135);
        self.editEmailPhoneTable.frame = CGRectMake(4, 135, 312, 95);
    }
    
    
    
}

-(void)memberFanChanged{
    
    if (self.memberFanSegment.selectedSegmentIndex == 0) {
        self.finalFanMember = @"member";
    }else{
        self.finalFanMember = @"fan";
    }
}

-(void)coordinatorChanged{
    if (self.coordinatorSegment.selectedSegmentIndex == 0) {
        self.finalUserRole = @"coordinator";
    }else{
        self.finalUserRole = @"member";
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[super viewDidUnload];
	 
}



@end