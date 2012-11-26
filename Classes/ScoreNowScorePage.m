//
//  ScoreNowScorePage.m
//  rTeam
//
//  Created by Nick Wroblewski on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreNowScorePage.h"
#import "Team.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Game.h"
#import "ScoreNowAddMembers.h"
#import "NewMemberObject.h"
#import "GANTracker.h"

@implementation ScoreNowScorePage
@synthesize noTeamsView, currentTeamsView, teamSelectButton, teamNameField, sportField, gameSelectButton, teamList, hasTeams, gameList, selectView,selectLabel, selectTable, isTeamTable, gameActivity, initialDate, selectedGameId, selectedTeamId, gameTableActivity, theScoreView, addMembersAlert, isNewTeam, mainActivity, sendScoreUs, sendInterval, sendScoreThem, sendSport, sendTeamName, gameIsOver, emailArray, phoneOnlyArray, errorString, doneButton, cancelButton;

-(void)viewWillAppear:(BOOL)animated{
    
    if ([self.emailArray count] > 0) {
        
        self.theScoreView.gameOverButton.enabled = NO;
        self.doneButton.enabled = NO;
        self.cancelButton.enabled = NO;
        
        //Members ahve been added, continue
        //create team
        self.sendScoreUs = self.theScoreView.scoreUs.text;
        self.sendScoreThem = self.theScoreView.scoreThem.text;
        
        if (self.gameIsOver) {
            self.sendInterval = @"-1";
        }else{
            self.sendInterval = self.theScoreView.quarter.text;
        }
        
        self.sendTeamName = self.teamNameField.text;
        self.sendSport = self.sportField.text;
        [self.mainActivity startAnimating];
        
        if (self.noTeamsView.hidden == YES) {
            
            if (![self.selectedGameId isEqualToString:@""] || (self.selectedGameId != nil)) {
                [self performSelector:@selector(runCreateGame) withObject:nil afterDelay:1.0];

            }
            [self performSelectorInBackground:@selector(addMembersToTeam:) withObject:self.selectedTeamId];
            
        }else {
            [self performSelectorInBackground:@selector(createTeam) withObject:nil];

        }
        
    }
    
}
-(void)done{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Score Now Saved - Gameday"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
   
    
    if (self.noTeamsView.hidden == NO) {
        
        bool isError = false;
        if ((self.teamNameField.text == nil) || [self.teamNameField.text isEqualToString:@""]) {
            isError = true;
        }else if ((self.teamNameField.text == nil) || [self.teamNameField.text isEqualToString:@""]) {
            isError = true;
        }
        
        if (isError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Field" message:@"Please fill out both 'Team Name' and 'Sport' before saving." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
            
            self.addMembersAlert = [[UIAlertView alloc] initWithTitle:@"Add Members?" message:@"Would you like to add any members to your new team before saving?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"No", nil];
            self.isNewTeam = true;
            [self.addMembersAlert show];
        }
        
    }else{
        
        self.theScoreView.gameOverButton.enabled = NO;
        self.doneButton.enabled = NO;
        self.cancelButton.enabled = NO;
        
        if ([self.selectedGameId isEqualToString:@""]) {
            //create game, then update game with score
            self.sendScoreUs = self.theScoreView.scoreUs.text;
            self.sendScoreThem = self.theScoreView.scoreThem.text;
            if (self.gameIsOver) {
                self.sendInterval = @"-1";
            }else{
                self.sendInterval = self.theScoreView.quarter.text;
            }
            
            [self.mainActivity startAnimating];
            [self performSelectorInBackground:@selector(createGame) withObject:nil];
        }else{
            //update game with score
            self.sendScoreUs = self.theScoreView.scoreUs.text;
            self.sendScoreThem = self.theScoreView.scoreThem.text;
            if (self.gameIsOver) {
                self.sendInterval = @"-1";
            }else{
                self.sendInterval = self.theScoreView.quarter.text;
            }
            
            [self.mainActivity startAnimating];
            [self performSelectorInBackground:@selector(updateGameScore) withObject:nil];
        }
       
        
    }
}

-(void)cancel{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    
    self.phoneOnlyArray = [NSMutableArray array];
    self.emailArray = @[];
    self.gameIsOver = false;
    
    NSMutableArray *coordTeamList = [NSMutableArray array];
    for (int i = 0; i < [self.teamList count]; i++) {
        Team *tmpTeam = (self.teamList)[i];
        
        if ([tmpTeam.userRole isEqualToString:@"creator"] || [tmpTeam.userRole isEqualToString:@"coordinator"]) {
            [coordTeamList addObject:tmpTeam];
        }
    }
    
    self.teamList = [NSArray arrayWithArray:coordTeamList];
    
    self.selectView.hidden = YES;
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	[self.navigationItem setLeftBarButtonItem:self.cancelButton];
    
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
	[self.navigationItem setRightBarButtonItem:self.doneButton];
    
    self.selectTable.delegate = self;
    self.selectTable.dataSource = self;
    
    self.title = @"Score Now";
    
    self.gameList = @[];
    self.theScoreView = [[ScoreNowScoring alloc] init];
    

    self.theScoreView.initScoreUs = @"0";
    self.theScoreView.initScoreThem = @"0";
    self.theScoreView.interval = @"1";
    
    self.theScoreView.myParent = self;
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.gameSelectButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.teamSelectButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];


    [self.gameActivity setHidesWhenStopped:YES];
    [self.gameTableActivity setHidesWhenStopped:YES];

    
    self.theScoreView.view.frame = CGRectMake(0, 191, 320, 225);
    [self.view addSubview:self.theScoreView.view];
    [self.view bringSubviewToFront:self.theScoreView.view];
    
    if ([self.teamList count] == 0) {
        self.hasTeams = false;
    }
    
    if (self.hasTeams) {
        self.currentTeamsView.hidden = NO;
        self.noTeamsView.hidden = YES;
        
        Team *tmpTeam = (self.teamList)[0];
        [self.teamSelectButton setTitle:tmpTeam.name forState:UIControlStateNormal];
        [self.gameActivity startAnimating];
        [self.gameTableActivity startAnimating];


        [self performSelectorInBackground:@selector(getGameList:) withObject:tmpTeam.teamId];
        
        self.initialDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd hh:mm"];
        
        NSString *dateString = [dateFormatter stringFromDate:self.initialDate];
        
        NSString *nowString = [NSString stringWithFormat:@"%@ (new game)", dateString];
        [self.gameSelectButton setTitle:nowString forState:UIControlStateNormal];
        
        self.selectedGameId = @"";
        self.selectedTeamId = tmpTeam.teamId;
    }else{
        self.noTeamsView.hidden = NO;
        self.currentTeamsView.hidden = YES;
    }
    
}

-(void)teamSelect{
    
    self.selectView.hidden = NO;
    self.noTeamsView.hidden = YES;
    self.currentTeamsView.hidden = YES;
    [self.view bringSubviewToFront:self.selectView];
    self.isTeamTable = true;
    [self.selectTable reloadData];
    self.selectLabel.text = @"Select Team";
    
}
                  
-(void)gameSelect{
    
    self.selectView.hidden = NO;
    self.noTeamsView.hidden = YES;
    self.currentTeamsView.hidden = YES;
    [self.view bringSubviewToFront:self.selectView];
    self.isTeamTable = false;
    [self.selectTable reloadData];
    self.selectLabel.text = @"Select Game";
    
}


-(void)getGameList:(NSString *)teamId{
            
    @autoreleasepool {
        
        NSString *token = @"";
        NSMutableArray *gameArray = [NSMutableArray array];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfGames:teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                gameArray = [NSMutableArray arrayWithArray:[response valueForKey:@"games"]];
                
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
        
        
        //remove games more than 36 hrs into future
        for (int i = 0; i < [gameArray count]; i++) {
            
            Game *tmpGame = gameArray[i];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
            
            NSDate *gameDate = [dateFormat dateFromString:tmpGame.startDate];
            NSDate *today = [NSDate date];
            NSDate *tomorrow = [today dateByAddingTimeInterval:129600];
            
            if ([tomorrow isEqualToDate:[tomorrow earlierDate:gameDate]]) {
                [gameArray removeObjectAtIndex:i];
                i--;
            }
            
        }
        
        
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:gameArray];
   
       
   
        
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        [tmpArray sortUsingDescriptors:@[lastNameSorter]];
        
        
        self.gameList = [NSArray arrayWithArray:tmpArray];
        
        
        [self performSelectorOnMainThread:@selector(doneGameList) withObject:nil waitUntilDone:NO];
        
    }
	
	
}

-(void)doneGameList{
    
    [self.gameActivity stopAnimating];
    [self.gameTableActivity stopAnimating];

    if (!self.isTeamTable) {
        [self.selectTable reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (self.isTeamTable) {
        return [self.teamList count] + 1;
    }else{
        return [self.gameList count] + 1;
    }
	
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
    
    if (self.isTeamTable) {
        
        if (row == 0) {
            cell.textLabel.text = @"+ Create New Team +";

        }else{
            Team *team = (self.teamList)[row-1];
            cell.textLabel.text = team.name;
        }
    }else{
        
        if (row == 0) {
            cell.textLabel.text = @"+ Create New Game +";
        }else{
            Game *tmpGame = (self.gameList)[row-1];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
            
            NSDate *theDate = [dateFormat dateFromString:tmpGame.startDate];
            [dateFormat setDateFormat:@"MM/dd hh:mm aa"];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Game on %@", [dateFormat stringFromDate:theDate]];
        }
    }

    
	
	
	
	return cell;
	
}

//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//Get the Team from the array, and forward action to the Teams home page
	
    self.theScoreView.scoreUs.text = @"0";
    self.theScoreView.scoreThem.text = @"0";
    self.theScoreView.quarter.text = @"1";
	NSUInteger row = [indexPath row];

	if (self.isTeamTable) {
        if (row == 0) {
            
            self.selectView.hidden = YES;
            self.currentTeamsView.hidden = YES;
            self.noTeamsView.hidden = NO;
            self.selectedGameId = @"";
            self.selectedTeamId = @"";
            
        }else{
            Team *tmpTeam = (self.teamList)[row-1];
            [self.teamSelectButton setTitle:tmpTeam.name forState:UIControlStateNormal];
            self.selectView.hidden = YES;
            [self.gameActivity startAnimating];
            [self.gameTableActivity startAnimating];

            self.gameList = @[];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd hh:mm"];
            NSString *dateString = [dateFormatter stringFromDate:self.initialDate];
            NSString *nowString = [NSString stringWithFormat:@"%@ (new game)", dateString];
            
            [self.gameSelectButton setTitle:nowString forState:UIControlStateNormal];
            
            [self performSelectorInBackground:@selector(getGameList:) withObject:tmpTeam.teamId];
            self.selectedTeamId = tmpTeam.teamId;
            
            
            self.selectedGameId = @"";
            self.currentTeamsView.hidden = NO;

        }
    }else{
        
        if (row == 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd hh:mm"];
            NSString *dateString = [dateFormatter stringFromDate:self.initialDate];
            NSString *nowString = [NSString stringWithFormat:@"%@ (new game)", dateString];
            
            [self.gameSelectButton setTitle:nowString forState:UIControlStateNormal];
                    
            self.selectView.hidden = YES;
            self.currentTeamsView.hidden = NO;

            
            self.selectedGameId = @"";
        }else{
            
            Game *tmpGame = (self.gameList)[row-1];
            
            self.selectedGameId = tmpGame.gameId;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 

            NSDate *theDate = [dateFormat dateFromString:tmpGame.startDate];
            [dateFormat setDateFormat:@"MM/dd hh:mm aa"];
            
            NSString *gameDateString = [NSString stringWithFormat:@"Game on %@", [dateFormat stringFromDate:theDate]];
            [self.gameSelectButton setTitle:gameDateString forState:UIControlStateNormal];
            
            self.selectView.hidden = YES;
            self.currentTeamsView.hidden = NO;
            
            NSString *time = @"";
            int interval = [tmpGame.interval intValue];
            
            bool showScore = false;
            if (interval >= 1) {
                self.theScoreView.quarter.text = [NSString stringWithString:tmpGame.interval];
                showScore = true;
            }
            
            if (interval == -2) {
                self.theScoreView.quarter.text = @"OT";
                showScore = true;
            }
            
            if (interval == -3) {
                time = @"";
                showScore = true;
            }
            
            if (showScore) {
                self.theScoreView.scoreUs.text = [NSString stringWithString:tmpGame.scoreUs];
                self.theScoreView.scoreThem.text = [NSString stringWithString:tmpGame.scoreThem];
            }
            
        }
    }
			
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

    return 40;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (alertView == self.addMembersAlert) {
        
        if (buttonIndex == 0) {
            //cancel
        }else if (buttonIndex == 1){
           //yes
            ScoreNowAddMembers *tmp = [[ScoreNowAddMembers alloc] init];
            [self.navigationController pushViewController:tmp animated:YES];
        }else if (buttonIndex == 2){
           //no 
            
            self.theScoreView.gameOverButton.enabled = NO;
            self.doneButton.enabled = NO;
            self.cancelButton.enabled = NO;
            
            if (self.isNewTeam) {
                //- create team, then create game, and update game with score
                //create game, then update game with score
                self.sendScoreUs = self.theScoreView.scoreUs.text;
                self.sendScoreThem = self.theScoreView.scoreThem.text;
                
                if (self.gameIsOver) {
                    self.sendInterval = @"-1";
                }else{
                    self.sendInterval = self.theScoreView.quarter.text;
                }
                
                self.sendTeamName = self.teamNameField.text;
                self.sendSport = self.sportField.text;
                [self.mainActivity startAnimating];
                [self performSelectorInBackground:@selector(createTeam) withObject:nil];
            }
            
     
        }
        
    }
    
    
}


-(void)createTeam{
    
    @autoreleasepool {
        NSString *teamId = @"";
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *results = [ServerAPI createTeam:self.sendTeamName :@"" :@"No description entered..." :@"false"
                                                     :mainDelegate.token :self.sendSport];
        
        NSString *status = [results valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
                        
            teamId = [results valueForKey:@"teamId"];
            
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
                    //self.errorString = @"*Error connecting to server";
                    break;
                    
                case 208:
                   // self.errorString = @"NA";
                    break;
                    
                default:
                    //should never get here
                   // self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        
        [self performSelectorOnMainThread:@selector(doneCreateTeam:) withObject:teamId waitUntilDone:NO];
        
    }

    
}

-(void)doneCreateTeam:(NSString *)teamId{
    
    if (![teamId isEqualToString:@""]) {
        self.selectedTeamId = [NSString stringWithString:teamId];
        
        if ([self.emailArray count] > 0) {
            

            [self performSelector:@selector(runCreateGame) withObject:nil afterDelay:1.0];
            [self performSelectorInBackground:@selector(addMembersToTeam:) withObject:teamId];
            
        }else{
            
            [self performSelectorInBackground:@selector(createGame) withObject:nil];

        }
    }else{
        [self.mainActivity stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Creating new team failed.  Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        self.theScoreView.gameOverButton.enabled = YES;
        self.doneButton.enabled = YES;
        self.cancelButton.enabled = YES;
    }
    
}

-(void)runCreateGame{

    [self performSelectorInBackground:@selector(createGame) withObject:nil];

}

- (void)createGame {
    
	@autoreleasepool {
        //Create the new game
        NSString *gameId = @"";
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //format the start date
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSString *startDateString = [format stringFromDate:self.initialDate];

    
        //get the current time zone
        NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
        
        NSString *timeZone = [tmp1 name];
        
        //Not using lat/long right now
        NSString *latitude = @"";
        NSString *longitude = @"";
        
        NSString *newDescription = @"No description entered...";        
        NSString *newOpp =  @"Opponent TBD";
                
        NSDictionary *response = [ServerAPI createGame:self.selectedTeamId :mainDelegate.token :startDateString :@"" 
                                                      :newDescription :timeZone :latitude :longitude
                                                      :newOpp];
        
        NSString *status = [response valueForKey:@"status"];
                   
        if ([status isEqualToString:@"100"]){
            
			gameId = [response valueForKey:@"gameId"];
            
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
        self.selectedGameId = [NSString stringWithString:gameId];
        [self performSelectorInBackground:@selector(updateGameScore) withObject:nil];
    }else{
        [self.mainActivity stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Creating new game failed.  Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        self.theScoreView.gameOverButton.enabled = YES;
        self.doneButton.enabled = YES;
        self.cancelButton.enabled = YES;
    }
}

-(void)updateGameScore{
    
    @autoreleasepool {
        NSString *token = @"";
        NSString *sendError = @"";
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        token = mainDelegate.token;
        
        
        NSDictionary *response = [ServerAPI updateGame:token :self.selectedTeamId :self.selectedGameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :self.sendScoreUs :self.sendScoreThem :self.sendInterval :@"" :@"" :@""];
        
        NSString *status = [response valueForKey:@"status"];
                
        if ([status isEqualToString:@"100"]){
            sendError = @"";
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    sendError = @"*Error connecting to server";
                    break;
                case 1:
                    ///error connecting to server
                    sendError = @"*Error connecting to server";
                    break;
                    
                default:
                    //should never get here
                    sendError = @"*Error connecting to server";
                    break;
            }
        }
        
        [self performSelectorOnMainThread:
         @selector(doneUpdate:)
                               withObject:sendError
                            waitUntilDone:NO
         ];
        
    }	

    
}

-(void)doneUpdate:(NSString *)sendError{
       
    if (![sendError isEqualToString:@""]) {
        [self.mainActivity stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Game score failed to update.  Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    self.theScoreView.gameOverButton.enabled = YES;
    self.doneButton.enabled = YES;
    self.cancelButton.enabled = YES;
    
    [self.mainActivity stopAnimating];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)gameOver{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Score Now Saved - Gameday"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    

    
    self.gameIsOver = true;
    
    if (self.noTeamsView.hidden == NO) {
        
        bool isError = false;
        if ((self.teamNameField.text == nil) || [self.teamNameField.text isEqualToString:@""]) {
            isError = true;
        }else if ((self.teamNameField.text == nil) || [self.teamNameField.text isEqualToString:@""]) {
            isError = true;
        }
        
        if (isError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Field" message:@"Please fill out both 'Team Name' and 'Sport' before saving." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
            
            self.addMembersAlert = [[UIAlertView alloc] initWithTitle:@"Add Members?" message:@"Would you like to add any members to your new team before saving?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"No", nil];
            self.isNewTeam = true;
            [self.addMembersAlert show];
        }
        
    }else{
        
        if (self.isNewTeam) {
            
            self.addMembersAlert = [[UIAlertView alloc] initWithTitle:@"Add Members?" message:@"Would you like to add any members to your new team before saving?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"No", nil];
            self.isNewTeam = false;
            [self.addMembersAlert show];
            
        }else{
            
            self.theScoreView.gameOverButton.enabled = NO;
            self.doneButton.enabled = NO;
            self.cancelButton.enabled = NO;
            
            if ([self.selectedGameId isEqualToString:@""]) {
                //create game, then update game with score
                self.sendScoreUs = self.theScoreView.scoreUs.text;
                self.sendScoreThem = self.theScoreView.scoreThem.text;
                if (self.gameIsOver) {
                    self.sendInterval = @"-1";
                }else{
                    self.sendInterval = self.theScoreView.quarter.text;
                }
                
                [self.mainActivity startAnimating];
                [self performSelectorInBackground:@selector(createGame) withObject:nil];
            }else{
                //update game with score
                self.sendScoreUs = self.theScoreView.scoreUs.text;
                self.sendScoreThem = self.theScoreView.scoreThem.text;
                if (self.gameIsOver) {
                    self.sendInterval = @"-1";
                }else{
                    self.sendInterval = self.theScoreView.quarter.text;
                }
                
                [self.mainActivity startAnimating];
                [self performSelectorInBackground:@selector(updateGameScore) withObject:nil];
            }
            
        }
        

        
    }

    
}


-(void)addMembersToTeam:(NSString *)teamId{
    
    @autoreleasepool {
        //Create the new player
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableArray *tmpMemberArray = [NSMutableArray array];
        NSArray *finalMemberArray = @[];
        
        for (int i = 0; i < [self.emailArray count]; i++) {
            
            NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
            
            NewMemberObject *tmpMember = (self.emailArray)[i];
            
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
                tmpDictionary[@"firstName"] = tmpMember.firstName;
            }
            if (![tmpMember.lastName isEqualToString:@""]) {
                tmpDictionary[@"lastName"] = tmpMember.lastName;
            }
            if (![tmpMember.email isEqualToString:@""]) {
                tmpDictionary[@"emailAddress"] = tmpMember.email;
            }
            if (![tmpMember.phone isEqualToString:@""]) {
                tmpDictionary[@"phoneNumber"] = tmpMember.phone;
            }
            if (![tmpMember.role isEqualToString:@""]) {
                tmpDictionary[@"participantRole"] = tmpMember.role;
            }
            
            NSMutableArray *guardArray = [NSMutableArray array];
            
            if (![tmpMember.guardianOneName isEqualToString:@""]) {
                
                
                NSMutableDictionary *guard1 = [NSMutableDictionary dictionary];
                
                NSArray *nameArray = [tmpMember.guardianOneName componentsSeparatedByString:@" "];
                
                NSString *fName = nameArray[0];
                NSString *lName = @"";
                
                for (int i = 1; i < [nameArray count]; i++) {
                    if (i == 1) {
                        lName = [lName stringByAppendingFormat:@"%@", nameArray[i]];
                    }else{
                        lName = [lName stringByAppendingFormat:@" %@", nameArray[i]];
                        
                    }
                }
                
                if (![fName isEqualToString:@""]) {
                    guard1[@"firstName"] = fName;
                }
                if (![lName isEqualToString:@""]) {
                    guard1[@"lastName"] = lName;
                }
                if (![tmpMember.guardianOneEmail isEqualToString:@""]) {
                    guard1[@"emailAddress"] = tmpMember.guardianOneEmail;
                }
                if (![tmpMember.guardianOnePhone isEqualToString:@""]) {
                    guard1[@"phoneNumber"] = tmpMember.guardianOnePhone;
                }
                
                [guardArray addObject:guard1];
                
                if (![tmpMember.guardianTwoName isEqualToString:@""]) {
                    
                    
                    NSMutableDictionary *guard2 = [NSMutableDictionary dictionary];
                    
                    NSArray *nameArray = [tmpMember.guardianTwoName componentsSeparatedByString:@" "];
                    
                    NSString *fName = nameArray[0];
                    NSString *lName = @"";
                    
                    for (int i = 1; i < [nameArray count]; i++) {
                        if (i == 1) {
                            lName = [lName stringByAppendingFormat:@"%@", nameArray[i]];
                        }else{
                            lName = [lName stringByAppendingFormat:@" %@", nameArray[i]];
                            
                        }
                    }
                    
                    if (![fName isEqualToString:@""]) {
                        guard2[@"firstName"] = fName;
                    }
                    if (![lName isEqualToString:@""]) {
                        guard2[@"lastName"] = lName;
                    }
                    if (![tmpMember.guardianTwoEmail isEqualToString:@""]) {
                        guard2[@"emailAddress"] = tmpMember.guardianTwoEmail;
                    }
                    if (![tmpMember.guardianTwoPhone isEqualToString:@""]) {
                        guard2[@"phoneNumber"] = tmpMember.guardianTwoPhone;
                    }
                    
                    [guardArray addObject:guard2];
                    
                }
                
            }
            
            if ([guardArray count] > 0) {
                tmpDictionary[@"guardians"] = guardArray;
            }
            
            [tmpMemberArray addObject:tmpDictionary];
            
        }
        
        finalMemberArray = [NSArray arrayWithArray:tmpMemberArray];
                
        NSDictionary *response = [ServerAPI createMultipleMembers:mainDelegate.token :teamId :finalMemberArray];
        
        NSString *status = [response valueForKey:@"status"];
        
        
        if ([status isEqualToString:@"100"]) {
            
            self.errorString = @"";
        }else {
            //Server hit failed...get status code out and display error accordingly
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
    
	rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	
	if ([self.errorString isEqualToString:@""]) {
		
		NSArray *tmpViews = [self.navigationController viewControllers];
		
		int theCount = [tmpViews count];
		theCount = theCount - 2;
        
		
        mainDelegate.phoneOnlyArray = [NSArray arrayWithArray:self.phoneOnlyArray];
        
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




-(void)endText{
    
}

-(void)viewDidUnload{
    
    gameActivity = nil;
    gameTableActivity = nil;
    noTeamsView = nil;
    currentTeamsView = nil;
    teamSelectButton = nil;
    teamNameField = nil;
    sportField = nil;
    gameSelectButton = nil;
    selectView = nil;
    selectTable = nil;
    mainActivity = nil;
    selectLabel = nil;
    
    [super viewDidUnload];
}

@end
