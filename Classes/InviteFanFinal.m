//
//  InviteFanFinal.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InviteFanFinal.h"
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
#import "MyTeams.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation InviteFanFinal
@synthesize firstName, lastName, email, roles, teamId, submitButton, serverProcess, error, createSuccess, isCoordinator, 
helpScreen, barItem, userRole, closeButton, sendEmailButton, multipleActivity, errorString, firstNamePicked,
lastNamePicked, phoneNumber, addMultipleMembersButton, addViewBackground, addView, closeMultipleButton, saveButton, emailArray, addNewButton, myTableView,
miniBackgroundView, miniForeGroundView, nameText, emailText, phoneText, miniErrorLabel, miniCancelButton, miniAddButton, isMiniAdd, addContactButton,
phoneOnlyArray, multiplePhoneArray, multipleEmailArray, multiplePhoneAlert, multipleEmailAlert, tmpMiniEmail, tmpMiniPhone, miniMultiple,
tmpMiniFirstName, tmpMiniLastName, miniMultiplePhoneAlert, miniMultipleEmailAlert, twoAlerts, phoneTextAlert,
addContactWhere, multipleEmailArrayLabels, multiplePhoneArrayLabels, coordinatorSegment, teamName, theFirstName, theLastName, thePhoneNumber, theEmail;



-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}


- (void)viewDidLoad {
    
    self.isMiniAdd = true;
    
    
    NSString *ios = [[UIDevice currentDevice] systemVersion];
	if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
		
		self.myTableView.backgroundColor = [UIColor clearColor];
		self.myTableView.opaque = NO;
		self.myTableView.backgroundView = nil;
		
	}
    
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
	
	
	self.title=@"Invite Fan(s)";
	[self.helpScreen setHidden:YES];
	[self.helpScreen setContentSize:CGSizeMake(200, 600.0)];
	
	self.barItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
	//[self.navigationItem setRightBarButtonItem:self.barItem];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.closeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.sendEmailButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	[self.closeMultipleButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.saveButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniAddButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniCancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addNewButton setBackgroundImage:stretch forState:UIControlStateNormal];

    
    
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"greenButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.addMultipleMembersButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
    
    
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.addView.bounds;
	UIColor *color2 =  [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:0.9];
	UIColor *color1 =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:255/255.0 alpha:0.9];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	[self.addView.layer insertSublayer:gradient atIndex:0];
	
    
    
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
	
    [TraceSession addEventToSession:@"Invite Fan(s) Page - Invite Fan(s) Button Clicked"];

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
        [self.navigationItem setHidesBackButton:YES];
        [self.firstName setEnabled:NO];
        [self.lastName setEnabled:NO];
        [self.email setEnabled:NO];
        
        
        
        
        //Create the player in a background thread
        
        self.theFirstName = [NSString stringWithString:self.firstName.text];
        self.theLastName = [NSString stringWithString:self.lastName.text];
        self.thePhoneNumber = [NSString stringWithString:self.phoneNumber.text];
        self.theEmail = [NSString stringWithString:self.email.text];

        [self performSelectorInBackground:@selector(runRequest) withObject:nil];
        
	}
	
	
	
	
}

- (void)runRequest {

	@autoreleasepool {
        //Create the new player
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *tmpRoles = [[NSMutableArray alloc] init];
        //NSMutableArray *guardians = [[NSMutableArray alloc] init];
        
        NSString *role = @"fan";
        
        
        
        NSArray *guardianArray = [NSArray array];
        
        
        [tmpRoles addObject:role];
        
        NSArray *rRoles = tmpRoles;
        
        NSString *theRole = @"fan";
        
        NSString *phone = @"";
        
        if (![self.thePhoneNumber isEqualToString:@""]) {
            phone = self.thePhoneNumber;
        }
        
        if ([self.theEmail isEqualToString:@""] && ![self.thePhoneNumber isEqualToString:@""]) {
            
            
            [self.phoneOnlyArray addObject:self.thePhoneNumber];
            
        }
        
        
        
        NSDictionary *response = [ServerAPI createMember:self.theFirstName :self.theLastName :self.theEmail
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
				tmpCont.selectedIndex = 1;
				
				Players *tmp = [[tmpCont viewControllers] objectAtIndex:1];
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
			NSString *tmp = @"Only User's with confirmed email addresses can invite fans.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}else {
			self.error.text = self.errorString;
		}
        
		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.firstName setEnabled:YES];
		[self.lastName setEnabled:YES];
		[self.email setEnabled:YES];
        
	}
	
	
}


-(void)endText {
	
	[self becomeFirstResponder];
}

- (void)showPicker:(id)sender {
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"New Member(s) - Add From Contacts"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    self.multipleEmailArray = [NSMutableArray array];
    
    self.addContactWhere = @"member";
    
    
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
	
    @try {
        self.multiplePhoneArray = [NSMutableArray array];
        self.multipleEmailArray = [NSMutableArray array];
        self.multipleEmailArrayLabels = [NSMutableArray array];
        self.multiplePhoneArrayLabels = [NSMutableArray array];
        
        self.twoAlerts = false;
        
        self.tmpMiniEmail = @"";
        self.tmpMiniLastName = @"";
        self.tmpMiniPhone = @"";
        self.tmpMiniFirstName = @"";
        
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
                    
                }
                
                
            }
            
            
            
            if (isEmail && isPhone){
                
                self.twoAlerts = true;
                self.miniMultiple = @"both";
                //self.tmpMiniFirstName = fName;
                //self.tmpMiniLastName = lName;
                self.nameText.text = [NSString stringWithFormat:@"%@ %@", fName, lName];
                
                if ([self.addContactWhere isEqualToString:@"member"]){
                    
                    [self.miniMultipleEmailAlert show];
                    
                }
                
                
            }else if (isEmail){
                
                self.miniMultiple = @"email";
                
                /*
                 self.tmpMiniFirstName = fName;
                 self.tmpMiniLastName = lName;
                 self.tmpMiniPhone = phoneString;
                 */
                self.nameText.text = [NSString stringWithFormat:@"%@ %@", fName, lName];
                self.phoneText.text = phoneString;
                
                if ([self.addContactWhere isEqualToString:@"member"]){
                    
                    [self.miniMultipleEmailAlert show];
                    
                }
                
                
            }else if (isPhone){
                
                self.miniMultiple = @"phone";
                
                /*
                 self.tmpMiniFirstName = fName;
                 self.tmpMiniLastName = lName;
                 self.tmpMiniEmail = emailAddress;
                 */
                
                self.nameText.text = [NSString stringWithFormat:@"%@ %@", fName, lName];
                self.emailText.text = emailAddress;
                if ([self.addContactWhere isEqualToString:@"member"]){
                    
                    [self.miniMultiplePhoneAlert show];
                    
                }
                
                
                
            }else{
                
                self.nameText.text = [NSString stringWithFormat:@"%@ %@", fName, lName];
                self.emailText.text = emailAddress;
                self.phoneText.text = phoneString;
                
                
            }
            
            
        }

    }
    @catch (NSException *exception) {
        
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



-(void)addMultipleMembers{
	
	self.addViewBackground.hidden = NO;
	self.submitButton.enabled = NO;
	self.isMiniAdd = true;
	
	
}

-(void)addNew{
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"New Member(s) - Add NOT Contacts"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
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

	@autoreleasepool {
        //Create the new player
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *tmpMemberArray = [NSMutableArray array];
        NSArray *finalMemberArray = [NSArray array];
        self.phoneOnlyArray = [NSMutableArray array];
        
        for (int i = 0; i < [self.emailArray count]; i++) {
            
            NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
            
            NewMemberObject *tmpMember = [self.emailArray objectAtIndex:i];
            
            if ([tmpMember.email isEqualToString:@""] && ![tmpMember.phone isEqualToString:@""]) {
                [self.phoneOnlyArray addObject:tmpMember.phone];
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
                [tmpDictionary setObject:@"fan" forKey:@"participantRole"];
            }
            
       		
            [tmpMemberArray addObject:tmpDictionary];
            
        }
        
        finalMemberArray = tmpMemberArray;
        
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Invite Multiple Fans"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
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
				tmpCont.selectedIndex = 1;
				
				Players *tmp = [[tmpCont viewControllers] objectAtIndex:1];
				tmp.phoneOnlyArray = self.phoneOnlyArray;
				[self.navigationController popToViewController:tmpCont animated:NO];
			}else if ([MyTeams class] == [[tmpViews objectAtIndex:[tmpViews count] - 2] class]) {
		
                
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
                        NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Would you like to send them a text right now with information on how to sign up?";
                        self.phoneTextAlert = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
                        [self.phoneTextAlert show];
                    }else {
                        NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Please notify them that they must send the text 'yes' to 'join@rteam.com'.";
                        self.phoneTextAlert = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [self.phoneTextAlert show];
                    }
                    
                    
                    
                }else{
                    
                    NSString *tmp = @"Fan Invite Successful!";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }

			}else{
				
				//Alert 'HOME' of the phone only array
				mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
                mainDelegate.justAddName = self.teamName;
				[self.navigationController dismissModalViewControllerAnimated:YES];
			}
			
		}else {
			
			mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
            mainDelegate.justAddName = self.teamName;
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
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Fans Failed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}
	}
    
}

-(void)miniAdd{
	
	self.miniErrorLabel.text = @"";
	
	if ([self.emailText.text isEqualToString:@""] && [self.phoneText.text isEqualToString:@""]){
		
		self.miniErrorLabel.text = @"*You must fill out email address or phone number.";
        
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
	return [self.emailArray count];
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
	dateLabel.backgroundColor = [UIColor clearColor];
    
	if (isEmpty) {
		dateLabel.text = @"No fans added...";
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.frame = CGRectMake(5, 5, 290, 20);
	}else{
        
        if (memberRow) {
            
            dateLabel.frame = CGRectMake(35, 5, 266, 20);
            
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(3, 3, 27, 27);
            deleteButton.tag = row;
            [deleteButton setImage:[UIImage imageNamed:@"redxsmall.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteButton];
            
            NewMemberObject *tmp = [self.emailArray objectAtIndex:row];
            
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
        
                
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
   if (alertView == self.miniMultipleEmailAlert){
        
        if (buttonIndex != 0) {
            
            self.emailText.text = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
            
            if (self.twoAlerts){
                [self.miniMultiplePhoneAlert show];
            }else{
                
            }
            
        }else{
            
            if (self.twoAlerts){
                [self.miniMultiplePhoneAlert show];
            }else{
                
            }
            
        }
        
    }else if (alertView == self.miniMultiplePhoneAlert){
        
        if (buttonIndex != 0) {
            
            self.phoneText.text = [self.multiplePhoneArray objectAtIndex:buttonIndex-1];
            
        }
        
        
    }else if (alertView == self.phoneTextAlert){
        
        if(buttonIndex == 1){
            
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
	
	NSString *displayString = @"";
	BOOL success = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			displayString = @"";
			break;
		case MessageComposeResultSent:
			displayString = @"Text sent successfully!";
            self.error.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
			success = YES;
			break;
		case MessageComposeResultFailed:
			displayString = @"Text send failed.";
            self.error.textColor = [UIColor redColor];

			break;
		default:
			displayString = @"Text send failed.";
            self.error.textColor = [UIColor redColor];
			break;
	}
	
    self.error.text = displayString;
	[self dismissModalViewControllerAnimated:YES];
	
    NSString *tmp = displayString;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Text Status." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
	
	
	
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

	submitButton = nil;
	serverProcess = nil;
	error = nil;
	isCoordinator = nil;
	userRole = nil;
	closeButton = nil;
	sendEmailButton = nil;
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

    coordinatorSegment = nil;
	[super viewDidUnload];
}


@end