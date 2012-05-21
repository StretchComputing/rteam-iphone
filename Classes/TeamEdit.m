//
//  TeamEdit.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TeamEdit.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "TeamChangeSport.h"
#import "TwitterAuth.h"
#import "FastActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#import "CurrentTeamTabs.h"
#import "GANTracker.h"
#import "TraceSession.h"

@implementation TeamEdit
@synthesize teamId, sportLabel, description, teamName, errorLabel, activity, changeSportButton, saveChangesButton, saveSuccess, newTeamName,
connectTwitterButton, connectTwitterLabel, twitterUser, updateTwitter, twitterUrl, disconnectTwitterButton, errorString, teamInfo, loadingActivity,
loadingLabel, disconnect, theDescription, theTeamName, theSportLabel, deleteButton, fromHome, deleteTeamAction;

-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
}

-(void)viewDidLoad{
	
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretch = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[self.changeSportButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.saveChangesButton setBackgroundImage:stretch forState:UIControlStateNormal];
	[self.disconnectTwitterButton setBackgroundImage:stretch forState:UIControlStateNormal];
	
    
    UIImage *buttonImageNormal1 = [UIImage imageNamed:@"redButton.png"];
	UIImage *stretch1 = [buttonImageNormal1 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.deleteButton setBackgroundImage:stretch1 forState:UIControlStateNormal];

    
	self.disconnectTwitterButton.hidden = YES;
	self.saveChangesButton.hidden = YES;
	
	self.updateTwitter = false;
	[self.connectTwitterButton setHidden:YES];
	[self.connectTwitterLabel setHidden:YES];
	self.title = @"Edit Team";
	self.description.delegate = self;
	[self.errorLabel setHidden:YES];
    
    self.description.layer.masksToBounds = YES;
    self.description.layer.cornerRadius = 7.0;
	

	
}

-(void)viewWillAppear:(BOOL)animated{

    [TraceSession addEventToSession:@"TeamEdit - View Will Appear"];

	if (self.newTeamName != nil) {
		self.sportLabel.text = self.newTeamName;
	}else {
		[self.loadingActivity startAnimating];
		[self.loadingLabel setHidden:NO];
		self.teamInfo = [NSDictionary dictionary];

		[self performSelectorInBackground:@selector(getGameInfo) withObject:nil];
	}
}

-(void)connectTwitter{
	

	self.updateTwitter = true;
	[self.activity startAnimating];
    [self.navigationItem setHidesBackButton:YES];	
	[self.teamName setEnabled:NO];
	[self.description setEditable:NO];
	[self.saveChangesButton setEnabled:NO];
	[self.changeSportButton setEnabled:NO];
    
    self.theDescription = [NSString stringWithString:self.description.text];
    self.theTeamName = [NSString stringWithString:self.teamName.text];
    
    if (self.sportLabel.text == nil) {
        self.theSportLabel = @"other";
    }else{
        self.theSportLabel = [NSString stringWithString:self.sportLabel.text];
    }
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Team Edit - Connect Twitter"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];

	
}
-(void)getGameInfo{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            NSDictionary *response = [ServerAPI getTeamInfo:self.teamId :token :@"false"];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.teamInfo = [response valueForKey:@"teamInfo"];
                
                self.errorString = @"";
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                [self.errorLabel setHidden:NO];
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
        
        [self performSelectorOnMainThread:@selector(doneGameInfo) withObject:nil waitUntilDone:NO];

    }
	
	
}

-(void)doneGameInfo{
	
	[self.loadingActivity stopAnimating];
	self.loadingLabel.hidden = YES;
	
	self.saveChangesButton.hidden = NO;
	if ([self.errorString isEqualToString:@""]) {
		
		self.teamName.text = [self.teamInfo valueForKey:@"teamName"];
		
		if ([teamInfo valueForKey:@"description"] != nil) {
			self.description.text = [self.teamInfo valueForKey:@"description"];
		}
		
		
		self.sportLabel.text = [self.teamInfo valueForKey:@"sport"];
		
		bool useTwitter = true;
		
		useTwitter = [[self.teamInfo valueForKey:@"useTwitter"] boolValue];
		
		[self.connectTwitterLabel setHidden:NO];
		if (!useTwitter) {
			[self.connectTwitterButton setHidden:NO];
			self.connectTwitterLabel.text = @"Connect Team to Twitter:";
			[self.disconnectTwitterButton setHidden:YES];
		}else {
			[self.connectTwitterButton setHidden:YES];
			[self.disconnectTwitterButton setHidden:NO];
			self.connectTwitterLabel.text = @"Remove Twitter Connection:";
		}

		
	}else {
		self.errorLabel.text = self.errorString;
	}

}

-(void)changeSport{

	TeamChangeSport *tmp = [[TeamChangeSport alloc] init];
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Team Edit - Change Sport"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	[self.navigationController pushViewController:tmp animated:YES];
}

-(void)saveChanges{
	
	[self.activity startAnimating];
    [self.navigationItem setHidesBackButton:YES];	
	[self.teamName setEnabled:NO];
	[self.description setEditable:NO];
	[self.saveChangesButton setEnabled:NO];
	[self.changeSportButton setEnabled:NO];
    
    self.theDescription = [NSString stringWithString:self.description.text];
    self.theTeamName = [NSString stringWithString:self.teamName.text];
    
    if (self.sportLabel.text == nil) {
        self.theSportLabel = @"other";
    }else{
        self.theSportLabel = [NSString stringWithString:self.sportLabel.text];
    }
    
	[self performSelectorInBackground:@selector(runRequest) withObject:nil];
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Team Edit - Save Changes"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	
	
}


- (void)runRequest {
	
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *twitterParam = @"";
        
        if (self.updateTwitter) {
            twitterParam = @"true";
        }
        
        NSString *newDesc = @"";
        if ([self.theDescription isEqualToString:@""]){
            
            newDesc = @"No description entered...";
        }else{
            newDesc = self.theDescription;
        }
        
        NSDictionary *results = [ServerAPI updateTeam:mainDelegate.token :self.teamId :self.theTeamName :newDesc :@"" :twitterParam :self.theSportLabel :[NSData data] :@""];
        
        NSString *status = [results valueForKey:@"status"];
        
        NSLog(@"Status: %@", status);

        
        if ([status isEqualToString:@"100"]){
            
            self.saveSuccess = true;
			
            if (self.updateTwitter) {
                self.twitterUrl = [results valueForKey:@"twitterUrl"];
                self.twitterUser = true;
            }
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            self.saveSuccess = false;
            int statusCode = [status intValue];
            
            switch (statusCode) {
                case 0:
                    //null parameter
                    self.errorLabel.text = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    self.errorLabel.text = @"*Error connecting to server";
                    break;
                default:
                    //should never get here
                    self.errorLabel.text = @"*Error connecting to server";
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
	[activity stopAnimating];
	
	if (self.twitterUser) {
		
		[self.navigationItem setHidesBackButton:NO];
		[self.teamName setEnabled:YES];
		[self.description setEditable:YES];
		[self.saveChangesButton setEnabled:YES];
		[self.changeSportButton setEnabled:YES];
		
		TwitterAuth *tmp = [[TwitterAuth alloc] init];
		tmp.url = self.twitterUrl;
		[self.navigationController pushViewController:tmp animated:YES];
		
	}else {

	if (self.saveSuccess){
		
		//See if the teamId was one of the quick links, and if the name changed, change quick link too.
		
		rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];

		if ([self.teamId isEqualToString:mainDelegate.quickLinkOne]) {
			
			mainDelegate.quickLinkOneName = self.teamName.text;
			
		}else if ([self.teamId isEqualToString:mainDelegate.quickLinkTwo]){
			
			mainDelegate.quickLinkTwo = self.teamName.text;
		}
		
		
		
		//Then go to the coaches home
		NSArray *temp = [self.navigationController viewControllers];
		int num = [temp count];
		num = num - 2;
		
		CurrentTeamTabs *cont = [temp objectAtIndex:num];
		cont.selectedIndex = 0;
		[self.navigationController popToViewController:cont animated:YES];
	}else{
		
		[self.navigationItem setHidesBackButton:NO];
		[self.teamName setEnabled:YES];
		[self.description setEditable:YES];
		[self.saveChangesButton setEnabled:YES];
		[self.changeSportButton setEnabled:YES];
	}
	}
}


-(void)endText{
	
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


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		
		FastActionSheet *actionSheet = [[FastActionSheet alloc] init];
		actionSheet.delegate = self;
		[actionSheet showInView:self.view];
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (actionSheet == self.disconnect) {
		
		if (buttonIndex == 0) {
			
			[self.activity startAnimating];
			[self performSelectorInBackground:@selector(removeTwitter) withObject:nil];
			
		}
	}else if (actionSheet == self.deleteTeamAction){
        
        if (buttonIndex == 0) {
			
            [self.activity startAnimating];
            [self performSelectorInBackground:@selector(runDelete) withObject:nil];
			
		}
        
    }else {
		[FastActionSheet doAction:self :buttonIndex];

	}

	
	
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}


-(void)disconnectTwitter{
	
	self.disconnect =  [[UIActionSheet alloc] initWithTitle:@"Disconnect This Team from Twitter?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Disconnect" otherButtonTitles:nil];
	self.disconnect.delegate = self;
	[self.disconnect showInView:self.view];
	
}

-(void)removeTwitter{
	

	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        
        NSDictionary *results = [ServerAPI updateTeam:mainDelegate.token :self.teamId :@"" :@"" :@"" :@"false" :@"" :[NSData data] :@""];
        
        NSString *status = [results valueForKey:@"status"];
		
        if ([status isEqualToString:@"100"]){
            
            
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            self.saveSuccess = false;
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
                    //should never get here
                    self.errorString = @"*Error connecting to server";
                    break;
            }
        }
        
        
        [self performSelectorOnMainThread:
         @selector(doneRemoveTwitter)
                               withObject:nil
                            waitUntilDone:NO
         ];
        

    }
		
}

-(void)doneRemoveTwitter{
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Team Edit - Remove Twitter"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	[self.activity stopAnimating];
	
	[self.loadingActivity startAnimating];
	self.teamInfo = [NSDictionary dictionary];
	[self performSelectorInBackground:@selector(getGameInfo) withObject:nil];
	
	
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.description.text isEqualToString:@"No description entered..."]){
		self.description.text = @"";
	}
}


-(void)deleteTeam{
    
    self.deleteTeamAction =  [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this team?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	self.deleteTeamAction.delegate = self;
	[self.deleteTeamAction showInView:self.view];
   
}

-(void)runDelete{
    
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI deleteTeam:self.teamId :token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString = @"";
                
                if ([mainDelegate.quickLinkOne isEqualToString:self.teamId]) {
                    //if this first quick link team was just deleted
                    
                    mainDelegate.quickLinkOne = @"create";
                    mainDelegate.quickLinkOneName = @"";
                    
                    [mainDelegate saveUserInfo];
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
                        //should never get here
                        self.errorString = @"*Error connecting to server";
                        break;
                }
            }
            
            
        }

        [self performSelectorOnMainThread:@selector(doneDelete) withObject:nil waitUntilDone:NO];
        
    }
}

-(void)doneDelete{
    
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Team Edit - Delete Team"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
    [self.activity stopAnimating];
    if ([self.errorString isEqualToString:@""]) {
        
        if (self.fromHome) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
       
    }else{
        self.errorLabel.text = self.errorString;
    }
}


-(void)viewDidUnload{
    deleteButton = nil;
	sportLabel = nil;
	description = nil;
	teamName = nil;
	errorLabel = nil;
	activity = nil;
	changeSportButton = nil;
	saveChangesButton = nil;
	connectTwitterLabel = nil;
	connectTwitterButton = nil;
	disconnectTwitterButton = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	disconnect = nil;
	[super viewDidUnload];
}


@end
