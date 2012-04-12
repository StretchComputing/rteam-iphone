//
//  GameAttendance.m
//  rTeamf
//
//  Created by Nick Wroblewski on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameAttendance.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Player.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation GameAttendance
@synthesize players, teamId, allSelector, gameId, attMarker, saveAll, select, activity, successLabel, startDate, attReport, attendanceInfo,
saveSuccess, playerTableView, successString, successNoChoices, barActivity, attActivity, attActivityLabel, attMarkerTemp, switchButton, playerTableViewPre, topLabel, errorString, preMarker, preMarkerTemp, selectPre, allSelectorPre;

-(void)viewDidLoad{
	
	
	
	self.playerTableView.hidden = YES;
	
	[self.attActivity startAnimating];
	self.attActivityLabel.hidden = NO;
	
	self.attMarker = [NSMutableArray array];

	
	self.playerTableView.delegate = self;
	self.playerTableView.dataSource = self;
    self.playerTableViewPre.delegate = self;
	self.playerTableViewPre.dataSource = self;
	
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.select setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.selectPre setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

	[self.saveAll setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    self.switchButton = [[UIBarButtonItem alloc] initWithTitle:@"Game" style:UIBarButtonItemStyleBordered target:self action:@selector(switchViews)];
	
}

-(void)switchViews{
    
    [TraceSession addEventToSession:@"Game Attendance Page - Game/Pregame Button Clicked"];

    
    if ([self.switchButton.title isEqualToString:@"Game"]) {
        self.switchButton.title = @"Pre-game";
        self.topLabel.text = @"Actual game attendance";
        self.playerTableView.hidden = NO;
        self.playerTableViewPre.hidden = YES;
        
        self.selectPre.hidden = YES;
        self.select.hidden = NO;
    }else{
        self.switchButton.title = @"Game";
        self.topLabel.text = @"Pre-game expected attendance";
        self.playerTableView.hidden = YES;
        self.playerTableViewPre.hidden = NO;
        
        self.selectPre.hidden = NO;
        self.select.hidden = YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
	    
    [TraceSession addEventToSession:@"GameAttendance - View Will Appear"];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    NSDate *formatedDate = [dateFormat dateFromString:self.startDate];
    
    NSDate *todaysDate = [NSDate date];

    [self.tabBarController.navigationItem setRightBarButtonItem:self.switchButton];

    self.playerTableView.hidden = NO;
    self.playerTableViewPre.hidden = YES;
    self.topLabel.text = @"";
    [self performSelectorInBackground:@selector(getAttendanceInfo) withObject:nil];

    
    
    
    if (![formatedDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
        //Game hasn't started yet, show pre-view
        self.switchButton.title = @"Game";
        self.topLabel.text = @"Pre-game expected attendance";
        self.playerTableView.hidden = YES;
        self.playerTableViewPre.hidden = NO;
        
        self.selectPre.hidden = NO;
        self.select.hidden = YES;
    
    }else{

        //show regular attendance view
        self.switchButton.title = @"Pre-game";
        self.topLabel.text = @"Actual game attendance";
        self.playerTableView.hidden = NO;
        self.playerTableViewPre.hidden = YES;
        
        [self.attActivity startAnimating];
                
        self.selectPre.hidden = YES;
        self.select.hidden = NO;
        
        //[self performSelectorInBackground:@selector(getAttendanceInfo) withObject:nil];
    }
     
     
    
    

		
}

-(void)getAttendanceInfo{

	@autoreleasepool {
        self.attMarkerTemp = [NSMutableArray array];
        self.preMarkerTemp = [NSMutableArray array];
        
        
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
            
            NSDictionary *responseAtt = [ServerAPI getAttendeesGame:token :self.teamId :self.gameId :@"game"];
            
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
            [self.preMarkerTemp addObject:@"-1"];  // -1, no reply, 0, no, 1, yes, 2, maybe
        }
		
        if (self.attendanceInfo) {
            
            for (int i = 0; i < [self.players count]; i++) {
                
                Player *tmpPlayer = [self.players objectAtIndex:i];
                
                for (int j = 0; j < [self.attReport count]; j++) {
                    
                    NSDictionary *memberReport = [self.attReport objectAtIndex:j];
                    
                    NSString *memId = [memberReport objectForKey:@"memberId"];
                    NSString *isPresent = [memberReport objectForKey:@"present"];
                    NSString *preResponse = [memberReport objectForKey:@"preGameStatus"];
                    
                    if ([memId isEqualToString:tmpPlayer.memberId]) {
                        
                        if ([isPresent isEqualToString:@"yes"]) {
                            [self.attMarkerTemp replaceObjectAtIndex:i withObject:@"1"];
                        }else if ([isPresent isEqualToString:@"no"]) {
                            [self.attMarkerTemp replaceObjectAtIndex:i withObject:@"0"];
                            
                        }
                        
                        
                        if ([preResponse isEqualToString:@"yes"]) {
                            [self.preMarkerTemp replaceObjectAtIndex:i withObject:@"1"];
                        }else if ([preResponse isEqualToString:@"no"]) {
                            [self.preMarkerTemp replaceObjectAtIndex:i withObject:@"0"];
                            
                        }else if ([preResponse isEqualToString:@"maybe"]){
                            [self.preMarkerTemp replaceObjectAtIndex:i withObject:@"2"];
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
    self.preMarker = [NSMutableArray arrayWithArray:self.preMarkerTemp];

	[self.barActivity stopAnimating];
	[self.attActivity stopAnimating];
	self.attActivityLabel.hidden = YES;
	[self.playerTableView reloadData];
    [self.playerTableViewPre reloadData];
    
	
}

-(void)selectAllNone{

        
    if ((self.allSelector == nil) || ([self.allSelector isEqualToString:@"none"])){
        self.allSelector = @"all";
        [self.select setTitle:@"Select None" forState:UIControlStateNormal];
        for (int i = 0; i < [self.players count]; i++) {
            
            if ([self.attMarker count] > i) {
                [self.attMarker replaceObjectAtIndex:i withObject:@"1"];
            }
        }
    }else if ([self.allSelector isEqualToString:@"all"]){
        self.allSelector = @"none";
        [self.select setTitle:@"Select All" forState:UIControlStateNormal];
        for (int i = 0; i < [self.players count]; i++) {
            
            if ([self.attMarker count] > i) {
                [self.attMarker replaceObjectAtIndex:i withObject:@"0"];
            }
            
        }
    }
    
    [self.playerTableView reloadData];    
	
}

-(void)selectAllNonePre{
    
    
    if ((self.allSelectorPre == nil) || ([self.allSelectorPre isEqualToString:@"none"])){
        self.allSelectorPre = @"all";
        [self.selectPre setTitle:@"Select None" forState:UIControlStateNormal];
        for (int i = 0; i < [self.players count]; i++) {
            
            if ([self.preMarker count] > i) {
                [self.preMarker replaceObjectAtIndex:i withObject:@"1"];
            }
        }
    }else if ([self.allSelectorPre isEqualToString:@"all"]){
        self.allSelectorPre = @"none";
        [self.selectPre setTitle:@"Select All" forState:UIControlStateNormal];
        for (int i = 0; i < [self.players count]; i++) {
            
            if ([self.preMarker count] > i) {
                [self.preMarker replaceObjectAtIndex:i withObject:@"0"];
            }
            
        }
    }
    
    [self.playerTableViewPre reloadData];    
	
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
	return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    if (tableView == self.playerTableView) {
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
        attendance.frame = CGRectMake(170.0, 3.0, 145.0, 27.0);
        attendance.tag = attTag;
        [cell.contentView addSubview:attendance];
        
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

    }else{
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
        NSArray *segments = [NSArray arrayWithObjects:@"Yes", @"No", @"?", nil];
        UISegmentedControl *attendance = [[UISegmentedControl alloc] initWithItems:segments];
        attendance.frame = CGRectMake(180.0, 3.0, 130.0, 27.0);
        attendance.tag = attTag;
        [cell.contentView addSubview:attendance];
        
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        
        //Configure the cell
        
        NSUInteger row = [indexPath row];
        Player *controller = [players objectAtIndex:row];
        
        nameLabel.text = controller.firstName;
        
        attendance.tag = row;
        [attendance addTarget:self action:@selector(segmentSelectPre:) forControlEvents:UIControlEventValueChanged];
        
        if ([[self.preMarker objectAtIndex:row] isEqualToString:@"1"]) {
            attendance.selectedSegmentIndex = 0;
        }else if ([[self.preMarker objectAtIndex:row] isEqualToString:@"0"]) {
            attendance.selectedSegmentIndex = 1;
        }else if ([[self.preMarker objectAtIndex:row] isEqualToString:@"2"]){
            attendance.selectedSegmentIndex = 2;
        }
        
		
        return cell;

    }
	
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
			if ([self.attMarker count] > row) {
				[self.attMarker replaceObjectAtIndex:row withObject:@"1"];
			}

			break;
		case 1:
			[segmentedControl setTitle:@"Absent" forSegmentAtIndex:1];
			[segmentedControl setTitle:@"" forSegmentAtIndex:0];
			if ([self.attMarker count] > row) {
				[self.attMarker replaceObjectAtIndex:row withObject:@"0"];
			}

			break;
		default:
			break;
	}
	
	
}

-(void)segmentSelectPre:(id)sender{
    
	self.successLabel.text = @"";
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int selection = [segmentedControl selectedSegmentIndex];
	int row = segmentedControl.tag;
	switch (selection) {
		case 0:
			[segmentedControl setTitle:@"Yes" forSegmentAtIndex:0];
			//[segmentedControl setTitle:@"" forSegmentAtIndex:1];
			if ([self.preMarker count] > row) {
				[self.preMarker replaceObjectAtIndex:row withObject:@"1"];
			}
            
			break;
		case 1:
			[segmentedControl setTitle:@"No" forSegmentAtIndex:1];
			//[segmentedControl setTitle:@"" forSegmentAtIndex:0];
			if ([self.preMarker count] > row) {
				[self.preMarker replaceObjectAtIndex:row withObject:@"0"];
			}
            
			break;
            
        case 2:
            [segmentedControl setTitle:@"?" forSegmentAtIndex:2];
			//[segmentedControl setTitle:@"" forSegmentAtIndex:2];
			if ([self.preMarker count] > row) {
				[self.preMarker replaceObjectAtIndex:row withObject:@"2"];
			}
            
			break;
            
		default:
			break;
	}
	
	
}

-(void)save{
    
    [TraceSession addEventToSession:@"Game Attendance Page - Save Button Clicked"];

    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Take Game Attendance"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	[self.activity startAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[self.saveAll setEnabled:NO];
	[self.select setEnabled:NO];
	[self.navigationItem setHidesBackButton:YES];
	
	
	//Create the player in a background thread
    
   
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}


- (void)runRequest {
	

	@autoreleasepool {
        //self.players is the array of Player objects
        //self.attMarker is the corresponding array of whether they were present or absent
        NSMutableArray *attendance = [NSMutableArray array];
        NSArray *finalAttendance = [NSArray array];
        bool anyselections = false;
        
        
        
        for (int i = 0; i < [self.players count]; i++) {
            
            NSMutableDictionary *attList = [NSMutableDictionary dictionary];
            Player *tmpPlayer = [self.players objectAtIndex:i];
            NSString *marker = [self.attMarker objectAtIndex:i];
            NSString *preMarkerString = [self.preMarker objectAtIndex:i];
            
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
            
            if ([preMarkerString isEqualToString:@"1"]) {
                //present
                [attList setObject:tmpPlayer.memberId forKey:@"memberId"];
                [attList setObject:@"yes" forKey:@"preGameStatus"];
                anyselections = true;
                
                [attendance addObject:attList];
            }else if ([preMarkerString isEqualToString:@"0"]) {
                //absent
                [attList setObject:tmpPlayer.memberId forKey:@"memberId"];
                [attList setObject:@"no" forKey:@"preGameStatus"];
                anyselections = true;
                
                [attendance addObject:attList];
            }else if ([preMarkerString isEqualToString:@"2"]){
                //maybe
                [attList setObject:tmpPlayer.memberId forKey:@"memberId"];
                [attList setObject:@"maybe" forKey:@"preGameStatus"];
                anyselections = true;
                
                [attendance addObject:attList];
            }else{
                //absent
                [attList setObject:tmpPlayer.memberId forKey:@"memberId"];
                [attList setObject:@"noreply" forKey:@"preGameStatus"];
                anyselections = true;
                
                [attendance addObject:attList];
            }
            
            
        }
        
        finalAttendance = [NSArray arrayWithArray:attendance];
        
        if (anyselections) {
            
            NSString *token = @"";
            
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            if (mainDelegate.token != nil){
                token = mainDelegate.token;
            }
            
            NSDictionary *response = [NSDictionary dictionary];
            if (![token isEqualToString:@""]){
                
                response = [ServerAPI updateAttendees:token :self.teamId :self.gameId :@"game" :finalAttendance :self.startDate];
                
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
	self.topLabel.hidden = YES;
    
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

    [self performSelector:@selector(labelChange) withObject:nil afterDelay:2.0];
	
}

-(void)labelChange{
    self.successLabel.hidden = YES;
    self.topLabel.hidden = NO;
}


- (void)viewDidUnload {

	saveAll = nil;
	select = nil;
	activity = nil;
	successLabel = nil;

	playerTableView = nil;
	barActivity = nil;
	attActivity = nil;
	attActivityLabel = nil;
    playerTableViewPre = nil;
    topLabel = nil;
    selectPre = nil;
	[super viewDidUnload];
	
}




@end

