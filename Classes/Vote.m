//
//  Vote.m
//  rTeam
//
//  Created by Nick Wroblewski on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Vote.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "VoteMemberObject.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation Vote
@synthesize userRole, teamId, loadingLabel, loadingActivity, myTableView, closeVotingButton, errorLabel, activity, memberArray, errorString, myVote,
gameId, votingActivity, isOpen, updateSuccess, gameInfoSuccess, updateStatus;

-(void)viewWillAppear:(BOOL)animated{
	
	
	[self.tabBarController.navigationItem setRightBarButtonItem:nil];

	[self performSelectorInBackground:@selector(getGameInfo) withObject:nil];
	self.memberArray = [NSMutableArray array];
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.closeVotingButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
	self.closeVotingButton.hidden = YES;
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	self.myTableView.hidden = YES;
	self.loadingLabel.hidden = NO;
	[self.loadingActivity startAnimating];
	[self performSelectorInBackground:@selector(getMemberVotes) withObject:nil];

	NSString *ios = [[UIDevice currentDevice] systemVersion];
	if (![ios isEqualToString:@"3.0"] && ![ios isEqualToString:@"3.0.1"] && ![ios isEqualToString:@"3.1"] && ![ios isEqualToString:@"3.1.2"] && ![ios isEqualToString:@"3.1.3"]) {
		
		self.myTableView.backgroundColor = [UIColor clearColor];
		self.myTableView.opaque = NO;
		self.myTableView.backgroundView = nil;
		
	}
	
}

-(void)getMemberVotes{
	
	@autoreleasepool {
        NSString *token = @"";
        NSMutableArray *tmpMemberArray = [NSMutableArray array];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getGameVoteTallies:token :self.teamId :self.gameId :@"mvp"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString = @"";
                
                self.myVote = @"";
                if ([response valueForKey:@"votedFor"] != nil) {
                    self.myVote = [response valueForKey:@"votedFor"];
                    
                }
                NSArray *memberTallies = [response valueForKey:@"memberTallies"];
                
                for (int i = 0; i < [memberTallies count]; i++) {
                    
                    NSDictionary *tmpDictionary = [memberTallies objectAtIndex:i];
                    VoteMemberObject *tmpMember = [[VoteMemberObject alloc] init];
                    
                    tmpMember.memberId = [tmpDictionary valueForKey:@"memberId"];
                    tmpMember.memberName = [tmpDictionary valueForKey:@"memberName"];
                    tmpMember.numVotes = [[tmpDictionary valueForKey:@"voteCount"] intValue];
                    
                    
                    [tmpMemberArray addObject:tmpMember];
                    
                    
                }
                
                self.memberArray = tmpMemberArray;
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
                        //Game retrieval failed, log error code?
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
               
        }

        [self performSelectorOnMainThread:@selector(doneMemberVotes) withObject:nil waitUntilDone:NO];

    }

}

-(void)doneMemberVotes{
	[self.loadingActivity stopAnimating];
	[self.votingActivity stopAnimating];

	self.loadingLabel.hidden = YES;
	
	if ([self.errorString isEqualToString:@""]) {
		
		self.myTableView.hidden = NO;
		
		[self.myTableView reloadData];
	}else {
		self.errorLabel.text = self.errorString;
	}

	
}


-(void)closeVoting{
    
    [TraceSession addEventToSession:@"Vote Page - Close Voting Button Clicked"];

    
	self.errorLabel.text = @"";
	[self.activity startAnimating];
	
	if (self.isOpen) {
		self.updateStatus = @"closed";
	}else {
		self.updateStatus = @"open";
	}

	self.closeVotingButton.enabled = NO;
	[self performSelectorInBackground:@selector(updateGame) withObject:nil];
	
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if ([self.memberArray count] == 0) {
		return 1;
	}
	return [self.memberArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	
	static NSString *MemberCell=@"MemberCell";
	
	static NSInteger dateTag = 1;
	static NSInteger imageTag = 2;
	
	bool isEmpty = false;
	if ([self.memberArray count] == 0) {
		isEmpty = true;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberCell];
		
	
	
	
	if (cell == nil){
		CGRect frame;
		
	
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MemberCell];
			

		frame.origin.x = 5;
		frame.origin.y = 5;
		frame.size.height = 20;
		frame.size.width = 160;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		frame.size.height = 20;
		frame.size.width = 20;
		frame.origin.y = 5;
		frame.origin.x = 135;
		UIImageView *tmpView = [[UIImageView alloc] initWithFrame:frame];
		tmpView.image = [UIImage imageNamed:@"blueCheck.png"];
		tmpView.tag = imageTag;
		[cell.contentView addSubview:tmpView];
		
		
	}
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	UIImageView *blueCheck = (UIImageView *)[cell.contentView viewWithTag:imageTag];
	
	if (isEmpty) {
		dateLabel.text = @"No members on this team...";
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
		dateLabel.textAlignment = UITextAlignmentCenter;
		dateLabel.frame = CGRectMake(5, 5, 160, 20);
		blueCheck.hidden = YES;
	}else{
		dateLabel.frame = CGRectMake(8, 7, 130, 20);
		

		
		VoteMemberObject *tmp = [self.memberArray objectAtIndex:row];
		
		dateLabel.textColor = [UIColor blackColor];
		dateLabel.textAlignment = UITextAlignmentLeft;
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
		
		dateLabel.text = [NSString stringWithFormat:@"%@ (%d)", tmp.memberName, tmp.numVotes];
		
		if ([self.myVote isEqualToString:tmp.memberId]) {
			blueCheck.hidden = NO;
		}else {
			blueCheck.hidden = YES;
		}

	}
	
	dateLabel.backgroundColor = [UIColor clearColor];
	
	
	return cell;
	
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
	
    [TraceSession addEventToSession:@"Vote Page - Member Row Clicked"];

    
	NSUInteger row = [indexPath row];
	
	if (self.isOpen) {
		VoteMemberObject *tmpMember = [self.memberArray objectAtIndex:row];
		
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"MVP Vote"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
		[self.votingActivity startAnimating];
		[self performSelectorInBackground:@selector(castVote:) withObject:tmpMember.memberId];
	}else {
		self.errorLabel.text = @"*Voting has been closed for this game.";
	}

	
	
	
	
}

-(void)castVote:(NSString *)memberId{

	@autoreleasepool {
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 

        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI castGameVote:token :self.teamId :self.gameId :@"mvp" :memberId];
            
            NSString *status = [response valueForKey:@"status"];
            
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString = @"";
                
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
                        //Game retrieval failed, log error code?
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
 
        }

        [self performSelectorOnMainThread:@selector(doneVoting) withObject:nil waitUntilDone:NO];
    }

}

-(void)doneVoting{
	
	if ([self.errorString isEqualToString:@""]) {
		
		[self performSelectorInBackground:@selector(getMemberVotes) withObject:nil];
	}else {
		
		[self.votingActivity stopAnimating];
		self.errorLabel.text = self.errorString;
	}

	
	
}

-(void)getGameInfo{

	@autoreleasepool {
        self.errorString = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        NSDictionary *response;
        NSDictionary *gameInfo;
        //If there is a token, do a DB lookup to find the game info 
        if (![token isEqualToString:@""]){
            
            response = [ServerAPI getGameInfo:self.gameId :self.teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                self.gameInfoSuccess = true;
                gameInfo = [response valueForKey:@"gameInfo"];
                
                NSString *pollStatus = [gameInfo valueForKey:@"pollStatus"];
                
                if ([pollStatus isEqualToString:@"closed"]) {
                    self.isOpen = false;
                }else {
                    self.isOpen = true;
                }
                
                
                
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
                        //log status code
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        [self performSelectorOnMainThread:@selector(doneGameInfo) withObject:nil waitUntilDone:NO];
    }
	
}

-(void)doneGameInfo{
	
	if (self.gameInfoSuccess) {
		
		if (self.isOpen) {
			[self.closeVotingButton setTitle:@"Close MVP Voting" forState:UIControlStateNormal];
		}else {
			[self.closeVotingButton setTitle:@"Re-Open MVP Voting" forState:UIControlStateNormal];

		}

		if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
			self.closeVotingButton.hidden = NO;
		}else {
			self.closeVotingButton.hidden = YES;
		}
		
		
	}else {
		
	}

	
	
}


-(void)updateGame{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response = [NSDictionary dictionary];
        if (![mainDelegate.token isEqualToString:@""]){	
            response = [ServerAPI updateGame:mainDelegate.token :self.teamId :self.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false" :self.updateStatus :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.updateSuccess = true;
                
                if (self.isOpen) {
                    self.isOpen = false;
                }else {
                    self.isOpen = true;
                }
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                self.updateSuccess = false;
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
                        //log status code?
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        [self performSelectorOnMainThread:
         @selector(doneUpdate)
                               withObject:nil
                            waitUntilDone:NO
         ];
   
    }

}

-(void)doneUpdate{
	[self.activity stopAnimating];
	self.closeVotingButton.enabled = YES;

	if (self.updateSuccess) {
		if (self.isOpen) {
			[self.closeVotingButton setTitle:@"Close MVP Voting" forState:UIControlStateNormal];
		}else {
			[self.closeVotingButton setTitle:@"Re-Open MVP Voting" forState:UIControlStateNormal];
			
		}
	}
	
}
-(void)viewDidUnload{
	
	loadingLabel = nil;
	loadingActivity = nil;
	myTableView = nil;
	closeVotingButton = nil;
	errorLabel = nil;
	activity = nil;
	votingActivity = nil;
	[super viewDidUnload];
	
}


@end
