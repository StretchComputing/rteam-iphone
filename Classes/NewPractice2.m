//
//  NewPractice2.m
//  rTeam
//
//  Created by Nick Wroblewski on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewPractice2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "AllEventsCalendar.h"
#import "CurrentTeamTabs.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "GANTracker.h"
#import "TraceSession.h"
#import "Home.h"
#import "CreateNewEventGameday.h"

@implementation NewPractice2
@synthesize createSuccess, serverProcess, error, submitButton, teamId, location, duration, description, start, errorString, theDuration, theDescription, theLocation;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"NewPractice2 - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.description.delegate = self;
	self.title = @"New Practice Info";
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	//self.select.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[self.submitButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	self.description.layer.masksToBounds = YES;
	self.description.layer.cornerRadius = 7;
	
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



-(void)createPractice{
	
    [TraceSession addEventToSession:@"New Single Practice Page - Create Practice Button Clicked"];

	self.error.text = @"";
	//Validate all fields are entered:
	
    self.theDescription = [NSString stringWithString:self.description.text];
    self.theDuration = [NSString stringWithString:self.duration.text];
    self.theLocation = [NSString stringWithString:self.location.text];
    
	if ([self.duration.text length] > 0) {
		int x = [self.duration.text intValue];
		
		NSString *intString = [NSString stringWithFormat:@"%d", x];
		
		if (([self.duration.text intValue] == 0) || (![intString isEqualToString:self.duration.text])){
			self.error.text = @"*Please enter a valid number for the duration.";
			
		}else {
			
			[serverProcess startAnimating];
			
			//Disable the UI buttons and textfields while registering
			
			[submitButton setEnabled:NO];
			[self.navigationItem setHidesBackButton:YES];
			[self.description setEditable:NO];
			[self.location setEnabled:NO];
			[self.duration setEnabled:NO];
			
			
			//Create the player in a background thread
			
          
            
			[self performSelectorInBackground:@selector(runRequest) withObject:nil];
			
			
		}
		
		
	}else{
		
		[serverProcess startAnimating];
		
		//Disable the UI buttons and textfields while registering
		
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.description setEditable:NO];
		[self.location setEnabled:NO];
		[self.duration setEnabled:NO];
		
		
		//Create the player in a background thread
		
      
		[self performSelectorInBackground:@selector(runRequest) withObject:nil];
		
	}
	
	
	
	
}

- (void)runRequest {

    @autoreleasepool {
        
        //Create the new game
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //format the start date
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSString *startDateString = [format stringFromDate:self.start];
        
        //add duration to start date for end date
        
        NSString *endDateString;
        if (self.theDuration > 0) {
            
            int minutes = [self.theDuration intValue];
            int seconds = minutes * 60;
            
            NSDate *endDate = [self.start dateByAddingTimeInterval:seconds];
            
            endDateString = [format stringFromDate:endDate];
        }else {
            endDateString = @"";
        }
        
        NSString *descrip = @"";
        if ([self.theDescription isEqualToString:@""]) {
            descrip = @"No description entered...";
        }else {
            descrip = self.theDescription;
        }
        
        NSString *theLoc = @"";
        if ([self.theLocation isEqualToString:@""]) {
            theLoc = @"Location TBD";
        }else {
            theLoc = self.theLocation;
        }
        
        
        //get the current time zone
        NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
        
        NSString *timeZone = [tmp1 name];
        
        //Not using lat/long right now
        NSString *latitude = @"";
        NSString *longitude = @"";
        
        NSDictionary *response = [ServerAPI createEvent:self.teamId :mainDelegate.token :startDateString :endDateString :descrip :timeZone
                                                       :latitude :longitude :theLoc :@"practice" :@"A Practice"];
        
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
                case 205:
                    //error connecting to server
                    self.errorString = @"*You must be a coordinator to add events.";
                    break;
                default:
                    //Log the status code?
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
	[serverProcess stopAnimating];
	
	if (self.createSuccess){
		NSArray *tempCont = [self.navigationController viewControllers];
		int tempNum = [tempCont count];
		tempNum = tempNum - 3;
		
        
        if (tempNum == -1) {
            rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                 action:@"Create Game - Gameday"
                                                  label:mainDelegate.token
                                                  value:-1
                                              withError:nil]) {
            }
            
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }else{
            if ([[tempCont objectAtIndex:tempNum] class] == [CurrentTeamTabs class]) {
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Create Game - Event List"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                CurrentTeamTabs *cont = [tempCont objectAtIndex:tempNum];
                cont.selectedIndex = 3;
                [self.navigationController popToViewController:cont animated:YES];
            }else if([[tempCont objectAtIndex:tempNum] class] == [AllEventsCalendar class]){
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Create Game - Calendar"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                AllEventsCalendar *cont = [tempCont objectAtIndex:tempNum];
                cont.createdEvent = true;
                [self.navigationController popToViewController:cont animated:YES];
            }else if([[tempCont objectAtIndex:tempNum] class] == [CreateNewEventGameday class]){
                
                rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                     action:@"Create Game - Gameday"
                                                      label:mainDelegate.token
                                                      value:-1
                                                  withError:nil]) {
                }
                //Go back home
                [self.navigationController dismissModalViewControllerAnimated:YES];
                
            }else if (tempNum > 0){
                
                if ([[tempCont objectAtIndex:tempNum - 1] class] == [AllEventsCalendar class]) {
                    
                    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                                         action:@"Create Game - Calendar"
                                                          label:mainDelegate.token
                                                          value:-1
                                                      withError:nil]) {
                    }
                    AllEventsCalendar *cont = [tempCont objectAtIndex:tempNum-1];
                    cont.createdEvent = true;
                    [self.navigationController popToViewController:cont animated:YES];
                    
                }
                
                if ([[tempCont objectAtIndex:tempNum - 1] class] == [Home class]) {
                    
                    Home *cont = [tempCont objectAtIndex:tempNum-1];
                    [self.navigationController popToViewController:cont animated:YES];
                    
                }else if ([[tempCont objectAtIndex:tempNum] class] == [Home class]) {
                    
                    Home *cont = [tempCont objectAtIndex:tempNum];
                    [self.navigationController popToViewController:cont animated:YES];
                    
                }
                
            }

        }
                
	}else{
		
		self.error.text = self.errorString;
		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.location setEnabled:YES];
		[self.duration setEnabled:YES];
		[self.description setEditable:YES];
		
		
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
	
	
	[FastActionSheet doAction:self :buttonIndex];
	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

-(void)viewDidUnload{
	serverProcess = nil;
	error = nil;
	submitButton = nil;
	location = nil;
	duration = nil;
	description = nil;

	[super viewDidUnload];
}



@end

