//
//  Event.h
//  rTeam
//
//  Created by Nick Wroblewski on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject {
	NSString *startDate;
	NSString *endDate;
	NSString *eventId;
	NSString *teamId;
	NSString *timeZone;
	NSString *description;
	NSString *latitude;
	NSString *longitude;
	NSString *location;
	NSString *userRole;
	NSString *eventName;
	NSString *teamName;
	
	bool isCanceled;
	
	
}
@property bool isCanceled;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *timeZone;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *userRole;
@end
