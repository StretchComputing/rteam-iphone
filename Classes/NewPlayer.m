//
//  NewPlayer.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewPlayer.h"
#import "Player.h"
#import "Players.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "CurrentTeamTabs.h"
#import "AddGuardian.h"
#import "QuartzCore/QuartzCore.h"
#import "FastActionSheet.h"
#import "NewMemberObject.h"
#import "Home.h"

@implementation NewPlayer
@synthesize firstName, lastName, email, guardianEmail, roles, teamId, submitButton, serverProcess, error, createSuccess, isCoordinator, 
helpScreen, barItem, userRole, closeButton, sendEmailButton, addParentGuardianButton, useGuardians, guardianOneFirst, multipleActivity,
guardianOneLast, guardianOneEmail, guardianTwoFirst, guardianTwoLast, guardianTwoEmail, errorString, firstNamePicked,
lastNamePicked, phoneNumber, addMultipleMembersButton, addViewBackground, addView, closeMultipleButton, saveButton, emailArray, addNewButton, myTableView,
miniBackgroundView, miniForeGroundView, nameText, emailText, phoneText, miniErrorLabel, miniCancelButton, miniAddButton, isMiniAdd, addContactButton,
phoneOnlyArray, multiplePhoneArray, multipleEmailArray, multiplePhoneAlert, multipleEmailAlert, tmpMiniEmail, tmpMiniPhone, miniMultiple,
tmpMiniFirstName, tmpMiniLastName, miniMultiplePhoneAlert, miniMultipleEmailAlert, twoAlerts, guardianOnePhone, guardianTwoPhone, 
guardianBackground, miniGuardAddButton, miniGuardCancelButton, oneName, oneEmail, onePhone, twoEmail, twoName, twoPhone, currentGuardianSelection,
miniGuardErrorLabel, removeGuardiansButton, addContactWhere, guard1EmailAlert, guard1PhoneAlert, guard2EmailAlert, guard2PhoneAlert,
currentGuardName, currentGuardEmail, currentGuardPhone, multipleEmailArrayLabels, multiplePhoneArrayLabels, coordinatorSegment;



-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewWillAppear:(BOOL)animated{
    
   

	if (self.useGuardians) {
		[self.addParentGuardianButton setTitle:@"Change Parent or Guardian" forState:UIControlStateNormal];
	}else {
		[self.addParentGuardianButton setTitle:@"+ Add Parent or Guardian" forState:UIControlStateNormal];
	}

}
- (void)viewDidLoad {
    
    self.isMiniAdd = true;
    
    
    NSString *ios = [[UIDevice currentDevice] systemVersion];
	if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
		
		self.myTableView.backgroundColor = [UIColor clearColor];
		self.myTableView.opaque = NO;
		self.myTableView.backgroundView = nil;
		
	}
	
    self.guardianBackground.hidden = YES;
    self.removeGuardiansButton.hidden = YES;
    
	self.phoneOnlyArray = [NSMutableArray array];

	myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];

	myTextFieldSemaphore = 0;
	[self.phoneNumber addTarget:self
						action:@selector(autoFormatTextField:)
			  forControlEvents:UIControlEventEditingChanged
	 ];
	
	[self.phoneText addTarget:self
						 action:@selector(autoFormatTextField1:)
			   forControlEvents:UIControlEventEditingChanged
	 ];
	
    [self.onePhone addTarget:self
                       action:@selector(autoFormatTextField2:)
             forControlEvents:UIControlEventEditingChanged
	 ];
    
    [self.twoPhone addTarget:self
                       action:@selector(autoFormatTextField3:)
             forControlEvents:UIControlEventEditingChanged
	 ];
    
	self.emailArray = [NSMutableArray array];
	
	
	self.addViewBackground.hidden = YES;
	
	self.miniBackgroundView.hidden = YES;
	
	self.addViewBackground.layer.masksToBounds = YES;
	self.addViewBackground.layer.cornerRadius = 10.0;
	self.addView.layer.masksToBounds = YES;
	self.addView.layer.cornerRadius = 10.0;
	
	self.miniBackgroundView.layer.masksToBounds = YES;
	self.miniBackgroundView.layer.cornerRadius = 10.0;
	
	self.miniForeGroundView.layer.masksToBounds = YES;
	self.miniForeGroundView.layer.cornerRadius = 10.0;
	
	self.myTableView.dataSource = self;
	self.myTableView.delegate = self;
	
	
	self.title=@"New Member(s)";
	[self.helpScreen setHidden:YES];
	[self.helpScreen setContentSize:CGSizeMake(200, 600.0)];
	
	self.barItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
	//[self.navigationItem setRightBarButtonItem:self.barItem];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.closeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.sendEmailButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addParentGuardianButton setBackgroundImage:stretch forState:UIControlStateNormal];
	//[self.addMultipleMembersButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.closeMultipleButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.saveButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniAddButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniCancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addNewButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.miniGuardCancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.miniGuardAddButton setBackgroundImage:stretch forState:UIControlStateNormal];


	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"greenButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.addMultipleMembersButton setBackgroundImage:stretch1 forState:UIControlStateNormal];

    UIImage *buttonImageNormal2 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch2 = [buttonImageNormal2 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.removeGuardiansButton setBackgroundImage:stretch2 forState:UIControlStateNormal];

    
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.addView.bounds;
	UIColor *color2 =  [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:0.9];
	UIColor *color1 =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:255/255.0 alpha:0.9];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	[self.addView.layer insertSublayer:gradient atIndex:0];
	
	self.useGuardians = false;
	self.guardianOneFirst = @"";
	self.guardianOneLast = @"";
	self.guardianOneEmail = @"";
	self.guardianTwoFirst = @"";
	self.guardianTwoLast = @"";
	self.guardianTwoEmail = @"";
    self.guardianOnePhone = @"";
	self.guardianTwoPhone = @"";


	self.helpScreen.layer.masksToBounds = YES;
	self.helpScreen.layer.cornerRadius = 25.0;
	
	UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(home)];
	[self.navigationItem setRightBarButtonItem:homeButton];
	
}

-(void)home{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
}

-(void)about{
	
	
	if ([self.barItem.title isEqualToString:@"Options"]) {
		self.barItem.title = @"Done";
		[self.helpScreen setHidden:NO];
	}else {
		self.barItem.title = @"Options";
		[self.helpScreen setHidden:YES];
	}
	
	//TestAddrBook *nextController = [[TestAddrBook alloc] init];
	//[self.navigationController pushViewController:nextController animated:YES];
}

-(void)closeHelp{
	
	self.barItem.title = @"Options";
	[self.helpScreen setHidden:YES];
}

-(void)sendEmail{
	
}




-(void)create {
	
	if (self.firstName.text == nil) {
		self.firstName.text = @"";
	}
	if (self.lastName.text == nil) {
		self.lastName.text = @"";
	}
	if (self.email.text == nil) {
		self.email.text = @"";
	}
	
	self.error.text = @"";
	//Validate all fields are entered:
	if ([self.firstName.text isEqualToString:@""] && [self.lastName.text isEqualToString:@""] && [self.email.text isEqualToString:@""] && 
		[self.phoneNumber.text isEqualToString:@""]){
		self.error.text = @"*You must fill out at least one field.";	
	}else{
	
	[serverProcess startAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[submitButton setEnabled:NO];
		[self.addParentGuardianButton setEnabled:NO];
	[self.navigationItem setHidesBackButton:YES];
	[self.firstName setEnabled:NO];
	[self.lastName setEnabled:NO];
	[self.email setEnabled:NO];
	
	
	
	
	//Create the player in a background thread
	
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	}
	
	
	
	
}

- (void)runRequest {

	
	//Create the new player
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpRoles = [[NSMutableArray alloc] init];
	NSMutableArray *guardians = [[NSMutableArray alloc] init];
	
	NSString *role = @"member";
	

	NSMutableDictionary *guardianOne = [NSMutableDictionary dictionary];
	NSMutableDictionary *guardianTwo = [NSMutableDictionary dictionary];

    
	if (![self.guardianOneFirst isEqualToString:@""]) {
		
		NSDictionary *tmpDictionary = [NSDictionary dictionary];
		[guardianOne setObject:self.guardianOneFirst forKey:@"firstName"];
		[guardianOne setObject:self.guardianOneLast forKey:@"lastName"];
        
        if (![self.guardianOneEmail isEqualToString:@""]) {
            [guardianOne setObject:self.guardianOneEmail forKey:@"emailAddress"];
        }
        if (![self.guardianOnePhone isEqualToString:@""]) {
            [guardianOne setObject:self.guardianOnePhone forKey:@"phoneNumber"];
        }
		
		tmpDictionary = guardianOne;
		[guardians addObject:tmpDictionary];
	}
	
	if (![self.guardianTwoFirst isEqualToString:@""]) {
		
		NSDictionary *tmpDictionary = [NSDictionary dictionary];
		[guardianTwo setObject:self.guardianTwoFirst forKey:@"firstName"];
		[guardianTwo setObject:self.guardianTwoLast forKey:@"lastName"];
		
        if (![self.guardianTwoEmail isEqualToString:@""]) {
            [guardianTwo setObject:self.guardianTwoEmail forKey:@"emailAddress"];
        }
        if (![self.guardianTwoPhone isEqualToString:@""]) {
            [guardianTwo setObject:self.guardianTwoPhone forKey:@"phoneNumber"];
        }

		
		tmpDictionary = guardianTwo;
		[guardians addObject:tmpDictionary];
	}
    
	NSArray *guardianArray = guardians;
	
	
	[tmpRoles addObject:role];
	
	NSArray *rRoles = tmpRoles;
	
	NSString *theRole = @"";
	if (self.isCoordinator.selectedSegmentIndex == 0) {
		theRole = @"coordinator";
	}
	
	NSString *phone = @"";
	
	if (![self.phoneNumber.text isEqualToString:@""]) {
		phone = self.phoneNumber.text;
	}
	
	if ([self.email.text isEqualToString:@""] && ![self.phoneNumber.text isEqualToString:@""]) {
	
		
		[self.phoneOnlyArray addObject:self.phoneNumber.text];
		
	}
    
	

	NSDictionary *response = [ServerAPI createMember:self.firstName.text :self.lastName.text :self.email.text
													:@"" :rRoles :guardianArray :self.teamId :mainDelegate.token :theRole :phone];
	
	
	NSString *status = [response valueForKey:@"status"];
		
	if ([status isEqualToString:@"100"]){
		
		self.createSuccess = true;
		
	}else{
		
		//Server hit failed...get status code out and display error accordingly
		self.createSuccess = false;
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
			case 208:
				self.errorString = @"NA";
				break;
			case 209:
				self.errorString = @"*Member email address already in use";
				break;
			case 219:
				self.errorString = @"*Guardian email address already in use";
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
	
	//When background thread is done, return to main thread
	[serverProcess stopAnimating];
	
	
	if (self.createSuccess){
		
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 2;
				
		if ([tempCont count] > tempNum) {
			
			
			if ([CurrentTeamTabs class] == [[tempCont objectAtIndex:tempNum] class]) {
				CurrentTeamTabs *tmpCont = [tempCont objectAtIndex:tempNum];
				tmpCont.userRole = self.userRole;
				tmpCont.selectedIndex = 2;
				
				Players *tmp = [[tmpCont viewControllers] objectAtIndex:2];
				tmp.phoneOnlyArray = self.phoneOnlyArray;
				[self.navigationController popToViewController:tmpCont animated:NO];
			}else if ([Home class] == [[tempCont objectAtIndex:tempNum] class]) {
				
				Home *tmp = [tempCont objectAtIndex:tempNum];
				tmp.phoneOnlyArray = self.phoneOnlyArray;
				[self.navigationController popToViewController:tmp animated:NO];
			}
			
		}else {
			rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

			mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
			[self.navigationController dismissModalViewControllerAnimated:YES];
		}

		
	}else{
	
		if ([self.errorString isEqualToString:@"NA"]) {
			//Alert
			NSString *tmp = @"Only User's with confirmed email addresses can add new team members.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
			self.error.text = self.errorString;
		}

		[submitButton setEnabled:YES];
		[self.addParentGuardianButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.firstName setEnabled:YES];
		[self.lastName setEnabled:YES];
		[self.email setEnabled:YES];
	
	}
	
	
}

-(void)addParentGuardian{
	
	[self.firstName resignFirstResponder];
	[self.lastName resignFirstResponder];
	[self.email resignFirstResponder];
	
	AddGuardian *tmp = [[AddGuardian alloc] init];
	tmp.guardianOneFirst = self.guardianOneFirst;
	tmp.guardianOneLast = self.guardianOneLast;
	tmp.guardianOneEmail = self.guardianOneEmail;
	tmp.guardianTwoFirst = self.guardianTwoFirst;
	tmp.guardianTwoLast = self.guardianTwoLast;
	tmp.guardianTwoEmail = self.guardianTwoEmail;
    tmp.guardianOnePhone = self.guardianOnePhone;
    tmp.guardianTwoPhone = self.guardianTwoPhone;
	[self.navigationController pushViewController:tmp animated:YES];
	
}

-(void)endText {
	
	[self becomeFirstResponder];
}

- (void)showPicker:(id)sender {
    self.multipleEmailArray = [NSMutableArray array];

    UIButton *tmpButton = (UIButton *)sender;
    
    if (tmpButton.tag == 0) {
        //New Member
        self.addContactWhere = @"member";
    }else if (tmpButton.tag == 1){
        //Guardian 1
        self.addContactWhere = @"guard1";
        
    }else{
        //Guardian 2
        self.addContactWhere = @"guard2";
        
    }

    
    ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	
    [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
    self.multiplePhoneArray = [NSMutableArray array];
    self.multipleEmailArray = [NSMutableArray array];
    self.multipleEmailArrayLabels = [NSMutableArray array];
    self.multiplePhoneArrayLabels = [NSMutableArray array];
    
    self.twoAlerts = false;
    
    self.tmpMiniEmail = @"";
    self.tmpMiniLastName = @"";
    self.tmpMiniPhone = @"";
    self.tmpMiniFirstName = @"";
    
    self.currentGuardName = @"";
    self.currentGuardEmail = @"";
    self.currentGuardPhone = @"";
    
    NSString* fName = (__bridge NSString *)ABRecordCopyValue(person,
												   kABPersonFirstNameProperty);
	
	NSString *lName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

	
	ABMultiValueRef emails = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
	
	NSArray *emailArray1 = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emails);
	NSString *emailAddress = @"";
	if ([emailArray1 count] > 0) {
		emailAddress = [emailArray1 objectAtIndex:0];
        self.multipleEmailArray = [NSMutableArray arrayWithArray:emailArray1];
        
        for(int i = 0; i < ABMultiValueGetCount(emails); i++)
        {
            NSString *test = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(emails, i);
            
            NSString *final = [self getType:test];
            
            [self.multipleEmailArrayLabels addObject:final];
            
        }

	}
	
	
	ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
	
	NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phone);
	NSString *phoneString = @"";
	if ([phoneArray count] > 0) {
		phoneString = [phoneArray objectAtIndex:0];
        self.multiplePhoneArray = [NSMutableArray arrayWithArray:phoneArray];
        
        for(int i = 0; i < ABMultiValueGetCount(phone); i++)
        {
            NSString *test = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phone, i);
            
            NSString *final = [self getType:test];
            
            [self.multiplePhoneArrayLabels addObject:final];
            
        }
	}

	


    if (fName == nil) {
        fName = @"";
    }
    if (lName == nil) {
        lName = @"";
    }
    if (emailAddress == nil) {
        emailAddress = @"";
    }
    if (phoneString == nil) {
        phoneString = @"";
    }
    
    self.currentGuardName = @"";
    if (![fName isEqualToString:@""]) {
        self.currentGuardName = fName;
        
        if (![lName isEqualToString:@""]){
            self.currentGuardName = [self.currentGuardName stringByAppendingFormat:@" %@", lName];
        }
    }
    
	if (self.isMiniAdd) {
		
        bool isEmail = false;
        bool isPhone = false;
        if ([self.multipleEmailArray count] > 1){
            
            isEmail = true;
            
            if ([self.multipleEmailArray count] > 4) {
                
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                for (int i = 0; i < 4 ; i++) {
                    [tmpArray addObject:[self.multipleEmailArray objectAtIndex:i]];
                }
                
                self.multipleEmailArray = [NSMutableArray arrayWithArray:tmpArray];
            }
            
            NSString *message = @"";
            if ([self.multipleEmailArray count] == 4) {
                message = @"Please Choose One.";
            }else{
                message = @"Please pick which email address you would like to use.";
            }

            
            if ([self.addContactWhere isEqualToString:@"member"]) {
                
                self.miniMultipleEmailAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Emails Found" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                for (int i = 0; i < [self.multipleEmailArray count]; i++) {
                    
                    NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multipleEmailArrayLabels objectAtIndex:i],
                                       [self.multipleEmailArray objectAtIndex:i]];
                    [self.miniMultipleEmailAlert addButtonWithTitle:title];
                }
                
            }else if ([self.addContactWhere isEqualToString:@"guard1"]){
                
                self.guard1EmailAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Emails Found" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                for (int i = 0; i < [self.multipleEmailArray count]; i++) {
                    
                    NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multipleEmailArrayLabels objectAtIndex:i],
                                       [self.multipleEmailArray objectAtIndex:i]];
                    [self.guard1EmailAlert addButtonWithTitle:title];
                }
                
            }else{
                
                self.guard2EmailAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Emails Found" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                for (int i = 0; i < [self.multipleEmailArray count]; i++) {
                    
                    NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multipleEmailArrayLabels objectAtIndex:i],
                                       [self.multipleEmailArray objectAtIndex:i]];
                    [self.guard2EmailAlert addButtonWithTitle:title];
                }
                
            }

            
        }
        
        if ([self.multiplePhoneArray count] > 1) {
            
            isPhone = true;
            
            if ([self.multiplePhoneArray count] > 4) {
                
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                for (int i = 0; i < 4 ; i++) {
                    [tmpArray addObject:[self.multiplePhoneArray objectAtIndex:i]];
                }
                
                self.multiplePhoneArray = [NSMutableArray arrayWithArray:tmpArray];
            }
            
            NSString *message = @"";
            if ([self.multiplePhoneArray count] == 4) {
                message = @"Please Choose One.";
            }else{
                message = @"Please pick which phone number you would like to use.";
            }

            
            if ([self.addContactWhere isEqualToString:@"member"]) {
                
                self.miniMultiplePhoneAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Phone Numbers" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                for (int i = 0; i < [self.multiplePhoneArray count]; i++) {
                    
                    NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multiplePhoneArrayLabels objectAtIndex:i],
                                       [self.multiplePhoneArray objectAtIndex:i]];
                    [self.miniMultiplePhoneAlert addButtonWithTitle:title];
                }
                
            }else if ([self.addContactWhere isEqualToString:@"guard1"]){
                
                self.guard1PhoneAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Phone Numbers" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                for (int i = 0; i < [self.multiplePhoneArray count]; i++) {
                    
                    NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multiplePhoneArrayLabels objectAtIndex:i],
                                       [self.multiplePhoneArray objectAtIndex:i]];
                    [self.guard1PhoneAlert addButtonWithTitle:title];
                }
                
            }else{
                
                self.guard2PhoneAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Phone Numbers" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                
                for (int i = 0; i < [self.multiplePhoneArray count]; i++) {
                    
                    NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multiplePhoneArrayLabels objectAtIndex:i],
                                       [self.multiplePhoneArray objectAtIndex:i]];
                    [self.guard2PhoneAlert addButtonWithTitle:title];
                }
            }
            
            
        }
        
       
        
        if (isEmail && isPhone){
            
            self.twoAlerts = true;
            self.miniMultiple = @"both";
            self.tmpMiniFirstName = fName;
            self.tmpMiniLastName = lName;
            
            if ([self.addContactWhere isEqualToString:@"member"]){
                
                [self.miniMultipleEmailAlert show];
                
            }else if ([self.addContactWhere isEqualToString:@"guard1"]){
                
                [self.guard1EmailAlert show];
            }else{
                
                [self.guard2EmailAlert show];
            }

            
        }else if (isEmail){
            
            self.miniMultiple = @"email";
            
            self.tmpMiniFirstName = fName;
            self.tmpMiniLastName = lName;
            self.tmpMiniPhone = phoneString;
            self.currentGuardPhone = phoneString;
            
            if ([self.addContactWhere isEqualToString:@"member"]){
                
                [self.miniMultipleEmailAlert show];
                
            }else if ([self.addContactWhere isEqualToString:@"guard1"]){
                
                [self.guard1EmailAlert show];
            }else{
                
                [self.guard2EmailAlert show];
            }

            
        }else if (isPhone){
            
            self.miniMultiple = @"phone";
            
            self.tmpMiniFirstName = fName;
            self.tmpMiniLastName = lName;
            self.tmpMiniEmail = emailAddress;
            self.currentGuardEmail = emailAddress;
            
            if ([self.addContactWhere isEqualToString:@"member"]){
                
                [self.miniMultiplePhoneAlert show];
                
            }else if ([self.addContactWhere isEqualToString:@"guard1"]){
                
                [self.guard1PhoneAlert show];
            }else{
                
                [self.guard2PhoneAlert show];
                
            }


            
        }else{
            
            if ([self.addContactWhere isEqualToString:@"member"]){
                NewMemberObject *tmpObject = [[NewMemberObject alloc] init];
                tmpObject.firstName = @"";
                tmpObject.lastName = @"";
                tmpObject.email = @"";
                tmpObject.phone = @"";
                tmpObject.role = @"";
                tmpObject.guardianOneName = @"";
                tmpObject.guardianOneEmail = @"";
                tmpObject.guardianOnePhone = @"";
                tmpObject.guardianTwoName = @"";
                tmpObject.guardianTwoEmail = @"";
                tmpObject.guardianTwoPhone = @"";
                
                if (fName != nil) {
                    tmpObject.firstName = fName;
                    
                }
                if (lName != nil) {
                    tmpObject.lastName = lName;
                    
                }
                if (emailAddress != nil) {
                    tmpObject.email = emailAddress;
                    
                }
                if (phoneString != nil) {
                    tmpObject.phone = phoneString;
                    
                }
                
                [self.emailArray addObject:tmpObject];
                
                [self.myTableView reloadData];
                
                
            }else if ([self.addContactWhere isEqualToString:@"guard1"]){
                
                self.oneName.text = self.currentGuardName;
                self.oneEmail.text = emailAddress;
                self.onePhone.text = phoneString;
            }else{
                self.twoName.text = self.currentGuardName;
                self.twoEmail.text = emailAddress;
                self.twoPhone.text = phoneString;
            }

            
        }
        
		
	}else {
		
        bool showEmail = false;
        bool showPhone = false;
		self.firstName.text = fName;
		
		self.lastName.text = lName;
		
        
        
        if ([self.multipleEmailArray count] > 1){
            
            if ([self.multipleEmailArray count] > 4) {
                
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                for (int i = 0; i < 4 ; i++) {
                    [tmpArray addObject:[self.multipleEmailArray objectAtIndex:i]];
                }
                
                self.multipleEmailArray = [NSMutableArray arrayWithArray:tmpArray];
            }
            
            NSString *message = @"";
            if ([self.multipleEmailArray count] == 4) {
                message = @"Please Choose One.";
            }else{
                message = @"Please pick which email address you would like to use.";
            }
            
            self.multipleEmailAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Emails Found" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            
            for (int i = 0; i < [self.multipleEmailArray count]; i++) {
                
                NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multipleEmailArrayLabels objectAtIndex:i],
                                   [self.multipleEmailArray objectAtIndex:i]];
                [self.multipleEmailAlert addButtonWithTitle:title];
            }
            showEmail = true;
            
        }else{
            self.email.text = emailAddress;

        }
        
        if ([self.multiplePhoneArray count] > 1){
            
            if ([self.multiplePhoneArray count] > 4) {
                
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                for (int i = 0; i < 4 ; i++) {
                    [tmpArray addObject:[self.multiplePhoneArray objectAtIndex:i]];
                }
                
                self.multiplePhoneArray = [NSMutableArray arrayWithArray:tmpArray];
            }
            
            NSString *message = @"";
            if ([self.multiplePhoneArray count] == 4) {
                message = @"Please Choose One.";
            }else{
                message = @"Please pick which phone number you would like to use.";
            }
            
            self.multiplePhoneAlert = [[UIAlertView alloc] initWithTitle:@"Multiple Phone Numbers" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            
            for (int i = 0; i < [self.multiplePhoneArray count]; i++) {
                
                NSString *title = [NSString stringWithFormat:@"%@: %@", [self.multiplePhoneArrayLabels objectAtIndex:i],
                                   [self.multiplePhoneArray objectAtIndex:i]];
                [self.multiplePhoneAlert addButtonWithTitle:title];
            }
            showPhone = true;
            
            
        }else{
            self.phoneNumber.text = phoneString;
        }
        
        if (showEmail && showPhone) {
            self.twoAlerts = true;
            [self.multipleEmailAlert show];

        }else if (showEmail){
            [self.multipleEmailAlert show];

        }else if (showPhone){
            
            [self.multiplePhoneAlert show];
        }

		
		
	}



    [self dismissModalViewControllerAnimated:YES];
	
    return NO;
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.phoneNumber resignFirstResponder];
	[self.phoneText resignFirstResponder];
    
    [self.onePhone resignFirstResponder];
    [self.twoPhone resignFirstResponder];
}


- (void)autoFormatTextField:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.phoneNumber.text = [myPhoneNumberFormatter format:self.phoneNumber.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)autoFormatTextField1:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.phoneText.text = [myPhoneNumberFormatter format:self.phoneText.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)autoFormatTextField2:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.onePhone.text = [myPhoneNumberFormatter format:self.onePhone.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)autoFormatTextField3:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.twoPhone.text = [myPhoneNumberFormatter format:self.twoPhone.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

-(void)addMultipleMembers{
	
	self.addViewBackground.hidden = NO;
	self.submitButton.enabled = NO;
	self.isMiniAdd = true;
	
	
}

-(void)addNew{
    self.coordinatorSegment.selectedSegmentIndex = 1;
	self.miniErrorLabel.text = @"";
	
	self.miniBackgroundView.hidden = NO;
	self.saveButton.enabled = NO;
	self.closeButton.enabled = NO;
}

-(void)closeMultiple{
	
	self.addViewBackground.hidden = YES;
	//self.isMiniAdd = false;
	self.submitButton.enabled = YES;
	//self.emailArray = [NSMutableArray array];
	[self.myTableView reloadData];
	[self becomeFirstResponder];
	
}


-(void)saveMultiple{
	
	if ([self.emailArray count] == 0) {
		
		NSString *tmp = @"You must add at least one member to submit.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Members Added." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		
	}else {
		self.submitButton.enabled = YES;
		//self.addViewBackground.hidden = YES;
		//self.isMiniAdd = false;
		[self becomeFirstResponder];
		
		//Run a background thread to create the multiple members, then pop to the view
		
		[self.multipleActivity startAnimating];
		self.saveButton.enabled = NO;
		self.closeMultipleButton.enabled = NO;
		self.addNewButton.enabled = NO;
		self.addContactButton.enabled = NO;
		[self performSelectorInBackground:@selector(addMembers) withObject:nil];
	}

	
}


-(void)addMembers{

	//Create the new player
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *tmpMemberArray = [NSMutableArray array];
	NSArray *finalMemberArray = [NSArray array];
	
	for (int i = 0; i < [self.emailArray count]; i++) {
		
		NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
		
		NewMemberObject *tmpMember = [self.emailArray objectAtIndex:i];

		if ([tmpMember.email isEqualToString:@""] && ![tmpMember.phone isEqualToString:@""]) {
            [self.phoneOnlyArray addObject:tmpMember.phone];
        }
        
        if ([tmpMember.guardianTwoEmail isEqualToString:@""] && ![tmpMember.guardianOnePhone isEqualToString:@""]) {
            [self.phoneOnlyArray addObject:tmpMember.guardianOnePhone];
        }
        
        if ([tmpMember.guardianTwoEmail isEqualToString:@""] && ![tmpMember.guardianTwoPhone isEqualToString:@""]) {
            [self.phoneOnlyArray addObject:tmpMember.guardianTwoPhone];
        }
		
		
		if (![tmpMember.firstName isEqualToString:@""]) {
			[tmpDictionary setObject:tmpMember.firstName forKey:@"firstName"];
		}
		if (![tmpMember.lastName isEqualToString:@""]) {
			[tmpDictionary setObject:tmpMember.lastName forKey:@"lastName"];
		}
		if (![tmpMember.email isEqualToString:@""]) {
			[tmpDictionary setObject:tmpMember.email forKey:@"emailAddress"];
		}
		if (![tmpMember.phone isEqualToString:@""]) {
			[tmpDictionary setObject:tmpMember.phone forKey:@"phoneNumber"];
		}
		if (![tmpMember.role isEqualToString:@""]) {
			[tmpDictionary setObject:tmpMember.role forKey:@"participantRole"];
		}
        
        NSMutableArray *guardArray = [NSMutableArray array];

        if (![tmpMember.guardianOneName isEqualToString:@""]) {
            
            
            NSMutableDictionary *guard1 = [NSMutableDictionary dictionary];
            
            NSArray *nameArray = [tmpMember.guardianOneName componentsSeparatedByString:@" "];
            
            NSString *fName = [nameArray objectAtIndex:0];
            NSString *lName = @"";
            
            for (int i = 1; i < [nameArray count]; i++) {
                if (i == 1) {
                    lName = [lName stringByAppendingFormat:@"%@", [nameArray objectAtIndex:i]];
                }else{
                    lName = [lName stringByAppendingFormat:@" %@", [nameArray objectAtIndex:i]];

                }
            }
            
            if (![fName isEqualToString:@""]) {
                [guard1 setObject:fName forKey:@"firstName"];
            }
            if (![lName isEqualToString:@""]) {
                [guard1 setObject:lName forKey:@"lastName"];
            }
            if (![tmpMember.guardianOneEmail isEqualToString:@""]) {
                [guard1 setObject:tmpMember.guardianOneEmail forKey:@"emailAddress"];
            }
            if (![tmpMember.guardianOnePhone isEqualToString:@""]) {
                [guard1 setObject:tmpMember.guardianOnePhone forKey:@"phoneNumber"];
            }
            
            [guardArray addObject:guard1];
            
            if (![tmpMember.guardianTwoName isEqualToString:@""]) {
                
                
                NSMutableDictionary *guard2 = [NSMutableDictionary dictionary];
                
                NSArray *nameArray = [tmpMember.guardianTwoName componentsSeparatedByString:@" "];
                
                NSString *fName = [nameArray objectAtIndex:0];
                NSString *lName = @"";
                
                for (int i = 1; i < [nameArray count]; i++) {
                    if (i == 1) {
                        lName = [lName stringByAppendingFormat:@"%@", [nameArray objectAtIndex:i]];
                    }else{
                        lName = [lName stringByAppendingFormat:@" %@", [nameArray objectAtIndex:i]];
                        
                    }
                }
                
                if (![fName isEqualToString:@""]) {
                    [guard2 setObject:fName forKey:@"firstName"];
                }
                if (![lName isEqualToString:@""]) {
                    [guard2 setObject:lName forKey:@"lastName"];
                }
                if (![tmpMember.guardianTwoEmail isEqualToString:@""]) {
                    [guard2 setObject:tmpMember.guardianTwoEmail forKey:@"emailAddress"];
                }
                if (![tmpMember.guardianTwoPhone isEqualToString:@""]) {
                    [guard2 setObject:tmpMember.guardianTwoPhone forKey:@"phoneNumber"];
                }
                
                [guardArray addObject:guard2];
                
            }

        }
		
        if ([guardArray count] > 0) {
			[tmpDictionary setObject:guardArray forKey:@"guardians"];
		}
		
		[tmpMemberArray addObject:tmpDictionary];
		
	}
	
	finalMemberArray = tmpMemberArray;
	
	NSDictionary *response = [ServerAPI createMultipleMembers:mainDelegate.token :self.teamId :finalMemberArray];

	NSString *status = [response valueForKey:@"status"];
    
	if ([status isEqualToString:@"100"]) {
		
		self.errorString = @"";
	}else {
		//Server hit failed...get status code out and display error accordingly
		self.createSuccess = false;
		int statusCode = [status intValue];
		
		switch (statusCode) {
			case 0:
				//null parameter
				self.errorString = @"There was an error connecting to the server.";
				break;
			case 1:
				//error connecting to server
				self.errorString = @"There was an error connecting to the server.";
				break;
			case 223:
				self.errorString = @"NA";
				break;
			case 209:
				self.errorString = @"Member emails must be unique.";
				break;
            case 222:
				self.errorString = @"Member phone numbers must be unique.";
				break;
			case 219:
				self.errorString = @"A Guardian email address is already being used.";
				break;
            case 542:
				self.errorString = @"Invalid phone number entered.";
				break;
			default:
				//Log the status code?
				self.errorString = @"There was an error connecting to the server.";
				break;
		}
	}

	
	[self performSelectorOnMainThread:@selector(doneMembers) withObject:nil waitUntilDone:NO];
	
}


-(void)doneMembers{
	
	[self.multipleActivity stopAnimating];
	self.saveButton.enabled = YES;
	self.closeMultipleButton.enabled = YES;
	self.addNewButton.enabled = YES;
	self.addContactButton.enabled = YES;
	
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

	
	if ([self.errorString isEqualToString:@""]) {
		
		NSArray *tmpViews = [self.navigationController viewControllers];
		
		int theCount = [tmpViews count];
		theCount = theCount - 2;
        
		if (theCount >= 0) {
			if ([CurrentTeamTabs class] == [[tmpViews objectAtIndex:[tmpViews count] - 2] class]) {
				CurrentTeamTabs *tmpCont = [tmpViews objectAtIndex:[tmpViews count] - 2];
				tmpCont.selectedIndex = 2;
				
				Players *tmp = [[tmpCont viewControllers] objectAtIndex:2];
				tmp.phoneOnlyArray = self.phoneOnlyArray;
				[self.navigationController popToViewController:tmpCont animated:NO];
			}else{
				
				//Alert 'HOME' of the phone only array
				mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
				[self.navigationController dismissModalViewControllerAnimated:YES];
			}
			
		}else {
			
			mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
			[self.navigationController dismissModalViewControllerAnimated:YES];

		}

	}else {
		if ([self.errorString isEqualToString:@"NA"]) {
			//Alert
			NSString *tmp = @"Only User's with confirmed email addresses can add new team members.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
            
			NSString *tmp = self.errorString;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Members Failed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}
	}

}

-(void)miniAdd{
	
	self.miniErrorLabel.text = @"";
	
	if ([self.nameText.text isEqualToString:@""] && [self.emailText.text isEqualToString:@""] && [self.phoneText.text isEqualToString:@""]){
		
		self.miniErrorLabel.text = @"*You must fill out at least one field.";
	}else {
		
		self.miniBackgroundView.hidden = YES;
		self.saveButton.enabled = YES;
		self.closeButton.enabled = YES;
		
		NewMemberObject *tmp = [[NewMemberObject alloc] init];
		tmp.firstName = @"";
		tmp.lastName = @"";
		tmp.email = @"";
		tmp.phone = @"";
		tmp.role = @"";
        tmp.guardianOneName = @"";
        tmp.guardianOneEmail = @"";
        tmp.guardianOnePhone = @"";
        tmp.guardianTwoName = @"";
        tmp.guardianTwoEmail = @"";
        tmp.guardianTwoPhone = @"";
        
        if (self.coordinatorSegment.selectedSegmentIndex == 0) {
            tmp.role = @"coordinator";
        }else{
            tmp.role = @"";
        }
		
		if (![self.nameText.text isEqualToString:@""]) {
			NSArray *nameArray = [self.nameText.text componentsSeparatedByString:@" "];
			
			tmp.firstName = [nameArray objectAtIndex:0];
			
			for (int i = 1; i < [nameArray count]; i++) {
				
				if (i == 1) {
					tmp.lastName = [nameArray objectAtIndex:1];
				}else {
					tmp.lastName = [tmp.lastName stringByAppendingFormat:@" %@", [nameArray objectAtIndex:i]];
				}

			}
			
		}
		
		if (![self.emailText.text isEqualToString:@""]) {
			tmp.email = self.emailText.text;
		}
		
		if (![self.phoneText.text isEqualToString:@""]) {
			tmp.phone = self.phoneText.text;
		}
		
		[self.emailArray addObject:tmp];
		
		
		self.phoneText.text = @"";
		self.emailText.text = @"";
		self.nameText.text = @"";
		
		[self.myTableView reloadData];
	}

	
}

-(void)miniCancel{
	
	self.miniErrorLabel.text = @"";
	
	self.miniBackgroundView.hidden = YES;
	self.saveButton.enabled = YES;
	self.closeButton.enabled = YES;
	
	self.phoneText.text = @"";
	self.emailText.text = @"";
	self.nameText.text = @"";

	
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if ([self.emailArray count] == 0) {
		return 1;
	}
	return [self.emailArray count] * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	static NSString *EmptyCell=@"EmptyCell";
	static NSString *MemberCell=@"MemberCell";
    static NSString *GuardianCell=@"GuardianCell";

	
	static NSInteger dateTag = 1;
	
	bool isEmpty = false;
	if ([self.emailArray count] == 0) {
		isEmpty = true;
	}
    
    bool memberRow = true;
    if ((row % 2) == 0) {
        memberRow = true;
    }else{
        memberRow = false;
    }
	
	UITableViewCell *cell;
	
	if (isEmpty) {
		cell = [tableView dequeueReusableCellWithIdentifier:EmptyCell];
		
	}else {
        
        if (memberRow) {
            cell = [tableView dequeueReusableCellWithIdentifier:MemberCell];

        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:GuardianCell];

        }
		
	}
	
	
	if (cell == nil){
		CGRect frame;
		
		
		if (isEmpty) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCell];
			
		}else {
            
            if (memberRow) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MemberCell];
                
            }else{
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GuardianCell];
                
            }
			
			
		}
		
		
		frame.origin.x = 35;
		frame.origin.y = 5;
		frame.size.height = 20;
		frame.size.width = 215;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	
	
	if (isEmpty) {
		dateLabel.text = @"No members added...";
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.frame = CGRectMake(5, 5, 290, 20);
	}else{
        
        if (memberRow) {
            
            dateLabel.frame = CGRectMake(35, 5, 266, 20);
            
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(3, 3, 27, 27);
            deleteButton.tag = row/2;
            [deleteButton setImage:[UIImage imageNamed:@"redxsmall.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteButton];
            
            NewMemberObject *tmp = [self.emailArray objectAtIndex:row/2];
            
            dateLabel.textColor = [UIColor blackColor];
            dateLabel.textAlignment = UITextAlignmentLeft;
            dateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
            
            
            bool param = false;
            NSString *displayString = @"";
            
            if (![tmp.firstName isEqualToString:@""]) {
                displayString = [displayString stringByAppendingString:tmp.firstName];
                param = true;
            }
            
            if (![tmp.lastName isEqualToString:@""]) {
                displayString = [displayString stringByAppendingFormat:@" %@", tmp.lastName];
                param = true;
            }
            
            if (![tmp.email isEqualToString:@""]) {
                
                if (param) {
                    displayString = [displayString stringByAppendingFormat:@", %@", tmp.email];
                }else {
                    displayString = [displayString stringByAppendingFormat:@"%@", tmp.email];
                }
                
                param = true;
            }
            
            if (![tmp.phone isEqualToString:@""]) {
                
                if (param) {
                    displayString = [displayString stringByAppendingFormat:@", %@", tmp.phone];
                }else {
                    displayString = [displayString stringByAppendingFormat:@"%@", tmp.phone];
                }
                
            }
            
            dateLabel.text = displayString;
            
        }else{
            
            dateLabel.frame = CGRectMake(35, 5, 266, 20);

            NewMemberObject *tmpObject = [self.emailArray objectAtIndex:(row-1)/2];
            
            if ([tmpObject.guardianOneName isEqualToString:@""]){
                dateLabel.text = @"+ Add parent or guardian";
                dateLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
            }else{
                
                dateLabel.text =  @"- Change/Remove guardian info";
                dateLabel.textColor = [UIColor blueColor];
            }
            

        }
		
	}
	
	
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
	
}

-(void)deleteEvent:(id)sender{
	
	UIButton *tmpbutton = (UIButton *)sender;
	
	int cell = tmpbutton.tag;
	
	[self.emailArray removeObjectAtIndex:cell];
	
	[self.myTableView reloadData];
	
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if ([self.emailArray count] == 0) {
        self.miniErrorLabel.text = @"";
        
        self.miniBackgroundView.hidden = NO;
        self.saveButton.enabled = NO;
        self.closeButton.enabled = NO;
    }else{
        int row = [indexPath row];
        
        if ((row % 2) == 1) {
            self.guardianBackground.hidden = NO;
            self.currentGuardianSelection = row-1;
            self.miniGuardErrorLabel.text = @"";
            
            NewMemberObject *tmpMember = [self.emailArray objectAtIndex:self.currentGuardianSelection/2];
            
            self.oneEmail.text = tmpMember.guardianOneEmail;
            self.oneName.text = tmpMember.guardianOneName;
            self.onePhone.text = tmpMember.guardianOnePhone;
            
            self.twoEmail.text = tmpMember.guardianTwoEmail;
            self.twoName.text = tmpMember.guardianTwoName;
            self.twoPhone.text = tmpMember.guardianTwoPhone;
            
            if ([tmpMember.role isEqualToString:@"coordinator"]) {
                self.coordinatorSegment.selectedSegmentIndex = 0;
            }else{
                self.coordinatorSegment.selectedSegmentIndex = 1;
            }
            
            if (![self.oneName.text isEqualToString:@""]) {
                self.removeGuardiansButton.hidden = NO;
            }else{
                self.removeGuardiansButton.hidden = YES;
            }
            
        }

    }
    	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    
    if (alertView == self.multipleEmailAlert) {
        
        if (buttonIndex != 0){
                    
            self.email.text = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
        }else{
            self.email.text = @"";
        }
        
        if (self.twoAlerts) {
            [self.multiplePhoneAlert show];
        }
        
    }else if (alertView == self.multiplePhoneAlert) {
        
        if (buttonIndex != 0) {
                        
            self.phoneNumber.text = [self.multiplePhoneArray objectAtIndex:buttonIndex-1];
        }else{
            self.phoneNumber.text = @"";
        }
        
    }else if (alertView == self.miniMultipleEmailAlert){
        
        if (buttonIndex != 0) {
            
            self.tmpMiniEmail = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
            
            if (self.twoAlerts){
                [self.miniMultiplePhoneAlert show];
            }else{
                
                NewMemberObject *tmpObject = [[NewMemberObject alloc] init];
                tmpObject.firstName = @"";
                tmpObject.lastName = @"";
                tmpObject.email = @"";
                tmpObject.phone = @"";
                tmpObject.role = @"";
                tmpObject.guardianOneName = @"";
                tmpObject.guardianOneEmail = @"";
                tmpObject.guardianOnePhone = @"";
                tmpObject.guardianTwoName = @"";
                tmpObject.guardianTwoEmail = @"";
                tmpObject.guardianTwoPhone = @"";
                
                tmpObject.firstName = self.tmpMiniFirstName;
                tmpObject.lastName = self.tmpMiniLastName;
                tmpObject.email = self.tmpMiniEmail;
                tmpObject.phone = self.tmpMiniPhone;
                
                [self.emailArray addObject:tmpObject];
                
                [self.myTableView reloadData];
                
                

            }
                       
        }else{
            
            if (self.twoAlerts){
                [self.miniMultiplePhoneAlert show];
            }else{
                NewMemberObject *tmpObject = [[NewMemberObject alloc] init];
                tmpObject.firstName = @"";
                tmpObject.lastName = @"";
                tmpObject.email = @"";
                tmpObject.phone = @"";
                tmpObject.role = @"";
                tmpObject.guardianOneName = @"";
                tmpObject.guardianOneEmail = @"";
                tmpObject.guardianOnePhone = @"";
                tmpObject.guardianTwoName = @"";
                tmpObject.guardianTwoEmail = @"";
                tmpObject.guardianTwoPhone = @"";
                
                tmpObject.firstName = self.tmpMiniFirstName;
                tmpObject.lastName = self.tmpMiniLastName;
                tmpObject.email = self.tmpMiniEmail;
                tmpObject.phone = self.tmpMiniPhone;
                
                [self.emailArray addObject:tmpObject];
                
                [self.myTableView reloadData];
                
            }
            
        }
               
    }else if (alertView == self.miniMultiplePhoneAlert){
        
        if (buttonIndex != 0) {
            
            self.tmpMiniPhone = [self.multiplePhoneArray objectAtIndex:buttonIndex-1];
            
        }
            NewMemberObject *tmpObject = [[NewMemberObject alloc] init];
            tmpObject.firstName = @"";
            tmpObject.lastName = @"";
            tmpObject.email = @"";
            tmpObject.phone = @"";
            tmpObject.role = @"";
        tmpObject.guardianOneName = @"";
        tmpObject.guardianOneEmail = @"";
        tmpObject.guardianOnePhone = @"";
        tmpObject.guardianTwoName = @"";
        tmpObject.guardianTwoEmail = @"";
        tmpObject.guardianTwoPhone = @"";
            
            tmpObject.firstName = self.tmpMiniFirstName;
            tmpObject.lastName = self.tmpMiniLastName;
            tmpObject.email = self.tmpMiniEmail;
            tmpObject.phone = self.tmpMiniPhone;
            
            [self.emailArray addObject:tmpObject];
            
            [self.myTableView reloadData];
            

            
        
               
    }else if (alertView == self.guard1EmailAlert){
        
        if (buttonIndex != 0) {
            
            self.currentGuardEmail = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
            
            if (self.twoAlerts) {
                [self.guard1PhoneAlert show];
            }else{
                
                self.oneName.text = self.currentGuardName;
                self.oneEmail.text = self.currentGuardEmail;
                self.onePhone.text = self.currentGuardPhone;
                
            }
            
            
        }else{
            
            if (self.twoAlerts) {
                [self.guard1PhoneAlert show];
            }else{
                
                self.oneName.text = self.currentGuardName;
                self.oneEmail.text = self.currentGuardEmail;
                self.onePhone.text = self.currentGuardPhone;
            }
        }
        
        
        
    }else if (alertView == self.guard1PhoneAlert){
        
        if (buttonIndex != 0) {
            
            self.currentGuardPhone = [self.multiplePhoneArray objectAtIndex:buttonIndex-1];
        }
        
        
        self.oneName.text = self.currentGuardName;
        self.oneEmail.text = self.currentGuardEmail;
        self.onePhone.text = self.currentGuardPhone;
        
        
    }else if (alertView == self.guard2EmailAlert){
        
        if (buttonIndex != 0) {
            
            self.currentGuardEmail = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
            
            if (self.twoAlerts) {
                [self.guard2PhoneAlert show];
            }else{
                
                self.twoName.text = self.currentGuardName;
                self.twoEmail.text = self.currentGuardEmail;
                self.twoPhone.text = self.currentGuardPhone;
                
            }
            
            
        }else{
            
            if (self.twoAlerts) {
                [self.guard2PhoneAlert show];
            }else{
                
                self.twoName.text = self.currentGuardName;
                self.twoEmail.text = self.currentGuardEmail;
                self.twoPhone.text = self.currentGuardPhone;
            }
        }
        
        
        
    }else if (alertView == self.guard2PhoneAlert){
        
        if (buttonIndex != 0) {
            
            self.currentGuardPhone = [self.multiplePhoneArray objectAtIndex:buttonIndex-1];
        }
        
        
        self.twoName.text = self.currentGuardName;
        self.twoEmail.text = self.currentGuardEmail;
        self.twoPhone.text = self.currentGuardPhone;
        
        
    }

    
}


-(void)miniGuardAdd{
    
    if ([self.oneName.text isEqualToString:@""]) {
        self.miniGuardErrorLabel.text = @"*Guardian 1 name required.";
    }else if ([self.oneEmail.text isEqualToString:@""] && [self.onePhone.text isEqualToString:@""]){
        self.miniGuardErrorLabel.text = @"*Guardian 1 email or phone required.";
    }else if (![self.twoName.text isEqualToString:@""] || ![self.twoEmail.text isEqualToString:@""] || ![self.twoPhone.text isEqualToString:@""]){
        
        if ([self.twoName.text isEqualToString:@""]) {
            self.miniGuardErrorLabel.text = @"*Guardian 2 name required.";
        }else if ([self.oneEmail.text isEqualToString:@""] && [self.onePhone.text isEqualToString:@""]){
            self.miniGuardErrorLabel.text = @"*Guardian 2 email or phone required.";
        }else{
            
            NewMemberObject *tmpObject = [self.emailArray objectAtIndex:self.currentGuardianSelection/2];
            
            tmpObject.guardianOneName = self.oneName.text;
            tmpObject.guardianOneEmail = self.oneEmail.text;
            tmpObject.guardianOnePhone = self.onePhone.text;
            
            
            tmpObject.guardianTwoName = self.twoName.text;
            tmpObject.guardianTwoEmail = self.twoEmail.text;
            tmpObject.guardianTwoPhone = self.twoPhone.text;
            
            
            
            [self.emailArray replaceObjectAtIndex:self.currentGuardianSelection/2 withObject:tmpObject];
            self.guardianBackground.hidden = YES;

            [self.myTableView reloadData];
            
        }
    }else{
        
        //Add the guardian info to the new member object
        NewMemberObject *tmpObject = [self.emailArray objectAtIndex:self.currentGuardianSelection/2];
        
        tmpObject.guardianOneName = self.oneName.text;
        tmpObject.guardianOneEmail = self.oneEmail.text;
        tmpObject.guardianOnePhone = self.onePhone.text;
        
        [self.emailArray replaceObjectAtIndex:self.currentGuardianSelection/2 withObject:tmpObject];
        self.guardianBackground.hidden = YES;
        [self.myTableView reloadData];
    }
    
    
    
}

-(void)removeGuardians{
    
    NewMemberObject *tmpObject = [self.emailArray objectAtIndex:self.currentGuardianSelection/2];
    
    tmpObject.guardianOneName = @"";
    tmpObject.guardianOneEmail = @"";
    tmpObject.guardianOnePhone = @"";
    
    
    tmpObject.guardianTwoName = @"";
    tmpObject.guardianTwoEmail = @"";
    tmpObject.guardianTwoPhone = @"";
    
    
    
    [self.emailArray replaceObjectAtIndex:self.currentGuardianSelection/2 withObject:tmpObject];
    self.guardianBackground.hidden = YES;
    
    [self.myTableView reloadData];
    
}


-(void)miniGuardCancel{
    
    self.guardianBackground.hidden = YES;
}

-(NSString *)getType:(NSString *)typeLabel{
    
    if ([typeLabel isEqualToString:@"iPhone"]){
        return @"iPhone";
    }
    
    NSString *returnString = @"";
    
    NSArray *tmpArray = [typeLabel componentsSeparatedByString:@">"];
    
    NSString *tmpString = [tmpArray objectAtIndex:0];
    
    returnString = [tmpString substringFromIndex:4];
    
    return returnString;
    
}


-(void)viewDidUnload{
	myPhoneNumberFormatter =nil;

	barItem = nil;
	helpScreen = nil;
	firstName = nil;
	lastName = nil;
	email = nil;
	//guardianEmail = nil;
	//roles = nil;
	//teamId = nil;
	submitButton = nil;
	serverProcess = nil;
	error = nil;
	isCoordinator = nil;
	userRole = nil;
	closeButton = nil;
	sendEmailButton = nil;
	addParentGuardianButton = nil;
	/*
	guardianOneFirst = nil;
	guardianOneLast = nil;
	guardianOneEmail = nil;
	guardianTwoFirst = nil;
	guardianTwoLast = nil;
	guardianTwoEmail = nil;
	 */
	errorString = nil;
	//firstNamePicked = nil;
	//lastNamePicked = nil;
	addMultipleMembersButton = nil;
	phoneNumber = nil;
	addViewBackground = nil;
	addView = nil;
	
	closeMultipleButton = nil;
	saveButton = nil;
	
	addNewButton = nil;
	
	myTableView = nil;
	
	miniBackgroundView = nil;
	miniForeGroundView = nil;
	nameText = nil;
	emailText = nil;
	phoneText = nil;
	miniErrorLabel = nil;
	miniCancelButton = nil;
	miniAddButton = nil;
	multipleActivity = nil;
	addContactButton = nil;
    miniGuardAddButton = nil;
    miniGuardCancelButton = nil;
    guardianBackground = nil;
    onePhone = nil;
    oneName = nil;
    oneEmail = nil;
    twoName = nil;
    twoEmail = nil;
    twoPhone = nil;
    miniGuardErrorLabel = nil;
    removeGuardiansButton = nil;
    coordinatorSegment = nil;
	[super viewDidUnload];
}

@end
