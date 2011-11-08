//
//  GameEdit.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameEdit.h"
#import "GameEditDate.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "JSON/JSON.h"
#import "GameTabs.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "AllEventCalList.h"
#import "AllEventsCalendar.h"
#import "CurrentTeamTabs.h"

@implementation GameEdit
@synthesize activity, saveChanges, gameOpponent, gameDate, gameDescription, opponent, stringDate, description, teamId, gameId, gameChangeDate, 
fromDateChange, gameDateObject, createSuccess, errorMessage, notifyTeam, errorString, deleteButton, deleteActionSheet, theGameDescription, theGameOpponent, isCancel;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
}

-(void)viewDidLoad{
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.saveChanges setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.gameChangeDate setBackgroundImage:stretch forState:UIControlStateNormal];
	
	UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.deleteButton setBackgroundImage:stretch1 forState:UIControlStateNormal];
	
	self.gameDescription.layer.masksToBounds = YES;
	self.gameDescription.layer.cornerRadius = 7.0;

	
}
-(void)viewWillAppear:(BOOL)animated{

	self.title = @"Edit Game Info";
	self.gameOpponent.text = self.opponent;
	self.gameDescription.text = self.description;
	self.gameDescription.delegate = self;
	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
	
	if (self.fromDateChange != YES){
		self.fromDateChange = NO;
		self.gameDateObject = [dateFormat dateFromString:self.stringDate];
	}
	
	[dateFormat setDateFormat:@"MMM dd, hh:mm aa"];
	
	self.gameDate.text = [@"Date: " stringByAppendingString:[dateFormat stringFromDate:self.gameDateObject]];
	

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		[self becomeFirstResponder];

        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


-(void)submit{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Team Alert" message:@"Notify your team of this update?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
	[alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//"No"
	if(buttonIndex == 0) {	
		self.notifyTeam = false;
		
		
		//"Yes"
	}else if (buttonIndex == 1) {
		
		self.notifyTeam = true;
		
		
	}
	
	[activity startAnimating];
	
	//Disable the UI buttons and textfields while registering
	
	[self.saveChanges setEnabled:NO];
	[self.gameChangeDate setEnabled:NO];
	[self.navigationItem.leftBarButtonItem setEnabled:NO];
	[self.gameOpponent setEnabled:NO];
	[self.gameDescription setEditable:NO];
	
	//Create the team in a background thread
	
    self.theGameDescription = [NSString stringWithString:self.gameDescription.text];
    self.theGameOpponent = [NSString stringWithString:self.gameOpponent.text];

	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
	
}



-(void)changeDate{
	
	GameEditDate *tmp = [[GameEditDate alloc] init];
	tmp.gameDate = self.gameDateObject;
	[self.navigationController pushViewController:tmp animated:YES];
	
}



- (void)runRequest {
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
        
        NSString *startDate = [dateFormat stringFromDate:self.gameDateObject];
        
        
        NSString *notify = @"";
        if (self.notifyTeam) {
            notify = @"true";
        }else {
            notify = @"false";
        }
        
        NSDictionary *response = [NSDictionary dictionary];
        if (![token isEqualToString:@""]){	
            response = [ServerAPI updateGame:token :self.teamId :self.gameId :startDate :@"" :[[NSTimeZone systemTimeZone] name] :self.theGameDescription :@"" :@"" :self.theGameOpponent :@"" :@"" :@"" :@"" :notify :@"" :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.createSuccess = true;
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
                        //log status code?
                        self.errorString = @"*Error connecting to server";
                        break;
                }
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
	[activity stopAnimating];
	
	if (self.createSuccess){
		//team, sent, inbox, game or pracitce
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num - 2;
		
		GameTabs *cont = [temp objectAtIndex:num];
		cont.selectedIndex = 0;
		
			
		[self.navigationController popToViewController:cont animated:YES];
		
		
	}else{
		
		self.errorMessage.text = self.errorString;
		
		[self.saveChanges setEnabled:YES];
		[self.gameChangeDate setEnabled:YES];
		[self.navigationItem.leftBarButtonItem setEnabled:YES];
		[self.gameOpponent setEnabled:YES];
		[self.gameDescription setEditable:YES];
	}
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
	
	if (actionSheet == self.deleteActionSheet) {
		
		if (buttonIndex == 0) {
			//Remove
			[self.activity startAnimating];
			self.deleteButton.enabled = NO;
			self.saveChanges.enabled = NO;
			[self performSelectorInBackground:@selector(removeGame) withObject:nil];
		}else if (buttonIndex == 1) {
			//Cancel
			[self.activity startAnimating];
			self.deleteButton.enabled = NO;
			self.saveChanges.enabled = NO;
			[self performSelectorInBackground:@selector(cancelGame) withObject:nil];
		}else{
			
		}

		
	}else {
		[FastActionSheet doAction:self :buttonIndex];

	}

	
	
}


-(void)removeGame{
    @autoreleasepool {
        isCancel = false;
        
        //Delete Event
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
		
        if (![token isEqualToString:@""]){
            NSDictionary *response = [ServerAPI deleteGame:token :self.teamId :self.gameId];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString  = @"";
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.errorString  = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        self.errorString  = @"*Error connecting to server";
                        break;
                    default:
                        //log status code
                        self.errorString  = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        
        
        
        [self performSelectorOnMainThread:@selector(doneCancelDelete) withObject:nil waitUntilDone:NO];

    }
	
}

-(void)cancelGame{
    
    @autoreleasepool {
        isCancel = true;
        
        
        //Cancel Event
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            NSDictionary *response = [ServerAPI updateGame:token :self.teamId :self.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"-4" :@"" :@"" :@""];
            
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
                        self.errorString  = @"*Error connecting to server";
                        break;
                    default:
                        //log status code
                        self.errorString  = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }
        
        [self performSelectorOnMainThread:@selector(doneCancelDelete) withObject:nil waitUntilDone:NO];

    }
		
}


-(void)doneCancelDelete{
	
	[self.activity stopAnimating];
	self.deleteButton.enabled = YES;
	self.saveChanges.enabled = YES;
	
	
	if ([self.errorString isEqualToString:@""]) {
		NSArray *viewControllers = [self.navigationController viewControllers];
		
		if ([viewControllers count] > 2) {
			
			int num = [viewControllers count];
			
			if ([AllEventCalList class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				AllEventCalList *tmp = [viewControllers objectAtIndex:num - 3];
				AllEventsCalendar *tmp1 = [viewControllers objectAtIndex:num - 4];
				tmp1.createdEvent = true;
				tmp.gameIdCanceled = self.gameId;
				tmp.isCancel = isCancel;
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([AllEventsCalendar class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				AllEventsCalendar *tmp = [viewControllers objectAtIndex:num - 3];
				tmp.createdEvent = true;
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else if ([CurrentTeamTabs class] == [[viewControllers objectAtIndex:num - 3] class]) {
				
				CurrentTeamTabs *tmp = [viewControllers objectAtIndex:num - 3];
				[self.navigationController popToViewController:tmp animated:NO];
				
			}else {
				[self.navigationController dismissModalViewControllerAnimated:YES];

			}

			
		}else {
			//from Home
			
			[self.navigationController dismissModalViewControllerAnimated:YES];
		}

		
	}else {
		self.errorMessage.text = self.errorString;
	}

	
	
	
}


- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)deleteGame{
	
	self.deleteActionSheet = [[UIActionSheet alloc] initWithTitle:@"'Delete' removes game from schedule. 'Cancel' marks game as cancelled." delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Delete Game" otherButtonTitles:@"Cancel Game", nil];
    self.deleteActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [self.deleteActionSheet showInView:self.view];
	
	
}

-(void)viewDidUnload{
	
	activity = nil;
	saveChanges = nil;
	gameOpponent = nil;
	gameDate = nil;
	gameDescription = nil;
	//opponent = nil;
	//stringDate = nil;
	//description = nil;
	//teamId = nil;
	//gameId = nil;
	gameChangeDate = nil;
	//gameDateObject = nil;
	errorMessage = nil;
	//errorString = nil;
	deleteButton = nil;
	[super viewDidUnload];
	

}

@end
