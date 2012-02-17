//
//  WhosComingPoll.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WhosComingPoll.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "Game.h"
#import "Practice.h"
#import "Event.h"

@implementation WhosComingPoll
@synthesize  teamList, cancelButton, selectView, selectTable, teamSelectButton, currentTeamsView, initialDate, selectedGameId, selectedTeamId, eventList, eventActivity, eventPicker, areNoEvents, eventType, eventId, mainActivity, displayLabel, sendButton, selectedMessageThreadId, isGettingEvents, newGame, createEventView, createEventSegment, createEventDatePicker, createEventCancelButton, createEventSubmitButton, createEventType, createEventDate;



-(void)viewWillAppear:(BOOL)animated{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Who's Coming Poll" message:@"To send a poll to your team asking if they will attend, first select a team, then select an event." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    [self.view bringSubviewToFront:self.eventPicker];
}

-(void)done{
    
    if (![self.selectedTeamId isEqualToString:@""]) {
        
        if (self.newGame) {
            
            self.createEventView.hidden = NO;
            [self.view bringSubviewToFront:self.createEventView];
            self.createEventSegment.selectedSegmentIndex = 0;
            
            
        }else if (![self.eventId isEqualToString:@""]){
            [self.mainActivity startAnimating];
            self.sendButton.enabled = NO;
            self.cancelButton.enabled = YES;
            
            if ([self.selectedMessageThreadId isEqualToString:@""]) {
                [self performSelectorInBackground:@selector(sendWhoPoll) withObject:nil];
            }else{
                [self performSelectorInBackground:@selector(resenedPoll) withObject:nil];
            }
        }else{
            self.displayLabel.text = @"*Please select a team and a game first.";
            self.displayLabel.textColor = [UIColor redColor];
        }
       
        
    }else{
        self.displayLabel.text = @"*Please select a team and a game first.";
        self.displayLabel.textColor = [UIColor redColor];
    }


}

-(void)resenedPoll{
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response = [ServerAPI updateMessageThread:mainDelegate.token :self.selectedTeamId :self.selectedMessageThreadId :@"" :@"" :@"" :@"" :@"true"];
        
        NSString *status = [response valueForKey:@"status"];
        
        NSString *didSucceed = @"";
        if ([status isEqualToString:@"100"]) {
            
        }else{
            didSucceed = @"error";
        }
        
        [self performSelectorOnMainThread:@selector(doneResendPoll:) withObject:didSucceed waitUntilDone:NO];

    }
    
}

-(void)sendWhoPoll{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response = [ServerAPI createMessageThread:mainDelegate.token teamId:self.selectedTeamId subject:@"" body:@"" type:@"whoiscoming" eventId:self.eventId eventType:self.eventType isAlert:@"" pollChoices:[NSArray array] recipients:[NSArray array] displayResults:@"" includeFans:@"" coordinatorsOnly:@""];
        
        NSString *status = [response valueForKey:@"status"];
                
        NSLog(@"SendWhoPoll: %@", status);

        NSString *didSucceed = @"";
        if ([status isEqualToString:@"100"]) {
         
        }else{
          didSucceed = @"error";
        }
        
        
        [self performSelectorOnMainThread:@selector(donePoll:) withObject:didSucceed waitUntilDone:NO];
        
    }
}

-(void)doneResendPoll:(NSString *)didSucceed{
    
    self.sendButton.enabled = YES;
    self.cancelButton.enabled = YES;
    [self.mainActivity stopAnimating];
    if ([didSucceed isEqualToString:@""]) {
        self.displayLabel.text = @"Poll Re-Sent Successfully!";
        self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        [self performSelector:@selector(cancel) withObject:nil afterDelay:1.0];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Poll Error" message:@"Who's Coming Poll failed to re-send.  Please make sure you are connected to the internet and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)donePoll:(NSString *)didSucceed{
    
    self.sendButton.enabled = YES;
    self.cancelButton.enabled = YES;
    [self.mainActivity stopAnimating];
    if ([didSucceed isEqualToString:@""]) {
        self.displayLabel.text = @"Poll Sent Successfully!";
        self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        [self performSelector:@selector(cancel) withObject:nil afterDelay:1.0];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Poll Error" message:@"Who's Coming Poll failed to send.  Please make sure you are connected to the internet and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)cancel{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    
    self.createEventView.hidden = YES;
    self.newGame = true;
    self.selectedMessageThreadId = @"";
    self.eventPicker.dataSource = self;
    self.eventPicker.delegate = self;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.teamSelectButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.createEventCancelButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.createEventSubmitButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];

    
    NSMutableArray *coordTeamList = [NSMutableArray array];
    for (int i = 0; i < [self.teamList count]; i++) {
        Team *tmpTeam = [self.teamList objectAtIndex:i];
        
        if ([tmpTeam.userRole isEqualToString:@"creator"] || [tmpTeam.userRole isEqualToString:@"coordinator"]) {
            [coordTeamList addObject:tmpTeam];
        }
    }
    
    self.teamList = [NSArray arrayWithArray:coordTeamList];
    
    self.selectView.hidden = YES;
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
    
    
    self.sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
	[self.navigationItem setRightBarButtonItem:self.sendButton];
    
    self.selectTable.delegate = self;
    self.selectTable.dataSource = self;
    
    self.title = @"Who's Coming";
    
    self.eventList = [NSMutableArray array];


    
    self.currentTeamsView.hidden = NO;
    
    Team *tmpTeam = [self.teamList objectAtIndex:0];
    [self.teamSelectButton setTitle:tmpTeam.name forState:UIControlStateNormal];
  
    
    
    [self performSelectorInBackground:@selector(getGameList:) withObject:tmpTeam.teamId];
    
    self.initialDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd hh:mm"];
        

    self.eventId = @"";
    self.selectedTeamId = tmpTeam.teamId;

    
}

-(void)teamSelect{
    
    self.selectView.hidden = NO;
    self.currentTeamsView.hidden = YES;
    [self.view bringSubviewToFront:self.selectView];
    [self.selectTable reloadData];
    
}




-(void)getGameList:(NSString *)teamId{
    
    @autoreleasepool {
        NSString *token = @"";
        NSArray *eventArray = [NSArray array];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){

            
            NSDictionary *response = [ServerAPI getListOfWhosComingEvents:teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                eventArray = [response valueForKey:@"events"];
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.error.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.error.text = @"*Error connecting to server";
                        break;
                    default:
                        //Game retrieval failed, log error code?
                        //self.error.text = @"*Error connecting to server";
                        break;
                }
            }
            
        }
            
            
                   
        //check for  old games;
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i < [eventArray count]; i++) {
            
            [tmpArray addObject:[eventArray objectAtIndex:i]];
        }
        
        
              
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        [tmpArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
        
        
        self.eventList = [NSArray arrayWithArray:tmpArray];
        
        
        [self performSelectorOnMainThread:@selector(doneGameList) withObject:nil waitUntilDone:NO];
        
    }
	
	
}

-(void)doneGameList{
    
    [self.eventActivity stopAnimating];
    
    self.isGettingEvents = false;
    [self.eventPicker reloadAllComponents];
    
  
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return [self.teamList count];
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: FirstLevelCell];
	}
	
	//Configure the cell
	NSUInteger row = [indexPath row];
	
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
        
      
            Team *team = [self.teamList objectAtIndex:row];
            cell.textLabel.text = team.name;
        
   
    
    
	
	
	
	return cell;
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//Get the Team from the array, and forward action to the Teams home page
	
	NSUInteger row = [indexPath row];
    
   
        Team *tmpTeam = [self.teamList objectAtIndex:row];
        [self.teamSelectButton setTitle:tmpTeam.name forState:UIControlStateNormal];
        self.selectView.hidden = YES;
        [self.eventActivity startAnimating];
        
        self.eventList = [NSMutableArray array];
    self.areNoEvents = false;
    self.isGettingEvents = true;
    [self.eventPicker reloadAllComponents];
 
        
        [self performSelectorInBackground:@selector(getGameList:) withObject:tmpTeam.teamId];
        self.selectedTeamId = tmpTeam.teamId;
        
        
        self.eventId = @"";
    
    self.newGame = true;
    self.currentTeamsView.hidden = NO;

    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    return 30;
}






- (void)createGame {
    
	@autoreleasepool {
        //Create the new game
        NSString *gameId = @"";
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //format the start date
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd HH:mm"];
            
        
        //get the current time zone
        NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
        
        NSString *timeZone = [tmp1 name];
        
        //Not using lat/long right now
        NSString *latitude = @"";
        NSString *longitude = @"";
        
        NSString *newDescription = @"No description entered...";        
        NSString *newOpp =  @"Opponent TBD";
        
        NSDictionary *response = [ServerAPI createGame:self.selectedTeamId :mainDelegate.token :self.createEventDate :@"" 
                                                      :newDescription :timeZone :latitude :longitude
                                                      :newOpp];
        
        NSString *status = [response valueForKey:@"status"];
        

        if ([status isEqualToString:@"100"]){
            
			gameId = [response valueForKey:@"gameId"];
            NSLog(@"GameID: %@", gameId);
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    // self.errorString = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    // self.errorString = @"*Error connecting to server";
                    break;
                case 205:
                    //error connecting to server
                    //self.errorString = @"*You must be a coordinator to add events.";
                    break;
                default:
                    //Log the status code?
                    // self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
		
        [self performSelectorOnMainThread:@selector(doneGame:) withObject:gameId waitUntilDone:NO];
        
    }
    
}

-(void)doneGame:(NSString *)gameId{
    
    if (![gameId isEqualToString:@""]) {
        self.eventId = [NSString stringWithString:gameId];
        NSLog(@"EventID: %@", self.eventId);
        [self performSelectorInBackground:@selector(sendWhoPoll) withObject:nil];

    }else{
        [self.mainActivity stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Game Error" message:@"There was an error creating the new game, please make sure you are connected to the internet and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)createEvent {
    
    @autoreleasepool {
        
        NSString *eventId1 = @"";
        //Create the new game
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //format the start date
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd HH:mm"];
                
        //add duration to start date for end date
        
        NSString *endDateString = @"";
        
        
        NSString *descrip = @"No description entered...";
      
        
        NSString *theLoc = @"Location TBD";
      
        
        
        //get the current time zone
        NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
        
        NSString *timeZone = [tmp1 name];
        
        //Not using lat/long right now
        NSString *latitude = @"";
        NSString *longitude = @"";
        
        NSDictionary *response = [ServerAPI createEvent:self.selectedTeamId :mainDelegate.token :self.createEventDate :endDateString :descrip :timeZone
                                                       :latitude :longitude :theLoc :self.createEventType :@"A Practice"];
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            eventId1 = [response valueForKey:@"practiceId"];
            
        }else{
            
           
        }
    
        [self performSelectorOnMainThread:@selector(doneEvent:) withObject:eventId1 waitUntilDone:NO];
        
    }
    
}

-(void)doneEvent:(NSString *)gameId{
    
    if (![gameId isEqualToString:@""]) {
        self.eventId = [NSString stringWithString:gameId];
        [self performSelectorInBackground:@selector(sendWhoPoll) withObject:nil];
        
    }else{
        [self.mainActivity stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Event Error" message:@"There was an error creating the new event, please make sure you are connected to the internet and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (row == 0) {
        
        self.newGame = true;
        self.eventId = @"";
    }else{
        self.newGame = false;
        if ([Game class] == [[self.eventList objectAtIndex:row-1] class]) {
            
            Game *tmpGame = [self.eventList objectAtIndex:row-1];
            self.eventId = tmpGame.gameId;
            self.eventType = @"game";
            
        }else if ([Practice class] == [[self.eventList objectAtIndex:row-1] class]) {
            
            Practice *tmpGame = [self.eventList objectAtIndex:row-1];
            self.eventId = tmpGame.practiceId;
            self.eventType = @"practice";
            
        }else {
            
            Event *tmpGame = [self.eventList objectAtIndex:row-1];
            self.eventId = tmpGame.eventId;
            self.eventType = @"generic";
        }
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  
    UILabel *returnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 35)];
    returnLabel.textColor = [UIColor blackColor];
    returnLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    returnLabel.backgroundColor = [UIColor clearColor];
    
    NSString *type = @"";
    NSString *date = @"";
    
    bool alreadySent = false;
    if (row == 0) {
        
        if (self.isGettingEvents) {
            returnLabel.text =  @"Loading Events...";

        }else{
            returnLabel.text = @"+ Create New Event +";
        }
    }else{
        
        if ([Game class] == [[self.eventList objectAtIndex:row-1] class]) {
            
            Game *tmpGame = [self.eventList objectAtIndex:row-1];
            type = @"Game";
            date = tmpGame.startDate;
            
            if ((tmpGame.messageThreadId != nil) && ![tmpGame.messageThreadId isEqualToString:@""]) {
                alreadySent = true;
            }
            
        }else if ([Practice class] == [[self.eventList objectAtIndex:row-1] class]) {
            
            Practice *tmpGame = [self.eventList objectAtIndex:row-1];
            type = @"Practice";
            date = tmpGame.startDate;
            
            if ((tmpGame.messageThreadId != nil) && ![tmpGame.messageThreadId isEqualToString:@""]) {
                alreadySent = true;
            }
            
        }else {
            
            Event *tmpGame = [self.eventList objectAtIndex:row-1];
            type = @"Event";
            date = tmpGame.startDate;
            
            if ((tmpGame.messageThreadId != nil) && ![tmpGame.messageThreadId isEqualToString:@""]) {
                alreadySent = true;
            }
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
        NSDate *newDate = [dateFormatter dateFromString:date];
        
    
        
        [dateFormatter setDateFormat:@"MM/dd 'at' hh:mm aa"];
        
        NSString *addString = @"";
        if (alreadySent) {
            addString = @" (re-send)";
        }
        returnLabel.text = [NSString stringWithFormat:@"%@ on %@%@", type, [dateFormatter stringFromDate:newDate], addString];
       
    }
    
    return returnLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 320;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
        return [self.eventList count] + 1;
    
}


-(void)createEventCancel{
    self.createEventView.hidden = YES;
}

-(void)createEventSubmit{
    
    self.createEventView.hidden = YES;
    
    [self.mainActivity startAnimating];
    self.sendButton.enabled = NO;
    self.cancelButton.enabled = YES;
    
    if (self.createEventSegment.selectedSegmentIndex == 0) {
        self.createEventType = @"game";

    }else if (self.createEventSegment.selectedSegmentIndex == 1){
        self.createEventType = @"practice";
    }else{
        self.createEventType = @"generic";
    }
    
    NSDate *tmpDate = self.createEventDatePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; 
    
    self.createEventDate = [dateFormatter stringFromDate:tmpDate];
    
    
    self.eventType = [NSString stringWithString:self.createEventType];
    if ([self.createEventType isEqualToString:@"game"]) {
        [self performSelectorInBackground:@selector(createGame) withObject:nil];

    }else{
        [self performSelectorInBackground:@selector(createEvent) withObject:nil];
    }
    
}

-(void)viewDidUnload{
    

    currentTeamsView = nil;
    teamSelectButton = nil;
    selectView = nil;
    selectTable = nil;
    mainActivity = nil;
    eventPicker = nil;
    displayLabel = nil;
    
    createEventDatePicker = nil;
    createEventCancelButton = nil;
    createEventSegment = nil;
    createEventSubmitButton = nil;
    createEventView = nil;
    [super viewDidUnload];
}



@end
