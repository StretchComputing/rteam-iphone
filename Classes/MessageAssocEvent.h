//
//  MessageAssocEvent.h
//  rTeam
//
//  Created by Nick Wroblewski on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageAssocEvent : UITableViewController {

	NSArray *events;
	NSString *teamId;
	NSString *error;
}
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, retain) NSString *teamId;
-(void)getAllEvents;
@end
