//
//  ViewDetailMessageReplies.m
//  rTeam
//
//  Created by Nick Wroblewski on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewDetailMessageReplies.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Player.h"
#import "PollReplyObject.h"
#import "Fan.h"
#import "ConfirmMessageDetail.h"
#import "FastActionSheet.h"
#import "TraceSession.h"
@implementation ViewDetailMessageReplies
@synthesize replyArray, teamId, allReplyObjects, finalized, getInfo, threadId, isSender, myTableView, loadingLabel, loadingActivity, members;


-(void)viewWillAppear:(BOOL)animated{
    [TraceSession addEventToSession:@"ViewDetailMessageReplies - View Will Appear"];

}
-(void)viewDidAppear:(BOOL)animated{
	
	[self becomeFirstResponder];
	
	
}

-(void)viewDidLoad{
	

	self.title = @"Details";
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.myTableView.hidden = YES;
	
	self.members = @[];
	
	[self.loadingActivity startAnimating];
	[self performSelectorInBackground:@selector(getMembers) withObject:nil];
	
	
}

-(void)getMembers{
    
    @autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *response;
        if (mainDelegate.token != nil) {
            
            response = [ServerAPI getListOfTeamMembers:self.teamId :mainDelegate.token :@"all" :@""];
            
            NSString *status = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                self.members = [response valueForKey:@"members"];
                
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
                        //log status code
                        //self.error.text = @"*Error connecting to server";
                        break;
                }
            }
            
        }
        
        
        [self performSelectorOnMainThread:@selector(doneMembers) withObject:nil waitUntilDone:NO];

    }

}

-(void)doneMembers{
	
	self.loadingLabel.hidden = YES;
	[self.loadingActivity stopAnimating];
	self.myTableView.hidden = NO;
	
	if ([self.members count] > 0) {
	
		NSMutableArray *allReplyObjectsMutable = [NSMutableArray array];
		
		for (int i = 0; i < [self.replyArray count]; i++) {
			
			NSDictionary *memberReplyObject = (self.replyArray)[i];
			
			NSString *memberReplyID = [memberReplyObject valueForKey:@"memberId"];
			
			for (int j = 0; j < [self.members count]; j++) {
				
				if ([(self.members)[j] class] == [Player class]) {
					
					Player *tmpPlayer = (self.members)[j];
					
					if ([memberReplyID isEqualToString:tmpPlayer.memberId]) {
						//Add that player to the list
						
						PollReplyObject *tmpReplyObject = [[PollReplyObject alloc] init];
						tmpReplyObject.name = tmpPlayer.firstName;
						
						if ([memberReplyObject valueForKey:@"replyDate"] != nil) {
							//
							tmpReplyObject.reply = @"Confirmed";
							tmpReplyObject.dateReplied = [memberReplyObject valueForKey:@"replyDate"];
							tmpReplyObject.memberId = tmpPlayer.memberId;
							tmpReplyObject.teamId = self.teamId;
							
						}else {
							if (self.finalized) {
								tmpReplyObject.reply = @"Did not confirm.";
							}else {
								tmpReplyObject.reply = @"No confirmation yet.";
								
							}
							tmpReplyObject.memberId = tmpPlayer.memberId;
							tmpReplyObject.teamId = self.teamId;
							
							
							
							tmpReplyObject.dateReplied = @"";
						}
						
						[allReplyObjectsMutable addObject:tmpReplyObject];
						
					}
					
					
					
				}else {
					
					Fan *tmpPlayer = (self.members)[j];
					
					if ([memberReplyID isEqualToString:tmpPlayer.memberId]) {
						//Add that player to the list
						
						PollReplyObject *tmpReplyObject = [[PollReplyObject alloc] init];
						tmpReplyObject.name = tmpPlayer.firstName;
						
						if ([memberReplyObject valueForKey:@"replyDate"] != nil) {
							//
							tmpReplyObject.reply = @"Confirmed";
							tmpReplyObject.dateReplied = [memberReplyObject valueForKey:@"replyDate"];
						}else {
							if (self.finalized) {
								tmpReplyObject.reply = @"Did not confirm.";
							}else {
								tmpReplyObject.reply = @"No confirmation yet.";
								
							}
							
							tmpReplyObject.dateReplied = @"";
						}
						
                        tmpReplyObject.memberId = [NSString stringWithString:tmpPlayer.memberId];
                        tmpReplyObject.teamId = self.teamId;
                        
						[allReplyObjectsMutable addObject:tmpReplyObject];
						
					}
					
					
					
				}
				
				
				
			}
			
			
		}
		
		self.allReplyObjects = allReplyObjectsMutable;
	
	}
	[self.myTableView reloadData];
	
}



		
	
	


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.allReplyObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	static NSString *FirstLevelCell=@"FirstLevelCell";
	static NSInteger nameTag = 1;
	static NSInteger replyTag = 2;
	static NSInteger dateTag = 3;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
	if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 300;
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		
		frame.size.height = 17;
		frame.origin.y += 23;
		UILabel *replyLabel = [[UILabel alloc] initWithFrame:frame];
		replyLabel.tag = replyTag;
		[cell.contentView addSubview:replyLabel];
		
		frame.size.height = 15;
		frame.origin.y += 18;
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
	}
	
	UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:nameTag];
	UILabel *replyLabel = (UILabel *)[cell.contentView viewWithTag:replyTag];
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	
	nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	replyLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	dateLabel.textColor = [UIColor blueColor];
	dateLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	
	//Configure the cell
	
    NSUInteger row = [indexPath row];
	
	PollReplyObject *reply = (self.allReplyObjects)[row];
	
	if ([reply.dateReplied isEqualToString:@""]) {
		
		nameLabel.text = reply.name;
		replyLabel.text = reply.reply;
		dateLabel.text = reply.dateReplied;
		
	}else {
		
		NSString *replyDate = reply.dateReplied;
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *formatedDate = [dateFormat dateFromString:replyDate];
		//[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aa"];
		[dateFormat setDateFormat:@"MMM dd hh:mm aa"];
		NSString *date = [dateFormat stringFromDate:formatedDate];
		
		
		nameLabel.text = reply.name;
		replyLabel.text =  reply.reply;
		dateLabel.text = [@"Date Confirmed: " stringByAppendingString:date];
	}
	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.isSender) {
		
		PollReplyObject *reply = (self.allReplyObjects)[[indexPath row]];

		NSString *nameString = @"";
		NSString *confirmDateString = @"";
		
		if ([reply.dateReplied isEqualToString:@""]) {
			
			nameString = reply.name;
	
			
		}else {
			
			NSString *replyDate = reply.dateReplied;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:replyDate];
			//[dateFormat setDateFormat:@"yyyy-MM-dd hh:mm aa"];
			[dateFormat setDateFormat:@"MMM dd hh:mm aa"];
			NSString *date = [dateFormat stringFromDate:formatedDate];
			
			
			nameString = reply.name;
			confirmDateString = [@"Date Confirmed: " stringByAppendingString:date];
		}

		
		ConfirmMessageDetail *tmp = [[ConfirmMessageDetail alloc] init];
		tmp.memberName = nameString;
		tmp.confirmDate = confirmDateString;
		tmp.memberId = reply.memberId;
		tmp.teamId = reply.teamId;
		[self.navigationController pushViewController:tmp animated:YES];
	}
	
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
	//replyArray = nil;
	//teamId = nil;
	//allReplyObjects = nil;
	threadId = nil;
	myTableView = nil;
	loadingLabel = nil;
	loadingActivity = nil;
	[super viewDidUnload];
}



@end