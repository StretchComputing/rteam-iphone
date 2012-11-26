//
//  AddGuardian.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddGuardian.h"
#import "NewPlayer.h"
#import "FastActionSheet.h"
#import "TraceSession.h"

@implementation AddGuardian
@synthesize oneFirstName, oneLastName, oneEmail, twoFirstName, twoLastName, twoEmail, errorLabel, saveButton, guardianOneFirst, 
guardianOneLast, guardianOneEmail, guardianTwoFirst, guardianTwoLast, guardianTwoEmail, onePhone, twoPhone, guardianOnePhone, guardianTwoPhone,
removeGuardians, addContactGuard1, twoAlerts, multipleEmailArray, multiplePhoneArray, currentGuardEmail, currentGuardPhone, currentGuardLastName, currentGuardFirstName, multipleEmailAlert, multiplePhoneAlert, multipleEmailArrayLabels, multiplePhoneArrayLabels;

-(void)viewWillAppear:(BOOL)animated{
    
    self.errorLabel.text = @"";

    [TraceSession addEventToSession:@"AddGuardian - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
    
    [self becomeFirstResponder];
}

-(void)viewDidLoad{
    
    self.oneFirstName.text = self.guardianOneFirst;
	self.oneLastName.text = self.guardianOneLast;
	self.oneEmail.text = self.guardianOneEmail;
	self.twoFirstName.text = self.guardianTwoFirst;
	self.twoLastName.text = self.guardianTwoLast;
	self.twoEmail.text = self.guardianTwoEmail;
    self.onePhone.text = self.guardianOnePhone;
    self.twoPhone.text = self.guardianTwoPhone;
    
    if (![self.oneFirstName.text isEqualToString:@""]) {
        self.removeGuardians.hidden = NO;
    }else{
        self.removeGuardians.hidden = YES;
    }
    
    myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    
	myTextFieldSemaphore1 = 0;
    myTextFieldSemaphore2 = 0;
    
	[self.onePhone addTarget:self
                      action:@selector(autoFormatTextField1:)
            forControlEvents:UIControlEventEditingChanged
	 ];
    [self.twoPhone addTarget:self
                      action:@selector(autoFormatTextField2:)
            forControlEvents:UIControlEventEditingChanged
	 ];
    
    self.title = @"Add Guardian(s)";
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.saveButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.removeGuardians setBackgroundImage:stretch1 forState:UIControlStateNormal];
    
}


-(void)save{
	self.errorLabel.text = @"";
    
    
    
    if ([self.oneLastName.text isEqualToString:@""] || [self.oneFirstName.text isEqualToString:@""]) {
        self.errorLabel.text = @"*Please fill out the entire name for Guardian 1.";
    }else if ([self.onePhone.text isEqualToString:@""] && [self.oneEmail.text isEqualToString:@""]){
        self.errorLabel.text = @"*Email Address or Phone Number required for Guardian 1.";
    }else if (![self.twoFirstName.text isEqualToString:@""] || ![self.twoLastName.text isEqualToString:@""] ||
              ![self.twoEmail.text isEqualToString:@""] || ![self.twoFirstName.text isEqualToString:@""]){
        
        if ([self.twoLastName.text isEqualToString:@""] || [self.twoFirstName.text isEqualToString:@""]) {
            self.errorLabel.text = @"*Please fill out the entire name for Guardian 2.";
        }else if ([self.twoPhone.text isEqualToString:@""] && [self.twoEmail.text isEqualToString:@""]){
            self.errorLabel.text = @"*Email Address or Phone Number required for Guardian 2.";
        }else{
            
            NSArray *temp = [self.navigationController viewControllers];
            int num = [temp count];
            num = num - 2;
            
            if ([temp[num] class] == [NewPlayer class]) {
                //
                NewPlayer *newPlayer = temp[num];
                newPlayer.useGuardians = true;
                newPlayer.guardianOneFirst = self.oneFirstName.text;
                newPlayer.guardianOneLast = self.oneLastName.text;
                newPlayer.guardianOneEmail = self.oneEmail.text;
                newPlayer.guardianOnePhone = self.onePhone.text;
                
                if (![self.twoFirstName.text isEqualToString:@""]) {
                    newPlayer.guardianTwoFirst = self.twoFirstName.text;
                    newPlayer.guardianTwoLast = self.twoLastName.text;
                    newPlayer.guardianTwoEmail = self.twoEmail.text;
                    newPlayer.guardianTwoPhone = self.twoPhone.text;
                    
                }
                
                
                [self.navigationController popToViewController:newPlayer animated:YES];
            }else {
                self.errorLabel.text = @"*Error connecting to server.";
            }
            
            
        }
        
        
        
    }else {
		
        NSArray *temp = [self.navigationController viewControllers];
        int num = [temp count];
        num = num - 2;
        
        if ([temp[num] class] == [NewPlayer class]) {
            //
            NewPlayer *newPlayer = temp[num];
            newPlayer.useGuardians = true;
            newPlayer.guardianOneFirst = self.oneFirstName.text;
            newPlayer.guardianOneLast = self.oneLastName.text;
            newPlayer.guardianOneEmail = self.oneEmail.text;
            newPlayer.guardianOnePhone = self.onePhone.text;
            
            if (![self.twoFirstName.text isEqualToString:@""]) {
                newPlayer.guardianTwoFirst = self.twoFirstName.text;
                newPlayer.guardianTwoLast = self.twoLastName.text;
                newPlayer.guardianTwoEmail = self.twoEmail.text;
                newPlayer.guardianTwoPhone = self.twoPhone.text;
                
            }
            [self.navigationController popToViewController:newPlayer animated:YES];
        }else {
            self.errorLabel.text = @"*Error connecting to server.";
        }
        
        
        
        
        
        
	}
}

- (void)autoFormatTextField1:(id)sender {
	if(myTextFieldSemaphore1) return;
	
	myTextFieldSemaphore1 = 1;
	NSString *myLocale;
	self.onePhone.text = [myPhoneNumberFormatter format:self.onePhone.text withLocale:myLocale];
	myTextFieldSemaphore1 = 0;
}

- (void)autoFormatTextField2:(id)sender {
	if(myTextFieldSemaphore2) return;
	
	myTextFieldSemaphore2 = 1;
	NSString *myLocale;
	self.twoPhone.text = [myPhoneNumberFormatter format:self.twoPhone.text withLocale:myLocale];
	myTextFieldSemaphore2 = 0;
}

-(void)endText{
    [self becomeFirstResponder];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == self.multipleEmailAlert) {
        
        if (buttonIndex != 0){
            if (self.addContactGuard1) {
                self.oneEmail.text = (self.multipleEmailArray)[buttonIndex-1];
                
            }else{
                self.twoEmail.text = (self.multipleEmailArray)[buttonIndex-1];
                
            }
        }else{
            
            if (addContactGuard1){
                self.oneEmail.text = @"";
                
            }else{
                self.twoEmail.text = @"";
                
            }
        }
        
        if (self.twoAlerts) {
            [self.multiplePhoneAlert show];
        }
        
    }else if (alertView == self.multiplePhoneAlert) {
        
        if (buttonIndex != 0) {
            
            if (self.addContactGuard1){
                self.onePhone.text = (self.multiplePhoneArray)[buttonIndex-1];
            }else{
                self.twoPhone.text = (self.multiplePhoneArray)[buttonIndex-1];
                
            }
        }else{
            if (self.addContactGuard1){
                self.onePhone.text = @"";
            }else{
                self.twoPhone.text = @"";
                
            }
        }
        
    }    
    
}


- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.onePhone resignFirstResponder];
	[self.twoPhone resignFirstResponder];
}

-(void)removeGuard{
    
    NSArray *temp = [self.navigationController viewControllers];
    int num = [temp count];
    num = num - 2;
    
    if ([temp[num] class] == [NewPlayer class]) {
        //
        NewPlayer *newPlayer = temp[num];
        newPlayer.useGuardians = false;
        newPlayer.guardianOneFirst = @"";
        newPlayer.guardianOneLast = @"";
        newPlayer.guardianOneEmail = @"";
        newPlayer.guardianOnePhone = @"";
        
        newPlayer.guardianTwoFirst = @"";
        newPlayer.guardianTwoLast = @"";
        newPlayer.guardianTwoEmail = @"";
        newPlayer.guardianTwoPhone = @"";
        
        
        
        [self.navigationController popToViewController:newPlayer animated:YES];
    }
    
    
}

- (void)showPicker:(id)sender {
    
    UIButton *tmpButton = (UIButton *)sender;
    
    if (tmpButton.tag == 1) {
        //New Member
        addContactGuard1 = true;
    }else{
        addContactGuard1 = false;
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
    
    self.currentGuardFirstName = @"";
    self.currentGuardLastName = @"";
    self.currentGuardEmail = @"";
    self.currentGuardPhone = @"";
    
    NSString *fName = @"";
    @try {
        fName = (__bridge NSString *)ABRecordCopyValue(person,
                                                       kABPersonFirstNameProperty);
    }
    @catch (NSException *exception) {
        
    }
    
    NSString *lName = @"";
    
    @try {
        lName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
    }
    @catch (NSException *exception) {
        
    }
    
    NSString *emailAddress = @"";
    
    @try {
        ABMultiValueRef emails = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
        
        NSArray *emailArray1 = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emails);
        
        if ([emailArray1 count] > 0) {
            emailAddress = emailArray1[0];
            self.multipleEmailArray = [NSMutableArray arrayWithArray:emailArray1];
            
            int countHere = ABMultiValueGetCount(emails);
            
            for(int i = 0; i < countHere; i++)
            {
                @try {
                    NSString *test = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(emails, i);
                    
                    NSString *final = [self getType:test];
                    
                    [self.multipleEmailArrayLabels addObject:final];
                }
                @catch (NSException *exception) {
                    [self.multipleEmailArrayLabels addObject:@""];
                }
                
                
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        self.multipleEmailArray = [NSMutableArray array];
        self.multipleEmailArrayLabels = [NSMutableArray array];
        
    }
    
    
    NSString *phoneString = @"";
    
    @try {
        ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phone);
        if ([phoneArray count] > 0) {
            phoneString = phoneArray[0];
            self.multiplePhoneArray = [NSMutableArray arrayWithArray:phoneArray];
            
            for(int i = 0; i < ABMultiValueGetCount(phone); i++)
            {
                
                @try {
                    NSString *test = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phone, i);
                    
                    NSString *final = [self getType:test];
                    
                    [self.multiplePhoneArrayLabels addObject:final];
                }
                @catch (NSException *exception) {
                    [self.multiplePhoneArrayLabels addObject:@""];
                }
                
            }
        }
        
    }
    @catch (NSException *exception) {
        self.multiplePhoneArray = [NSMutableArray array];
        self.multiplePhoneArrayLabels = [NSMutableArray array];
        
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
    
    self.currentGuardFirstName = fName;
    self.currentGuardLastName = lName;
    
    if (self.addContactGuard1) {
        self.oneFirstName.text = fName;
        self.oneLastName.text = lName;
    }else{
        self.twoFirstName.text = fName;
        self.twoLastName.text = lName;
    }
    
    bool showEmail = false;
    bool showPhone = false;
    
    
    if ([self.multipleEmailArray count] > 1){
        
        if ([self.multipleEmailArray count] > 4) {
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            for (int i = 0; i < 4 ; i++) {
                [tmpArray addObject:(self.multipleEmailArray)[i]];
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
            
            NSString *title = [NSString stringWithFormat:@"%@: %@", (self.multipleEmailArrayLabels)[i],
                               (self.multipleEmailArray)[i]];
            [self.multipleEmailAlert addButtonWithTitle:title];
        }
        showEmail = true;
        
    }else{
        if (self.addContactGuard1) {
            self.oneEmail.text = emailAddress;
        }else{
            self.twoEmail.text = emailAddress;
        }
        
    }
    
    if ([self.multiplePhoneArray count] > 1){
        
        if ([self.multiplePhoneArray count] > 4) {
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            for (int i = 0; i < 4 ; i++) {
                [tmpArray addObject:(self.multiplePhoneArray)[i]];
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
            
            NSString *title = [NSString stringWithFormat:@"%@: %@", (self.multiplePhoneArrayLabels)[i],
                               (self.multiplePhoneArray)[i]];
            [self.multiplePhoneAlert addButtonWithTitle:title];
        }
        showPhone = true;
        
        
    }else{
        if (self.addContactGuard1) {
            self.onePhone.text = phoneString;
        }else{
            self.twoPhone.text = phoneString;
        }
    }
    
    if (showEmail && showPhone) {
        self.twoAlerts = true;
        [self.multipleEmailAlert show];
        
    }else if (showEmail){
        [self.multipleEmailAlert show];
        
    }else if (showPhone){
        
        [self.multiplePhoneAlert show];
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

-(NSString *)getType:(NSString *)typeLabel{
    
    if ([typeLabel isEqualToString:@"iPhone"]){
        return @"iPhone";
    }
    
    NSString *returnString = @"";
    
    NSArray *tmpArray = [typeLabel componentsSeparatedByString:@">"];
    
    NSString *tmpString = tmpArray[0];
    
    returnString = [tmpString substringFromIndex:4];
    
    return returnString;
    
}

-(void)viewDidUnload{
	
	oneFirstName = nil;
	oneLastName = nil;
	oneEmail = nil;
	twoEmail = nil;
	twoFirstName = nil;
	twoLastName = nil;
	errorLabel = nil;
	saveButton = nil;
    onePhone = nil;
    twoPhone = nil;
    removeGuardians = nil;
    
	[super viewDidUnload];
}

@end
