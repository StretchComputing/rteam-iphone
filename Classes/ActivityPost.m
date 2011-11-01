//
//  ActivityPost.m
//  rTeam
//
//  Created by Nick Wroblewski on 10/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPost.h"
#import "ServerAPI.h"
#import "rTeamAppDelegate.h"
#import "Team.h"
#import "SelectTeams.h"
#import "SelectRecipients.h"

@implementation ActivityPost
@synthesize messageText, postTeamId, teamSelectButton, hasTeams, teams, savedTeams, selectedTeams, keyboardIsUp, keyboardButton, sendPollButton, sendPrivateButton, activity, segControl, theMessageText;


-(void)viewWillAppear:(BOOL)animated{
    
    if (self.savedTeams) {
        self.savedTeams = false;
        
        NSString *titleString = @"";
        
        for (int i = 0; i < [self.selectedTeams count]; i++) {
            
            if (![[self.selectedTeams objectAtIndex:i] isEqualToString:@""]) {
                
                Team *tmpTeam = [self.teams objectAtIndex:i];
                
                if ([titleString isEqualToString:@""]) {
                    titleString = [titleString stringByAppendingFormat:@"%@", tmpTeam.name];
                }else{
                    titleString = [titleString stringByAppendingFormat:@", %@", tmpTeam.name];
                }
            }
        }
        
        [self.teamSelectButton setTitle:titleString forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad
{
    self.keyboardIsUp = false;
    self.title = @"Post";
    
    self.hasTeams = false;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
	[self.navigationItem setLeftBarButtonItem:addButton];
    
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(post)];
	[self.navigationItem setRightBarButtonItem:postButton];
    
    [self performSelectorInBackground:@selector(getListOfTeams) withObject:nil];
    
    [self.teamSelectButton setTitle:@"Loading Teams..." forState:UIControlStateNormal];
    self.messageText.delegate = self;
    
    [super viewDidLoad];

}

-(void)post{
    
    self.theMessageText = [NSString stringWithString:self.messageText.text];
    if ((self.messageText.text != nil) && ![self.messageText.text isEqualToString:@""]) {
        
        [self.activity startAnimating];
        [self.sendPrivateButton setEnabled:NO];
        [self.sendPollButton setEnabled:NO];
        [self.keyboardButton setEnabled:NO];
        [self.teamSelectButton setEnabled:NO];
        [self.segControl setEnabled:NO];
        
        [self performSelectorInBackground:@selector(createActivity) withObject:nil];
    }
    
}
-(void)cancel{
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)createActivity{
    
    @autoreleasepool {
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *orientation = @"";
        NSData *tmpData = [NSData data];
        NSData *tmpMovieData = [NSData data];
        
        NSDictionary *response = [ServerAPI createActivity:mainDelegate.token :self.postTeamId :self.theMessageText :tmpData :tmpMovieData :orientation];
        
        
        NSString *status = [response valueForKey:@"status"];
        
        if ([status isEqualToString:@"100"]){
            
            
            
        }else{
            
            //Server hit failed...get status code out and display error accordingly
            int statusCode = [status intValue];
            
            //[self.errorLabel setHidden:NO];
            switch (statusCode) {
                case 0:
                    //null parameter
                    //self.errorLabel.text = @"*Error connecting to server";
                    break;
                case 1:
                    //error connecting to server
                    //self.errorLabel.text = @"*Error connecting to server";
                    break;
                case 208:
                    //self.errorString = @"NA";
                default:
                    //log status code?
                    //self.errorLabel.text = @"*Error connecting to server";
                    break;
            }
        }

        [self performSelectorOnMainThread:@selector(donePost) withObject:nil waitUntilDone:NO];
        
    }
   

}

-(void)donePost{
    
    [self.activity stopAnimating];
    [self.sendPrivateButton setEnabled:YES];
    [self.sendPollButton setEnabled:YES];
    [self.keyboardButton setEnabled:YES];
    [self.teamSelectButton setEnabled:YES];
    [self.segControl setEnabled:YES];

    [self.navigationController dismissModalViewControllerAnimated:YES];
}


-(void)getListOfTeams{

    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        if (![token isEqualToString:@""]){	
            NSDictionary *response = [ServerAPI getListOfTeams:token];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSArray *teamsHere = [response valueForKey:@"teams"];
                
                self.teams = [NSMutableArray arrayWithArray:teamsHere];
                
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                //[self.errorLabel setHidden:NO];
                switch (statusCode) {
                    case 0:
                        //null parameter
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                    default:
                        //log status code?
                        //self.errorLabel.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        [self performSelectorOnMainThread:@selector(doneTeams) withObject:nil waitUntilDone:NO];
    }
	
	
}

-(void)doneTeams{
    
    if ([self.teams count] > 0) {
        Team *tmpTeam = [self.teams objectAtIndex:0];
        hasTeams = true;
        [self.teamSelectButton setTitle:tmpTeam.name forState:UIControlStateNormal];
        self.postTeamId = tmpTeam.teamId;  
        
        self.selectedTeams = [NSMutableArray array];
        for (int i = 0; i < [self.teams count]; i++) {
            [self.selectedTeams addObject:@""];
        }
        [self.selectedTeams replaceObjectAtIndex:0 withObject:@"s"];
    }else{
        [self.teamSelectButton setTitle:@"No Teams Found..." forState:UIControlStateNormal];

    }
    
}

-(void)teamSelect{
    
    if (self.hasTeams) {
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        
        SelectTeams *tmp = [[SelectTeams alloc] init];
        tmp.myTeams = [NSMutableArray arrayWithArray:self.teams];
        tmp.rowsSelected = [NSMutableArray arrayWithArray:self.selectedTeams];
        [self.navigationController pushViewController:tmp animated:YES];
    }
}
-(void)sendPoll{
    
    if (self.teams > 0) {
        
        if ([self.teams count] == 1) {
            
            Team *tmpTeam = [self.teams objectAtIndex:0];
            
            SelectRecipients *tmp = [[SelectRecipients alloc] init];
            tmp.teamId = tmpTeam.teamId;
            tmp.isPoll = true;
            [self.navigationController pushViewController:tmp animated:YES];
            
        }else{
            
            SelectTeams *tmp = [[SelectTeams alloc] init];
            tmp.myTeams = [NSMutableArray arrayWithArray:self.teams];
            tmp.isPoll = true;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i = 0; i < [self.teams count]; i++) {
                [tmpArray addObject:@""];
            }
            tmp.rowsSelected = [NSMutableArray arrayWithArray:tmpArray];
            
            [self.navigationController pushViewController:tmp animated:YES];
            
        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found" message:@"You must have at least one team to send a poll." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)privateMessage{
    
    if (self.teams > 0) {
        
        if ([self.teams count] == 1) {
            
            Team *tmpTeam = [self.teams objectAtIndex:0];
            
            SelectRecipients *tmp = [[SelectRecipients alloc] init];
            tmp.teamId = tmpTeam.teamId;
            tmp.isPrivate = true;
            [self.navigationController pushViewController:tmp animated:YES];
            
        }else{
            
            SelectTeams *tmp = [[SelectTeams alloc] init];
            tmp.myTeams = [NSMutableArray arrayWithArray:self.teams];
            tmp.isPrivate = true;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i = 0; i < [self.teams count]; i++) {
                [tmpArray addObject:@""];
            }
            tmp.rowsSelected = [NSMutableArray arrayWithArray:tmpArray];
     
            [self.navigationController pushViewController:tmp animated:YES];
            
        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Teams Found" message:@"You must have at least one team to send a message." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.keyboardIsUp = true;
    [self.keyboardButton setImage:[UIImage imageNamed:@"keyboarddown.png"] forState:UIControlStateNormal];
}

-(void)keyboard{
    
    if (self.keyboardIsUp) {
        self.keyboardIsUp = false;
        [self.messageText resignFirstResponder];
        [self.keyboardButton setImage:[UIImage imageNamed:@"keyboardup.png"] forState:UIControlStateNormal];

    }else{
        self.keyboardIsUp = true;
        [self.messageText becomeFirstResponder];
        [self.keyboardButton setImage:[UIImage imageNamed:@"keyboarddown.png"] forState:UIControlStateNormal];

    }
    
}
- (void)viewDidUnload
{
    messageText = nil;
    teamSelectButton = nil;
    keyboardButton = nil;
    segControl = nil;
    activity = nil;
    sendPollButton = nil;
    sendPrivateButton = nil;
    [super viewDidUnload];

}


@end
