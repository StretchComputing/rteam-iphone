//
//  DeleteMessageFrequency.m
//  rTeam
//
//  Created by Nick Wroblewski on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeleteMessageFrequency.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "TraceSession.h"
#import "GANTracker.h"

@implementation DeleteMessageFrequency
@synthesize myTableView, activity, selectedArray, errorString, displayLabel, newValue;

-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"DeleteMessageFrequency - View Will Appear"];

}
-(void)viewDidLoad{
	
	self.title = @"Archive Frequency";
	
	[self.activity startAnimating];
	[self performSelectorInBackground:@selector(getUserInfo) withObject:nil];
	self.selectedArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
	

	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	
	

		
		self.myTableView.backgroundColor = [UIColor clearColor];
		self.myTableView.opaque = NO;
		self.myTableView.backgroundView = nil;
		
	
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger cellTag = 1;
	static NSInteger segTag = 2;
	static NSInteger feedbackTag = 3;
	static NSInteger imageTag = 4;

	
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 22;
		frame.size.width = 200;
		
		
		UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
		cellLabel.tag = cellTag;
		[cell.contentView addSubview:cellLabel];
		
		frame.origin.x = 125;
		frame.size.width = 150;
		UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:frame];
		feedbackLabel.tag = feedbackTag;
		[cell.contentView addSubview:feedbackLabel];
		
		
		frame.size.height = 30;
		frame.origin.y = 6;
		frame.origin.x = 200;
		frame.size.width = 90;
		UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithFrame:frame];
		segControl.tag = segTag;
		[cell.contentView addSubview:segControl];
		
		frame.size.height = 20;
		frame.size.width = 20;
		frame.origin.y = 12;
		UIImageView *tmpView = [[UIImageView alloc] initWithFrame:frame];
		tmpView.image = [UIImage imageNamed:@"blueCheck.png"];
		tmpView.tag = imageTag;
		[cell.contentView addSubview:tmpView];
		
		
	}
	
	UIImageView *blueCheck = (UIImageView *)[cell.contentView viewWithTag:imageTag];
	UILabel *cellLabel = (UILabel *)[cell.contentView viewWithTag:cellTag];
	UISegmentedControl *segControl = (UISegmentedControl *)[cell.contentView viewWithTag:segTag];
	
	UILabel *feedbackLabel = (UILabel *)[cell.contentView viewWithTag:feedbackTag];
	
	segControl.hidden = YES;
	cellLabel.frame = CGRectMake(10, 10, 200, 22);
    cellLabel.backgroundColor = [UIColor clearColor];
	
	NSInteger row = [indexPath row];
	feedbackLabel.hidden = YES;
	
	if (row == 0) {
		cellLabel.text = @"3 Days";
	}else if (row == 1) {
		cellLabel.text = @"1 Week";

	}else if (row == 2) {
		cellLabel.text = @"2 Weeks";

	}else if (row == 3) {
		cellLabel.text = @"3 Weeks";

	}else if (row == 4) {
		cellLabel.text = @"1 Month";

	}
	
	if ([[self.selectedArray objectAtIndex:row] isEqualToString:@""]) {
		blueCheck.hidden = YES;
	}else {
		blueCheck.hidden = NO;
	}

	return cell;
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[GANTracker sharedTracker] trackEvent:@"action"
                                         action:@"Change Message Delete Frequency"
                                          label:mainDelegate.token
                                          value:-1
                                      withError:nil]) {
    }
    
	NSInteger row = [indexPath row];
	
		
		if (row == 0) {
			self.newValue = @"3";
		}else if (row == 1) {
			self.newValue = @"7";

		}else if (row == 2) {
			self.newValue = @"14";

		}else if (row == 3) {
			self.newValue = @"21";

		}else if (row == 4) {
			self.newValue = @"30";

		}
		
		
		
	[self.activity startAnimating];
	[self performSelectorInBackground:@selector(updateUserInfo) withObject:nil];
	
	
	
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
		return 5;
	
	
}




- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return NO;
	
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
		return @"Archive After:";
	
	
}

-(void)getUserInfo{

    @autoreleasepool {
        
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getUserInfo:token :@"false"];
            
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                NSDictionary *info = [response valueForKey:@"userInfo"];
                
                if ([info valueForKey:@"autoArchiveDayCount"] != nil) {
                    
                    NSNumber *tmpNumber = [info valueForKey:@"autoArchiveDayCount"];
                    
                    int number = [tmpNumber intValue];
                    
                    if (number == 3) {
                        [self.selectedArray replaceObjectAtIndex:0 withObject:@"s"];
                    }else if (number == 7) {
                        [self.selectedArray replaceObjectAtIndex:1 withObject:@"s"];
                    }else if (number == 14) {
                        [self.selectedArray replaceObjectAtIndex:2 withObject:@"s"];
                    }else if (number == 21) {
                        [self.selectedArray replaceObjectAtIndex:3 withObject:@"s"];
                    }else {
                        [self.selectedArray replaceObjectAtIndex:4 withObject:@"s"];
                    }
                    
                    self.errorString = @"";
                }
                
            }else{
                
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
                        //log status code
                        //self.error = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        [self performSelectorOnMainThread:@selector(doneUserInfo) withObject:nil waitUntilDone:NO];

        
    }
		
}



-(void)doneUserInfo{
	
	[self.activity stopAnimating];
	
	if ([self.errorString isEqualToString:@""]) {
		[self.myTableView reloadData];
	}else {
		
	}

}

-(void)updateUserInfo{
	
	@autoreleasepool {
        //Retrieve teams from DB
        NSString *token = @"";
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        
        //If there is a token, do a DB lookup to find the teams associated with this coach:
        if (![token isEqualToString:@""]){
            
            
            NSDictionary *response = [ServerAPI updateUser:token :@"" :@"" :@"" :@"" :@"" :@"" :@""
                                                          :@"" :@"" :@""
                                                          :@"" :@"" :self.newValue :[NSData data] :@"" :@"" :@"" :@"" :@"" :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.errorString = @"";
                
            }else{
                
                //self.memberTeams = [NSMutableArray array];
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
        
        [self performSelectorOnMainThread:@selector(doneUpdate) withObject:nil waitUntilDone:NO];
    }
	
	
}

-(void)doneUpdate{
	
	if ([self.errorString isEqualToString:@""]) {
		
		self.displayLabel.text = @"Update Successful!";
		self.displayLabel.textColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
		[self performSelector:@selector(cancel) withObject:nil afterDelay:1];

		
	
	}else {
		self.displayLabel.text = self.errorString;
		self.displayLabel.textColor = [UIColor redColor];
	}

	
}

-(void)cancel{
	
	[self.navigationController popViewControllerAnimated:NO];
	
}

-(void)viewDidUnload{
	
	myTableView = nil;
	activity = nil;
	displayLabel = nil;
	[super viewDidUnload];
	
}

@end
