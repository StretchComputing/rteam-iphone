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
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *userRole;
@end
