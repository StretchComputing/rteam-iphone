//
//  NewTeam.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewTeam.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "JSON/JSON.h"
#import "ServerAPI.h"
#import "TwitterAuth.h"
#import "FastActionSheet.h"
#import "QuartzCore/QuartzCore.h"
#import "NewMemberObject.h"
#import "MyTeams.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation NewTeam
@synthesize teamName, from, oldTeams, errorLabel, serverProcess, submitButton, createSuccess, other, enableTwitter, twitterUrl, errorString,
addButton, addView, addViewBackground, closeButton, saveButton, emailArray, teamId, addNewButton, myTableView, miniBackgroundView, miniForeGroundView,
nameText, emailText, phoneText, miniErrorLabel, miniCancelButton, miniAddButton, phoneOnlyArray, noMembers, showedMemberAlert, fromHome,
miniMultiplePhoneAlert, miniMultipleEmailAlert, multipleEmailArray, multiplePhoneArray, miniMultiple, tmpMiniPhone, tmpMiniEmail, tmpMiniLastName,
tmpMiniFirstName, twoAlerts, addContactWhere, guard1EmailAlert, guard1PhoneAlert, guard2EmailAlert, guard2PhoneAlert,
guardianBackground, miniGuardAddButton, miniGuardCancelButton, oneName, oneEmail, onePhone, twoEmail, twoName, twoPhone, currentGuardianSelection,
miniGuardErrorLabel, removeGuardiansButton, currentGuardName, currentGuardEmail, currentGuardPhone, multipleEmailArrayLabels, multiplePhoneArrayLabels, coordinatorSegment, theTeamName;



-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"NewTeam - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

- (void)viewDidLoad {
    self.guardianBackground.hidden = YES;
    self.removeGuardiansButton.hidden = YES;
    
	self.showedMemberAlert = false;
	
	myPhoneNumberFormatter = [[PhoneNumberFormatter alloc] init];
	myTextFieldSemaphore = 0;
	
	self.phoneOnlyArray = [NSMutableArray array];
	[self.phoneText addTarget:self
                       action:@selector(autoFormatTextField:)
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
    
	self.teamId = @"";
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
	
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.addView.bounds;
	UIColor *color2 =  [UIColor colorWithRed:176/255.0 green:196/255.0 blue:222/255.0 alpha:0.9];
	UIColor *color1 =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:255/255.0 alpha:0.9];
	gradient.colors = [NSArray arrayWithObjects:(id)[color2 CGColor], (id)[color1 CGColor], nil];
	[self.addView.layer insertSublayer:gradient atIndex:0];
	
	self.twitterUrl = @"";
	NSString *new = @"New ";
	NSString *newTitle = [new stringByAppendingString: self.from];
	newTitle = [newTitle stringByAppendingFormat: @" Team"];
	self.title=newTitle;
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.submitButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.closeButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.saveButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.addNewButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniCancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniAddButton setBackgroundImage:stretch forState:UIControlStateNormal];
    [self.miniGuardAddButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.miniGuardCancelButton setBackgroundImage:stretch forState:UIControlStateNormal];
    
    
    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.removeGuardiansButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
    
    
	
	
}




-(void)endText {
    
	[self becomeFirstResponder];
}

-(void)create{
    
    [TraceSession addEventToSession:@"New Team Page - Create Team Clicked"];

    
	self.errorLabel.text = @"";
    
	if ([self.teamName.text  isEqualToString:@""]) {
		self.errorLabel.text = @"*You must enter a team name";
		
		
	}else {
		
		if (([self.emailArray count] > 0) || self.showedMemberAlert) {
			
			[serverProcess startAnimating];
			
			//Disable the UI buttons and textfields while registering
			
			[submitButton setEnabled:NO];
			[self.navigationItem.leftBarButtonItem setEnabled:NO];
			[self.teamName setEnabled:NO];
			
			
			
			//Create the team in a background thread
            self.theTeamName = [NSString stringWithString:self.teamName.text];

         
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
			
		}else {
			
			self.showedMemberAlert = true;
			NSString *tmp = @"Adding new members to your team is quick and easy.  Are you sure you don't want to add a few right now?  If you choose 'No Thanks', you will be able to add members to your team later.";
			self.noMembers = [[UIAlertView alloc] initWithTitle:@"No Members Added" message:tmp delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Add Members", nil];
			[self.noMembers show];
			
		}
        
		
		
		
        
		
	}
}


- (void)runRequest {
	
	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *useTwitter = @"";
        if (self.enableTwitter.selectedSegmentIndex == 0) {
            useTwitter = @"true";
        }else {
            useTwitter = @"false";
        }
        
        
        NSDictionary *results = [ServerAPI createTeam:self.theTeamName :@"" :@"No description entered..." :useTwitter
                                                     :mainDelegate.token :self.from];
        
        NSString *status = [results valueForKey:@"status"];
                
        if ([status isEqualToString:@"100"]){
            
            self.createSuccess = true;
            
            self.teamId = [results valueForKey:@"teamId"];
            if ([results valueForKey:@"twitterUrl"] != nil) {
                self.twitterUrl = [results valueForKey:@"twitterUrl"];
                
            }
            
            if ([mainDelegate.quickLinkOne isEqualToString:@"create"]) {
                
                mainDelegate.quickLinkOne = [results valueForKey:@"teamId"];
                NSDictionary *res = [ServerAPI getTeamInfo:[results valueForKey:@"teamId"] :mainDelegate.token :@"false"];
                NSDictionary *info = [res valueForKey:@"teamInfo"];
                
                mainDelegate.quickLinkOneName = [info valueForKey:@"teamName"];
                mainDelegate.quickLinkOneImage = [self.from lowercaseString];
                
                [mainDelegate saveUserInfo];
            }else if ([mainDelegate.quickLinkOne length] > 0) {
                //quickLinkOne is a team
                
                if ([mainDelegate.quickLinkTwo isEqualToString:@""]) {
                    mainDelegate.quickLinkTwo = [results valueForKey:@"teamId"];
                    
                    NSDictionary *res = [ServerAPI getTeamInfo:[results valueForKey:@"teamId"] :mainDelegate.token :@"false"];
                    NSDictionary *info = [res valueForKey:@"teamInfo"];
                    
                    mainDelegate.quickLinkTwoName = [info valueForKey:@"teamName"];
                    mainDelegate.quickLinkTwoImage = [self.from lowercaseString];
                    [mainDelegate saveUserInfo];
                    
                }
            }
            
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
                    
                default:
                    //should never get here
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
	[self.serverProcess stopAnimating];
	
	
	if (self.createSuccess) {
		
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"New Team Created"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:nil]) {
        }
        
		[self.serverProcess startAnimating];
        
		for (int i = 0; i < [self.emailArray count]; i++) {
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
		}
		
		if ([self.emailArray count] > 0) {
			[self performSelectorInBackground:@selector(addMembers) withObject:nil];
            
		}else {
			
			[self.serverProcess stopAnimating];
			//Then go to the coaches home
			NSArray *temp = [self.navigationController viewControllers];
			int num = [temp count];
			if (self.other) {
				num = num - 4;
			}else {
				num = num - 3;
			}
			

            
			MyTeams *tmp = [temp objectAtIndex:num];
			tmp.phoneOnlyArray = [NSMutableArray arrayWithArray:self.phoneOnlyArray];
			tmp.newlyCreatedTeam = self.teamName.text;
			
			if (![self.twitterUrl isEqualToString:@""]) {
				
				//twitter enabled
				TwitterAuth *tmp1 = [[TwitterAuth alloc] init];
				tmp1.url = self.twitterUrl;
                
                if (self.fromHome){
                    tmp1.fromHome = true;
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
                    
                }
				[self.navigationController pushViewController:tmp1 animated:YES];
				
			}else {
                if (self.fromHome) {
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
                    [self.navigationController dismissModalViewControllerAnimated:YES];
                }else{
                    [self.navigationController popToViewController:tmp animated:YES];
                    
                }
				
			}
			
		}
		
	}else {
		
		if ([self.errorString isEqualToString:@"NA"]) {
			//Alert
			NSString *tmp = @"Only User's with confirmed email addresses can connect a team to twitter.  To confirm your email, please click on the activation link in the email we sent you.";
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Not Confirmed." message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
            //[alert release];
			self.errorLabel.text = @"Please try again";
		}else {
			self.errorLabel.text = self.errorString;
		}
		
		[submitButton setEnabled:YES];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
		[self.teamName setEnabled:YES];
		
	}
    
    
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
		//[actionSheet release];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)add{
    
    [TraceSession addEventToSession:@"New Team Page - Add Members Clicked"];

	self.addViewBackground.hidden = NO;
	self.submitButton.enabled = NO;
	
}

-(void)close{
	
	self.addViewBackground.hidden = YES;
	self.submitButton.enabled = YES;
	//self.emailArray = [NSMutableArray array];
	[self.myTableView reloadData];
	[self becomeFirstResponder];
}


-(void)save{
	
	self.submitButton.enabled = YES;
	self.addViewBackground.hidden = YES;
	[self becomeFirstResponder];
	
	
}


-(void)addMembers{
	
	@autoreleasepool {
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
        
        if (![[GANTracker sharedTracker] trackEvent:@"action"
                                             action:@"Add Multipe Members - New Team"
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
        
        
        [self performSelectorOnMainThread:@selector(doneCreate) withObject:nil waitUntilDone:NO];

    }
		
}

-(void)doneCreate{
    
	[self.serverProcess stopAnimating];
	//Then go to the coaches home
	NSArray *temp = [self.navigationController viewControllers];
	int num = [temp count];
	if (self.other) {
		num = num - 4;
	}else {
		num = num - 3;
	}
	
	
	MyTeams *cont = [temp objectAtIndex:num];
	cont.phoneOnlyArray = self.phoneOnlyArray;
	cont.newlyCreatedTeam = self.teamName.text;
	if ([self.errorString isEqualToString:@"NA"]){
        
        cont.displayNa = true;
    }else if (![self.errorString isEqualToString:@""]){
        cont.displayError = true;
    }
    
	if (![self.twitterUrl isEqualToString:@""]) {
		
		//twitter enabled
		TwitterAuth *tmp = [[TwitterAuth alloc] init];
		tmp.url = self.twitterUrl;
        
        if (self.fromHome){
            tmp.fromHome = true;
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
            
        }
        
		[self.navigationController pushViewController:tmp animated:YES];
		
	}else {
        
        if (self.fromHome) {
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }else{
            [self.navigationController popToViewController:cont animated:YES];
            
        }
		
	}
	
	
	
}




-(void)addNew{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"New Team - Add NOT Contacts"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    
    self.coordinatorSegment.selectedSegmentIndex = 1;
	self.miniErrorLabel.text = @"";
    
	self.miniBackgroundView.hidden = NO;
	self.saveButton.enabled = NO;
	self.closeButton.enabled = NO;
	
	[self.nameText becomeFirstResponder];
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
		
		//[tmp release];
		
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

-(void)addContact{
	
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
		frame.size.width = 290;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
        dateLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:dateLabel];
		//[dateLabel release];
		
        
	}
    
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	
	
	if (isEmpty) {
		dateLabel.text = @"No members added...";
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.frame = CGRectMake(5, 5, 290, 20);
	}else{
        
        if (memberRow) {
            
            dateLabel.frame = CGRectMake(35, 5, 255, 20);
            
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(5, 1, 27, 27);
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
                
                dateLabel.text = @"- Change/Remove guardian info";
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


- (void)showPicker:(id)sender {
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"New Team - Add From Contacts"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
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
    //[picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
    @try {
        self.twoAlerts = false;
        
        self.multipleEmailArray = [NSMutableArray array];
        self.multiplePhoneArray = [NSMutableArray array];
        self.multipleEmailArrayLabels = [NSMutableArray array];
        self.multiplePhoneArrayLabels = [NSMutableArray array];
        
        self.tmpMiniFirstName = @"";
        self.tmpMiniLastName = @"";
        self.tmpMiniEmail = @"";
        self.tmpMiniPhone = @"";
        
        self.currentGuardEmail = @"";
        self.currentGuardName = @"";
        self.currentGuardPhone = @"";
        
        NSString *fName = (__bridge_transfer NSString *)ABRecordCopyValue(person,
                                                                          kABPersonFirstNameProperty);
        
        NSString *lName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        
        ABMultiValueRef emails = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
        
        NSArray *emailArray1 = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(emails);
        NSString *emailAddress = @"";
        if ([emailArray1 count] > 0) {
            emailAddress = [emailArray1 objectAtIndex:0];
            self.multipleEmailArray = [NSMutableArray arrayWithArray:emailArray1];
            
            for(int i = 0; i < ABMultiValueGetCount(emails); i++)
            {
                NSString *test = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(emails, i);
                
                NSString *final = [self getType:test];
                
                [self.multipleEmailArrayLabels addObject:final];
                
            }
            
        }
        
        
        ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSArray *phoneArray = (__bridge_transfer NSArray *)ABMultiValueCopyArrayOfAllValues(phone);
        NSString *phoneString = @"";
        if ([phoneArray count] > 0) {
            phoneString = [phoneArray objectAtIndex:0];
            self.multiplePhoneArray = [NSMutableArray arrayWithArray:phoneArray];
            
            for(int i = 0; i < ABMultiValueGetCount(phone); i++)
            {
                NSString *test = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(phone, i);
                
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
            
            if ([self.multiplePhoneArray count] > 4) {
                
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                for (int i = 0; i < 4 ; i++) {
                    [tmpArray addObject:[self.multiplePhoneArray objectAtIndex:i]];
                }
                
                self.multiplePhoneArray = [NSMutableArray arrayWithArray:tmpArray];
            }
            
            isPhone = true;
            NSString *message = @"";
            if ([self.multipleEmailArray count] == 4) {
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
            
            self.miniMultiple = @"both";
            self.tmpMiniFirstName = fName;
            self.tmpMiniLastName = lName;
            
            self.twoAlerts = true;
            
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

//handle events
- (void)autoFormatTextField:(id)sender {
	if(myTextFieldSemaphore) return;
	
	myTextFieldSemaphore = 1;
	NSString *myLocale;
	self.phoneText.text = [myPhoneNumberFormatter format:self.phoneText.text withLocale:myLocale];
	myTextFieldSemaphore = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.phoneText resignFirstResponder];
    [self.onePhone resignFirstResponder];
    [self.twoPhone resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (alertView == self.noMembers) {
		
		if (buttonIndex == 0) {
			//No Thanks
			[serverProcess startAnimating];
			
			//Disable the UI buttons and textfields while registering
			
			[submitButton setEnabled:NO];
			[self.navigationItem.leftBarButtonItem setEnabled:NO];
			[self.teamName setEnabled:NO];
			
			
			
			//Create the team in a background thread
			self.theTeamName = [NSString stringWithString:self.teamName.text];
                        
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
			
		}else {
			
			self.addViewBackground.hidden = NO;
			self.submitButton.enabled = NO;
		}
        
		
	}else if (alertView == self.miniMultipleEmailAlert){
        
        if (buttonIndex != 0) {
            
            self.tmpMiniEmail = [self.multipleEmailArray objectAtIndex:buttonIndex-1];
            
            if (self.twoAlerts) {
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
                
                //[tmpObject release];
                
            }
            
            
        }else{
            
            if (self.twoAlerts) {
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
                
                //[tmpObject release];
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
        
        //[tmpObject release];
        
        
        
        
        
        
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

- (void)viewDidUnload {
   
    twoPhone = nil;
    twoEmail = nil;
    twoName = nil;
    onePhone =nil;
    oneEmail = nil;
    oneName = nil;
    miniGuardAddButton = nil;
    miniGuardCancelButton = nil;
    guardianBackground = nil;
    miniGuardErrorLabel = nil;
    removeGuardiansButton = nil;

    addNewButton = nil;
    myTableView = nil;
    miniAddButton = nil;
    miniCancelButton = nil;
    miniErrorLabel = nil;
    phoneText = nil;
    emailText = nil;
    nameText = nil;
    miniForeGroundView = nil;
    miniBackgroundView = nil;
    
    
    enableTwitter = nil;
    serverProcess = nil;
    errorLabel = nil;
    teamName = nil;
    addButton = nil;
    addView = nil;
    addViewBackground = nil;
    saveButton = nil;
    closeButton = nil;
    submitButton = nil;
    
    coordinatorSegment = nil;
     
    [super viewDidUnload];
     
}



@end
