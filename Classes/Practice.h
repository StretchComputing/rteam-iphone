//
//  Web.h
//  iCoach
//
//  Created by Nick Wroblewski on 12/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Practice : NSObject {
	NSString *startDate;
	NSString *endDate;
	NSString *practiceId;
	NSString *ppteamId;
	NSString *timeZone;
	NSString *description;
	NSString *latitude;
	NSString *longitude;
	NSString *location;
	NSString *userRole;
	NSString *teamName;
	
	bool isCanceled;

	
}
@property bool isCanceled;
@property (nonatomic, retain )NSString *teamName;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *timeZone;
@property (nonatomic, retain) NSString *practiceId;
@property (nonatomic, retain) NSString *ppteamId;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *userRole;
@end
