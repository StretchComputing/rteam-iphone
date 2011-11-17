//
//  NewEvent2.m
//  rTeam
//
//  Created by Nick Wroblewski on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewEvent2.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "AllEventsCalendar.h"
#import "CurrentTeamTabs.h"
#import "FastActionSheet.h"
#import "QuartzCore/QuartzCore.h"
#import "GANTracker.h"

@implementation NewEvent2
@synthesize createSuccess, serverProcess, error, submitButton, teamId, location, eventName, description, start, errorString, theLocation, theDescription, theEventName;


-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	self.description.delegate = self;
	self.title = @"New Event Info";
	
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



-(void)createEvent{
	
	error.text = @"";
    
    
	//Validate all fields are entered:
	if ([self.eventName.text  isEqualToString:@""]){
		error.text = @"*You must enter a value for the event name.";	
	}else{
		
		if ([self.location.text isEqualToString:@""]) {
			self.location.text = @"Location TBD";
		}
		
		[serverProcess startAnimating];
		
		//Disable the UI buttons and textfields while registering
		
		[submitButton setEnabled:NO];
		[self.navigationItem setHidesBackButton:YES];
		[self.description setEditable:NO];
		[self.location setEnabled:NO];
		[self.eventName setEnabled:NO];
		
		
		//Create the player in a background thread
        self.theDescription = [NSString stringWithString:self.description.text];
        self.theEventName = [NSString stringWithString:self.eventName.text];
        self.theLocation = [NSString stringWithString:self.location.text];
        
        NSError *errors;
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (![[GANTracker sharedTracker] trackEvent:@"button_click"
                                             action:@"Create Event - Single"
                                              label:mainDelegate.token
                                              value:-1
                                          withError:&errors]) {
        }
        
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
        
        
        NSString *theDesc = @"";
        if ([self.theDescription isEqualToString:@""]) {
            theDesc = @"No description entered...";
        }else {
            theDesc = self.theDescription;
        }
        
        
        //get the current time zone
        NSTimeZone *tmp1 = [NSTimeZone systemTimeZone];
        
        NSString *timeZone = [tmp1 name];
        
        //Not using lat/long right now
        NSString *latitude = @"";
        NSString *longitude = @"";
                
        NSDictionary *response = [ServerAPI createEvent:self.teamId :mainDelegate.token :startDateString :@"" :theDesc :timeZone
                                                       :latitude :longitude :self.theLocation :@"generic" :self.theEventName];
        
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
		
        if ([[tempCont objectAtIndex:tempNum] class] == [CurrentTeamTabs class]) {
			CurrentTeamTabs *cont = [tempCont objectAtIndex:tempNum];
			cont.selectedIndex = 3;
			[self.navigationController popToViewController:cont animated:YES];
		}else if([[tempCont objectAtIndex:tempNum] class] == [AllEventsCalendar class]){
			
		    AllEventsCalendar *cont = [tempCont objectAtIndex:tempNum];
			cont.createdEvent = true;
		    [self.navigationController popToViewController:cont animated:YES];
		}else if (tempNum > 0){
			
            if ([[tempCont objectAtIndex:tempNum - 1] class] == [AllEventsCalendar class]) {
                
                AllEventsCalendar *cont = [tempCont objectAtIndex:tempNum-1];
                cont.createdEvent = true;
                [self.navigationController popToViewController:cont animated:YES];
                
            }
			
		}
        
	}else{
		
		self.error.text = [NSString stringWithString:self.errorString];
		
		[submitButton setEnabled:YES];
		[self.navigationItem setHidesBackButton:NO];
		[self.location setEnabled:YES];
		[self.eventName setEnabled:YES];
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
	//teamId = nil;
	location = nil;
	eventName = nil;
	description = nil;
	//start = nil;
	//errorString = nil;
	[super viewDidUnload];
}


@end