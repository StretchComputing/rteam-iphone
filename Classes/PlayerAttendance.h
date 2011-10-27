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
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSArray *attResults;
@property (nonatomic, strong) NSArray *displayAttResults;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) UISegmentedControl *segmentEventType;
@property bool segChange;

-(void)getAttendance;
-(void)filterAttendance:(NSString *)event;
@end
