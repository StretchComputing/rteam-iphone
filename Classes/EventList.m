//
//  EventList.m
//  rTeam
//
//  Created by Nick Wroblewski on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventList.h"
#import "Player.h"
#import "NewPlayer.h"
#import "rTeamAppDelegate.h"
#import "ServerAPI.h"
#import "Team.h"
#import "Game.h"
#import "Gameday.h"
#import "GameTabs.h"
#import "GameAttendance.h"
#import "GameEdit.h"
#import "Practice.h"
#import "PracticeTabs.h"
#import "PracticeNotes.h"
#import "PracticeAttendance.h"
#import "PracticeEdit.h"
#import "GameTabsNoCoord.h"
#import "NewGamePractice.h"
#import "MapLocation.h"
#import "Event.h"
#import "EventTabs.h"
#import "EventNotes.h"
#import "EventAttendance.h"
#import "EventEdit.h"
#import "Fans.h"
#import "Vote.h"

@implementation EventList
@synthesize events, teamName, teamId, deleteRow, isPastGame, fromEdit, userRole, error, addButton, sport, barActivity, 
eventActivityLabel, eventsTableView, undoCancel, actionRow, editEventActiviy;


-(void)viewWillDisappear:(BOOL)animated{
	
	//self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidLoad {
    
    self.addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];

	self.eventsTableView.dataSource = self;
	self.eventsTableView.delegate = self;
	
	self.eventsTableView.hidden = YES;
	
	self.eventActivityLabel.hidden = NO;
	
}

-(void)viewWillAppear:(BOOL)animated{

	[self.eventsTableView setEditing:NO];
	[super setEditing:NO animated:NO];
	[self.eventsTableView setEditing:NO animated:NO];
	
	if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
		[self.tabBarController.navigationItem setRightBarButtonItem:self.addButton];
	}else{
        
        self.tabBarController.navigationItem.rightBarButtonItem = nil;

    }
	
	
	
	[self.barActivity startAnimating];
	[self performSelectorInBackground:@selector(getAllEvents) withObject:nil];
	
	
	
	NSInteger numEvents = [self.events count];
	
	
	//Header to be displayed if there are no players
	UIView *headerView =
	[[UIView alloc]
	  initWithFrame:CGRectMake(0, 0, 300, 75)];
	
	UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 320, 1)];
	UIColor *color = [[UIColor alloc] initWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
	line2.backgroundColor = color;
	[headerView addSubview:line2];
	
	//Only display header if there are no teams
	CGFloat yPos = 20;
	UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
	b.frame = CGRectMake(65, yPos, 170, 30);
	[b setTitle:@"Add An Event" forState:UIControlStateNormal];
	[b setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
	[b addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
	UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	b.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
	[b setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
	
	headerView.backgroundColor = [UIColor whiteColor];
	
	if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
		[headerView addSubview:b];
		
		if (numEvents > 0) {
			
			
		}
	}else {
		headerView = nil;
	}
	
	
	
	
	self.eventsTableView.tableHeaderView = headerView;
	
	
}





-(void)getAllEvents{

    @autoreleasepool {
        NSString *token = @"";
        NSArray *gameArray = [NSArray array];
        NSArray *practiceArray = [NSArray array];
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        } 
        
        
        
        //If there is a token, do a DB lookup to find the players associated with this team:
        if (![token isEqualToString:@""]){
            
            NSDictionary *response = [ServerAPI getListOfGames:self.teamId :token];
            NSDictionary *responsePractice = [ServerAPI getListOfEvents:self.teamId :token :@"all"];
            
            NSString *status = [response valueForKey:@"status"];
            NSString *statusPractice = [response valueForKey:@"status"];
            
            if ([status isEqualToString:@"100"]){
                
                gameArray = [response valueForKey:@"games"];
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.error.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        self.error.text = @"*Error connecting to server";
                        break;
                    default:
                        //Game retrieval failed, log error code?
                        self.error.text = @"*Error connecting to server";
                        break;
                }
            }
            
            
            if ([statusPractice isEqualToString:@"100"]){
                
                practiceArray = [responsePractice valueForKey:@"events"];
                
            }else{
                
                //Server hit failed...get status code out and display error accordingly
                int statusCode = [status intValue];
                
                switch (statusCode) {
                    case 0:
                        //null parameter
                        self.error.text = @"*Error connecting to server";
                        break;
                    case 1:
                        //error connecting to server
                        self.error.text = @"*Error connecting to server";
                        break;
                    default:
                        //Practice retrieval failed, log status code?
                        self.error.text = @"*Error connecting to server";
                        break;
                }
            }
        }
        
        
        //check for  old games;
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        self.isPastGame = false;
        
        
        for (int i = 0; i < [gameArray count]; i++) {
            //Game *tmpPractice = [gameArray objectAtIndex:i];
            
            //NSString *date = tmpPractice.startDate;
            
            //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
            //	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
            
            //***********TODO CHANGE THIS (display old games?)
            //NSDate *formatedDate = [dateFormat dateFromString:date];
            //NSDate *todaysDate = [NSDate date];
            
            //if (![formatedDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
            
            [tmpArray addObject:[gameArray objectAtIndex:i]];
            
            //}
            
            
        }
        
        
        for (int i = 0; i < [practiceArray count]; i++) {
            /*
             Practice *tmpPractice = [practiceArray objectAtIndex:i];
             
             NSString *date = tmpPractice.startDate;
             
             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
             [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
             NSDate *formatedDate = [dateFormat dateFromString:date];
             NSDate *todaysDate = [NSDate date];
             
             if (![formatedDate isEqualToDate:[formatedDate earlierDate:todaysDate]]) {
             */
            [tmpArray addObject:[practiceArray objectAtIndex:i]];
			
            //}
            
            
        }
        
        
        NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
        [tmpArray sortUsingDescriptors:[NSArray arrayWithObject:lastNameSorter]];
        
        
        self.events = [NSArray arrayWithArray:tmpArray];
        
        
        [self performSelectorOnMainThread:@selector(finishedMessages) withObject:nil waitUntilDone:NO];

    }
	
	
}


-(void)finishedMessages{
	
	[self.barActivity stopAnimating];
	self.eventActivityLabel.hidden = YES;
	self.eventsTableView.hidden = NO;
	[self.eventsTableView reloadData];
    
    [self scrollToCurrent];
	
	
}

     
-(void)scrollToCurrent{
      
    NSString *cellDate = @"";
    int cell = -1;
    for (int i = 0; i < [self.events count]; i++) {
        
        if ([[self.events  objectAtIndex:i] class] == [Game class]) {
			Game *tmpGame = [self.events  objectAtIndex:i];
			cellDate = tmpGame.startDate;
		}else if ([[self.events  objectAtIndex:i] class] == [Practice class]) {
			Practice *tmpGame = [self.events  objectAtIndex:i];
			cellDate = tmpGame.startDate;
		}else if ([[self.events  objectAtIndex:i] class] == [Event class]) {
			Event *tmpGame = [self.events  objectAtIndex:i];
			cellDate = tmpGame.startDate;
		}
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
		[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
		NSDate *eventDate = [dateFormat dateFromString:cellDate];
		NSDate *todaysDate = [NSDate date];
		
        
        if ([todaysDate isEqualToDate:[todaysDate earlierDate:eventDate]]) {

            cell = i;
            break;
        }
    }
    
    if ([self.events count] > 0) {
        if (cell == 0) {
            //No past dates, dont scroll
        }else if (cell == -1){
            //No future dates, scroll to bottom of list
            cell = [self.events count] - 1;
            NSIndexPath *scrollPath = [NSIndexPath indexPathForRow:cell inSection:0]; 
            [self.eventsTableView scrollToRowAtIndexPath:scrollPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            
            NSIndexPath *scrollPath = [NSIndexPath indexPathForRow:cell inSection:0]; 
            [self.eventsTableView scrollToRowAtIndexPath:scrollPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            
        }

    }
}

-(void)create{
	
	NewGamePractice *nextController = [[NewGamePractice alloc] init];
	nextController.teamId = self.teamId;
	[self.navigationController pushViewController:nextController animated:YES];	
	
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	if ([self.events count] == 0) {
		return 1;
	}
	return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSUInteger row = [indexPath row];
	bool mapIt = false;
	
	if ([self.events count] > 0) {
		
		if ([[self.events objectAtIndex:row] class] == [Game class]) {
			
			Game *theGame = [self.events objectAtIndex:row];
			if (theGame.latitude != nil) {
				mapIt = true;
			}
		
			if ([theGame.interval isEqualToString:@"-4"]) {
				mapIt = false;
			}
			
			
		}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
			
			Practice *thePracitce = [self.events objectAtIndex:row];
			if (thePracitce.latitude != nil) {
				mapIt = true;
			}
			
			if (thePracitce.isCanceled) {
				mapIt = false;
			}
			
			
		}else if ([[self.events objectAtIndex:row] class] == [Event class]) {
			
			Event *theEvent = [self.events objectAtIndex:row];
			
			if (theEvent.latitude != nil) {
				mapIt = true;
			}
			
			if (theEvent.isCanceled) {
				mapIt = false;
			}
		}
		
	}
	

	static NSString *noMapCell=@"noMapCell";
	static NSString *mapCell = @"mapCell";
	
	static NSInteger dateTag = 100000;
	static NSInteger oppTag = 200000;
	static NSInteger descTag = 300000;
	static NSInteger typeTag = 400000;
	static NSInteger mapTag = 500000;
	static NSInteger scoreTag = 600000;
	static NSInteger noEventsTag = 700000;
	static NSInteger canceledTag = 800000;
	
	UITableViewCell *cell;
	if (mapIt) {
		cell = [tableView dequeueReusableCellWithIdentifier:mapCell];
	}else {
		cell = [tableView dequeueReusableCellWithIdentifier:noMapCell];
		
	}
	
	
	if (cell == nil){
		
		if (mapIt) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCell];

		}else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMapCell];

		}

		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 22;
		frame.size.width = 300;
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
		dateLabel.tag = dateTag;
		[cell.contentView addSubview:dateLabel];
		
		frame.size.height = 17;
		frame.origin.y += 23;
		UILabel *oppLabel = [[UILabel alloc] initWithFrame:frame];
		oppLabel.tag = oppTag;
		[cell.contentView addSubview:oppLabel];
		
		frame.size.height = 15;
		frame.origin.y += 18;
		UILabel *descLabel = [[UILabel alloc] initWithFrame:frame];
		descLabel.tag = descTag;
		[cell.contentView addSubview:descLabel];
		
		frame.size.height = 15;
		frame.origin.y = 5;
		frame.origin.x = 200;
		frame.size.width = 75;
		UILabel *typeLabel = [[UILabel alloc] initWithFrame:frame];
		typeLabel.tag = typeTag;
		[cell.contentView addSubview:typeLabel];
		
		
		//[cell.contentView bringSubviewToFront:mapButton];
		
		frame.origin.x = 10;
		frame.origin.y = 65;
		frame.size.height = 15;
		frame.size.width = 100;	
		UILabel *scoreLabel = [[UILabel alloc] initWithFrame:frame];
		scoreLabel.tag = scoreTag;
		[cell.contentView addSubview:scoreLabel];
		
		frame.origin.x = 0;
		frame.origin.y = 30;
		frame.size.height = 20;
		frame.size.width = 320;	
		UILabel *noEventsLabel = [[UILabel alloc] initWithFrame:frame];
		noEventsLabel.tag = noEventsTag;
		[cell.contentView addSubview:noEventsLabel];
		
		frame.origin.x = 0;
		frame.origin.y = 0;
		frame.size.height = 80;
		frame.size.width = 320;	
		UILabel *canceledLabel = [[UILabel alloc] initWithFrame:frame];
		canceledLabel.tag = canceledTag;
		[cell.contentView addSubview:canceledLabel];
		
		
	}
	
	
	UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:dateTag];
	dateLabel.backgroundColor = [UIColor clearColor];
	UILabel *oppLabel = (UILabel *)[cell.contentView viewWithTag:oppTag];
	oppLabel.backgroundColor = [UIColor clearColor];
	UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:descTag];
	descLabel.backgroundColor = [UIColor clearColor];
	UILabel *typeLabel = (UILabel *)[cell.contentView viewWithTag:typeTag];
	typeLabel.backgroundColor = [UIColor clearColor];
	UILabel *scoreLabel = (UILabel *)[cell.contentView viewWithTag:scoreTag];
	scoreLabel.backgroundColor = [UIColor clearColor];
	UILabel *noEventsLabel = (UILabel *)[cell.contentView viewWithTag:noEventsTag];


	UILabel *canceledLabel = (UILabel *)[cell.contentView viewWithTag:canceledTag];
	
	
	canceledLabel.text = @"CANCELED";
	canceledLabel.textColor = [UIColor colorWithRed:190.0/255.0 green:0.0 blue:0.0 alpha:.90];
	canceledLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:40];
	canceledLabel.textAlignment = UITextAlignmentCenter;
	canceledLabel.backgroundColor = [UIColor clearColor];
	canceledLabel.hidden = YES;
	
	UIButton *mapButton;
	
	if (mapIt) {
		

		mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		mapButton.frame = CGRectMake(197, 30, 80, 30);
		mapButton.tag = mapTag;
		[mapButton setTitle:@"View Map" forState:UIControlStateNormal];
		[mapButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
		[mapButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:mapButton]; 
		

	}
	
	
	[cell.contentView bringSubviewToFront:canceledLabel];
	
	scoreLabel.textColor = [UIColor greenColor];
	scoreLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	oppLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	descLabel.textColor = [UIColor darkGrayColor];
	descLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	
	typeLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	typeLabel.textColor = [UIColor blueColor];
	typeLabel.textAlignment = UITextAlignmentCenter;
	
	
	//Configure the cell
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;

	if ([self.events count] == 0) {
		
		noEventsLabel.textColor = [UIColor grayColor];
		noEventsLabel.hidden = NO;
		dateLabel.hidden = YES;
		oppLabel.hidden = YES;
		descLabel.hidden = YES;
		typeLabel.hidden = YES;
		scoreLabel.hidden = YES;
		
		noEventsLabel.text = @"No future events found...";
        noEventsLabel.backgroundColor = [UIColor clearColor];
		noEventsLabel.textAlignment = UITextAlignmentCenter;
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.editingAccessoryType = UITableViewCellAccessoryNone;

		return cell;
		
	}else {
		noEventsLabel.hidden = YES;
		dateLabel.hidden = NO;
		oppLabel.hidden = NO;
		descLabel.hidden = NO;
		typeLabel.hidden = NO;
		scoreLabel.hidden = NO;

		if ([[self.events objectAtIndex:row] class] == [Game class]) {
			
			typeLabel.text = @"Game";
			Game *theGame = [self.events objectAtIndex:row];
			
			//format the start date (coming back as YYYY-MM-DD hh:mm)
			NSString *date = theGame.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];	
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"MMM dd, hh:mm aa"];
			
			NSString *startDateString = [format stringFromDate:formatedDate];
			
			
			dateLabel.text = startDateString;
			//retrieve the opponent
			
			oppLabel.text = [@"vs. " stringByAppendingString:theGame.opponent];
			
			//set description
			
			descLabel.text = theGame.description;
			

			//Map info
			if(mapIt){
			   mapButton.tag = row;
			}
			
			//Scoring info
			[scoreLabel setHidden:YES];
			
			if (theGame.interval != nil) {
				
				if (![theGame.interval isEqualToString:@"0"]) {
					
					
					if ([theGame.interval isEqualToString:@"-1"]) {
						//Game over
						int scoreUs = [theGame.scoreUs intValue];
						int scoreThem = [theGame.scoreThem intValue];
						
						NSString *result = @"";
						
						if (scoreUs > scoreThem) {
							result = @"W";
							scoreLabel.textColor = [UIColor colorWithRed:.34 green:.55 blue:.34 alpha:1.0];
							scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
							
						}else if (scoreUs < scoreThem) {
							result = @"L";
							scoreLabel.textColor = [UIColor redColor];
						}else {
							result = @"T";
							scoreLabel.textColor = [UIColor colorWithRed:.34 green:.55 blue:.34 alpha:1.0];
							scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
						}
						
						scoreLabel.text = [NSString stringWithFormat:@"%@ %@-%@", result, theGame.scoreUs, theGame.scoreThem];
						[scoreLabel setHidden:NO];
						
					}else if ([theGame.interval isEqualToString:@"-4"]) {
						//Cancled
						canceledLabel.hidden = NO;
						cell.selectionStyle = UITableViewCellSelectionStyleNone;
					}else {
						//Game in progress
						//scoreLabel.textColor = [UIColor colorWithRed:.412 green:.412 blue:.412 alpha:1.0];
						scoreLabel.textColor = [UIColor blueColor];
						
						NSString *time = @"";
						int interval = [theGame.interval intValue];
						
						if (interval == 1) {
							time = @"1st";
						}
						
						if (interval == 2) {
							time = @"2nd";
						}
						
						if (interval == 3) {
							time = @"3rd";
						}
						
						if (interval >= 4) {
							time = [NSString stringWithFormat:@"%@th", theGame.interval];
						}
						
						if (interval == -2) {
							time = @"OT";
						}
						
						
						if (interval == -3) {
							time = @"";
						}
						
						
						scoreLabel.text = [NSString stringWithFormat:@"%@-%@ %@", theGame.scoreUs, theGame.scoreThem, time];
						[scoreLabel setHidden:NO];
					}
					
				}
			}
			
			
			
		}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
			
			[scoreLabel setHidden:YES];
			typeLabel.text = @"Practice";
			Practice *thePracitce = [self.events objectAtIndex:row];
			
			//format the start date (coming back as YYYY-MM-DD hh:mm)
			NSString *date = thePracitce.startDate;
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];
			
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"MMM dd, hh:mm aa"];
			
			NSString *startDateString = [format stringFromDate:formatedDate];
			
			if(mapIt){
				mapButton.tag = row;
			}
			
			dateLabel.text = startDateString;
		
			//retrieve the opponent
			
			oppLabel.text = [@"at " stringByAppendingString:thePracitce.location];
			
			//set description
			
			descLabel.text = thePracitce.description;
			
			if (thePracitce.isCanceled) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
		}else if ([[self.events objectAtIndex:row] class] == [Event class]) {
			
			[scoreLabel setHidden:YES];
			typeLabel.text = @"Event";
			Event *theEvent = [self.events objectAtIndex:row];
			
			//format the start date (coming back as YYYY-MM-DD hh:mm)
			NSString *date = theEvent.startDate;
			
			if(mapIt){
				mapButton.tag = row;
			}
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
			[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"]; 
			NSDate *formatedDate = [dateFormat dateFromString:date];
			
			
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"MMM dd, hh:mm aa"];
			
			NSString *startDateString = [format stringFromDate:formatedDate];
			
			
			dateLabel.text = startDateString;
		
			
			
			oppLabel.text = theEvent.eventName;
            NSLog(@"Event Name: %@", theEvent.eventName);
            NSLog(@"Event Location: %@", theEvent.location);
            
			descLabel.text = [@"at " stringByAppendingString:theEvent.location];
			
			if (theEvent.isCanceled) {
				canceledLabel.hidden = NO;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
		}
		
		if (row % 2 != 0) {
			cell.contentView.backgroundColor = [UIColor whiteColor];
			cell.accessoryView.backgroundColor = [UIColor whiteColor];
			cell.backgroundView = [[UIView alloc] init]; 
			cell.backgroundView.backgroundColor = [UIColor whiteColor];
			
		}else {
			UIColor *tmpColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
			cell.contentView.backgroundColor = tmpColor;
			cell.accessoryView.backgroundColor = tmpColor;
			
			cell.backgroundView = [[UIView alloc] init]; 
			cell.backgroundView.backgroundColor = tmpColor;
		}
		
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		

		//cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		return cell;
		
	}
	
}

-(void)viewMap:(id)sender{
	
	
	UIButton *tmp = (UIButton *)sender;
	
	int row = tmp.tag;
	
	if ([[self.events objectAtIndex:row] class] == [Game class]) {
		
		Game *tmpGame = [self.events objectAtIndex:row];
		
		MapLocation *next = [[MapLocation alloc] init];
		next.eventLatCoord = [tmpGame.latitude doubleValue];
		next.eventLongCoord = [tmpGame.longitude doubleValue];
		[self.navigationController pushViewController:next animated:YES];
		
		
	}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
		
		Practice *tmpPractice = [self.events objectAtIndex:row];
		
		MapLocation *next = [[MapLocation alloc] init];
		next.eventLatCoord = [tmpPractice.latitude doubleValue];
		next.eventLongCoord = [tmpPractice.longitude doubleValue];
		[self.navigationController pushViewController:next animated:YES];
		
		
	}else if ([[self.events objectAtIndex:row] class] == [Event class]) {
		
		Event *tmpPractice = [self.events objectAtIndex:row];
		
		MapLocation *next = [[MapLocation alloc] init];
		next.eventLatCoord = [tmpPractice.latitude doubleValue];
		next.eventLongCoord = [tmpPractice.longitude doubleValue];
		[self.navigationController pushViewController:next animated:YES];
		
		
	}
	
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //Code to delete the team goes here

	
	self.deleteRow = [indexPath row];
	
	[self deleteActionSheet];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
}



- (IBAction) EditTable:(id)sender{
	
	if(self.editing){
		[super setEditing:NO animated:NO];
		[self.eventsTableView setEditing:NO animated:NO];
		[self.eventsTableView reloadData];
		[self.addButton setTitle:@"Edit"];
		[self.addButton setStyle:UIBarButtonItemStylePlain];
		
	}else{
		
		[super setEditing:YES animated:YES];
		[self.eventsTableView setEditing:YES animated:YES];
		[self.eventsTableView reloadData];
		[self.addButton setTitle:@"Done"];
		[self.addButton setStyle:UIBarButtonItemStyleDone];
		
	}	
}


//Method that gets called when a row is selected
#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//go to that game profile
	
	if ([self.events count] > 0) {
		NSUInteger row = [indexPath row];
		
		UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithTitle:@"Events" style:UIBarButtonItemStyleDone target:nil action:nil];
		self.navigationItem.backBarButtonItem = temp;
		
		if ([[self.events objectAtIndex:row] class] == [Game class]) {
			
			Game *currentGame = [self.events objectAtIndex:row];
						
			if (![currentGame.interval isEqualToString:@"-4"]) {
				if ([self.userRole isEqualToString:@"creator"] || [self.userRole isEqualToString:@"coordinator"]) {
					GameTabs *currentGameTab = [[GameTabs alloc] init];
					NSArray *viewControllers = currentGameTab.viewControllers;
					currentGameTab.teamId = self.teamId;
					currentGameTab.gameId = currentGame.gameId;
					currentGameTab.userRole = self.userRole;
					currentGameTab.teamName = self.teamName;
					
					Gameday *currentNotes = [viewControllers objectAtIndex:0];
					currentNotes.gameId = currentGame.gameId;
					currentNotes.teamId = self.teamId;
					currentNotes.userRole = self.userRole;
					currentNotes.sport = self.sport;
					currentNotes.description = currentGame.description;
					currentNotes.startDate = currentGame.startDate;
					currentNotes.opponentString = currentGame.opponent;
		
					GameAttendance *currentAttendance = [viewControllers objectAtIndex:1];
					currentAttendance.gameId = currentGame.gameId;
					currentAttendance.teamId = self.teamId;
					currentAttendance.startDate = currentGame.startDate;
	
                    
					Vote *fans = [viewControllers objectAtIndex:2];
					fans.teamId = self.teamId;
					fans.userRole = self.userRole;
					fans.gameId = currentGame.gameId;
					
					[self.navigationController pushViewController:currentGameTab animated:YES];
					
				}else {
					
					GameTabsNoCoord *currentGameTab = [[GameTabsNoCoord alloc] init];
					NSArray *viewControllers = currentGameTab.viewControllers;
					currentGameTab.teamId = self.teamId;
					currentGameTab.gameId = currentGame.gameId;
					currentGameTab.userRole = self.userRole;
					currentGameTab.teamName = self.teamName;
		
					
					Gameday *currentNotes = [viewControllers objectAtIndex:0];
					currentNotes.gameId = currentGame.gameId;
					currentNotes.teamId = self.teamId;
					currentNotes.userRole = self.userRole;
					currentNotes.sport = self.sport;
	
                    Vote *fans = [viewControllers objectAtIndex:1];
					fans.teamId = self.teamId;
					fans.userRole = self.userRole;
					fans.gameId = currentGame.gameId;
					
					[self.navigationController pushViewController:currentGameTab animated:YES];
					
				}
				
			}else {
				if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
					
					self.actionRow = row;
					
					self.undoCancel = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
					self.undoCancel.actionSheetStyle = UIActionSheetStyleDefault;
					[self.undoCancel showInView:self.tabBarController.view];
				
					
				}
			}

			
		}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
			
			PracticeTabs *currentPracticeTab = [[PracticeTabs alloc] init];
			
			
			Practice *currentPractice = [self.events objectAtIndex:row];
			
			if (currentPractice.isCanceled) {
				if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
					
					self.actionRow = row;
					
					self.undoCancel = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
					self.undoCancel.actionSheetStyle = UIActionSheetStyleDefault;
					[self.undoCancel showInView:self.tabBarController.view];
					
					
				}
			}else {
				NSArray *viewControllers = currentPracticeTab.viewControllers;
				currentPracticeTab.teamId = self.teamId;
				currentPracticeTab.practiceId = currentPractice.practiceId;
				currentPracticeTab.userRole = self.userRole;
				
				PracticeNotes *currentNotes = [viewControllers objectAtIndex:0];
				currentNotes.practiceId = currentPractice.practiceId;
				currentNotes.teamId = self.teamId;
				currentNotes.userRole = self.userRole;
				
				PracticeAttendance *currentAttendance = [viewControllers objectAtIndex:1];
				currentAttendance.practiceId = currentPractice.practiceId;
				currentAttendance.teamId = self.teamId;
				currentAttendance.startDate = currentPractice.startDate;
				currentAttendance.userRole = self.userRole;
				
                /*
				PracticeChatter *messages = [viewControllers objectAtIndex:2];
				messages.teamId = self.teamId;
				messages.practiceId = currentPractice.practiceId;
				messages.userRole = self.userRole;
				messages.startDate = currentPractice.startDate;
				*/
				
				/*
				 PracticeMessages *messages = [viewControllers objectAtIndex:1];
				 messages.teamId = self.teamId;
				 messages.practiceId = currentPractice.practiceId;
				 messages.userRole = self.userRole;
				 */
				
				[self.navigationController pushViewController:currentPracticeTab animated:YES];
			}

			
		}else if ([[self.events objectAtIndex:row] class] == [Event class]) {
			
			EventTabs *currentPracticeTab = [[EventTabs alloc] init];
			
			
			Event *currentEvent = [self.events objectAtIndex:row];
			
			if (currentEvent.isCanceled) {
				if ([self.userRole isEqualToString:@"coordinator"] || [self.userRole isEqualToString:@"creator"]) {
					
					self.actionRow = row;
					
					self.undoCancel = [[UIActionSheet alloc] initWithTitle:@"Do you want to remove this event from the schedule, or make it active again?" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Remove Event" otherButtonTitles:@"Make Active", nil];
					self.undoCancel.actionSheetStyle = UIActionSheetStyleDefault;
					[self.undoCancel showInView:self.tabBarController.view];
					
					
				}
			}else {
				NSArray *viewControllers = currentPracticeTab.viewControllers;
				currentPracticeTab.teamId = self.teamId;
				currentPracticeTab.eventId = currentEvent.eventId;
				currentPracticeTab.userRole = self.userRole;
				
				EventNotes *currentNotes = [viewControllers objectAtIndex:0];
				currentNotes.eventId = currentEvent.eventId;
				currentNotes.teamId = self.teamId;
				currentNotes.userRole = self.userRole;
				
				
				EventAttendance *currentAttendance = [viewControllers objectAtIndex:1];
				currentAttendance.eventId = currentEvent.eventId;
				currentAttendance.teamId = self.teamId;
				currentAttendance.startDate = currentEvent.startDate;
				currentAttendance.userRole = self.userRole;
				
				
				/*
				 EventMessages *messages = [viewControllers objectAtIndex:1];
				 messages.teamId = self.teamId;
				 messages.eventId = currentEvent.eventId;
				 messages.userRole = self.userRole;
				 */
				
				[self.navigationController pushViewController:currentPracticeTab animated:YES];
				
			}

			
		}
		
	}
		
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	
	//go to that game profile
	
	NSUInteger row = [indexPath row];
	
	if ([[self.events objectAtIndex:row] class] == [Game class]) {
		
		Game *currentGame = [self.events objectAtIndex:row];
		
		
		GameEdit *editGame = [[GameEdit alloc] init];
		
		editGame.stringDate = currentGame.startDate;
		editGame.opponent = currentGame.opponent;
		editGame.description = currentGame.description;
		editGame.teamId = self.teamId;
		editGame.gameId = currentGame.gameId;
		
		
		[self.navigationController pushViewController:editGame animated:YES];
		
	}else if ([[self.events objectAtIndex:row] class] == [Practice class]) {
		Practice *currentPractice = [self.events objectAtIndex:row];
		
		
		PracticeEdit *editPractice = [[PracticeEdit alloc] init];
		
		editPractice.stringDate = currentPractice.startDate;
		editPractice.opponent = currentPractice.location;
		editPractice.description = currentPractice.description;
		editPractice.teamId = self.teamId;
		editPractice.practiceId = currentPractice.practiceId;
		
		
		[self.navigationController pushViewController:editPractice animated:YES];
	}else if ([[self.events objectAtIndex:row] class] == [Event class]) {
		Event *currentPractice = [self.events objectAtIndex:row];
		
		
		EventEdit *editPractice = [[EventEdit alloc] init];
		
		editPractice.stringDate = currentPractice.startDate;
		editPractice.opponent = currentPractice.location;
		editPractice.nameString = currentPractice.eventName;
		editPractice.description = currentPractice.description;
		editPractice.teamId = self.teamId;
		editPractice.eventId = currentPractice.eventId;
		
		
		[self.navigationController pushViewController:editPractice animated:YES];
	}
}



-(void)deleteActionSheet{

	UIActionSheet *deleteNow = [[UIActionSheet alloc] initWithTitle:@"'Delete' removes event from schedule. 'Cancel' marks event as cancelled." delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:@"Delete Event" otherButtonTitles:@"Cancel Event", nil];
    deleteNow.actionSheetStyle = UIActionSheetStyleDefault;
    [deleteNow showInView:self.tabBarController.view];
	
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
	if (actionSheet == self.undoCancel) {
		
		if (buttonIndex == 1) {
			//Undo cancel
			
			[self.editEventActiviy startAnimating];
			[self performSelectorInBackground:@selector(activateEvent) withObject:nil];			
			
		}else if (buttonIndex == 0) {
			[self.editEventActiviy startAnimating];

			[self performSelectorInBackground:@selector(deleteEvent) withObject:nil];
			
		}else {
			
		}

	}else {
		if (buttonIndex == 0) {
			[self.editEventActiviy startAnimating];

			[self performSelectorInBackground:@selector(deleteEvent) withObject:nil];
			
		}else if (buttonIndex == 1) {
			[self.editEventActiviy startAnimating];

			[self performSelectorInBackground:@selector(cancelEvent) withObject:nil];
		}else {
			//Back
		}
		
	}
	
	
	
}


-(void)deleteEvent{

	@autoreleasepool {
        //Delete Event
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([[self.events objectAtIndex:self.deleteRow] class] == [Game class]) {
            
            Game *gameToDelete = [self.events objectAtIndex:self.deleteRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteGame:token :self.teamId :gameToDelete.gameId];
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
            
        }else if ([[self.events objectAtIndex:self.deleteRow] class] == [Practice class]) {
            
            Practice *practiceToDelete = [self.events objectAtIndex:self.deleteRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteEvent:token :self.teamId :practiceToDelete.practiceId];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
        }else {
            
            Event *practiceToDelete = [self.events objectAtIndex:self.deleteRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI deleteEvent:token :self.teamId :practiceToDelete.eventId];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
            
            
        }
        
        
        
        [self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];
    }
	
}

-(void)cancelEvent{

	@autoreleasepool {
        //Cancel Event
        
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([[self.events objectAtIndex:self.deleteRow] class] == [Game class]) {
            
            Game *gameToDelete = [self.events objectAtIndex:self.deleteRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateGame:token :self.teamId :gameToDelete.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"-4" :@"" :@"" :@""];
                
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
                            //	self.error.text = @"*Error connecting to server";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
                
                
            }
            
        }else if ([[self.events objectAtIndex:self.deleteRow] class] == [Practice class]) {
            
            Practice *practiceToDelete = [self.events objectAtIndex:self.deleteRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.teamId :practiceToDelete.practiceId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            ////null parameter
                            //	self.error.text = @"*Error connecting to server";
                            break;
                        case 1:
                            //error connecting to server
                            //	self.error.text = @"*Error connecting to server";
                            break;
                        default:
                            //log status code
                            //	self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
        }else {
            
            Event *practiceToDelete = [self.events objectAtIndex:self.deleteRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.teamId :practiceToDelete.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"true"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
            
            
        }
        
        
        
        
        
        [self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];

    }
	
	
}

-(void)activateEvent{

    
	@autoreleasepool {
        rTeamAppDelegate *mainDelegate = (rTeamAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *token = @"";
        if (mainDelegate.token != nil){
            token = mainDelegate.token;
        }
        
        if ([[self.events objectAtIndex:self.actionRow] class] == [Game class]) {
            
            Game *gameToDelete = [self.events objectAtIndex:self.actionRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateGame:token :self.teamId :gameToDelete.gameId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"0" :@"" :@"" :@""];
                
                
                NSString *status = [response valueForKey:@"status"];
                
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
            
        }else if ([[self.events objectAtIndex:self.actionRow] class] == [Practice class]) {
            
            Practice *practiceToDelete = [self.events objectAtIndex:self.actionRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.teamId :practiceToDelete.practiceId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
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
                            ///self.error.text = @"*Error connecting to server";
                            break;
                        default:
                            //log status code
                            //self.error.text = @"*Error connecting to server";
                            break;
                    }
                }
            }
        }else {
            
            Event *practiceToDelete = [self.events objectAtIndex:self.actionRow];
            if (![token isEqualToString:@""]){
                NSDictionary *response = [ServerAPI updateEvent:token :self.teamId :practiceToDelete.eventId :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"" :@"false"];
                NSString *status = [response valueForKey:@"status"];
                
                if ([status isEqualToString:@"100"]){
                    
                    
                }else{
                    
                    //Server hit failed...get status code out and display error accordingly
                    int statusCode = [status intValue];
                    
                    switch (statusCode) {
                        case 0:
                            ///null parameter
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
            
            
        }
        
        
        
        
        [self performSelectorOnMainThread:@selector(doneEventEdit) withObject:nil waitUntilDone:NO];
    }
	
	
}

-(void)doneEventEdit{
	
	[self.editEventActiviy stopAnimating];
	[super setEditing:NO animated:NO];
	[self.eventsTableView setEditing:NO animated:NO];
	[self.addButton setTitle:@"Edit"];
	[self.addButton setStyle:UIBarButtonItemStylePlain];
	[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
	[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	[self.barActivity startAnimating];
	[self performSelectorInBackground:@selector(getAllEvents) withObject:nil];
	
}

- (void)viewDidUnload {
	
	
	addButton = nil;
	barActivity = nil;
	eventsTableView = nil;
	error = nil;
	eventActivityLabel = nil;
	editEventActiviy = nil;
	

	[super viewDidUnload];
}



@end
