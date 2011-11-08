//
//  CreateNewEvent.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreateNewEvent.h"
#import "NewGame2.h"
#import "NewPractice2.h"
#import "NewEvent2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "SelectTeamCal.h"
#import "FastActionSheet.h"
#import "RecurringEventSelection.h"

@implementation CreateNewEvent
@synthesize selection, teamId, eventDate, eventTime, titleLabel, haveTeamList, teamList, teamListFailed, error, createButton, createMultipleButton,
createSingleLabel;

-(void)viewWillAppear:(BOOL)animated{
    
	[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
    
}
-(void)viewDidLoad{
	
	self.error.textColor = [UIColor redColor];
	
	self.title = @"New Event";
	self.selection.selectedSegmentIndex = 0;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
	[dateFormat setDateFormat:@"MMM dd"]; 
	
	NSString *dateString = [dateFormat stringFromDate:self.eventDate];
	
	self.titleLabel.text = [[@"New Event On " stringByAppendingString:dateString] stringByAppendingString:@":"];
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.select.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.createButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	[self.createMultipleButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"greenButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.createMultipleButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
    
}

-(void)create{
	
	
    
	while (!self.haveTeamList) {
		//Wait here for the background thread to finish;
		
		if (self.teamListFailed) {
			break;
		}
	}
	
	if (self.teamListFailed) {
		self.error.text = @"*Error connecting to server, please try again.";
		self.teamListFailed = false;
		[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
	}else {
		
        
		if ([self.teamList count] == 0) {
			
			self.error.text = @"*You must create or be a part of at least 1 team to add an event";
			
		}else if ([self.teamList count] > 1){
			//Go to a "select team" page
			bool coordTeam;
			NSMutableArray *coordTeams = [NSMutableArray array];
			
			for (int i = 0; i < [self.teamList count]; i++) {
				Team *tmpTeam = [self.teamList objectAtIndex:i];
				
				if ([tmpTeam.userRole isEqualToString:@"creator"] || [tmpTeam.userRole isEqualToString:@"coordinator"]) {
					coordTeam = true;
					[coordTeams addObject:tmpTeam];
				}
			}
			
			if (coordTeam) {
				
				NSDate *theTime = self.eventTime.date;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"hh:mm aa"]; 
				
				NSString *timeString = [dateFormat stringFromDate:theTime];
				
				[dateFormat setDateFormat:@"yyyy-MM-dd "];
				
				NSString *dateString = [dateFormat stringFromDate:self.eventDate];
                
				NSString *dateTimeString = [dateString stringByAppendingString:timeString];
				//string now has a format of @"yyyy-MM-dd hh:mm aa"
				
				[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aa"];
				
				NSDate *finalDate = [dateFormat dateFromString:dateTimeString];
				
				SelectTeamCal *tmp = [[SelectTeamCal alloc] initWithStyle:UITableViewStyleGrouped];
				
				tmp.teams = coordTeams;
				tmp.finalDate = finalDate;
				tmp.singleOrMultiple = @"single";
				
				if (self.selection.selectedSegmentIndex == 0) {
					//Game	
					tmp.event = @"game";
				}else if (self.selection.selectedSegmentIndex == 1) {
					//Practice
					tmp.event = @"practice";
				}else {
					//Other
					tmp.event = @"event";
				}
				[self.navigationController pushViewController:tmp animated:YES];
			}else {
				self.error.text = @"*You are not a coordinator on any of your teams";
			}
            
			
		}else {
            
			Team *tmpTeam = [self.teamList objectAtIndex:0];
			self.teamId = tmpTeam.teamId;
			if ([tmpTeam.userRole isEqualToString:@"coordinator"] || [tmpTeam.userRole isEqualToString:@"creator"]) {
				
                
                
				//Combine the evenDate from previous screen with the eventTime picked on this screen, into one NSDate object
                
				NSDate *theTime = self.eventTime.date;
                
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"hh:mm aa"]; 
                
				NSString *timeString = [dateFormat stringFromDate:theTime];
                
				[dateFormat setDateFormat:@"yyyy-MM-dd "];
				
				NSString *dateString = [dateFormat stringFromDate:self.eventDate];
                
				NSString *dateTimeString = [dateString stringByAppendingString:timeString];
				//string now has a format of @"yyyy-MM-dd hh:mm aa"
                
				[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aa"];
                
				NSDate *finalDate = [dateFormat dateFromString:dateTimeString];
                
                
				if (self.selection.selectedSegmentIndex == 0) {
					//Game	
					NewGame2 *nextController = [[NewGame2 alloc] init];
					nextController.teamId = self.teamId;
					nextController.start = finalDate;
					[self.navigationController pushViewController:nextController animated:YES];	
				}else if (self.selection.selectedSegmentIndex == 1) {
					//Practice
					NewPractice2 *nextController = [[NewPractice2 alloc] init];
					nextController.teamId = self.teamId;
					nextController.start = finalDate;
					[self.navigationController pushViewController:nextController animated:YES];	
				}else {
					//Other
					NewEvent2 *nextController = [[NewEvent2 alloc] init];
					nextController.teamId = self.teamId;
					nextController.start = finalDate;
					[self.navigationController pushViewController:nextController animated:YES];	
				}
				
			}else {
				self.error.text = @"*You must be a team coordinator to add events.";
			}
            
            
            
		}
	}
}

-(void)getTeamList{
    
	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            
            NSDictionary *response = [ServerAPI getListOfTeams:token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.teamList = [response valueForKey:@"teams"];
                self.haveTeamList = true;
                
            }else{
                
                self.teamListFailed = true;
                //self.memberTeams = [NSMutableArray array];
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.error = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.error = @"*Error connecting to server";
                        break;
                    default:
                        //should never get here
                        //self.error = @"*Error connecting to server";
                        break;
                }
            }
            
            
            
            
        }

    }
		
}

-(void)segmentSelect:(id)sender{
	
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int selection1 = [segmentedControl selectedSegmentIndex];
	
	switch (selection1) {
		case 0:
			
			self.createSingleLabel.text = @"Single Game Time:";
			[self.createMultipleButton setTitle:@"Add Multiple Games" forState:UIControlStateNormal];
			
			break;
		case 1:
			
			self.createSingleLabel.text = @"Single Practice Time:";
			[self.createMultipleButton setTitle:@"Add Multiple Practices" forState:UIControlStateNormal];
			
			break;
			
		case 2:
			
			self.createSingleLabel.text = @"Single Event Time:";
			[self.createMultipleButton setTitle:@"Add Multiple Events" forState:UIControlStateNormal];
			
			
			break;
		default:
			break;
	}
	
	
}

-(void)createMultiple{
    
	while (!self.haveTeamList) {
		//Wait here for the background thread to finish;
		
		if (self.teamListFailed) {
			break;
		}
	}
	
	if (self.teamListFailed) {
		self.error.text = @"*Error connecting to server, please try again.";
		self.teamListFailed = false;
		[self performSelectorInBackground:@selector(getTeamList) withObject:nil];
	}else {
		
		
		if ([self.teamList count] == 0) {
			
			self.error.text = @"*You must create or be a part of at least 1 team to add an event";
			
		}else if ([self.teamList count] > 1){
			//Go to a "select team" page
			bool coordTeam;
			NSMutableArray *coordTeams = [NSMutableArray array];
			
			for (int i = 0; i < [self.teamList count]; i++) {
				Team *tmpTeam = [self.teamList objectAtIndex:i];
				
				if ([tmpTeam.userRole isEqualToString:@"creator"] || [tmpTeam.userRole isEqualToString:@"coordinator"]) {
					coordTeam = true;
					[coordTeams addObject:tmpTeam];
				}
			}
			
			if (coordTeam) {
				
				NSDate *theTime = self.eventTime.date;
				
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
				[dateFormat setDateFormat:@"hh:mm aa"]; 
				
				NSString *timeString = [dateFormat stringFromDate:theTime];
				
				[dateFormat setDateFormat:@"yyyy-MM-dd "];
				
				NSString *dateString = [dateFormat stringFromDate:self.eventDate];
				
				NSString *dateTimeString = [dateString stringByAppendingString:timeString];
				//string now has a format of @"yyyy-MM-dd hh:mm aa"
				
				[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aa"];
				
				NSDate *finalDate = [dateFormat dateFromString:dateTimeString];
				
				SelectTeamCal *tmp = [[SelectTeamCal alloc] initWithStyle:UITableViewStyleGrouped];
				
				tmp.teams = coordTeams;
				tmp.finalDate = finalDate;
				tmp.singleOrMultiple = @"multiple";
				
				if (self.selection.selectedSegmentIndex == 0) {
					//Game	
					tmp.event = @"game";
				}else if (self.selection.selectedSegmentIndex == 1) {
					//Practice
					tmp.event = @"practice";
				}else {
					//Other
					tmp.event = @"event";
				}
				[self.navigationController pushViewController:tmp animated:YES];
			}else {
				self.error.text = @"*You are not a coordinator on any of your teams";
			}
			
			
		}else {
			
			Team *tmpTeam = [self.teamList objectAtIndex:0];
			self.teamId = tmpTeam.teamId;
			if ([tmpTeam.userRole isEqualToString:@"coordinator"] || [tmpTeam.userRole isEqualToString:@"creator"]) {
				
				
				
				RecurringEventSelection *tmp = [[RecurringEventSelection alloc] init];
				tmp.teamId = self.teamId;
				if (self.selection.selectedSegmentIndex == 0) {
					tmp.eventType = @"game";
					
				}else if (self.selection.selectedSegmentIndex == 1) {
					tmp.eventType = @"practice";
					
				}else {
					tmp.eventType = @"generic";
				}
				
				
				[self.navigationController pushViewController:tmp animated:YES];
				
			}else {
				self.error.text = @"*You must be a team coordinator to add events.";
			}
			
			
			
		}
	}
    
	
}


-(void)viewDidUnload{
	selection = nil;
	//teamId = nil;
	//eventDate = nil;
	eventTime = nil;
	titleLabel = nil;
	//teamList = nil;
	createButton = nil;
	error = nil;
	createMultipleButton = nil;
	createSingleLabel = nil;
	[super viewDidUnload];
}

@end
