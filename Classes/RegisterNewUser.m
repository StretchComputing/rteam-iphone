//
//  RegisterNewUser.m
//  rTeam
//
//  Created by Nick Wroblewski on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//
//  CoachRegister.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RegisterNewUser.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "rTeamAppDelegate.h"
#import "Home.h"
#import "SettingsTabs.h"
#import "MobileCarrier.h"
#import "ValidatePhoneCarrier.h"
#import "GANTracker.h"
#import "TraceSession.h"


@implementation RegisterNewUser
@synthesize email, password, firstName, lastName, error, registering, submitButton, createSuccess, firstString, lastString, errorString,
locationManager, updateLat, updateLong, phoneText, carrierText, carrierLabel, carrierPicker, carrierExplain, phoneExplain, carriers, selectedCarrier,
selectCarrierButton, carrierCode, sendingText, tryAgainText, didGetCarrierList, hardCarriers, usingHardCarriers, locationString, theFirstName, theLastName, thePhoneNumber;

-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"RegisterNewUser - View Will Appear"];

}

- (void)viewDidLoad {
    
    [self buildTempArray];
    self.locationString = @"";
    self.usingHardCarriers = false;
    self.didGetCarrierList = false;
	self.title = @"Register";
    
    self.carriers = [NSArray array];
    
    [self performSelectorInBackground:@selector(getCarriers) withObject:nil];
    
    self.carrierPicker.hidden = YES;
    self.selectCarrierButton.hidden = YES;
    self.carrierPicker.delegate = self;
    
	self.carrierText.hidden = YES;
    self.carrierLabel.hidden = YES;
    self.carrierExplain.hidden = YES;
    self.phoneExplain.hidden = NO;
    
	self.firstName.text = self.firstString;
	self.lastName.text = self.lastString;
    
    //self.carrierPicker.dataSource = self;
	//UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
	//[self.navigationItem setRightBarButtonItem:about];
	//[about release];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.selectCarrierButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.updateLat = @"";
	self.updateLong = @"";
	
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	[locationManager startUpdatingLocation];
    
    myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
    
	myTextFieldSemaphore = 0;
	[self.phoneText addTarget:self
                         action:@selector(autoFormatTextField:)
               forControlEvents:UIControlEventEditingChanged
	 ];
	
}




-(void)endText {
	
	
	
}

-(void)submit{
	
    [TraceSession addEventToSession:@"Register 2 Page - Register Button Clicked"];

    
	self.error.text = @"";
    
    if (self.firstName.text == nil){
        self.firstName.text = @"";
    }
    if (self.lastName.text == nil){
        self.lastName.text = @"";
    }
    if (self.phoneText.text == nil){
        self.phoneText.text = @"";
    }
    if (self.carrierText.text == nil){
        self.carrierText.text = @"";
    }
	//Validate all fields are entered:
	if (([self.firstName.text  isEqualToString:@""]) ||
		([self.lastName.text  isEqualToString:@""])){
		self.error.text = @"*You must enter your name.";	
	}else if (![self.phoneText.text isEqualToString:@""] && [self.carrierText.text isEqualToString:@""]){
    
        self.error.text = @"*Phone carrier is required with phone number.";
    }else{
		
		[registering startAnimating];
		
		//Disable the UI buttons and textfields while registering
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.firstName setEnabled:NO];
		[self.lastName setEnabled:NO];
		
		
		//Register the User in a background thread
		
        
        self.theLastName = self.lastName.text;
        self.theFirstName = self.firstName.text;
        self.thePhoneNumber = self.phoneText.text;
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
		
	}
}


- (void)runRequest {

    @autoreleasepool {
        NSDictionary *response = [ServerAPI createUser:self.theFirstName
                                                      :self.theLastName
                                                      :self.email
                                                      :self.password
                                                      :@"" :self.updateLat :self.updateLong :self.thePhoneNumber :self.carrierCode :self.locationString];
    

        NSString *status = [response valueForKey:@"status"];
                
        if ([status isEqualToString:@"100"]){
            
            NSString *token = [response valueForKey:@"token"];
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            mainDelegate.token = token;
            mainDelegate.quickLinkOne = @"";
            mainDelegate.quickLinkTwo = @"";
            mainDelegate.quickLinkOneName = @"";
            mainDelegate.quickLinkTwoName = @"";
            mainDelegate.quickLinkOneImage = @"";
            mainDelegate.quickLinkTwoImage = @"";
            
            if (([response valueForKey:@"teamId"] != nil) && ([[response valueForKey:@"teamId"] length] > 0)) {
                mainDelegate.quickLinkOne = [response valueForKey:@"teamId"];
                
                
                mainDelegate.quickLinkOneName = @"Team 1";
                mainDelegate.quickLinkOneImage = [@"Basketball" lowercaseString];
            }
            
            [mainDelegate saveUserInfo];
            
            self.createSuccess = true;
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            self.createSuccess = false;
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 1:
                    //error connecting to server
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 201:
                    //email address already in use
                    self.errorString = @"*Email address is already in use.";
                    break;
                case 300:
                    //first and last names required
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 303:
                    //email address and password required
                    self.errorString = @"*Email address and password required.";
                    break;
                case 518:
                    //invalid already member parameter
                    self.errorString = @"*Error connecting to server.";
                    break;
                case 542:
                    //invalid already member parameter
                    self.errorString = @"*Invalid phone number.";
                    break;
                default:
                    //should never get here
                    self.errorString = @"*Error connecting to server.";
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
	[registering stopAnimating];
	
    [submitButton setEnabled:YES];
    [self.navigationItem setHidesBackButton:NO];
    [self.firstName setEnabled:YES];
    [self.lastName setEnabled:YES];
    
	if (self.createSuccess){
		
        if (![self.phoneText.text isEqualToString:@""]) {
            
            if ([self.carrierText.text isEqualToString:@"I don't know."]) {
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"User Registered - With Phone Number, Unknown Carrier"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                NSString *ios = [[UIDevice currentDevice] systemVersion];
                
                bool canText = false;
                if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                    
                    if ([MFMessageComposeViewController canSendText]) {
                        
                        canText = true;
                        
                    }
                }else { 
                    canText = false;
                }

                
                if (canText) {
                    
                    self.sendingText = true;
                    NSString *message = @"To validate your phone number, we need you to send a text to us from your phone.  Press 'Ok' to send the text now.";
                    UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Confirm Phone" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [tmp show];
                    
                }else{
                    self.sendingText = false;
                    NSString *message = @"To validate your phone number, we need you to send a text message (not an email) to 'join@rTeam.com', with the message 'yes'.  Please send this text from the device you entered the phone number for.  You can send the text at any time.";
                    UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Confirm Phone" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [tmp show];
                    
                    
                }
            }else{
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"User Registerd - With Phone Number"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                
                ValidatePhoneCarrier *tmp = [[ValidatePhoneCarrier alloc]  init];
                tmp.phoneNumber = self.phoneText.text;
                
                if (self.usingHardCarriers) {
                    tmp.carriers = [NSArray arrayWithArray:self.hardCarriers];

                }else{
                    tmp.carriers = [NSArray arrayWithArray:self.carriers];
                }
                tmp.carrierCode = self.carrierCode;
                
                [self.navigationController pushViewController:tmp animated:YES];
            }
            
        }else{
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                 action:@"User Registered - No Phone Number"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:nil]) {
            }
            
            SettingsTabs *nextController = [[SettingsTabs alloc] init];
            nextController.fromRegisterFlow = @"true";
            nextController.didRegister = @"true";
            [self.navigationController  pushViewController:nextController animated:NO];
            
        }
		
	}else {
		//if it failed, re-enable all fields so user can make changes
		
		self.error.text = self.errorString;
	
		
	}
	
}


- (void)locationManager: (CLLocationManager *)manager
	didUpdateToLocation: (CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	
	double degrees = newLocation.coordinate.latitude;
	NSString *currentLat = [NSString stringWithFormat:@"%f", degrees];
	degrees = newLocation.coordinate.longitude;
	NSString *currentLongt = [NSString stringWithFormat:@"%f", degrees];
	
	
	self.updateLat = currentLat;
	self.updateLong = currentLongt;
	
    float lat = [self.updateLat floatValue];
    float lon = [self.updateLong floatValue];
    
    CLLocationCoordinate2D coord;
    coord.longitude = lon;
    coord.latitude = lat;
    
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coord];
    [geocoder setDelegate:self];
    [geocoder start];
	
}
- (void)locationManager: (CLLocationManager *)manager
	   didFailWithError: (NSError *)error
{
	
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{        
    NSString *city = [[placemark addressDictionary] valueForKey:@"City"];
    NSString *state = [[placemark addressDictionary] valueForKey:@"State"];
    
    self.locationString = [NSString stringWithFormat:@"%@,%@", city, state];
    
    if (self.locationString == nil) {
        self.locationString = @"";
    }

}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.phoneText resignFirstResponder];
    self.carrierPicker.hidden=YES;
    self.selectCarrierButton.hidden = YES;

}

-(void)carrierBeginCheat{
    
    [self.phoneText resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
   
    
    if (self.didGetCarrierList) {
        self.carrierPicker.hidden = NO;
        self.selectCarrierButton.hidden = NO;
    }else{
        
        self.usingHardCarriers = true;
        [self.carrierPicker reloadAllComponents];
        self.carrierPicker.hidden = NO;
        self.selectCarrierButton.hidden = NO;
    }
    
}

-(void)carrierBegin{

   // [self.carrierText resignFirstResponder];
    self.carrierPicker.hidden = NO;
    self.selectCarrierButton.hidden = NO;

}

- (void)autoFormatTextField:(id)sender {
    
    if ((self.phoneText.text == nil) || [self.phoneText.text isEqualToString:@""]) {
        self.carrierText.hidden = YES;
        self.carrierLabel.hidden = YES;
        self.carrierExplain.hidden = YES;
        self.phoneExplain.hidden = NO;
    }else{
        self.carrierText.hidden = NO;
        self.carrierLabel.hidden = NO;
        self.carrierExplain.hidden = NO;
        self.phoneExplain.hidden = YES;
    }
        
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.phoneText.text = [myPhoneNumberFormatter format:self.phoneText.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

-(void)carrierEditBegin{
    
    if (self.didGetCarrierList) {
        self.carrierPicker.hidden = NO;
        self.selectCarrierButton.hidden = NO;
    }else{
        
        self.usingHardCarriers = true;
        [self.carrierPicker reloadAllComponents];
        self.carrierPicker.hidden = NO;
        self.selectCarrierButton.hidden = NO;
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
	
    if (self.usingHardCarriers) {
        return [self.hardCarriers count] + 1;
    }
	return [self.carriers count] + 1;
}


-(NSString *)pickerView:(UIPickerView *)pickerView
			titleForRow:(NSInteger)row
		   forComponent:(NSInteger)component 
{
    
    if (row == 0) {
        return @"I don't know.";
    }else{
        if (self.usingHardCarriers) {
            MobileCarrier *tmpCarrier = [self.hardCarriers objectAtIndex:row-1];
            return tmpCarrier.name;
        }else{
            MobileCarrier *tmpCarrier = [self.carriers objectAtIndex:row-1];
            return tmpCarrier.name;
        }
       
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (row == 0) {
        self.selectedCarrier = @"I don't know.";
        self.carrierCode = @"";
    }else{
        
        if (self.usingHardCarriers) {
            MobileCarrier *tmpCarrier = [self.hardCarriers objectAtIndex:row-1];
            self.selectedCarrier = tmpCarrier.name;
            self.carrierCode = tmpCarrier.code;
        }else{
            MobileCarrier *tmpCarrier = [self.carriers objectAtIndex:row-1];
            self.selectedCarrier = tmpCarrier.name;
            self.carrierCode = tmpCarrier.code;
        }
        
    }
    
	
}

-(void)selectCarrier{
    
    if ((self.selectedCarrier == nil) || [self.selectedCarrier isEqualToString:@""]) {
        self.selectedCarrier = @"I don't know.";
    }else{
        self.carrierText.text = self.selectedCarrier;
    }
    self.carrierPicker.hidden = YES;
    self.selectCarrierButton.hidden = YES;

}

-(void)getCarriers{

    @autoreleasepool {
        NSDictionary *response = [ServerAPI getMobileCarrierList];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            self.didGetCarrierList = true;
            self.carriers = [response valueForKey:@"mobileCarriers"];
            
            self.selectedCarrier = @"I don't know.";
            self.carrierCode = @"";
            
            
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
                default:
                    //should never get here
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:@selector(doneCarriers) withObject:nil waitUntilDone:NO];

    }
    
}

-(void)doneCarriers{
    [self.carrierPicker reloadAllComponents];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (self.tryAgainText){
        self.tryAgainText = false;
        
        if (buttonIndex == 0) {
            
            MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
            messageViewController.messageComposeDelegate = self;
            NSArray *numbersToCall = [NSArray arrayWithObject:@"join@rteam.com"];
            [messageViewController setRecipients:numbersToCall];
            
            NSString *bodyMessage = @"yes";
            [messageViewController setBody:bodyMessage];
            [self presentModalViewController:messageViewController animated:YES];
            
        }else{
            
            SettingsTabs *nextController = [[SettingsTabs alloc] init];
            nextController.fromRegisterFlow = @"true";
            nextController.didRegister = @"true";
            [self.navigationController  pushViewController:nextController animated:NO];
            
        }
        
        
    }else{
        if (self.sendingText){
            
            NSString *ios = [[UIDevice currentDevice] systemVersion];

            if ((![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"])) {
                
                MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
                messageViewController.messageComposeDelegate = self;
                NSArray *numbersToCall = [NSArray arrayWithObject:@"join@rteam.com"];
                [messageViewController setRecipients:numbersToCall];
                
                NSString *bodyMessage = @"yes";
                [messageViewController setBody:bodyMessage];
                [self presentModalViewController:messageViewController animated:YES];
                
            }else { 
                
                NSString *url = [@"sms://" stringByAppendingString:@"join@rteam.com"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
                
            }
            
          
            
        }else{
            
            SettingsTabs *nextController = [[SettingsTabs alloc] init];
            nextController.fromRegisterFlow = @"true";
            nextController.didRegister = @"true";
            [self.navigationController  pushViewController:nextController animated:NO];
            
        }

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
    
    if (success) {
        
        SettingsTabs *nextController = [[SettingsTabs alloc] init];
        nextController.fromRegisterFlow = @"true";
        nextController.didRegister = @"true";
        [self.navigationController  pushViewController:nextController animated:NO];
        
    }else{
        
        self.tryAgainText = true;
        NSString *message = @"The text message was not sent.  To validate your phone number, you must send this text message.  You can try again, or finish registering without your phone number.";
        UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Text Not Sent" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Try Again", @"Continue", nil];
        [tmp show];
        
    }
	
	
	
	
}

-(void)buildTempArray{
    
    NSMutableArray *tmpCarrierArray = [NSMutableArray array];
    
    MobileCarrier *tmp1 = [[MobileCarrier alloc] init];
    tmp1.name = @"AT&T";
    tmp1.code = @"103";
    [tmpCarrierArray addObject:tmp1];
    
    MobileCarrier *tmp2 = [[MobileCarrier alloc] init];
    tmp2.name = @"Verizon";
    tmp2.code = @"158";
    [tmpCarrierArray addObject:tmp2];
    
    MobileCarrier *tmp3 = [[MobileCarrier alloc] init];
    tmp3.name = @"Sprint";
    tmp3.code = @"147";
    [tmpCarrierArray addObject:tmp3];
    
    MobileCarrier *tmp4 = [[MobileCarrier alloc] init];
    tmp4.name = @"T-Mobile";
    tmp4.code = @"150";
    [tmpCarrierArray addObject:tmp4];
    
    MobileCarrier *tmp5 = [[MobileCarrier alloc] init];
    tmp5.name = @"Alltel";
    tmp5.code = @"102";
    [tmpCarrierArray addObject:tmp5];
    
    MobileCarrier *tmp6 = [[MobileCarrier alloc] init];
    tmp6.name = @"US Cellular";
    tmp6.code = @"155";
    [tmpCarrierArray addObject:tmp6];
    
    MobileCarrier *tmp7 = [[MobileCarrier alloc] init];
    tmp7.name = @"3 River Wireless";
    tmp7.code = @"100";
    [tmpCarrierArray addObject:tmp7];
    
    MobileCarrier *tmp8 = [[MobileCarrier alloc] init];
    tmp8.name = @"ACS Wireless";
    tmp8.code = @"101";
    [tmpCarrierArray addObject:tmp8];
    
    MobileCarrier *tmp9 = [[MobileCarrier alloc] init];
    tmp9.name = @"Bell Canada";
    tmp9.code = @"104";
    [tmpCarrierArray addObject:tmp9];
    
    MobileCarrier *tmp10 = [[MobileCarrier alloc] init];
    tmp10.name = @"Bell Mobility (Canada)";
    tmp10.code = @"105";
    [tmpCarrierArray addObject:tmp10];
    
    MobileCarrier *tmp11 = [[MobileCarrier alloc] init];
    tmp11.name = @"Bell Mobility";
    tmp11.code = @"106";
    [tmpCarrierArray addObject:tmp11];
    
    MobileCarrier *tmp12 = [[MobileCarrier alloc] init];
    tmp12.name = @"Blue Sky Frog";
    tmp12.code = @"107";
    [tmpCarrierArray addObject:tmp12];
    
    MobileCarrier *tmp13 = [[MobileCarrier alloc] init];
    tmp13.name = @"Bluegrass Cellular";
    tmp13.code = @"108";
    [tmpCarrierArray addObject:tmp13];
    
    MobileCarrier *tmp14 = [[MobileCarrier alloc] init];
    tmp14.name = @"Boost Mobile";
    tmp14.code = @"109";
    [tmpCarrierArray addObject:tmp14];
    
    MobileCarrier *tmp15 = [[MobileCarrier alloc] init];
    tmp15.name = @"BPL Mobile";
    tmp15.code = @"110";
    [tmpCarrierArray addObject:tmp15];
    
    MobileCarrier *tmp16 = [[MobileCarrier alloc] init];
    tmp16.name = @"Carolina West Wireless";
    tmp16.code = @"111";
    [tmpCarrierArray addObject:tmp16];
    
    MobileCarrier *tmp17 = [[MobileCarrier alloc] init];
    tmp17.name = @"Cellular One";
    tmp17.code = @"112";
    [tmpCarrierArray addObject:tmp17];
    
    MobileCarrier *tmp18 = [[MobileCarrier alloc] init];
    tmp18.name = @"Cellular South";
    tmp18.code = @"113";
    [tmpCarrierArray addObject:tmp18];
    
    MobileCarrier *tmp19 = [[MobileCarrier alloc] init];
    tmp19.name = @"Centennial Wireless";
    tmp19.code = @"114";
    [tmpCarrierArray addObject:tmp19];
    
    MobileCarrier *tmp20 = [[MobileCarrier alloc] init];
    tmp20.name = @"CenturyTel";
    tmp20.code = @"115";
    [tmpCarrierArray addObject:tmp20];
    
    MobileCarrier *tmp21 = [[MobileCarrier alloc] init];
    tmp21.name = @"Cingular (Now AT&T)";
    tmp21.code = @"116";
    [tmpCarrierArray addObject:tmp21];
    
    MobileCarrier *tmp22 = [[MobileCarrier alloc] init];
    tmp22.name = @"Clearnet";
    tmp22.code = @"117";
    [tmpCarrierArray addObject:tmp22];
    
    MobileCarrier *tmp23 = [[MobileCarrier alloc] init];
    tmp23.name = @"Comcast";
    tmp23.code = @"118";
    [tmpCarrierArray addObject:tmp23];
    
    MobileCarrier *tmp24 = [[MobileCarrier alloc] init];
    tmp24.name = @"Corr Wireless Communications";
    tmp24.code = @"119";
    [tmpCarrierArray addObject:tmp24];
    
    MobileCarrier *tmp25 = [[MobileCarrier alloc] init];
    tmp25.name = @"Dobson";
    tmp25.code = @"120";
    [tmpCarrierArray addObject:tmp25];
    
    MobileCarrier *tmp26 = [[MobileCarrier alloc] init];
    tmp26.name = @"Edge Wireless";
    tmp26.code = @"121";
    [tmpCarrierArray addObject:tmp26];
    
    MobileCarrier *tmp27 = [[MobileCarrier alloc] init];
    tmp27.name = @"Fido";
    tmp27.code = @"122";
    [tmpCarrierArray addObject:tmp27];
    
    MobileCarrier *tmp28 = [[MobileCarrier alloc] init];
    tmp28.name = @"Golden Telecom";
    tmp28.code = @"123";
    [tmpCarrierArray addObject:tmp28];
    
    MobileCarrier *tmp29 = [[MobileCarrier alloc] init];
    tmp29.name = @"Helio";
    tmp29.code = @"124";
    [tmpCarrierArray addObject:tmp29];
    
    MobileCarrier *tmp30 = [[MobileCarrier alloc] init];
    tmp30.name = @"Houston Cellular";
    tmp30.code = @"125";
    [tmpCarrierArray addObject:tmp30];
    
    MobileCarrier *tmp31 = [[MobileCarrier alloc] init];
    tmp31.name = @"Idea Cellular";
    tmp31.code = @"126";
    [tmpCarrierArray addObject:tmp31];
    
    MobileCarrier *tmp32 = [[MobileCarrier alloc] init];
    tmp32.name = @"Illinois Valley Cellular";
    tmp32.code = @"127";
    [tmpCarrierArray addObject:tmp32];
    
    MobileCarrier *tmp33 = [[MobileCarrier alloc] init];
    tmp33.name = @"Inland Cellular Telephone";
    tmp33.code = @"128";
    [tmpCarrierArray addObject:tmp33];
    
    MobileCarrier *tmp34 = [[MobileCarrier alloc] init];
    tmp34.name = @"MCI";
    tmp34.code = @"129";
    [tmpCarrierArray addObject:tmp34];
    
    MobileCarrier *tmp35 = [[MobileCarrier alloc] init];
    tmp35.name = @"Metrocall";
    tmp35.code = @"130";
    [tmpCarrierArray addObject:tmp35];
    
    MobileCarrier *tmp36 = [[MobileCarrier alloc] init];
    tmp36.name = @"Metrocall 2-way";
    tmp36.code = @"131";
    [tmpCarrierArray addObject:tmp36];
    
    MobileCarrier *tmp37 = [[MobileCarrier alloc] init];
    tmp37.name = @"Metro PCS";
    tmp37.code = @"132";
    [tmpCarrierArray addObject:tmp37];
    
    MobileCarrier *tmp38 = [[MobileCarrier alloc] init];
    tmp38.name = @"Microcell";
    tmp38.code = @"133";
    [tmpCarrierArray addObject:tmp38];
    
    MobileCarrier *tmp39 = [[MobileCarrier alloc] init];
    tmp39.name = @"Midwest Wireless";
    tmp39.code = @"134";
    [tmpCarrierArray addObject:tmp39];
    
    MobileCarrier *tmp40 = [[MobileCarrier alloc] init];
    tmp40.name = @"Mobilcomm";
    tmp40.code = @"135";
    [tmpCarrierArray addObject:tmp40];
    
    MobileCarrier *tmp41 = [[MobileCarrier alloc] init];
    tmp41.name = @"MTS";
    tmp41.code = @"136";
    [tmpCarrierArray addObject:tmp41];
    
    MobileCarrier *tmp42 = [[MobileCarrier alloc] init];
    tmp42.name = @"Nextel";
    tmp42.code = @"137";
    [tmpCarrierArray addObject:tmp42];
    
    MobileCarrier *tmp43 = [[MobileCarrier alloc] init];
    tmp43.name = @"OnlineBeep";
    tmp43.code = @"138";
    [tmpCarrierArray addObject:tmp43];
    
    MobileCarrier *tmp44 = [[MobileCarrier alloc] init];
    tmp44.name = @"PCS One";
    tmp44.code = @"139";
    [tmpCarrierArray addObject:tmp44];
    
    MobileCarrier *tmp45 = [[MobileCarrier alloc] init];
    tmp45.name = @"President's Choice";
    tmp45.code = @"140";
    [tmpCarrierArray addObject:tmp45];
    
    MobileCarrier *tmp46 = [[MobileCarrier alloc] init];
    tmp46.name = @"Public Service Cellular";
    tmp46.code = @"141";
    [tmpCarrierArray addObject:tmp46];
    
    MobileCarrier *tmp47 = [[MobileCarrier alloc] init];
    tmp47.name = @"Qwest";
    tmp47.code = @"142";
    [tmpCarrierArray addObject:tmp47];
    
    MobileCarrier *tmp48 = [[MobileCarrier alloc] init];
    tmp48.name = @"Rogers AT&T Wireless";
    tmp48.code = @"143";
    [tmpCarrierArray addObject:tmp48];
    
    MobileCarrier *tmp49 = [[MobileCarrier alloc] init];
    tmp49.name = @"Rogers Canada";
    tmp49.code = @"144";
    [tmpCarrierArray addObject:tmp49];
    
    MobileCarrier *tmp50 = [[MobileCarrier alloc] init];
    tmp50.name = @"Satellink";
    tmp50.code = @"145";
    [tmpCarrierArray addObject:tmp50];
    
    MobileCarrier *tmp51 = [[MobileCarrier alloc] init];
    tmp51.name = @"Southwestern Bell";
    tmp51.code = @"146";
    [tmpCarrierArray addObject:tmp51];
    
    MobileCarrier *tmp52 = [[MobileCarrier alloc] init];
    tmp52.name = @"Sumcom";
    tmp52.code = @"148";
    [tmpCarrierArray addObject:tmp52];
    
    MobileCarrier *tmp53 = [[MobileCarrier alloc] init];
    tmp53.name = @"Surewest Communications";
    tmp53.code = @"149";
    [tmpCarrierArray addObject:tmp53];
    
    MobileCarrier *tmp54 = [[MobileCarrier alloc] init];
    tmp54.name = @"Telus";
    tmp54.code = @"151";
    [tmpCarrierArray addObject:tmp54];
    
    MobileCarrier *tmp55 = [[MobileCarrier alloc] init];
    tmp55.name = @"Tracfone";
    tmp55.code = @"152";
    [tmpCarrierArray addObject:tmp55];
    
    MobileCarrier *tmp56 = [[MobileCarrier alloc] init];
    tmp56.name = @"Triton";
    tmp56.code = @"153";
    [tmpCarrierArray addObject:tmp56];
    
    MobileCarrier *tmp57 = [[MobileCarrier alloc] init];
    tmp57.name = @"Unicel";
    tmp57.code = @"154";
    [tmpCarrierArray addObject:tmp57];
    
    MobileCarrier *tmp58 = [[MobileCarrier alloc] init];
    tmp58.name = @"Solo Mobile";
    tmp58.code = @"156";
    [tmpCarrierArray addObject:tmp58];
    
    MobileCarrier *tmp59 = [[MobileCarrier alloc] init];
    tmp59.name = @"US West";
    tmp59.code = @"157";
    [tmpCarrierArray addObject:tmp59];
    
    MobileCarrier *tmp60 = [[MobileCarrier alloc] init];
    tmp60.name = @"Virgin Mobile";
    tmp60.code = @"159";
    [tmpCarrierArray addObject:tmp60];
    
    MobileCarrier *tmp61 = [[MobileCarrier alloc] init];
    tmp61.name = @"Virgin Mobile Canada";
    tmp61.code = @"160";
    [tmpCarrierArray addObject:tmp61];
    
    MobileCarrier *tmp62 = [[MobileCarrier alloc] init];
    tmp62.name = @"West Central Wireless";
    tmp62.code = @"161";
    [tmpCarrierArray addObject:tmp62];
    
    MobileCarrier *tmp63 = [[MobileCarrier alloc] init];
    tmp63.name = @"Western Wireless";
    tmp63.code = @"162";
    [tmpCarrierArray addObject:tmp63];
    
    
    self.hardCarriers = [NSArray arrayWithArray:tmpCarrierArray];
    
    
    
}
- (void)viewDidUnload {

	firstName = nil;
	lastName = nil;
	error = nil;
	registering = nil;
	submitButton = nil;
    phoneText = nil;
    phoneExplain = nil;
    carrierExplain = nil;
    carrierLabel = nil;
    carrierPicker = nil;
    carrierText = nil;
    selectCarrierButton = nil;
	[super viewDidUnload];
}


@end

