//
//  PracticeAttendance.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PracticeAttendance.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Player.h"
#import "GANTracker.h"

@implementation PracticeAttendance
@synthesize players, teamId, allSelector, practiceId, attMarker, saveAll, select, activity, successLabel, startDate, attReport, attendanceInfo,
saveSuccess, playerTableView, successNoChoices, successString, barActivity, attActivity, attActivityLabel, isCoord, userRole, lineView, attMarkerTemp, errorString;

-(void)viewDidLoad{
	
	self.playerTableView.hidden = YES;
	
	[self.attActivity startAnimating];
	self.attActivityLabel.hidden = NO;
	
	self.attMarker = [NSMutableArray array];
	
	/*
	self.barActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80, 32, 20, 20)];
	//set the initial property
	self.barActivity.hidesWhenStopped = YES;
	self.barActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	
	[self.navigationController.view addSubview:self.barActivity];
	*/
	self.playerTableView.delegate = self;
	self.playerTableView.dataSource = self;
	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.select setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.saveAll setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
}

-(void)viewWillAppear:(BOOL)animated{

	[self.attActivity startAnimating];
	
	[self.tabBarController.navigationItem setRightBarButtonItem:nil];
    self.tabBarController.navigationItem.title = @"Attendance";

	
	[self performSelectorInBackground:@selector(getAttendanceInfo) withObject:nil];
	
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
		self.isCoord = true;
	}else {
		self.isCoord = false;
	}
	
	if (self.isCoord) {
		self.playerTableView.frame = CGRectMake(0, 62, 320, 305);
		self.saveAll.hidden = NO;
		self.select.hidden = NO;
		self.lineView.hidden = NO;
	}else {
		self.playerTableView.frame = CGRectMake(0, 0, 320, 367);
		self.saveAll.hidden = YES;
		self.select.hidden = YES;
		self.lineView.hidden = YES;
	}


	
}

-(void)getAttendanceInfo{

	@autoreleasepool {
        self.attMarkerTemp = [NSMutableArray array];
        
        
        
        [self.tabBarController.navigationItem setRightBarButtonItem:nil];
        
        NSString *token = @"";
        NSArray *playerArray = [NSArray array];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        NSDictionary *response = [NSDictionary dictionary];
        self.errorString = @"";
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            response = [ServerAPI getListOfTeamMembers:self.teamId :token :@"member" :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                playerArray = [response valueForKey:@"members"];
                
                
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
            
            NSDictionary *responseAtt = [ServerAPI getAttendeesGame:token :self.teamId :self.practiceId :@"practice"];
            
            NSString *statusAtt = [responseAtt valueForKey:@"status"];
            
            if ([statusAtt isEqualToString:@"100"]){
                
                self.attendanceInfo = true;
                
                self.attReport = [responseAtt valueForKey:@"attendance"];
                
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
            
            
        }
        
        self.players = [NSArray arrayWithArray:playerArray];
        
        NSInteger numPlayers = [self.players count];
        //initalize the attendance marker array
        for (int i = 0; i < numPlayers; i++) {
            [self.attMarkerTemp addObject:@"-1"];
        }
        
        if (self.attendanceInfo) {
            
            for (int i = 0; i < [self.players count]; i++) {
                
                Player *tmpPlayer = [self.players objectAtIndex:i];
                
                for (int j = 0; j < [self.attReport count]; j++) {
                    
                    NSDictionary *memberReport = [self.attReport objectAtIndex:j];
                    
                    NSString *memId = [memberReport objectForKey:@"memberId"];
                    NSString *isPresent = [memberReport objectForKey:@"present"];
                    
                    if ([memId isEqualToString:tmpPlayer.memberId]) {
                        
                        if ([isPresent isEqualToString:@"yes"]) {
                            [self.attMarkerTemp replaceObjectAtIndex:i withObject:@"1"];
                        }else if ([isPresent isEqualToString:@"no"]) {
                            [self.attMarkerTemp replaceObjectAtIndex:i withObject:@"0"];
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        [self performSelectorOnMainThread:@selector(finishedAttendance) withObject:nil waitUntilDone:NO];

    }
	
}


-(void)finishedAttendance{
	
    self.successLabel.text = self.errorString;
    
	self.attMarker = [NSMutableArray arrayWithArray:self.attMarkerTemp];
	[self.barActivity stopAnimating];
	[self.attActivity stopAnimating];
	self.attActivityLabel.hidden = YES;
	self.playerTableView.hidden = NO;
	[self.playerTableView reloadData];
	
}

-(void)selectAllNone{
	
	if ((self.allSelector == nil) || ([self.allSelector isEqualToString:@"none"])){
		self.allSelector = @"all";
		[self.select setTitle:@"Select None" forState:UIControlStateNormal];
		for (int i = 0; i < [self.players count]; i++) {
			[self.attMarker replaceObjectAtIndex:i withObject:@"1"];
		}
	}else if ([self.allSelector isEqualToString:@"all"]){
		self.allSelector = @"none";
		[self.select setTitle:@"Select All" forState:UIControlStateNormal];
		for (int i = 0; i < [self.players count]; i++) {
			[self.attMarker replaceObjectAtIndex:i withObject:@"0"];
		}
	}
	
	[self.playerTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	static NSInteger attTag = 2;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 5;
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 170;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	NSArray *segments = [NSArray arrayWithObjects:@"Present", @"Absent", nil];
	UISegmentedControl *attendance = [[UISegmentedControl alloc] initWithItems:segments];
	attendance.frame = CGRectMake(175.0, 3.0, 140.0, 27.0);
	attendance.tag = attTag;
	[cell.contentView addSubview:attendance];
	
	if (self.isCoord) {
		attendance.enabled = YES;
	}else {
		attendance.enabled = NO;
	}

	nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	//Configure the cell
	
    NSUInteger row = [indexPath row];
	Player *controller = [players objectAtIndex:row];
	
	nameLabel.text = controller.firstName;
	
	attendance.tag = row;
	[attendance addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
	
	if ([[self.attMarker objectAtIndex:row] isEqualToString:@"1"]) {
		attendance.selectedSegmentIndex = 0;
	}else if ([[self.attMarker objectAtIndex:row] isEqualToString:@"0"]) {
		attendance.selectedSegmentIndex = 1;
	}
	
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(void)segmentSelect:(id)sender{
	
	self.successLabel.text = @"";
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int selection = [segmentedControl selectedSegmentIndex];
	int row = segmentedControl.tag;
	switch (selection) {
		case 0:
			[segmentedControl setTitle:@"Present" forSegmentAtIndex:0];
			[segmentedControl setTitle:@"" forSegmentAtIndex:1];
			[self.attMarker replaceObjectAtIndex:row withObject:@"1"];
			
			break;
		case 1:
			[segmentedControl setTitle:@"Absent" forSegmentAtIndex:1];
			[segmentedControl setTitle:@"" forSegmentAtIndex:0];
			[self.attMarker replaceObjectAtIndex:row withObject:@"0"];
			
			break;
		default:
			break;
	}
	
	
}


-(void)save{
	[self.activity startAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[self.saveAll setEnabled:NO];
	[self.select setEnabled:NO];
	[self.navigationItem setHidesBackButton:YES];
	
	
	//Create the player in a background thread
	
    NSError *errors;
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                         action:@"Take Attendance - Practice"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:&errors]) {
    }
    
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}


- (void)runRequest {

	@autoreleasepool {
        //self.players is the array of Player objects
        //self.attMarker is the corresponding array of whether they were present or absent
        NSMutableArray *attendance = [[NSMutableArray alloc] init];
        NSArray *finalAttendance = [[NSArray alloc] init];
        bool anyselections = false;
        
        
        
        for (int i = 0; i < [self.players count]; i++) {
            NSMutableDictionary *attList = [[NSMutableDictionary alloc] init];
            Player *tmpPlayer = [self.players objectAtIndex:i];
            NSString *marker = [self.attMarker objectAtIndex:i];
            
            if ([marker isEqualToString:@"1"]) {
                //present
                [attList setObject:tmpPlayer.memberId forKey:@"memberId"];
                [attList setObject:@"yes" forKey:@"present"];
                anyselections = true;
                
                [attendance addObject:attList];
            }else if ([marker isEqualToString:@"0"]) {
                //absent
                [attList setObject:tmpPlayer.memberId forKey:@"memberId"];
                [attList setObject:@"no" forKey:@"present"];
                anyselections = true;
                
                [attendance addObject:attList];
            }
            
        }
        
        finalAttendance = attendance;
        
        if (anyselections) {
            
            NSString *token = @"";
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            if (mainDelegate.token != nil){
                token = mainDelegate.token;
            }
            
            NSDictionary *response = [NSDictionary dictionary];
            if (![token isEqualToString:@""]){
                
                response = [ServerAPI updateAttendees:token :self.teamId :self.practiceId :@"practice" :finalAttendance :self.startDate];
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    self.saveSuccess = true;
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    
                    self.saveSuccess = false;
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            //null parameter
                            //self.successLabel.text = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            //self.successLabel.text = @"*Error connecting to server";
                            break;
                        default:
                            //should never get here
                            //self.successLabel.text = @"*Error connecting to server";
                            break;
                    }
                }
                
            }
            
        }else {
            self.successString = @"*No selections made";
            self.successNoChoices = true;
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
	[self.activity stopAnimating];
	
	self.successLabel.hidden = NO;
	
	[self.saveAll setEnabled:YES];
	[self.select setEnabled:YES];
	[self.navigationItem setHidesBackButton:NO];
	
	if (self.saveSuccess){
		self.successLabel.text = @"Save Successfull!";
		self.successLabel.textColor = [UIColor greenColor];
	}else {
		self.successLabel.text = @"*Error connecting to server.";
		self.successLabel.textColor = [UIColor redColor];
	}
	
	if (self.successNoChoices) {
		self.successNoChoices = false;
		self.successLabel.text = self.successString;
		self.successLabel.textColor = [UIColor redColor];

	}
	
}


- (void)viewDidUnload {
	//players = nil;
	//teamId = nil;
	//allSelector = nil;
	//practiceId = nil;
	//attMarker = nil;
	saveAll = nil;
	select = nil;
	activity = nil;
	successLabel = nil;
	//startDate = nil;
	attReport = nil;
	//successString = nil;
	playerTableView = nil;
	barActivity = nil;
	attActivity = nil;
	attActivityLabel = nil;
	lineView = nil;
	[super viewDidUnload];

}




@end

