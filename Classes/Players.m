//
//  Players.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Players.h"
#import "Player.h"
#import "NewPlayer.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "Base64.h"
#import "Fan.h"
#import "NewMemberObject.h"
#import "InviteFanFinal.h"
#import "TraceSession.h"
#import "GANTracker.h"
#import "GoogleAppEngine.h"

@implementation Players
@synthesize players, teamName, teamId, userRole, currentMemberId, isFans, segRosterFans, addButton, error, fans, playerPics,
fanPics, barActivity, memberTableView, memberActivity, memberActivityLabel, tmpPlayerPics, tmpFanPics, tmpPlayers, tmpFans, phoneOnlyArray;


-(void)viewWillDisappear:(BOOL)animated{
	
	//self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidLoad {

	self.memberTableView.delegate = self;
	self.memberTableView.dataSource = self;
	
	
	self.players = [NSMutableArray array];
	self.fans = [NSMutableArray array];
	self.playerPics = [NSMutableArray array];
	self.fanPics = [NSMutableArray array];
	
	self.memberTableView.hidden = YES;
	
	//[self.memberActivity startAnimating];
	self.memberActivityLabel.hidden = NO;
	
	//Header to be displayed if there are no players
	UIView *headerView =
	[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 75)]
	 ;
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 320, 1)];
	UIColor *color = [[UIColor alloc] initWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
	line2.backgroundColor = color;
	[headerView addSubview:line2];
	
	
	
	NSArray *segments = [NSArray arrayWithObjects:@"Roster", @"Fans", nil];
	
	self.segRosterFans = [[UISegmentedControl alloc] initWithItems:segments];
	self.segRosterFans.frame = CGRectMake(75, 20, 170, 30);
	if (self.isFans) {
		self.segRosterFans.selectedSegmentIndex = 1;
	}else {
		self.segRosterFans.selectedSegmentIndex = 0;
		
	}
	[self.segRosterFans addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	headerView.backgroundColor = [UIColor whiteColor];
	
	[headerView addSubview:self.segRosterFans];
	
	
	self.memberTableView.tableHeaderView = headerView;
	
}

-(void)viewWillAppear:(BOOL)animated{
    
    [TraceSession addEventToSession:@"Players.m - View Will Appear"];

	self.currentMemberId = @"";
	self.error = @"";
	
	[self.barActivity startAnimating];

	[self performSelectorInBackground:@selector(getListOfMembers) withObject:nil];
		
	if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		
		NSString *bTitle;
		if (self.isFans) {
			bTitle = @"Invite";
		}else {
			bTitle = @"Add";
		}
		
		self.addButton = [[UIBarButtonItem alloc] initWithTitle:bTitle style:UIBarButtonItemStyleBordered target:self action:@selector(create)];
		[self.tabBarController.navigationItem setRightBarButtonItem:self.addButton];
		
	}else{
        
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
	
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
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Text", nil];
			[alert1 show];
		}else {
			NSString *message1 = @"You have added at least one member with a phone number and no email address.  We can still send them rTeam messages if they sign up for our free texting service first.  Please notify them that they must send the text 'yes' to 'join@rteam.com' to sign up.";
			UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Text Message" message:message1 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert1 show];
		}

		
		
	}
	
}




-(void)getListOfMembers{
    
	@autoreleasepool {
        NSString *token = @"";
        NSDictionary *response = [NSDictionary dictionary];
        NSArray *playerArray = [NSArray array];
        
        self.tmpPlayers = [NSMutableArray array];
        self.tmpFans = [NSMutableArray array];
        
        self.playerPics = [NSMutableArray array];
        self.fanPics = [NSMutableArray array];
        
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            response = [ServerAPI getListOfTeamMembers:self.teamId :token :@"" :@""];
			
            
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                playerArray = [response valueForKey:@"members"];
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.error = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        self.error = @"*Error connecting to server";
                        break;
                    default:
                        //Log the status code?
                        self.error = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        
        for (int i = 0; i < [playerArray count]; i++) {
            
            if ([[playerArray objectAtIndex:i] class] == [Fan class]) {
                Fan *tmpPlayer = [playerArray objectAtIndex:i];
                
                [self.tmpFans addObject:tmpPlayer];
                [self.fanPics addObject:@""];
            }else {
                Player *tmpPlayer = [playerArray objectAtIndex:i];
                
                [self.tmpPlayers addObject:tmpPlayer];
                [self.playerPics addObject:@""];
            }
            
        }
        
        [self performSelectorOnMainThread:@selector(finishedMembers) withObject:nil waitUntilDone:NO];
    }
	
    
}



-(void)finishedMembers{
	
	self.players = [NSMutableArray arrayWithArray:self.tmpPlayers];
	self.fans = [NSMutableArray arrayWithArray:self.tmpFans];
	
	if ([self.players count] > 0) {
		[self performSelectorInBackground:@selector(getPicsPlayers) withObject:nil];

	}
	
	if ([self.fans count] > 0) {
		[self performSelectorInBackground:@selector(getPicsFans) withObject:nil];
	}
	
	
	[self.barActivity stopAnimating];
	//[self.memberActivity stopAnimating];
	self.memberActivityLabel.hidden = YES;
	self.memberTableView.hidden = NO;
	[self.memberTableView reloadData];
	
	

}

-(void)segmentSelect:(id)sender{
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int selection = [segmentedControl selectedSegmentIndex];
	
	switch (selection) {
		case 0:
			segmentedControl.selectedSegmentIndex = 0;
			self.isFans = false;
			self.addButton.title = @"Add";
			[self.memberTableView reloadData];
			break;
		case 1:
			segmentedControl.selectedSegmentIndex = 1;
			self.isFans = true;
			self.addButton.title = @"Invite";
			[self.memberTableView reloadData];
			break;
		default:
			break;
	}
	
	
}


-(void)create{
	

    
	if (self.isFans) {	
        [TraceSession addEventToSession:@"People Page - Invite Fan Clicked"];

        
        InviteFanFinal *tmp = [[InviteFanFinal alloc] init];
        tmp.teamId = self.teamId;
        tmp.userRole = self.userRole;
		[self.navigationController pushViewController:tmp animated:YES];
	}else {
        
        [TraceSession addEventToSession:@"People Page - Add Member Clicked"];

        
		NewPlayer *nextController = [[NewPlayer alloc] init];
		nextController.teamId = self.teamId;
		nextController.userRole = self.userRole;
		[self.navigationController pushViewController:nextController animated:YES];	
	}

}




- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if (self.isFans) {
		
		if ([self.fans count] == 0) {
			return 1;
		}else {
			return [self.fans count];
		}

	}else {
		
		if ([self.players count] == 0) {
			return 1;
		}else {
			return [self.players count];
		}
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	static NSInteger imageTag = 2;
	static NSInteger descTag = 3;
    static NSInteger descTag1 = 4;
	static NSInteger descTag2 = 5;

	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		
		frame.origin.x = 50;
		frame.origin.y = 6;
		frame.size.height = 25;
		frame.size.width = 265;
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		
		frame.origin.x = 50;
		frame.origin.y = 25;
		frame.size.height = 20;
		frame.size.width = 250;
		UILabel *descLabel = [[UILabel alloc] initWithFrame:frame];
		descLabel.tag = descTag;
		[cell.contentView addSubview:descLabel];
        
        frame.origin.x = 50;
		frame.origin.y = 40;
		frame.size.height = 20;
		frame.size.width = 250;
		UILabel *descLabel1 = [[UILabel alloc] initWithFrame:frame];
		descLabel1.tag = descTag1;
		[cell.contentView addSubview:descLabel1];
        
        frame.origin.x = 50;
		frame.origin.y = 55;
		frame.size.height = 20;
		frame.size.width = 250;
		UILabel *descLabel2 = [[UILabel alloc] initWithFrame:frame];
		descLabel2.tag = descTag2;
		[cell.contentView addSubview:descLabel2];
        
        
		
		frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 45;
		frame.size.width = 45;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.tag = imageTag;
		[cell.contentView addSubview:imageView];
		
		
	}
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:descTag];
    UILabel *descLabel1 = (UILabel *)[cell.contentView viewWithTag:descTag1];
	UILabel *descLabel2 = (UILabel *)[cell.contentView viewWithTag:descTag2];

	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageTag];
	nameLabel.backgroundColor = [UIColor clearColor];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel1.backgroundColor = [UIColor clearColor];
    descLabel2.backgroundColor = [UIColor clearColor];

    
    //imageView.contentMode = UIViewContentModeCenter;
    //imageView.clipsToBounds = YES;
    
    descLabel1.hidden = YES;
    descLabel2.hidden = YES;
	if (self.isFans) {
		
		if ([self.fans count] == 0) {
			
			
			nameLabel.text = @"You have no fan contacts...";
			nameLabel.font = [UIFont fontWithName:@"Helvetica" size:17];

			descLabel.text = @"";
			imageView.image = nil;
			imageView = nil;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

		
			return cell;
		}else {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

			descLabel.backgroundColor = [UIColor clearColor];
			descLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
			
			nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
			NSUInteger row = [indexPath row];
			if ([self.fans count] >= row) {
			
			Fan *controller = [self.fans objectAtIndex:row];
						
				if (controller.isUser) {
					descLabel.text = @"Active - rTeam App";
				}else {
					if (controller.isNetworkAuthenticated) {
						
						if (![controller.email isEqualToString:@""]) {
							descLabel.text = @"Active - Email";
						}else {
							
							if (![controller.phone isEqualToString:@""]) {
								descLabel.text = @"Active - SMS";
							}
						}
						
						
					}else {
						
						if (![controller.email isEqualToString:@""]) {
							descLabel.text = @"(Pending - Email)";
						}else {
							
							if (![controller.phone isEqualToString:@""]) {
								descLabel.text = @"(Pending - SMS)";
							}else {
								descLabel.text = @"(Pending - No Contact Info)";
							}
							
						}
					}
					
				}
				

			if ((controller.firstName == nil) || ([controller.firstName isEqualToString:@" "])) {
				nameLabel.text = controller.email;
			}else{
				nameLabel.text = controller.firstName;
				
			}
			nameLabel.backgroundColor = [UIColor clearColor];
			
			
			if ([self.fanPics count] > row) {
					
				
			if ([[self.fanPics objectAtIndex:row] isEqualToString:@""]) {
				imageView.image = [UIImage imageNamed:@"profile1.png"];
			}else {
				
                NSData *profileData = [Base64 decode:[self.fanPics objectAtIndex:row]];
                UIImage *tmpImage = [UIImage imageWithData:profileData];
                
                
                int xVal;
                int yVal;
                
                if (tmpImage.size.height > tmpImage.size.width) {
                    
                    xVal = 45;
                    yVal = 60;
                    
                }else{
                    
                    xVal = 60;
                    yVal = 45;
                }
                
                UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
                
                [tmpImage drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
                
                UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                
				imageView.image = newImage1;
                
                imageView.contentMode = UIViewContentModeCenter;
                imageView.clipsToBounds = YES;
               
			}
                
			}

			
			
			if (row % 2 != 0) {
				cell.contentView.backgroundColor = [UIColor whiteColor];
				cell.accessoryView.backgroundColor = [UIColor whiteColor];
				cell.backgroundView = [[UIView alloc] init]; 
				cell.backgroundView.backgroundColor = [UIColor whiteColor];
			}else {
				UIColor *tmpColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
				cell.contentView.backgroundColor = tmpColor;
				cell.accessoryView.backgroundColor = tmpColor;
				
				cell.backgroundView = [[UIView alloc] init]; 
				cell.backgroundView.backgroundColor = tmpColor;
			}
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				
			}
			return cell;
		}
		
	}else {
		
		
		
		if ([self.players count] == 0) {
			
			
			nameLabel.text = @"You have no player contacts...";
			descLabel.text = @"";
			imageView.image = nil;
			imageView = nil;
			
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

			return cell;
		}else {
			
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

			descLabel.backgroundColor = [UIColor clearColor];
			descLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
            descLabel1.font = [UIFont fontWithName:@"Helvetica" size:13];
			descLabel2.font = [UIFont fontWithName:@"Helvetica" size:13];

			
			nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];

			
			NSUInteger row = [indexPath row];
			
			if ([self.players count] > row) {
				
			Player *controller = [self.players objectAtIndex:row];
			
                if (![controller.guard1First isEqualToString:@""]) {
                    //At least 1 guardian
                    descLabel1.hidden = NO;
                    
                    if (controller.isUser) {
                        descLabel.text = @"Member: Active - rTeam App";
                    }else {
                        if (controller.isNetworkAuthenticated) {
                            
                            if (!controller.isSmsConfirmed) {
                                descLabel.text = @"Member: Active - Email";
                            }else {
                                descLabel.text = @"Member: Active - SMS";
                                
                            }
                            
                            
                        }else {
                            
                            if (![controller.email isEqualToString:@""]) {
                                descLabel.text = @"Member: (Pending - Email)";
                            }else {
                                
                                if (![controller.phone isEqualToString:@""]) {
                                    descLabel.text = @"Member: (Pending - SMS)";
                                }else {
                                    descLabel.text = @"Member: (Pending - No Contact Info)";
                                }
                                
                            }
                        }
                        
                    }
                    
                    if (controller.guard1isUser) { //If Guardian1 is a User
                        descLabel1.text = @"Guardian 1: Active - rTeam App";
                    }else {
                        if (controller.guard1NA) {
                            
                            if (!controller.guard1SmsConfirmed) {
                                descLabel1.text = @"Guardian 1: Active - Email";
                            }else {
                                descLabel1.text = @"Guardian 1: Active - SMS";
                                
                            }
                            
                            
                        }else {
                            
                            if (![controller.guard1Email isEqualToString:@""]) {
                                descLabel1.text = @"Guardian 1: (Pending - Email)";
                            }else {
                                
                                if (![controller.guard1Phone isEqualToString:@""]) {
                                    descLabel1.text = @"Guardian 1: (Pending - SMS)";
                                }else {
                                    descLabel1.text = @"Guardian 1: (Pending - No Contact Info)";
                                }
                                
                            }
                        }
                        
                    }
                    
                    if (![controller.guard2First isEqualToString:@""]) {
                        descLabel2.hidden = NO;
                        
                        if (controller.guard2isUser) { //If Guardian2 is a User
                            descLabel2.text = @"Guardian 2: Active - rTeam App";
                        }else {
                            if (controller.guard2NA) {
                                
                                if (!controller.guard2SmsConfirmed) {
                                    descLabel2.text = @"Guardian 2: Active - Email";
                                }else {
                                    
                                    descLabel2.text = @"Guardian 2: Active - SMS";
                                    
                                }
                                
                                
                            }else {
                                
                                if (![controller.guard2Email isEqualToString:@""]) {
                                    descLabel2.text = @"Guardian 2: (Pending - Email)";
                                }else {
                                    
                                    if (![controller.guard2Phone isEqualToString:@""]) {
                                        descLabel2.text = @"Guardian 2: (Pending - SMS)";
                                    }else {
                                        descLabel2.text = @"Guardian 2: (Pending - No Contact Info)";
                                    }
                                    
                                }
                            }
                            
                        }

                    }

                }else{
                    
                    if (controller.isUser) {
                        descLabel.text = @"Active - rTeam App";
                    }else {
                        if (controller.isNetworkAuthenticated) {
                            
                            if (![controller.email isEqualToString:@""]) {
                                descLabel.text = @"Active - Email";
                            }else {
                                
                                if (![controller.phone isEqualToString:@""]) {
                                    descLabel.text = @"Active - SMS";
                                }
                            }
                            
                            
                        }else {
                            
                            if (![controller.email isEqualToString:@""]) {
                                descLabel.text = @"(Pending - Email)";
                            }else {
                                
                                if (![controller.phone isEqualToString:@""]) {
                                    descLabel.text = @"(Pending - SMS)";
                                }else {
                                    descLabel.text = @"(Pending - No Contact Info)";
                                }
                                
                            }
                        }
                        
                    }

                    
                }
						
			if ((controller.firstName == nil) || ([controller.firstName isEqualToString:@" "])) {
				nameLabel.text = controller.email;
			}else{
				nameLabel.text = controller.firstName;
				
			}
			
			nameLabel.backgroundColor = [UIColor clearColor];
			
			
			if ([self.playerPics count] > row) {
		
				
			if ([[self.playerPics objectAtIndex:row] isEqualToString:@""]) {
				imageView.image = [UIImage imageNamed:@"profile1.png"];
			}else {
				
				NSData *profileData = [Base64 decode:[self.playerPics objectAtIndex:row]];
                UIImage *tmpImage = [UIImage imageWithData:profileData];
        
        
                int xVal;
                int yVal;
                
                if (tmpImage.size.height > tmpImage.size.width) {
                    
                    xVal = 45;
                    yVal = 60;

                }else{
                    
                    xVal = 60;
                    yVal = 45;
                }
                
                UIGraphicsBeginImageContext(CGSizeMake(xVal, yVal));
                
                [tmpImage drawInRect:CGRectMake(0.0, 0.0, xVal, yVal)];
                
                UIImage *newImage1    = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                
				imageView.image = newImage1;
                
                imageView.contentMode = UIViewContentModeCenter;
                imageView.clipsToBounds = YES;
                
            

               
			}
			}
			
			
			if (row % 2 != 0) {
				cell.contentView.backgroundColor = [UIColor whiteColor];
				cell.accessoryView.backgroundColor = [UIColor whiteColor];
				cell.backgroundView = [[UIView alloc] init]; 
				cell.backgroundView.backgroundColor = [UIColor whiteColor];
			}else {
				UIColor *tmpColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
				cell.contentView.backgroundColor = tmpColor;
				cell.accessoryView.backgroundColor = tmpColor;
				
				cell.backgroundView = [[UIView alloc] init]; 
				cell.backgroundView.backgroundColor = tmpColor;
			}
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			return cell;
		}
		
	}

	
	//Configure the cell
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    @try {
        if (self.isFans) {
            
            [TraceSession addEventToSession:@"People Page - Fan Row Clicked"];
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                 action:@"View Fan Profile"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:nil]) {
            }
            
            
            if ([self.fans count] > 0) {
                //go to that player profile
                NSUInteger row = [indexPath row];
                Fan *coachTeam = [self.fans objectAtIndex:row];
                coachTeam.headUserRole = self.userRole;
                coachTeam.teamName = self.teamName;
                [self.navigationController pushViewController:coachTeam animated:YES];
                
            }
            
        }else {
            
            [TraceSession addEventToSession:@"People Page - Member Row Clicked"];
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                 action:@"View Member Profile"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:nil]) {
            }
            
            
            if ([self.players count] > 0) {
                //go to that player profile
                NSUInteger row = [indexPath row];
                Player *coachTeam = [self.players objectAtIndex:row];
                coachTeam.headUserRole = self.userRole;
                coachTeam.teamName = self.teamName;
                [self.navigationController pushViewController:coachTeam animated:YES];
                
            }
            
        }

    }
    @catch (NSException *exception) {
        [GoogleAppEngine sendClientLog:@"Players.m - didSelectRowAtIndexPath()" logMessage:[exception reason] logLevel:@"exception" exception:exception];

        
        
    }
	
	
	
	
	
}

- (void)getPicsFans {

    @autoreleasepool {
        //Create the new player
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [self.fans count]; i++) {
            
            if ([self.fans count] > i) {
                
                Player *controller = [self.fans objectAtIndex:i];
                
                NSDictionary *response = [ServerAPI getMemberInfo:self.teamId :controller.memberId :mainDelegate.token :@""];
                
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    NSDictionary *memberInfo = [response valueForKey:@"memberInfo"];
                    
                    NSString *profile = [memberInfo valueForKey:@"thumbNail"];
                    
                    
                    if ((profile == nil)  || ([profile isEqualToString:@""])){
                        
                        
                    }else {
                        
                        if ([self.fanPics count] > i) {
                            [self.fanPics replaceObjectAtIndex:i withObject:profile];
                            
                        }
                        
                        
                    }
                    
                    
                    [self performSelectorOnMainThread:
                     @selector(didFinishFans)
                                           withObject:nil
                                        waitUntilDone:NO
                     ];
                    
                }else{
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            self.error = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            self.error = @"*Error connecting to server";
                            break;
                        default:
                            //should never get here
                            self.error = @"*Error connecting to server";
                            break;
                    }
                }
                
            }
            
        }

    }
	
}

- (void)didFinishFans{
	
	if (self.isFans) {
		[self.memberTableView reloadData];

	}
	
	
}

- (void)getPicsPlayers {
	
    @autoreleasepool {
        //Create the new player
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [self.players count]; i++) {
            
            
            if ([self.players count] > i) {
                
                Player *controller = [self.players objectAtIndex:i];
                
                NSDictionary *response = [ServerAPI getMemberInfo:self.teamId :controller.memberId :mainDelegate.token :@""];
                
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    NSDictionary *memberInfo = [response valueForKey:@"memberInfo"];
                    
                    NSString *profile = [memberInfo valueForKey:@"thumbNail"];
                    
                    
                    if ((profile == nil)  || ([profile isEqualToString:@""])){
                        
                        
                    }else {
                        
                        if ([self.playerPics count] > i) {
                            [self.playerPics replaceObjectAtIndex:i withObject:profile];
                            
                        }
                    }
                    
                    [self performSelectorOnMainThread:
                     @selector(didFinishPlayers)
                                           withObject:nil
                                        waitUntilDone:NO
                     ];
                    
                }else{
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            self.error = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            self.error = @"*Error connecting to server";
                            break;
                        default:
                            //should never get here
                            self.error = @"*Error connecting to server";
                            break;
                    }
                }
                
            }
            
        }

    }
	
	
}

- (void)didFinishPlayers{
	
	if (!self.isFans) {
		[self.memberTableView reloadData];
		
	}	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    
    if (self.isFans){
        return 45;

    }else{
        if ([self.players count] > 0) {
            
            if ([self.players count] >= row) {

                Player *tmpPlayer = [self.players objectAtIndex:row];
                
                if (![tmpPlayer.guard1First isEqualToString:@""]) {
                    
                    if (![tmpPlayer.guard2First isEqualToString:@""]){
                        //2 Guardians
                        return 75;
                    }else{
                        //1 Guardian
                        return 60;
                    }
                }else{
                    //No Guardians
                    return 45;
                }

                
            }else{
                return 45;
            }
                       
        }else{
            return 45;
        }
      
        
        

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		
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
	
	
	
	
}


- (void)viewDidUnload {

    memberActivity = nil;
	memberActivityLabel = nil;
	memberTableView = nil;
	barActivity = nil;
	segRosterFans = nil;
	[super viewDidUnload];
}



@end

