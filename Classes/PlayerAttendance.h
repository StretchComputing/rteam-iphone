//
//  PlayerAttendance.h
//  iCoach
//
//  Created by Nick Wroblewski on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlayerAttendance : UITableViewController {

	NSString *teamId;
	NSString *memberId;
	NSString *errorMessage;
	NSArray *attResults;
	NSArray *displayAttResults;
	NSString *eventType;
	bool segChange;
	UISegmentedControl *segmentEventType;
	
	bool fromSearch;
	
}
@property bool fromSearch;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *memberId;
@property (nonatomic, retain) NSString *errorMessage;
@property (nonatomic, retain) NSArray *attResults;
@property (nonatomic, retain) NSArray *displayAttResults;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) UISegmentedControl *segmentEventType;
@property bool segChange;

-(void)getAttendance;
-(void)filterAttendance:(NSString *)event;
@end
