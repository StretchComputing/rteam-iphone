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
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSString *teamId;
-(void)getAllEvents;
@end
